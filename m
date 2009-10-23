From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Fri, 23 Oct 2009 09:58:40 +0200
Message-ID: <20091023075839.GC5930@schmichrtp.de.ibm.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <20091021152437.GA19717@schmichrtp.de.ibm.com> <4ADF37D5.5090507@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:47720 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZJWH7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 03:59:02 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate7.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n9N7wpQO407526
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 07:58:56 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9N7wfx72912340
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 08:58:41 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9N7wfqA030623
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 08:58:41 +0100
Content-Disposition: inline
In-Reply-To: <4ADF37D5.5090507@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Oct 21, 2009 at 12:33:25PM -0400, James Smart wrote:
> Here's what I remember about this from the past:
>
> - This was originally added when dealing with older kernels that didn't 
> have the eh patch that bounced the timeout handler when the rport was 
> blocked (see fc_timed_out).
>
>   The eh patch avoided entering the eh thread upon i/o timeouts if the 
> rport was blocked.
>
>
> - As mentioned in my prior email - there's a window where things can be  
> entered before the target blocked state protects you. What if you are in 
> the eh_handler when it occurs ?  Unfortunately, the eh thread is very 
> black and white on abort/reset/io status - its either success or not. It 
> doesn't validate the "not" cases, never looks at retry conditions, and 
> just assumes hard failure - which was taking everyone down bad paths.  
> This is a rats nest to resolve right, and I think I mentioned it on the 
> list a long time ago with Christoph. Thus the stall was added to plug the 
> hole.

I could imagine the case where something triggers the SCSI eh thread
(e.g.  a command timeout), but as soon as the eh thread starts the
recovery, something else prevents access to the remote port. Returning
DID_IMM_RETRY from fc_remote_port_chkready or the LLD does not help,
scsi_eh_completed_normally simply maps this error code to FAILED.
Holding off the SCSI eh thread until the rport leaves the BLOCKED
state will guarantee that we can either reach the rport or the SCSI
devices are being removed anyway.

It looks to me like this is required to prevent offline SCSI devices
in this case. Should this code be in a FC transport helper function
rather than being duplicated in each FC LLD?

Christof

> Christof Schmitt wrote:
>> On Tue, Oct 20, 2009 at 04:40:27PM +0200, Christof Schmitt wrote:
>>> If the remote_port status is not BLOCKED, this will trigger the SCSI
>>> midlayer error handling which cannot do much during the interruption
>>> to the hardware and will mark the SCSI devices 'offline'. In order to
>>> prevent this, the rule would be: First call fc_remote_port_delete to
>>> set the remote port (or in the case of an HBA interruption all remote
>>> ports) to BLOCKED, and only after this step call scsi_done to pass the
>>> SCSI commands back to the upper layers.
>>
>> I just stumbled across a loop that blocks the SCSI error handling
>> thread:
>>
>> 	spin_lock_irqsave(shost->host_lock, flags);
>> 	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
>> 		spin_unlock_irqrestore(shost->host_lock, flags);
>> 		msleep(1000);
>> 		spin_lock_irqsave(shost->host_lock, flags);
>> 	}
>> 	spin_unlock_irqrestore(shost->host_lock, flags);
>>
>> This seems to be popular among FC drivers. Is this the preferred way
>> to synchronize the FC transport class state changes with the SCSI
>> midlayer error recovery?
