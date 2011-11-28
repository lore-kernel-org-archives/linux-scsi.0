From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: mpt2sas regression: can not add disk...
Date: Mon, 28 Nov 2011 11:39:42 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A604726F2824@inbmail02.lsi.com>
References: <7863850E8C98C748980632D9D3B7C19911968B8AE5@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:50838 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749Ab1K1GJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2011 01:09:49 -0500
In-Reply-To: <7863850E8C98C748980632D9D3B7C19911968B8AE5@inbmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>
Cc: James Bottomley <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yinghai Lu,

Please set the driver logging level to 0x421F8 (echo 0x421F8 > /sys/module/mpt2sas/parameters/logging_level) and the scsi logging level to 0x180000F1 (echo 0x180000F1 > /proc/sys/dev/scsi/logging_level) and recreate the issue and provide the var/log/message

Regards,
Nagalakshmi




-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Yinghai Lu
Sent: Tuesday, November 22, 2011 8:42 AM
To: Nandigama, Nagalakshmi; James Bottomley; Linux-Scsi
Subject: mpt2sas regression: can not add disk...

[   42.047744] calling  _scsih_init+0x0/0x175 @ 1
[   42.052184] mpt2sas version 10.100.00.00 loaded
[   42.057154] scsi0 : Fusion MPT SAS Host
[   42.062299] mpt2sas 0000:40:00.0: PCI INT A -> GSI 40 (level, low) -> IRQ 40
[   42.069351] mpt2sas 0000:40:00.0: setting latency timer to 64
[   42.075094] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (8120880 kB)
[   42.083052]   alloc irq_desc for 100 on node 0
[   42.087502]   msi_compose_msg: mpt2sas 0000:40:00.0 irq 100 Set *IRTE* entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:6A Dest:00000001 SID:4000 SQ:0 SVT:1)
[   42.104342] mpt2sas 0000:40:00.0: irq 100 for MSI-X
[   42.109238]   ir_irq_set_affinity: mpt2sas 0000:40:00.0 irq 100 IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 *Vector*:6A *Dest*:00000001 SID:4000 SQ:0 SVT:1)
[   42.126264] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 100
[   42.131397] mpt2sas0: iomem(0x00000000df500000), mapped(0xffffc90000c60000), size(16384)
[   42.139480] mpt2sas0: ioport(0x0000000000007000), size(256)
[   42.433031] mpt2sas0: sending diag reset !!
[   43.564513] mpt2sas0: diag reset: SUCCESS
[   43.712491] mpt2sas 0000:40:00.0: with iommu 1 : domain 3
[   43.724243] mpt2sas0: Allocated physical memory: size(2255 kB)
[   43.730069] mpt2sas0: Current Controller Queue Depth(1001), Max Controller Queue Depth(1024)
[   43.738499] mpt2sas0: Scatter Gather Elements per IO(128)
[   43.976988] mpt2sas0: LSISAS2008: FWVersion(11.00.02.00), ChipRevision(0x02), BiosVersion(07.21.03.00)
[   43.986283] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[   43.997760] mpt2sas0: sending port enable !!
[   45.606943] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b000fa9460), phys(8)
[   51.724793] mpt2sas0: port enable: SUCCESS
[   51.731423] scsi 0:0:0:0: Direct-Access     SEAGATE  ST930003SSUN300G 0768 PQ: 0 ANSI: 5
[   51.739509] scsi 0:0:0:0: SSP: handle(0x0009), sas_addr(0x5000c5001364dfe1), phy(0), device_name(0x5000c5001364dfe0)
[   51.750108] scsi 0:0:0:0: SSP: enclosure_logical_id(0x500605b000fa9460), slot(0)
[   51.757496] scsi 0:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
[   51.768474]  port-0:0: remove: sas_addr(0x5000c5001364dfe1)
[   51.774051]  port-0:0: remove: sas_addr(0x5000c5001364dfe1), phy(0)
[   51.782940] mpt2sas0: removing handle(0x0009), sas_addr(0x5000c5001364dfe1)
[   51.789895] mpt2sas0: failure at drivers/scsi/mpt2sas/mpt2sas_transport.c:705/mpt2sas_transport_port_add()!
[   51.799920] initcall _scsih_init+0x0/0x175 returned 0 after 9523612 usecs


bisected to:

921cd8024b908f8f49f772c8d3a02381b4db2ed2 is the first bad commit
commit 921cd8024b908f8f49f772c8d3a02381b4db2ed2
Author: nagalakshmi.nandigama@lsi.com <nagalakshmi.nandigama@lsi.com>
Date:   Wed Oct 19 15:36:26 2011 +0530

    [SCSI] mpt2sas: New feature - Fast Load Support

    New feature Fast Load Support.

    (1)Asynchronous SCSI scanning: This will allow the drivers to scan
    for devices in parallel while other device drivers are loading at
    the same time. This will improve the amount of time it takes for the
    OS to load.

    (2) Reporting Devices while port enable is active: This feature will
    allow devices to be reported to OS immediately while port enable is
    active. The previous implementation waits for port enable to complete,
    and then report devices. This feature is only enabled on IT firmware
    configurations when there are no boot device configured in BIOS 
Configuration
    Utility, else the driver will wait till port enable completes reporting
    devices. For IR firmware, this feature is turned off. This feature 
is to
    address large SAS topologies (>100 drives) when the boot OS is 
using onboard
    SATA device, in other words, the boot devices is not
    connected to our controller.

    (3) Scanning for devices after diagnostic reset completes: A new 
routine
    _scsih_scan_start is added. This will scan the expander pages, IR 
pages,
    and sas device pages, then reporting new devices to SCSI Mid layer. It
    seems the driver is not supporting adding devices while diagnostic 
reset
    is active. Apparently this is due to the sanity checks on
    ioc->shost_recovery flag throughout the context of kernel work 
thread FIFO,
    and the mpt2sas_fw_work.

    Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>

:040000 040000 1677fb01f359d74e0cca33f81d47a66906e91969 
78cbc450d0224573f1bbf0d7427bbbbaeecb93d6 M      drivers
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
