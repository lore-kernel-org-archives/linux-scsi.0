From: Lars Randers <lars@nstec.dk>
Subject: [scsi] mpt-fusion: No SES device support?
Date: Sat, 22 Sep 2012 21:54:28 +0200
Message-ID: <CAO5z_vJq+LgaE9noZxvxX8Gu_J_+5=ECBuY5OiQ_687cnrq9cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55478 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2IVTy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2012 15:54:29 -0400
Received: by lbbgj3 with SMTP id gj3so5225972lbb.19
        for <linux-scsi@vger.kernel.org>; Sat, 22 Sep 2012 12:54:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I can't get the SES device on my MPT controller to show up in Linux as
a sg device.

The controller is a re-flashed IBM BR10i (LSISAS1068E), running the
latest firmware and it is connected
to the SES capable backplane via i2c on the SFF-8087 sidebands.

Bios post as follows:

SLOT  ID   LUN  VENDOR                    PRODUCT
REVISION                SIZE \ NV
--------- ----- ------- ---------------------------------
------------------------------  ---------------------------
----------------
    8       0    0    IBM                            SAS SES-2 DEVICE  01.0
    8       1    0    IBM-ESXS                   ST973401SS
 B51D                       68 GB
    8       2    0    IBM-ESXS                   ST973401SS
 B51D                       68 GB
    8                  LSILogic                      SAS1068E-IT
      1.33.00.00               NV 2D:03


Windows 7 reports the device present in device manager.

Here's a snip from messages:

Sep 22 21:31:15 nas kernel: Fusion MPT base driver 3.04.20
Sep 22 21:31:15 nas kernel: Copyright (c) 1999-2008 LSI Corporation
Sep 22 21:31:15 nas kernel: Fusion MPT SAS Host driver 3.04.20
Sep 22 21:31:15 nas kernel: ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
Sep 22 21:31:15 nas kernel: mptsas 0000:01:00.0: PCI INT A ->
Link[APC5] -> GSI 16 (level, low) -> IRQ 16
Sep 22 21:31:15 nas kernel: mptbase: ioc0: Initiating bringup
Sep 22 21:31:15 nas kernel: ioc0: LSISAS1068E B3: Capabilities={Initiator}
Sep 22 21:31:15 nas kernel: scsi7 : ioc0: LSISAS1068E B3,
FwRev=01210000h, Ports=1, MaxQ=483, IRQ=16
Sep 22 21:31:15 nas kernel: mptsas: ioc0: attaching ssp device:
fw_channel 0, fw_id 1, phy 1, sas_addr 0x5000c500002b0f59
Sep 22 21:31:15 nas kernel: scsi 7:0:0:0: Direct-Access     IBM-ESXS
ST973401SS       B51D PQ: 0 ANSI: 5
Sep 22 21:31:15 nas kernel: mptsas: ioc0: attaching ssp device:
fw_channel 0, fw_id 2, phy 2, sas_addr 0x5000c500002b0d95
Sep 22 21:31:15 nas kernel: scsi 7:0:1:0: Direct-Access     IBM-ESXS
ST973401SS       B51D PQ: 0 ANSI: 5
Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] 143374000 512-byte
logical blocks: (73.4 GB/68.3 GiB)
Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] 143374000 512-byte
logical blocks: (73.4 GB/68.3 GiB)
Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] Write Protect is off
Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] Write Protect is off
Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] Write cache: disabled,
read cache: enabled, supports DPO and FUA
Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] Write cache: disabled,
read cache: enabled, supports DPO and FUA
Sep 22 21:31:15 nas kernel: sd 7:0:1:0: [sdd] Attached SCSI disk
Sep 22 21:31:15 nas kernel: sd 7:0:0:0: [sdc] Attached SCSI disk
Sep 22 21:31:15 nas kernel: sd 7:0:0:0: Attached scsi generic sg2 type 0
Sep 22 21:31:15 nas kernel: sd 7:0:1:0: Attached scsi generic sg3 type 0

Looking at mptsas.c with my limited knowledge of the mpt complex, I
can't really spot any probes for anything but
resources connected directly to the PHY's and ofc the adding of the
raid volume if the firmware is running as IR.

Is there anyone here who wants to help me get the raw SES device to
show up as a /dev/sg<x>
so I can use the sg_ses (sg3_utils) commands to control the leds and
get environmental readouts?

I'll apply any patch you can come up with for the sake of getting
support into the kernel.

TIA,
Lars Randers.
