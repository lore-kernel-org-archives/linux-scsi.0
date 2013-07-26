From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Fri, 26 Jul 2013 13:40:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1307261337240.1028-100000@iolanthe.rowland.org>
References: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60937 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751301Ab3GZRkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 13:40:47 -0400
In-Reply-To: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

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

It looks like sd_sync_cache() should return immediately if no media is 
present or the media has been changed.

In addition, scsi_start_stop_device() should return immediately if no 
media is present.  Or at least, it shouldn't treat "medium not present" 
responses as errors.

Alan Stern

