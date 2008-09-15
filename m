From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface
Date: Mon, 15 Sep 2008 09:21:44 -0700
Message-ID: <A5FD7683-581F-4F53-A86D-BFDEC10AFC5C@qlogic.com>
References: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com> <48CA9DB3.20005@emulex.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:52020 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYIOQVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2008 12:21:48 -0400
In-Reply-To: <48CA9DB3.20005@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>


On Sep 12, 2008, at 9:49 AM, James Smart wrote:

> Seokmann,
>
> There are number of fundamental issues with this patch that need to  
> be corrected. I'll be at plumbers conference next week, and will be  
> able to work through this. Please look me up if you will be there.  
> Otherwise, I'll just post a revised patch.
>
> Here are the issues as I see them:
>
> - There is no concept of a Request Structure, that supplies the type  
> of
>  request and other parameters (such as a timeout). This should have
>  come from the cdb bytes.  Over time, we can expand this request
>  structure for other types of requests, not just els/ct passthru.
OK. the FC transport layer will define them in a strucure and they  
will passed to the driver via request entry of the sg_io_v4.

> - There is no true definition of what the request payload should be.
>  It's implied that it should be a fully built frame header, followed  
> by
>  payload.  We should be striking the frame header, and just stating
>  that for els/ct, the request payload is the tx sequence payload.
Yes, the FC frame header will be removed and raw ELS/CT service  
payload only get passed down...

> - There is no definition of what the response payload should be. Does
>  it contain a header too ? or what ? If the request is rejected,
>  could it also contain other frame types ? We should simply state
>  that it is the rx sequence payload, and only if successful.
This response payload contains the actual ELS/CT response for the  
request.
And, yes, it contains raw ELS/CT response payload without header.
When the request rejected, the response payload contains the actual  
reject formation for the request as defined in the FC standard.
Please let me know if I missed any of points you'd mentioned above...,  
(I guess I did some...)

> - There is no concept or definition of a Reply structure, which should
>  be stuffed into the request sense area.  This should be well defined,
>  and matched to the request structure. We whould supply status values,
>  or response data from RJT's, BSY's, aborted status's, etc.
If I understood correctly, those RJT or BSY formation should be  
available on the 'response'.
If this is true, I guess that there are not many of information to be  
passed back to the application via the reply structure, beside,  
completion status, some vendor specific error code (if any), residual.

> - Once we follow the above, there's no need for common FC structures
>  and so on. Note: if we did need them, rather than redefining them,
>  we would premerge the headers from open-fcoe.
Yes, I've got it. There is no need to have ELS/CT service request  
structure.
But, how about structures for response? I think we need to define them  
to check whether or not the completion successful so that we can set  
the reply structure accordingly.

> - We really should be making the request handling asynchronous in
>  nature, rather than following smp's simple synchronous structure.
OK, understood. It will be added it.

> - Timeout values should be part of the request, not hardcoded in the
>  transport. If there is one in the transport, it would be a default,
>  used when the app didn't specify it, and should be tunable by sysfs.
OK, timeout value tunable through sysfs attribute.

> - It would be nice, although difficult, to allow the user to abort
>  an outstanding service request. We should look into what sgio
>  does in this area.
Could you please elaborate a bit further?

> - We really should add support, for the initial merge, to talk to an
>  address that doesn't exist via an rport (think fabric service).
>  This means adding some request types to the fc_host too.
This one too, please.

>
>
>
> -- james s
>
>
> ========
>
> More detailed comments:
>
> scsi_transport_fc.c:
>
> - Do we really need a kmem_cache for service structures ?
>  Note: given the blocking nature in what you sent, there could only
>    be one request at a time being performed on the rport, so unless
>    you're talking about a lot of requests to different rports
>    simultaneously, why the cache ?  I'd argue even then, the number
>    requests is small, so it doesn't need a cache.
Ok. Will make changes.

> - fc_service_handler is done oddly. I know you copied smp's approach,
>  but we have no desire for the lld to override the transports handler.
>  We would rather want to have the transport siphone of the requests
>  it handles, and fall back to a driver handler.
Could you elaborate this a bit?

> - There's no reason for separate ct and els service handlers. It can
>  be consolidated into a single handler, and data in the service
>  structure or initial request structure.
Yes, make sense, will make changes.

> - Have you tested how large of a single buffer you can supply and get
>  by on the single sg vector ?  For nameserver payloads we should
>  support bigger buffers - 4k as a minimum.
OK. will make changes.

> qla2xxx implementation:
> - Why does the driver re-allocate buffers for the transmit and
>  response payloads, and re-dma map them. Why couldn't it use
>  the buffers/sg values from the initial request ?
>
> - How does the timeout path ever work ?  with the qla driver blocking
>  in it's request handlers - how does the transport wait_completion()
>  ever get invoked prior to a request completing ? And if that's true,
>  how did the abort request ever do anything ?
>
>
> Seokmann Ju wrote:
>> Hi,
>> After the RFC, here is the patch.
>> Again, the implementation has following remarks,
>> - the SMP support in the SAS transport has been referenced, so the
>> layout of the changes are quite similar to it.
>> - at this stage, the ELS/CT service packet serviced one at a time,
>> synchronously.
>> - in the scsi_transport_fc module, there is dedicated handler in the
>> LLDD for ELS and CT, respectively.
>> - device files are created in following directories for each of
>> discovered initiator/targets,
>>        = /sys/class/bsg/rport-<host_no>:<bus>-<id>
>>        = dev/rport-<host_no>:<bus>-<id>
>> - the qla2xxx module has been tested with the simple applikcation  
>> that
>> issues some of ELS and CT service requests.
>> - abort mechanism is in place.
>> This patch was made against scsi-misc.
>> Thank you,
>> Seokmann

