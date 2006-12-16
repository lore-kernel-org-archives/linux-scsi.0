From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: I/O errors on 6TB device
Date: Sat, 16 Dec 2006 13:12:40 +0100
Message-ID: <em0nro$njf$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53336 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbWLPNOG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Dec 2006 08:14:06 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1GvYPI-0006mv-Tw
	for linux-scsi@vger.kernel.org; Sat, 16 Dec 2006 13:12:48 +0100
Received: from c-134-228-188.d.dsl.de.ignite.net ([62.134.228.188])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2006 13:12:48 +0100
Received: from bernd-schubert by c-134-228-188.d.dsl.de.ignite.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2006 13:12:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

recently I asked about problems to expect with >2TB devices and the answer
of Douglas made me hope we won't get any problems this time.
Unfortunately, we get I/O errors on accessing the device.

The unit is called transtec PV610S, which is actually an Infortrend EonStor
A16U-G2421-1 device.

Presently its running in test mode on our failover system with attached to a
MPT scsi controller, after thouroughly tested it is supposed to become our
main storage device on our primary server with an AIC79XX controller.

Without any knowledge about the scsi protocol and its error numbers it looks
like the device is claiming to have more sectors than it actually has,
doesn't it?

[17179724.816000] Fusion MPT base driver 3.03.07
[17179724.816000] Copyright (c) 1999-2005 LSI Logic Corporation
[17179724.832000] Fusion MPT SPI Host driver 3.03.07
[17179724.840000] ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 24 (level,
low) -> IRQ 19
[17179724.840000] mptbase: Initiating ioc0 bringup
[17179725.312000] ioc0: 53C1030: Capabilities={Initiator}
[17179725.800000] scsi0 : ioc0: LSI53C1030, FwRev=01030600h, Ports=1,
MaxQ=255, IRQ=19
[17179726.064000]   Vendor: Transtec  Model: PV610S16R1B       Rev: 347G
[17179726.064000]   Type:   Direct-Access                      ANSI SCSI
revision: 05
[17179726.084000] sda : very big device. try to use READ CAPACITY(16).
[17179726.084000] SCSI device sda: 12691101696 512-byte hdwr sectors
(6497844 MB)
[17179726.088000] sda: Write Protect is off
[17179726.088000] sda: Mode Sense: 9b 00 00 08
[17179726.088000] SCSI device sda: drive cache: write back
[17179726.100000] sda : very big device. try to use READ CAPACITY(16).
[17179726.100000] SCSI device sda: 12691101696 512-byte hdwr sectors
(6497844 MB)
[17179726.100000] sda: Write Protect is off
[17179726.100000] sda: Mode Sense: 9b 00 00 08
[17179726.100000] SCSI device sda: drive cache: write back
[17179726.100000]  sda:<6>sd 0:0:1:0: SCSI error: return code = 0xb0000
[17179726.132000] end_request: I/O error, dev sda, sector 12691101688
[17179726.132000] Buffer I/O error on device sda, logical block 1586387711
[17179726.136000] sd 0:0:1:0: SCSI error: return code = 0xb0000
[17179726.136000] end_request: I/O error, dev sda, sector 12691101688
[17179726.136000] Buffer I/O error on device sda, logical block 1586387711
[17179726.136000] Alternate GPT is invalid, using primary GPT.
[17179726.136000]
[17179726.136000] sd 0:0:1:0: Attached scsi disk sda
[17179726.160000] sd 0:0:1:0: Attached scsi generic sg0 type 0
[17179729.412000] ACPI: PCI Interrupt 0000:02:0a.1[B] -> GSI 25 (level,
low) -> IRQ 20
[17179729.660000] mptbase: Initiating ioc1 bringup
[17179730.132000] ioc1: 53C1030: Capabilities={Initiator}
[17179730.620000] scsi1 : ioc1: LSI53C1030, FwRev=01030600h, Ports=1,
MaxQ=255, IRQ=20
/10

Now using parted to set a proper partition table, parted will complain about
an I/O error and dmesg shows the messages below.

[17179939.464000] sd 0:0:1:0: SCSI error: return code = 0xb0000
[17179939.464000] end_request: I/O error, dev sda, sector 12691101688
[17180107.112000] sd 0:0:1:0: SCSI error: return code = 0xb0000
[17180107.116000] end_request: I/O error, dev sda, sector 12691101688


Any help is appriciated.

Thanks in advance,
Bernd

