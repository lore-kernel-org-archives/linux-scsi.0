From: Eric Moore <eric.moore@lsil.com>
Subject: Re: [PATCH] mptspi : min_period, max_offset, max_width,incorrectly set, resulting domain validation failing
Date: Tue, 19 Sep 2006 12:41:38 -0600
Message-ID: <20060919184137.GA12200@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60888 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751912AbWISSoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 14:44:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Monday, September 18, 2006 9:53 PM, James Bottomley wrote:
> All of this should be done already in the generic code ... it knows full
> well that the min and max taken from the BIOS are likely
> "overoptimistic" so it doesn't begin with them as the negotiation ... it
> begins with whatever the device can support from its inquiry data and
> then reduces these so as not to go over/under the min/max settings

No, I don't see spi transport layer properly setting min_period
per what inquiry says it can support.  I have a device capable of doing
FAST40, however MPT Bios says it can do U320 (factor 0x8). Spi transport
tries factor=0x8 on it and the max speed inquiry test fail's.

See my example below. Using my newer driver with debug enabled.  I commented
out my fix for setting min_sync from inquiry, so instead I'm sending the nvram
values which are min_period=0x08 max_offset=0x7f max_width=1. Notice
that spi transport tryies sending nego at U320.

> Can you post the problem you're actually having?  If there's a
> negotiation problem in the SPI transport class, it's likely not specific
> to the mptspi driver.

Here is my Fast-40 device:

standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x02  [SCSI-2]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=1  Sync=1  Linked=0  [TranDis=0]  CmdQue=1
  Clocking=0x0  QAS=0  IUS=0
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: QUANTUM 
 Product identification: VIKING II 4.5WLS
 Product revision level: 5542
 Unit serial number: 194818141287



Fusion MPT base driver 3.04.02
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.02
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:09:02.0[A] -> GSI 72 (level, low) -> IRQ 193
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator,Target}
[ACPI Debug]  String: [0x0B] "_TMP Method"
mptbase: ioc0: PortPage0 minSyncFactor=8
mptspi: ioc0: saf_te 0
scsi2 : ioc0: LSI53C1030, FwRev=01032310h, Ports=1, MaxQ=255, IRQ=193
mptspi: ioc0: id=0 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
scsi 2:0:0:0: Direct access     QUANTUM  VIKING II 4.5WLS 5542 PQ: 0 ANSI: 2
mptspi: ioc0: id=0 min_period=0x08 max_offset=0x7f max_width=1
 target2:0:0: Beginning Domain Validation
mptspi: ioc0: id=0 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
mptspi: ioc0: id=0 Requested = 0x00000a00 (  factor = 0x0a @ offset = 0x00 )
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
mptspi: ioc0: id=0 Requested = 0x20000a00 ( Wide  factor = 0x0a @ offset = 0x00 )
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
mptspi: ioc0: id=0 Requested = 0x207f0a00 ( Wide  factor = 0x0a @ offset = 0x7f )
mptspi: ioc0: id=0 Requested = 0x207f0803 ( Wide  factor = 0x08 @ offset = 0x7f IU DT )
mptspi: ioc0: id=0 Requested = 0x207f0823 ( Wide  factor = 0x08 @ offset = 0x7f IU DT RDSTRM )
mptspi: ioc0: id=0 Requested = 0x207f0833 ( Wide  factor = 0x08 @ offset = 0x7f IU DT WRFLOW RDSTRM )
mptspi: ioc0: id=0 Requested = 0x207f0873 ( Wide  factor = 0x08 @ offset = 0x7f IU DT WRFLOW RDSTRM RTI )
mptspi: ioc0: id=0 Requested = 0x207f08f3 ( Wide  factor = 0x08 @ offset = 0x7f IU DT WRFLOW RDSTRM RTI PCOMP )
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
scsi 2:0:0:0: 
        command: Inquiry: 12 00 00 00 60 00
 target2:0:0: Domain Validation skipping write tests
 target2:0:0: Ending Domain Validation
 target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
SCSI device sdg: 8910423 512-byte hdwr sectors (4562 MB)
sdg: Write Protect is off
sdg: Mode Sense: b3 00 00 08
SCSI device sdg: drive cache: write through
SCSI device sdg: 8910423 512-byte hdwr sectors (4562 MB)
sdg: Write Protect is off
sdg: Mode Sense: b3 00 00 08
SCSI device sdg: drive cache: write through
 sdg: unknown partition table
sd 2:0:0:0: Attached scsi disk sdg
sd 2:0:0:0: Attached scsi generic sg6 type 0

