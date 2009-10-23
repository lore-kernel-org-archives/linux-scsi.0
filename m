From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Fri, 23 Oct 2009 09:13:24 +0200
Message-ID: <20091023071324.GA5930@schmichrtp.de.ibm.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <4ADF4EC3.6010506@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:55792 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZJWHNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 03:13:22 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n9N7DQ8h003956
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 07:13:26 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9N7DQY73113200
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 08:13:26 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9N7DPAj026096
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 08:13:26 +0100
Content-Disposition: inline
In-Reply-To: <4ADF4EC3.6010506@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 21, 2009 at 01:11:15PM -0500, Mike Christie wrote:
> Christof Schmitt wrote:
>> If the remote_port status is not BLOCKED, this will trigger the SCSI
>> midlayer error handling which cannot do much during the interruption
>> to the hardware and will mark the SCSI devices 'offline'. In order to
>> prevent this, the rule would be: First call fc_remote_port_delete to
>> set the remote port (or in the case of an HBA interruption all remote
>> ports) to BLOCKED, and only after this step call scsi_done to pass the
>> SCSI commands back to the upper layers.
>>
>
> One other note when doing this.
>
> For problems where you are deleting the rport, it is best to use  
> something like DID_TRANSPORT_DISRUPTED to fail the cmd if you are  
> failing it right away.

"something like DID_TRANSPORT_DISRUPTED" would be any error code that
goes through "maybe_retry" in scsi_decide_disposition? I guess moving
to DID_TRANSPORT_DISRUPTED is nice for consistency, but DID_ERROR
triggers the same code paths as far as i can see.

> If drivers block the rport, then fail commands  
> immediately with DID_TRANSPORT_DISRUPTED, then they will not actually be  
> failed to the block/mpath layer until the fast io fail timeout has  
> fired. This will prevent very short problems from firing the mutlipath  
> path offlining code.

Just to get the complete picture: Blocking the rport and then
returning DID_TRANSPORT_DISRUPTED will retry the command to the LLD
which then first calls fc_remote_port_chkready.
fc_remote_port_chkready will then keep the command between LLD and
SCSI midlayer until the rport state changes or the fast_fail fires.
Is this the complete picture or did i miss something?

> If your driver deletes the rport and does not fail the cmd immediately  
> so it can recover within the command or some other reason like the fw  
> just works that way, then when the fast io fail timer fires and the  
> terminate_rport_io callback is run you could actually use any error code  
> since at this time when a IO is sent to the queuecommand the driver will  
> call fc_remote_port_chkready and IO will be failed immediately with  
> DID_TRANSPORT_FAILFAST).

And the rport state is still BLOCKED, so at this point commands failed
in the upper layers with blk_abort_request will not end up in the SCSI
error recovery which cannot do much...

Thanks for the help, i am starting to get the complete picture...

Christof
