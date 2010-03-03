From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Wed, 3 Mar 2010 10:50:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003031046370.2821-100000@iolanthe.rowland.org>
References: <233671224A0FED4688218FFDBED26E1A517AC38638@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50863 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753418Ab0CCPuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 10:50:37 -0500
In-Reply-To: <233671224A0FED4688218FFDBED26E1A517AC38638@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2 Mar 2010, Hugh Daschbach wrote:

> The system may fail to boot when the kernel's devices_kset->list gets
> written by another thread while device_shutdown() is traversing the
> list.  Though not common, this is fairly reproducible for some SCSI
> Fibre Channel topologies; particularly so with FCoE configurations.
> 
> The reboot thread calls device_shutdown() as part of system shutdown.
> device_shutdown() loops through devices_kset->list, shutting down each
> system device.  But devices_kset->list isn't protected from other
> writers while device_shutdown() traverses the list.
> 
> One such secondary writer is the SCI Fibre Channel workqueue.  When
> fc_wq_N removes a device that device_shutdown() holds in it's "devn"
> (list traversal iterator) variable, device_shutdown() stalls, chasing
> what is essentially a broken link.
> 
> This is not a common occurrence.  But FC SCSI devices associated with a
> link that has gone down cause a race between device_shutdown() running
> in reboot's process and scsi_remove_target() running in a SCSI FC
> workqueue (fc_wq_N).
> 
> Network attached FC devices are particularly vulnerable because SysV
> init scripts shut network interfaces down before proceeding with the
> reboot request.  So by the time reboot is called, the link to the FC
> devices is already down.
> 
> When the link is down device_shutdown() stalls (in sd_shutdown() --
> which issues cache flush CDBs to what are, by that time, inaccessible
> devices).  The stall ends when the fc rport timer expires.  But the
> timer expiration also initiates fc_starget_delete() in the fc workqueue,
> causing the race with device_shutdown().
> 
> The attached patch detects and attempts to recover from the
> corruption.  But this can hardly be considered a fix, as it does not
> address the race between device_shutdown() and scsi_remove_target().
> 
> Perhaps converting the list_for_each_entry_safe_reverse() to something
> like.
> 
>         while (!list_empty(&devices_kset->list)) {
>                 dev = list_last_entry(...);
>                 ...
>         }
> 
> might be appropriate.  But I have no idea if any devices don't fully
> remove themselves from the list when shutdown.

You can't make any assumptions about that.  Probably most of them 
don't.

> Does anyone have any guidance for what would make a more appropriate
> fix?

Your suggestion above ought to work out okay, if you remove each device
from the list yourself as you come to it.  (I don't think that will
cause problems elsewhere, but I could be wrong.)  However, struct kset
contains a spinlock which is supposed to protect the list.  This loop
should be using the spinlock.

Alan Stern

