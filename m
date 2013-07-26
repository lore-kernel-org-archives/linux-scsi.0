From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Fri, 26 Jul 2013 16:31:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307261629290.1028-100000@iolanthe.rowland.org>
References: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux PM List <linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux SCSI List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 26 Jul 2013, Andy Lutomirski wrote:

> This is kernel 3.9.9-302.fc19.x86_64.
> 
> I plugged in a BN Nook (a usb mass storage device), used it, and
> ejected it.  This makes suspend fail:
> 
> [50135.265514] PM: Entering freeze sleep
> [50135.265517] Suspending console(s) (use no_console_suspend to debug)
> [50135.287724] sd 7:0:0:0: [sdb] Synchronizing SCSI cache
> [50135.290413] sd 7:0:0:0: [sdb]
> [50135.290415] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [50135.290418] sd 7:0:0:0: [sdb]
> [50135.290422] Sense Key : Not Ready [current]
> [50135.290424] sd 7:0:0:0: [sdb]
> [50135.290429] Add. Sense: Medium not present
> [50135.290448] dpm_run_callback(): scsi_bus_suspend+0x0/0x40 returns -5
> [50135.290454] PM: Device 7:0:0:0 failed to suspend async: error -5
> [50138.486917] PM: Some devices failed to suspend
> [50138.525007] PM: resume of devices complete after 38.132 msecs
> [50138.525315] pci_pm_runtime_suspend():
> hcd_pci_runtime_suspend+0x0/0x50 returns -16
> [50138.536357] PM: Finishing wakeup.

In addition to my earlier comment, the patch below should be applied.  
It will fix your immediate problem, although not in the best way.

Alan Stern



Index: usb-3.10/drivers/scsi/scsi_pm.c
===================================================================
--- usb-3.10.orig/drivers/scsi/scsi_pm.c
+++ usb-3.10/drivers/scsi/scsi_pm.c
@@ -48,8 +48,6 @@ static int scsi_dev_type_resume(struct d
 static int
 scsi_bus_suspend_common(struct device *dev, int (*cb)(struct device *))
 {
-	int err = 0;
