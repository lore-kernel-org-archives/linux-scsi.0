From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Fri, 25 Jul 2008 06:45:43 -0700
Message-ID: <20080725134543.GN14959@plap4-2.local>
References: <200807241750.m6OHophm028516@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:16504 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYGYNpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2008 09:45:46 -0400
Content-Disposition: inline
In-Reply-To: <200807241750.m6OHophm028516@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Thu, 24 Jul 2008, greg@enjellic.com wrote:

> Good morning to everyone, hope your respective days are going well.
> Sorry for the wide cast on this but I wanted to get what would seem to
> be the concerned parties on this issue in the loop.
<snip>
> The targets are using Qlogic 2462 cards using the isp_mod driver.  The
> client initiators are using Qlogic 2342 cards with the qla2xxx driver.
> 
> Failure mode is as follows:
> 
>         1.) Configure SCST based storage for an initiator (vdisk
>             based).
> 
>         2.) Activate initiator.  Initiator logs into fabric and
>             discovers SCST based storage.
> 
>         3.) Force SCST target failure by rebooting or pulling power.
> 
>         4.) SCST target returns to service and logs into zone.
> 
>         5.) Initiator picks up RSCN but re-activates the rport for
>             SCST server as an INITIATOR rather than TARGET role.
> 
> After this point in time the initiator is effectively 'poisoned'.
> 
> Nothing short of unloading and reloading the Qlogic 2xxx driver on the
> client initiator will allow the initiator to recognize the SCST server
> as a target device.  A driver unload/reload of course is not an option
> to restore connectivity since it would take the remaining live side of
> the mirror off-line as well.
> 
> We finally figured out what seems to be happening by watching the logs
> on the client and comparing what was going on there to the FLOGI login
> status on the fabric.
> 
> When the SCST target server reboots the initiator times out the remote
> port and places it into 'unknown' state.  The qla2xxx driver,
> according to the source code, maintains the previous rport state in
> driver internal data.

Ok, thanks for the detailed description of the problem...

> The 2462 card in the target on boot logs into the fabric with an
> initiator role, I'm assuming in support of BIOS based SAN booting. The
> client initiator picks up on this and re-activates the rport as being
> in an INITIATOR role.

Yes, BIOS would FLOGI into the switch...  RSCN received on initiator
side, and the role registered for the rport would have been migrated
from target->initiator... (Step 1)

> Loading the isp_mod driver causes the 2462 card in the target to be
> shutdown.  The client initiator picks up on this and times out the
> rport retaining the last rport state as INITIATOR.

Ok, I would have expected this to at least start when the BIOS FLOGI'd
into the switch above...

> Enabling target mode on the 2462 causes it to log back into the
> fabric.  The client initiator picks up on the RSCN but refuses to
> transition the rport from INITIATOR to TARGET state.

Ok, so on the initiator side, I'd expect and RSCN, PLOGI and PRLI to
target side, the bits processed from the PRLI response, role migrated
from UNKNOWN during fc_remote_port_add(), then to TARGET during
fc_remote_port_rolechg(). (Step 2)

> Without going
> into TARGET state the remote port won't have SCSI device discovery
> initiated against it and hence the SCST based storage is inaccessible.

Ok, could you provide the kernel log of the full failure with the
qla2xxx driver loaded with the ql2xextended_error_logging module
parameter set to 1.

> Activating a LIP on the client initiates a new fabric login attempt
> which completes with the following message:
> 
> Jul 24 02:53:59 init-test kernel: rport-2:0-0: blocked FC remote port
> time out: no longer a FCP target, removing starget
> 
> Which from a review of the source code seems consistent with our
> analysis of the problem.
> 
> The culprit is the following code from drivers/scsi/scsi_transport_fc.c:
> 
>         if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
>             (rport->scsi_target_id != -1) &&
>             !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
>                 dev_printk(KERN_ERR, &rport->dev,
>                         "blocked FC remote port time out: no longer"
>                         " a FCP target, removing starget\n");
>                 spin_unlock_irqrestore(shost->host_lock, flags);
>                 scsi_target_unblock(&rport->dev);
>                 fc_queue_work(shost, &rport->stgt_delete_work);
>                 return;
>         }

I would have expected this during step 1 (guess it depends on timing
latency during reboot/BIOS-flogi_plogi/isp_mod-load)...

> The above gets executed in response to the LIP on the initiator.  The
> value in rport->roles is being populated with what the remote target
> was INITIATOR rather than its current TARGET state.

Ok, so at step-1, the fc_remote_port_add() should have fallen into
this code:

      ...
      /* was a target, not in roles */
	if ((rport->scsi_target_id != -1) &&
	    (!(ids->roles & FC_PORT_ROLE_FCP_TARGET)))
		return rport;

since role is unknown... then transitioned to initiator during
rolechg().

then at step-2, the same process during fc_remote_port_add() (since
the transition to target is again deferred to rolechg()), then during
rolechg() I'd expect the transport would fall into the 'else if' here:

        spin_lock_irqsave(shost->host_lock, flags);
        if (roles & FC_PORT_ROLE_FCP_TARGET) {
                if (rport->scsi_target_id == -1) {
                        rport->scsi_target_id = fc_host->next_target_id++;
                        create = 1;
                } else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
                        create = 1;

Hmm, but that doesn't seem to be the case here...

Let's start with the driver logs, just I get full picture of at least
what's happending with qla2xxx at the wire-side.

Thanks, AV
