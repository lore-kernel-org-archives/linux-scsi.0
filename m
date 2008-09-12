From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 0/2] FC pass through support via bsg interface
Date: Fri, 12 Sep 2008 12:49:55 -0400
Message-ID: <48CA9DB3.20005@emulex.com>
References: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40241 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbYILQuo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 12:50:44 -0400
In-Reply-To: <56AAA08B-4276-4CA2-92E2-D539AD1AB769@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>

Seokmann,

There are number of fundamental issues with this patch that need to be 
corrected. I'll be at plumbers conference next week, and will be able to 
work through this. Please look me up if you will be there. Otherwise, 
I'll just post a revised patch.

Here are the issues as I see them:

- There is no concept of a Request Structure, that supplies the type of
   request and other parameters (such as a timeout). This should have
   come from the cdb bytes.  Over time, we can expand this request
   structure for other types of requests, not just els/ct passthru.

- There is no true definition of what the request payload should be.
   It's implied that it should be a fully built frame header, followed by
   payload.  We should be striking the frame header, and just stating
   that for els/ct, the request payload is the tx sequence payload.

- There is no definition of what the response payload should be. Does
   it contain a header too ? or what ? If the request is rejected,
   could it also contain other frame types ? We should simply state
   that it is the rx sequence payload, and only if successful.

- There is no concept or definition of a Reply structure, which should
   be stuffed into the request sense area.  This should be well defined,
   and matched to the request structure. We whould supply status values,
   or response data from RJT's, BSY's, aborted status's, etc.

- Once we follow the above, there's no need for common FC structures
   and so on. Note: if we did need them, rather than redefining them,
   we would premerge the headers from open-fcoe.

- We really should be making the request handling asynchronous in
   nature, rather than following smp's simple synchronous structure.

- Timeout values should be part of the request, not hardcoded in the
   transport. If there is one in the transport, it would be a default,
   used when the app didn't specify it, and should be tunable by sysfs.

- It would be nice, although difficult, to allow the user to abort
   an outstanding service request. We should look into what sgio
   does in this area.

- We really should add support, for the initial merge, to talk to an
   address that doesn't exist via an rport (think fabric service).
   This means adding some request types to the fc_host too.


-- james s


========

More detailed comments:

scsi_transport_fc.c:

- Do we really need a kmem_cache for service structures ?
   Note: given the blocking nature in what you sent, there could only
     be one request at a time being performed on the rport, so unless
     you're talking about a lot of requests to different rports
     simultaneously, why the cache ?  I'd argue even then, the number
     requests is small, so it doesn't need a cache.

- fc_service_handler is done oddly. I know you copied smp's approach,
   but we have no desire for the lld to override the transports handler.
   We would rather want to have the transport siphone of the requests
   it handles, and fall back to a driver handler.

- There's no reason for separate ct and els service handlers. It can
   be consolidated into a single handler, and data in the service
   structure or initial request structure.

- Have you tested how large of a single buffer you can supply and get
   by on the single sg vector ?  For nameserver payloads we should
   support bigger buffers - 4k as a minimum.

qla2xxx implementation:
- Why does the driver re-allocate buffers for the transmit and
   response payloads, and re-dma map them. Why couldn't it use
   the buffers/sg values from the initial request ?

- How does the timeout path ever work ?  with the qla driver blocking
   in it's request handlers - how does the transport wait_completion()
   ever get invoked prior to a request completing ? And if that's true,
   how did the abort request ever do anything ?


Seokmann Ju wrote:
> Hi,
> 
> After the RFC, here is the patch.
> Again, the implementation has following remarks,
> - the SMP support in the SAS transport has been referenced, so the
> layout of the changes are quite similar to it.
> - at this stage, the ELS/CT service packet serviced one at a time,
> synchronously.
> - in the scsi_transport_fc module, there is dedicated handler in the
> LLDD for ELS and CT, respectively.
> - device files are created in following directories for each of
> discovered initiator/targets,
>         = /sys/class/bsg/rport-<host_no>:<bus>-<id>
>         = dev/rport-<host_no>:<bus>-<id>
> - the qla2xxx module has been tested with the simple applikcation that
> issues some of ELS and CT service requests.
> - abort mechanism is in place.
> 
> This patch was made against scsi-misc.
> 
> Thank you,
> Seokmann
> 
