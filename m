From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Tue, 27 Oct 2009 16:53:50 -0500
Message-ID: <4AE76BEE.20907@cs.wisc.edu>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <4ADF4EC3.6010506@cs.wisc.edu> <20091023071324.GA5930@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40286 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbZJ0Vxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Oct 2009 17:53:55 -0400
In-Reply-To: <20091023071324.GA5930@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Christof Schmitt wrote:
> On Wed, Oct 21, 2009 at 01:11:15PM -0500, Mike Christie wrote:
>> Christof Schmitt wrote:
>>> If the remote_port status is not BLOCKED, this will trigger the SCSI
>>> midlayer error handling which cannot do much during the interruption
>>> to the hardware and will mark the SCSI devices 'offline'. In order to
>>> prevent this, the rule would be: First call fc_remote_port_delete to
>>> set the remote port (or in the case of an HBA interruption all remote
>>> ports) to BLOCKED, and only after this step call scsi_done to pass the
>>> SCSI commands back to the upper layers.
>>>
>> One other note when doing this.
>>
>> For problems where you are deleting the rport, it is best to use  
>> something like DID_TRANSPORT_DISRUPTED to fail the cmd if you are  
>> failing it right away.
> 
> "something like DID_TRANSPORT_DISRUPTED" would be any error code that
> goes through "maybe_retry" in scsi_decide_disposition? I guess moving
> to DID_TRANSPORT_DISRUPTED is nice for consistency, but DID_ERROR
> triggers the same code paths as far as i can see.

It could be a little different. See scsi_noretry_cmd. If you used 
DID_ERROR and something set the driver failfast bit then it would be 
fast failed.


> 
>> If drivers block the rport, then fail commands  
>> immediately with DID_TRANSPORT_DISRUPTED, then they will not actually be  
>> failed to the block/mpath layer until the fast io fail timeout has  
>> fired. This will prevent very short problems from firing the mutlipath  
>> path offlining code.
> 
> Just to get the complete picture: Blocking the rport and then
> returning DID_TRANSPORT_DISRUPTED will retry the command to the LLD
> which then first calls fc_remote_port_chkready.
> fc_remote_port_chkready will then keep the command between LLD and
> SCSI midlayer until the rport state changes or the fast_fail fires.
> Is this the complete picture or did i miss something?

I think that is it.

> 
>> If your driver deletes the rport and does not fail the cmd immediately  
>> so it can recover within the command or some other reason like the fw  
>> just works that way, then when the fast io fail timer fires and the  
>> terminate_rport_io callback is run you could actually use any error code  
>> since at this time when a IO is sent to the queuecommand the driver will  
>> call fc_remote_port_chkready and IO will be failed immediately with  
>> DID_TRANSPORT_FAILFAST).
> 
> And the rport state is still BLOCKED, so at this point commands failed
> in the upper layers with blk_abort_request will not end up in the SCSI
> error recovery which cannot do much...
> 
> Thanks for the help, i am starting to get the complete picture...
> 
> Christof

