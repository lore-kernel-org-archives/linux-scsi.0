From: Greg KH <gregkh@suse.de>
Subject: Re: System reboot hangs due to race against devices_kset->list
	triggered by SCSI FC workqueue
Date: Tue, 2 Mar 2010 20:54:33 -0800
Message-ID: <20100303045433.GA27847@suse.de>
References: <233671224A0FED4688218FFDBED26E1A517AC38638@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab0CCEyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Mar 2010 23:54:31 -0500
Content-Disposition: inline
In-Reply-To: <233671224A0FED4688218FFDBED26E1A517AC38638@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Mar 02, 2010 at 04:47:01PM -0800, Hugh Daschbach wrote:
> The system may fail to boot when the kernel's devices_kset->list gets
> written by another thread while device_shutdown() is traversing the
> list.  Though not common, this is fairly reproducible for some SCSI
> Fibre Channel topologies; particularly so with FCoE configurations.

Really?  What a mess :(

> The reboot thread calls device_shutdown() as part of system shutdown.
> device_shutdown() loops through devices_kset->list, shutting down each
> system device.  But devices_kset->list isn't protected from other
> writers while device_shutdown() traverses the list.

Can't we just protect the list?  What is wanting to write to the list
while shutdown is happening?

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

Can't you just not do this?

> The attached patch detects and attempts to recover from the
> corruption.  But this can hardly be considered a fix, as it does not
> address the race between device_shutdown() and scsi_remove_target().

I agree, this patch isn't ok, it should be handled in the scsi core as
it looks like a scsi problem, not a driver core problem, right?

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

That shouldn't really solve the problem, right?

> Does anyone have any guidance for what would make a more appropriate
> fix?

So the scsi core is trying to remove a device at the same time shutdown
is happening, right?  So we need to protect the list somehow, maybe just
switch it over to use a klist which should handle this for us instead?
Can you try that?

thanks,

greg k-h
