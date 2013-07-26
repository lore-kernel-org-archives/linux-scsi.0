From: Andy Lutomirski <luto@amacapital.net>
Subject: Ejected Nook (usb mass storage) prevents suspend
Date: Fri, 26 Jul 2013 09:54:02 -0700
Message-ID: <CALCETrVoMc+aCNgwthdwYzx9rXh=Zqzwb5e2djwbFB8FTo4kRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:42364 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3GZQyX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 12:54:23 -0400
Received: by mail-ve0-f171.google.com with SMTP id b10so1442531vea.30
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2013 09:54:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

This is kernel 3.9.9-302.fc19.x86_64.

I plugged in a BN Nook (a usb mass storage device), used it, and
ejected it.  This makes suspend fail:

[50135.265514] PM: Entering freeze sleep
[50135.265517] Suspending console(s) (use no_console_suspend to debug)
[50135.287724] sd 7:0:0:0: [sdb] Synchronizing SCSI cache
[50135.290413] sd 7:0:0:0: [sdb]
[50135.290415] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[50135.290418] sd 7:0:0:0: [sdb]
[50135.290422] Sense Key : Not Ready [current]
[50135.290424] sd 7:0:0:0: [sdb]
[50135.290429] Add. Sense: Medium not present
[50135.290448] dpm_run_callback(): scsi_bus_suspend+0x0/0x40 returns -5
[50135.290454] PM: Device 7:0:0:0 failed to suspend async: error -5
[50138.486917] PM: Some devices failed to suspend
[50138.525007] PM: resume of devices complete after 38.132 msecs
[50138.525315] pci_pm_runtime_suspend():
hcd_pci_runtime_suspend+0x0/0x50 returns -16
[50138.536357] PM: Finishing wakeup.

Experimenting a bit, here's what happens.

 - Plug in device (so it's working).  Suspend works.
 - eject /dev/sdb.  Suspend fails.
 - Physically unplug the device.  Suspend works again.

This is actually a real issue -- my laptop can continue to power its
usb port while suspended, and the Nook is functional (and charges)
while plugged in but ejected, but I can't suspend my laptop so it can
charge my Nook.

Curiously, this issue seems to be Nook-specific.  I can't reproduce it
with a Corsair Flash Voyager.

--Andy
