From: "Jack Wang" <jack_wang@usish.com>
Subject: Re:[RFC] libsas: the trouble with ata resets
Date: Wed, 26 Oct 2011 11:04:29 +0800
Message-ID: <660ADDE5D3A1477593E284FFA68F76E3@usish.com.cn>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37593 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1JZDDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2011 23:03:08 -0400
In-Reply-To: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'IDE/ATA development list' <linux-ide@vger.kernel.org>
Cc: "'Skirvin, Jeffrey D'" <jeffrey.d.skirvin@intel.com>, 'Jacek Danecki' <jacek.danecki@intel.com>, "'edmund.nadolski'" <edmund.nadolski@intel.com>, 'Luben Tuikov' <ltuikov@yahoo.com>, 'Mark Salyzyn' <mark_salyzyn@us.xyratex.com>, 'Hannes Reinecke' <hare@suse.de>, 'David Milburn' <dmilburn@redhat.com>, 'Jeff Garzik' <jeff@garzik.org>, 'James Bottomley' <jbottomley@parallels.com>

I have seen this problem too, but have not figure out how to do the right
thing. Add Jeff and James to CC, maybe they have more insight idea to fix
this.

BTW: how to push Redhat and SUSE to include the libsas fix like: T-T support
and others will cause this oops.

Jack

[RFC] libsas: the trouble with ata resets
> 
> Currently libsas has a problem with prematurely dropping sata devices
> during recovery.  Libata knows that some devices can take quite a
> while to recover from a reset and re-establish the link.  The fact
> that sas_ata_hard_reset() ignores its 'deadline'  parameter is
> evidence that it ignores the link management aspects of what libata
> wants from a ->hardreset() handler.
> 
> item1: teach sas_ata_hard_reset() to check that the link came back up.
>  For direct attached devices the lldd will need the deadline
> parameter, and for expander attached perform smp polling to wait for
> the link to come back.
> 
> Now, during this time that libata is trying to recover the connection
> in the host-eh context libsas will start receiving BCNs in the
> host-workqueue context.  In the unfortunate cases libsas may take
> removal action on a device that will come back with a bit more time.
> While libata-eh is in progress libsas should not take any action on
> the ata phys in question..
> 
> item2:  flush eh before trying to determine what action to take on a phy.
> 
> In the case of libsas not all resets are initiated by the eh process
> (the sas transport class can reset a phy directly).  It seems libata
> takes care to arrange for user requested resets to occur under the
> control of eh, and libsas should do the same.
> 
> item3: teach all reset entry points to kick and flush eh for ata devices
> 
> A corollary for items 1 and 3 is that there is a difference between
> scheduling the reset and performing the reset.
> ->lldd_I_T_nexus_reset() is currently called twice, once by sas-eh to
> manage sas_tasks and again by ata-eh to recover the device.  Likely we
> need a new ->lldd_ata_hard_reset() handler that is called by ata-eh,
> while ->lldd_I_T_nexus_reset() cleans up the sas_tasks and just
> schedules reset on the ata_port.
> 
> item4: allow for lldd's to provide a direct ->lldd_ata_hard_reset()
> which can be assumed to only be called from ata-eh context.
> 
> Any other pain points in reset handling?
> 
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

