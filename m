From: Go Taniguchi <go@turbolinux.co.jp>
Subject: Re: dptiO hangs on boot
Date: Sat, 31 Jul 2004 16:19:35 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410B4807.5030001@turbolinux.co.jp>
References: <20040730191507.GA678@synapse.neuralscape.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.turbolinux.co.jp ([210.171.55.67]:65032 "EHLO
	mail.turbolinux.co.jp") by vger.kernel.org with ESMTP
	id S261724AbUGaHXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jul 2004 03:23:08 -0400
In-Reply-To: <20040730191507.GA678@synapse.neuralscape.com>
List-Id: linux-scsi@vger.kernel.org
To: Karen Shaeffer <shaeffer@neuralscape.com>
Cc: linux-scsi@vger.kernel.org

Karen Shaeffer wrote:
> Hello,
> 
> The dpt_i2o driver hangs on boot. I am running the
> linux-2.6.8-rc2-bk7. Everything proceeds as expected,
> until md autodetects the RAID arrays, which hangs at
> the line,
> 
> md: ... autorun DONE.
> 
> After a number of minutes, The driver reports,
> 
> dptiO: Trying to Abort cmd=70
> 
> And then the system hangs indefinitely.

Probably you must select dpt_i2o or i2o_scsi for Adaptec I2O RAID controller driver.

> 
> 
> I include some information from the boot logs here:
> 
> Jul 30 01:45:15 demo kernel: Detecting Adaptec I2O RAID controllers...
> Jul 30 01:45:15 demo kernel: Adaptec I2O RAID controller 0 irq=106
> Jul 30 01:45:15 demo kernel:      BAR0 f889a000 - size= 100000
> Jul 30 01:45:15 demo kernel:      BAR1 f899b000 - size= 1000000
> Jul 30 01:45:15 demo kernel: dpti: If you have a lot of devices this could take a few minutes.
> Jul 30 01:45:15 demo kernel: dpti0: Reading the hardware resource table.
> Jul 30 01:45:15 demo kernel: TID 008  Vendor: ADAPTEC      Device: AIC-7902 Rev: 00000001
> Jul 30 01:45:15 demo kernel: TID 009  Vendor: ADAPTEC      Device: AIC-7902 Rev: 00000001
> Jul 30 01:45:15 demo kernel: TID 528  Vendor: IBM     I    Device: IC35L036UCDY Rev: S27EE
> Jul 30 01:45:15 demo kernel: TID 516  Vendor: IFT     I    Device: IFT-7200 Rev: 0145
> Jul 30 01:45:15 demo kernel: scsi0 : Vendor: Adaptec  Model: 2010S FW:3B05
> Jul 30 01:45:15 demo kernel:   Vendor: IBM       Model: IC35L036UCDY10-0 Rev: S27E
> Jul 30 01:45:15 demo kernel:   Type:   Direct-Access ANSI SCSI revision: 03
> Jul 30 01:45:15 demo kernel:   Vendor: IFT       Model: IFT-7200 Rev: 0145
> Jul 30 01:45:15 demo kernel:   Type:   Direct-Access ANSI SCSI revision: 04
> ....
> Jul 30 01:45:15 demo kernel: SCSI device sda: 71687323 512-byte hdwr sectors (36704 MB)
> Jul 30 01:45:15 demo kernel: SCSI device sda: drive cache: write back
> Jul 30 01:45:15 demo kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
> Jul 30 01:45:15 demo kernel: Attached scsi disk sda at scsi0, channel 0, id 1, lun 0
> Jul 30 01:45:15 demo kernel: SCSI device sdb: 78183919 512-byte hdwr sectors (40030 MB)
> Jul 30 01:45:15 demo kernel: SCSI device sdb: drive cache: write through
> Jul 30 01:45:15 demo kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
> Jul 30 01:45:15 demo kernel: Attached scsi disk sdb at scsi0, channel 1, id 0, lun 0
> Jul 30 01:45:15 demo kernel: Attached scsi generic sg0 at scsi0, channel 0, id 1, lun 0,  type 0
> Jul 30 01:45:15 demo kernel: Attached scsi generic sg1 at scsi0, channel 1, id 0, lun 0,  type 0
> Jul 30 01:45:15 demo kernel: I2O Core - (C) Copyright 1999 Red Hat Software
> Jul 30 01:45:15 demo kernel: I2O: Event thread created as pid 167
> Jul 30 01:45:15 demo kernel: i2o: Checking for PCI I2O controllers...
> Jul 30 01:45:15 demo kernel: I2O configuration manager v 0.04.
> Jul 30 01:45:15 demo kernel:   (C) Copyright 1999 Red Hat Software
> Jul 30 01:45:15 demo kernel: I2O Block Storage OSM v0.9
> Jul 30 01:45:15 demo kernel:    (c) Copyright 1999-2001 Red Hat Software.
> Jul 30 01:45:15 demo kernel: i2o_block: Checking for Boot device...
> Jul 30 01:45:15 demo kernel: i2o_block: Checking for I2O Block devices...
> Jul 30 01:45:15 demo kernel: i2o_scsi.c: Version 0.1.2
> Jul 30 01:45:15 demo kernel:   chain_pool: 0 bytes @ f7d8421c
> Jul 30 01:45:15 demo kernel:   (512 byte buffers X 4 can_queue X 0 i2o controllers)
> Jul 30 01:45:15 demo kernel: Fusion MPT base driver 3.01.03
> Jul 30 01:45:15 demo kernel: Copyright (c) 1999-2004 LSI Logic Corporation
> Jul 30 01:45:15 demo kernel: Fusion MPT SCSI Host driver 3.01.03
> Jul 30 01:45:15 demo kernel: Fusion MPT LAN driver 3.01.03
> ......
> Jul 30 01:45:16 demo kernel: md: linear personality registered as nr 1
> Jul 30 01:45:16 demo kernel: md: raid0 personality registered as nr 2
> Jul 30 01:45:16 demo kernel: md: raid1 personality registered as nr 3
> Jul 30 01:45:16 demo kernel: md: raid5 personality registered as nr 4
> Jul 30 01:45:16 demo kernel: raid5: measuring checksumming speed
> Jul 30 01:45:16 demo kernel:    8regs     :  2352.000 MB/sec
> Jul 30 01:45:16 demo kernel:    8regs_prefetch:  2172.000 MB/sec
> Jul 30 01:45:16 demo kernel:    32regs    :  1480.000 MB/sec
> Jul 30 01:45:16 demo kernel:    32regs_prefetch:  1400.000 MB/sec
> Jul 30 01:45:16 demo kernel:    pIII_sse  :  2584.000 MB/sec
> Jul 30 01:45:16 demo kernel:    pII_mmx   :  3152.000 MB/sec
> Jul 30 01:45:16 demo kernel:    p5_mmx    :  3108.000 MB/sec
> Jul 30 01:45:16 demo kernel: raid5: using function: pIII_sse (2584.000 MB/sec)
> Jul 30 01:45:16 demo kernel: md: multipath personality registered as nr 7
> Jul 30 01:45:16 demo kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> Jul 30 01:45:16 demo kernel: device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
> Jul 30 01:45:16 demo kernel: device-mapper: dm_multipath v0.2.0
> Jul 30 01:45:16 demo kernel: oprofile: using NMI interrupt.
> Jul 30 01:45:16 demo kernel: NET: Registered protocol family 2
> Jul 30 01:45:16 demo kernel: IP: routing cache hash table of 8192 buckets, 64Kbytes
> Jul 30 01:45:16 demo kernel: TCP: Hash tables configured (established 262144 bind 65536)
> Jul 30 01:45:16 demo kernel: NET: Registered protocol family 1
> Jul 30 01:45:16 demo kernel: NET: Registered protocol family 17
> Jul 30 01:45:16 demo kernel: ACPI: (supports S0 S1 S4 S5)
> Jul 30 01:45:16 demo kernel: BIOS EDD facility v0.13 2004-Mar-09, 6 devices found
> Jul 30 01:45:16 demo kernel: Please report your BIOS at http://linux.dell.com/edd/results.html
> Jul 30 01:45:16 demo kernel: md: Autodetecting RAID arrays.
> Jul 30 01:45:16 demo kernel: md: autorun ...
> Jul 30 01:45:16 demo kernel: md: ... autorun DONE.
> 
> If I can provide any additional information, please let me know.
> Thanks,
> Karen


