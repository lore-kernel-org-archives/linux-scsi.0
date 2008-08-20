From: greg@enjellic.com
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Wed, 20 Aug 2008 16:13:45 -0500
Message-ID: <200808202113.m7KLDj6T015673@wind.enjellic.com>
References: <andrew.vasquez@qlogic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([209.243.13.15]:34203 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYHTVOP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 17:14:15 -0400
In-Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
       "Re: Poisoning of Linux initiators on SCST reboot." (Aug 13, 10:28pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, greg@enjellic.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, vst@vlnb.net

On Aug 13, 10:28pm, Andrew Vasquez wrote:
} Subject: Re: Poisoning of Linux initiators on SCST reboot.

Good afternoon to everyone, hope the day is going well.

> Ok, we've verified and backported the three changes through to 2.6.24.
> The patches in this order:
> 
>  [SCSI] qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5f3a9a207f1fccde476dd31b4c63ead2967d934f
> 
>  [SCSI] qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=85821c906cf3563a00a3d98fa380a2581a7a5ff1
> 
>  [PATCH 2/8] qla2xxx: Correct synchronization of software/firmware fcport states.
>  http://article.gmane.org/gmane.linux.scsi/43971
> 
> apply cleanly to 2.6.26 (git-am clean), and with minor 'fuzz' (git-am
> warns) while applying the first patch against 2.6.25 and 2.6.24.

We ran into an issue today which I wanted to bounce off everyone since
it may be related.  If not there may be another issue to look at.

We were transitioning storage on a pair of our production boxes from
an existing Linux SCSI target solution to SCST.  Previously the
storage was being accessed as target 0/LUN1.  Under SCST the storage
would be accessed as target 0/LUN0.

The target machine was upgraded and rebooted.  SCST loaded and
initialized.  The MDS indicated the initiator and target were both
logged into the zone.   So there would seem to be connectivity at the
link layer between the initiator/target and the switch.

Unfortunately we cannot get a session established on the target for
the initiator(s).  The initiators are running stock RHEL5 2.6.18
kernels.

Enabling/disabling the interface on the target server results in the
following messages on the initiators:

Aug 20 14:54:27 initiator kernel: rport-4:0-1: blocked FC remote port
time out: saving binding

The following are also noted in the output of dmesg on the initiators:

scsi 4:0:0:0: timing out command, waited 22s

There is a remote port defined for the target server.  The port WWN
and FCID match previous values.  The only difference is the LUN on
which the storage is being delivered.

We tore down the SCST storage definition on the target and re-mapped
the storage as LUN 1 but this had no affect on the situation.  That
isn't really surprising since the problem appears be secondary to the
initiator and target being unable to establish an N_PORT relationship.

I would be interested in any thoughts the group might have.  From the
perspective of the initiators the behavior seems somewhat identical to
what we experienced earlier.  The Qlogic driver is essentially
'poisoned' with respect to its ability to access the remote port which
has seen a change in configuration.

I should note that it doesn't appear there was an attempt by the
target's HBA to log into the fabric as an initiator.  So this would
seem to be a different scenario than what we noted before when the
target transitioned to an initiator role and back to a target role
from the perspective of the initiator.

> Thanks, av

We are in the process of scheduling an outage to reboot the initiators
to see if we can clear the situation.  Holler quickly if anyone has
any additional testing they would like conducted and I will try to get
that done before the outage.

Have a good evening.

}-- End of excerpt from Andrew Vasquez

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Any intelligent fool can make things bigger and more complex... It
 takes a touch of genius - and a lot of courage to move in the opposite
 direction."
                                -- Albert Einstein
