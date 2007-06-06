From: "Matthew Jacob" <lydianconcepts@gmail.com>
Subject: Re: Very slow writes with mptsas
Date: Tue, 5 Jun 2007 22:32:40 -0700
Message-ID: <7579f7fb0706052232x44db1f7he88a50646a3c57db@mail.gmail.com>
References: <20070605161620.GB6519@bloch.config>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:52407 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbXFFFcl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2007 01:32:41 -0400
Received: by nz-out-0506.google.com with SMTP id n1so36840nzf
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jun 2007 22:32:40 -0700 (PDT)
In-Reply-To: <20070605161620.GB6519@bloch.config>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bloch@verdurin.com" <bloch@verdurin.com>
Cc: linux-scsi@vger.kernel.org, linux-precision@dell.com

The FreeBSD problem was fixed by Scott Long a couple of days ago by
doing some cut through SAS stuff that enabled Write Cache for SATA
drives. Why LSI-Logic couldn't just blitheringly synthesize mode page
8 is beyond me, but okay.

I dunno whether the issue here is the same one Scott tackled- probably
given the messages. Eric- you listening in on this?

-matt


On 6/5/07, bloch@verdurin.com <bloch@verdurin.com> wrote:
> Hello
>
> I'm seeing very slow writes on a Dell Precision 690 with the Dell SAS5
> adapter, serving a RAID1 array of SATA-II disks.
>
> It's very similar to the problem in FreeBSD, described here:
>
> http://unix.derkeiler.com/Mailing-Lists/FreeBSD/stable/2007-03/msg00756.html
>
> I'm running FC6 with the latest kernel.
>
> Reads are quite fast, writes terribly slow.
>
> dmesg and lspci out below.
>
> Is the Linux driver suffering from a similar problem?
>
> Adam
>
>
> SCSI subsystem initialized
> Fusion MPT base driver 3.04.03
> Copyright (c) 1999-2007 LSI Logic Corporation
> Fusion MPT SAS Host driver 3.04.03
> ACPI: PCI Interrupt 0000:05:0b.0[A] -> GSI 24 (level, low) -> IRQ 24
> mptbase: Initiating ioc0 bringup
> ioc0: SAS1068: Capabilities={Initiator}
> scsi0 : ioc0: LSISAS1068, FwRev=00063200h, Ports=1, MaxQ=511, IRQ=24
> scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000KS-75M 2E08 PQ: 0
> ANSI: 5
> scsi 0:0:1:0: Direct-Access     ATA      HDS725050KLA360  AB5A PQ: 0
> ANSI: 5
> scsi 0:1:0:0: Direct-Access     Dell     VIRTUAL DISK     1028 PQ: 0
> ANSI: 5
> SCSI device sda: 976562176 512-byte hdwr sectors (500000 MB)
> sda: Write Protect is off
> sda: Mode Sense: 03 00 00 08
> SCSI device sda: write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
> SCSI device sda: 976562176 512-byte hdwr sectors (500000 MB)
> sda: Write Protect is off
> sda: Mode Sense: 03 00 00 08
> SCSI device sda: write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2 sda3
> sd 0:1:0:0: Attached scsi disk sda
>
> There are no cache-related options in the controller BIOS.
>
> 00:00.0 Host bridge: Intel Corporation 5000X Chipset Memory Controller
> Hub (rev 12)
> 00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
> Port 2 (rev 12)
> 00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
> Port 3 (rev 12)
> 00:04.0 PCI bridge: Intel Corporation 5000X Chipset PCI Express x16 Port
> 4-7 (rev 12)
> 00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
> Port 5 (rev 12)
> 00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
> Port 6 (rev 12)
> 00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
> Port 7 (rev 12)
> 00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error
> Reporting Registers (rev 12)
> 00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error
> Reporting Registers (rev 12)
> 00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error
> Reporting Registers (rev 12)
> 00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
> Registers (rev 12)
> 00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
> Registers (rev 12)
> 00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers
> (rev 12)
> 00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers
> (rev 12)
> 00:1b.0 Audio device: Intel Corporation 631xESB/632xESB High Definition
> Audio Controller (rev 09)
> 00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI
> Express Root Port 1 (rev 09)
> 00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
> UHCI USB Controller #1 (rev 09)
> 00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
> UHCI USB Controller #2 (rev 09)
> 00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
> UHCI USB Controller #3 (rev 09)
> 00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
> UHCI USB Controller #4 (rev 09)
> 00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
> EHCI USB2 Controller (rev 09)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
> 00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
> Interface Controller (rev 09)
> 00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller
> (rev 09)
> 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA Storage
> Controller AHCI (rev 09)
> 00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
> Controller (rev 09)
> 01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
> Upstream Port (rev 01)
> 01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
> PCI-X Bridge (rev 01)
> 02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
> Downstream Port E1 (rev 01)
> 02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
> Downstream Port E2 (rev 01)
> 05:0b.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
> Fusion-MPT SAS (rev 01)
> 07:00.0 VGA compatible controller: nVidia Corporation Quadro FX 3500
> (rev a1)
> 0b:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752
> Gigabit Ethernet PCI Express (rev 02)
> 0c:0a.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
> IEEE-1394a-2000 Controller (PHY/Link)
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
