From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Wed, 21 Oct 2009 12:33:25 -0400
Message-ID: <4ADF37D5.5090507@emulex.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <20091021152437.GA19717@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40205 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbZJUQdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 12:33:24 -0400
In-Reply-To: <20091021152437.GA19717@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Here's what I remember about this from the past:

- This was originally added when dealing with older kernels that didn't have 
the eh patch that bounced the timeout handler when the rport was blocked (see 
fc_timed_out).

   The eh patch avoided entering the eh thread upon i/o timeouts if the rport 
was blocked.


- As mentioned in my prior email - there's a window where things can be 
entered before the target blocked state protects you. What if you are in the 
eh_handler when it occurs ?  Unfortunately, the eh thread is very black and 
white on abort/reset/io status - its either success or not. It doesn't 
validate the "not" cases, never looks at retry conditions, and just assumes 
hard failure - which was taking everyone down bad paths.  This is a rats nest 
to resolve right, and I think I mentioned it on the list a long time ago with 
Christoph. Thus the stall was added to plug the hole.

-- james s


Christof Schmitt wrote:
> On Tue, Oct 20, 2009 at 04:40:27PM +0200, Christof Schmitt wrote:
>> If the remote_port status is not BLOCKED, this will trigger the SCSI
>> midlayer error handling which cannot do much during the interruption
>> to the hardware and will mark the SCSI devices 'offline'. In order to
>> prevent this, the rule would be: First call fc_remote_port_delete to
>> set the remote port (or in the case of an HBA interruption all remote
>> ports) to BLOCKED, and only after this step call scsi_done to pass the
>> SCSI commands back to the upper layers.
> 
> I just stumbled across a loop that blocks the SCSI error handling
> thread:
> 
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
> 		spin_unlock_irqrestore(shost->host_lock, flags);
> 		msleep(1000);
> 		spin_lock_irqsave(shost->host_lock, flags);
> 	}
> 	spin_unlock_irqrestore(shost->host_lock, flags);
> 
> This seems to be popular among FC drivers. Is this the preferred way
> to synchronize the FC transport class state changes with the SCSI
> midlayer error recovery?
> 
> Christof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
