From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: I/O errors on 6TB device
Date: Sat, 16 Dec 2006 09:28:34 -0600
Message-ID: <1166282914.2878.2.camel@mulgrave.il.steeleye.com>
References: <em0nro$njf$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49508 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161045AbWLPP2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Dec 2006 10:28:40 -0500
In-Reply-To: <em0nro$njf$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsil.com>

On Sat, 2006-12-16 at 13:12 +0100, Bernd Schubert wrote:
> Hi,
> 
> recently I asked about problems to expect with >2TB devices and the answer
> of Douglas made me hope we won't get any problems this time.
> Unfortunately, we get I/O errors on accessing the device.
> 
> The unit is called transtec PV610S, which is actually an Infortrend EonStor
> A16U-G2421-1 device.
> 
> Presently its running in test mode on our failover system with attached to a
> MPT scsi controller, after thouroughly tested it is supposed to become our
> main storage device on our primary server with an AIC79XX controller.
> 
> Without any knowledge about the scsi protocol and its error numbers it looks
> like the device is claiming to have more sectors than it actually has,
> doesn't it?
> 
> [17179724.816000] Fusion MPT base driver 3.03.07
> [17179724.816000] Copyright (c) 1999-2005 LSI Logic Corporation
> [17179724.832000] Fusion MPT SPI Host driver 3.03.07
> [17179724.840000] ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 24 (level,
> low) -> IRQ 19
> [17179724.840000] mptbase: Initiating ioc0 bringup
> [17179725.312000] ioc0: 53C1030: Capabilities={Initiator}
> [17179725.800000] scsi0 : ioc0: LSI53C1030, FwRev=01030600h, Ports=1,
> MaxQ=255, IRQ=19
> [17179726.064000]   Vendor: Transtec  Model: PV610S16R1B       Rev: 347G
> [17179726.064000]   Type:   Direct-Access                      ANSI SCSI
> revision: 05
> [17179726.084000] sda : very big device. try to use READ CAPACITY(16).
> [17179726.084000] SCSI device sda: 12691101696 512-byte hdwr sectors
> (6497844 MB)
> [17179726.088000] sda: Write Protect is off
> [17179726.088000] sda: Mode Sense: 9b 00 00 08
> [17179726.088000] SCSI device sda: drive cache: write back
> [17179726.100000] sda : very big device. try to use READ CAPACITY(16).
> [17179726.100000] SCSI device sda: 12691101696 512-byte hdwr sectors
> (6497844 MB)
> [17179726.100000] sda: Write Protect is off
> [17179726.100000] sda: Mode Sense: 9b 00 00 08
> [17179726.100000] SCSI device sda: drive cache: write back
> [17179726.100000]  sda:<6>sd 0:0:1:0: SCSI error: return code = 0xb0000
> [17179726.132000] end_request: I/O error, dev sda, sector 12691101688

This is definitely a fusion driver error: it's DID_SOFT_ERROR, which
that driver returns for a variety of firmware related conditions or
transfer underruns.

I've cc'd the fusion people to see if they can help you diagnose it
further.

James


> [17179726.132000] Buffer I/O error on device sda, logical block 1586387711
> [17179726.136000] sd 0:0:1:0: SCSI error: return code = 0xb0000
> [17179726.136000] end_request: I/O error, dev sda, sector 12691101688
> [17179726.136000] Buffer I/O error on device sda, logical block 1586387711
> [17179726.136000] Alternate GPT is invalid, using primary GPT.
> [17179726.136000]
> [17179726.136000] sd 0:0:1:0: Attached scsi disk sda
> [17179726.160000] sd 0:0:1:0: Attached scsi generic sg0 type 0
> [17179729.412000] ACPI: PCI Interrupt 0000:02:0a.1[B] -> GSI 25 (level,
> low) -> IRQ 20
> [17179729.660000] mptbase: Initiating ioc1 bringup
> [17179730.132000] ioc1: 53C1030: Capabilities={Initiator}
> [17179730.620000] scsi1 : ioc1: LSI53C1030, FwRev=01030600h, Ports=1,
> MaxQ=255, IRQ=20
> /10
> 
> Now using parted to set a proper partition table, parted will complain about
> an I/O error and dmesg shows the messages below.
> 
> [17179939.464000] sd 0:0:1:0: SCSI error: return code = 0xb0000
> [17179939.464000] end_request: I/O error, dev sda, sector 12691101688
> [17180107.112000] sd 0:0:1:0: SCSI error: return code = 0xb0000
> [17180107.116000] end_request: I/O error, dev sda, sector 12691101688
> 
> 
> Any help is appriciated.
> 
> Thanks in advance,
> Bernd
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

