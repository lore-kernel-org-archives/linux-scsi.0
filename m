From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Mon, 29 Jul 2013 08:02:52 +0200
Message-ID: <1375077772.25230.3.camel@linux-fkkt.site>
References: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab3G2GCy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jul 2013 02:02:54 -0400
In-Reply-To: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de

On Fri, 2013-07-26 at 09:54 -0700, Andy Lutomirski wrote:
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
> 
> Experimenting a bit, here's what happens.
> 
>  - Plug in device (so it's working).  Suspend works.
>  - eject /dev/sdb.  Suspend fails.
>  - Physically unplug the device.  Suspend works again.

Hi,

this looks like a logical error in sd_suspend(). It should
ignore errors due to missing media (or offlined devices)

	Regards
		Oliver


