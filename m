From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Thu, 4 Mar 2010 14:22:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003041420510.1742-100000@iolanthe.rowland.org>
References: <233671224A0FED4688218FFDBED26E1A5181BF12D1@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55054 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756894Ab0CDTWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2010 14:22:35 -0500
In-Reply-To: <233671224A0FED4688218FFDBED26E1A5181BF12D1@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>

On Thu, 4 Mar 2010, Hugh Daschbach wrote:

> Apparently I still don't understand your original suggestion.  I'd
> prefer to, especially if it leads to a simpler fix.  The loop in
> device_shutdown() looks something like:
> 
>        struct device *dev, *devn;
> 
>         list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
>                                 kobj.entry) {
>                 if (dev->bus && dev->bus->shutdown) {
>                         dev->bus->shutdown(dev);
>                 } else if (dev->driver && dev->driver->shutdown) {
>                         dev->driver->shutdown(dev);
>                 }
>         }
> 
> *dev gets delinked kobj_kset_leave() indirectly called from
> dev->*->shutdown(dev).  This is protected by the spinlock.
> 
> The secondary thread similarly calls kobj_kset_leave().  But when the
> secondary thread calls the shutdown routine for the device that devn
> points to, the loop hangs.
> 
> Is there some way I can detect that devn no longer points to a valid
> device upon return from dev->*->shutdown(dev)?  Or, where else can I
> look to better understand your suggestion?

Did you read the patch in my previous message?  You didn't quote it.  
It removes the devn variable, so the problem you're worried about
cannot occur.

Alan Stern

