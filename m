From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] mptspi : min_period, max_offset,
	max_width,incorrectlyset, resulting domain validation failing
Date: Tue, 19 Sep 2006 21:04:34 -0400
Message-ID: <1158714274.4170.57.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7032CE62@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14978 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750779AbWITBEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 21:04:37 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032CE62@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-19 at 17:06 -0600, Moore, Eric wrote:
> On Tuesday, September 19, 2006 3:12 PM, James Bottomley wrote:
> 
> > 
> > The issue sounds like a bug in the generic DV ... it's supposed to
> > respect the DT setting, but it currently does this by looking 
> > at the bus
> > signalling ... it should be respecting the inquiry data as well.
> > 
> > Does this fix it?
> > 
> 
> No, all that does is disables DT.  It still sending 
> factor=0x8 (U320 nego) to a device that can only do U80. 

It shouldn't be doing that ... that factor isn't legal for ST
negotiation.  Fast-40 (factor=0x0a) is the fastest legal setting for ST.

There's even a check in the mptspi set_dt routines for this:

	if (!dt && spi_period(starget) < 10)
		spi_period(starget) = 10;

	spi_dt(starget) = dt;

Can you debug why that's not raising the period to the correct value?

Thanks,

James


> This is what its sending to fusion with your patch:
> 
> ( Wide  factor = 0x08 @ offset = 0x7f IU WRFLOW RDSTRM RTI PCOMP )
> 
> Does the algorithm in spi transport check for a (scsi_device_sync(sdev)
> == 1)
> and (scsi_device_dv(sdev) == 0), then set spi_min_period(sdev) = 0xA ??
> 
> 
> Also, the algorithm in spi_transport is broke for U160 devices. Its
> sending U320
> nego to U160 devices.  What it should do is check for
> scsi_device_ius(sdev) == 0
> and scsi_device_qas(sdev) == 0, then spi_min_period(sdev)=0x9.  Due to
> this,
> spi transport dv ends up with FAST-40, instead of U160, becuase the nego
> at factor=0x8 failed.
> 
> 
> Here is inquiry of U160 device.
> 
> 
> standard INQUIRY:
>   PQual=0  Device_type=0  RMB=0  version=0x03  [SPC]
>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>   SCCS=0  ACC=0  TGPS=0  3PC=0  Protect=0  BQue=0
>   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>   [RelAdr=0]  WBus16=1  Sync=1  Linked=1  [TranDis=1]  CmdQue=1
>   Clocking=0x3  QAS=0  IUS=0
>     length=96 (0x60)   Peripheral device type: disk
>  Vendor identification: QUANTUM 
>  Product identification: ATLAS V 36 WLS  
>  Product revision level: 0A06
>  Unit serial number: 143991122028
> 
> 
> 
> Fusion MPT base driver 3.04.02
> Copyright (c) 1999-2005 LSI Logic Corporation
> Fusion MPT SPI Host driver 3.04.02
> mptbase: Initiating ioc0 bringup
> ioc0: 53C1030: Capabilities={Initiator}
> mptbase: ioc0: PortPage0 minSyncFactor=8
> mptspi: ioc0: saf_te 0
> scsi5 : ioc0: LSI53C1030, FwRev=01033000h, Ports=1, MaxQ=222, IRQ=217
> mptspi: ioc0: id=0 Requested = 0x00000a00 (  factor = 0x0a @ offset =
> 0x00 )
> scsi 5:0:0:0: Direct access     QUANTUM  ATLAS V 36 WLS   0A06 PQ: 0
> ANSI: 3
> mptspi: ioc0: id=0 min_period=0x08 max_offset=0x7f max_width=1
>  target5:0:0: Beginning Domain Validation
> mptspi: ioc0: id=0 Requested = 0x00000a00 (  factor = 0x0a @ offset =
> 0x00 )
> mptspi: ioc0: id=0 Requested = 0x00000a00 (  factor = 0x0a @ offset =
> 0x00 )
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> mptspi: ioc0: id=0 Requested = 0x20000a00 ( Wide  factor = 0x0a @ offset
> = 0x00 )
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> mptspi: ioc0: id=0 Requested = 0x207f0a00 ( Wide  factor = 0x0a @ offset
> = 0x7f )
> mptspi: ioc0: id=0 Requested = 0x207f0803 ( Wide  factor = 0x08 @ offset
> = 0x7f IU DT )
> mptspi: ioc0: id=0 Requested = 0x207f0823 ( Wide  factor = 0x08 @ offset
> = 0x7f IU DT RDSTRM )
> mptspi: ioc0: id=0 Requested = 0x207f0833 ( Wide  factor = 0x08 @ offset
> = 0x7f IU DT WRFLOW RDSTRM )
> mptspi: ioc0: id=0 Requested = 0x207f0873 ( Wide  factor = 0x08 @ offset
> = 0x7f IU DT WRFLOW RDSTRM RTI )
> mptspi: ioc0: id=0 Requested = 0x207f08f3 ( Wide  factor = 0x08 @ offset
> = 0x7f IU DT WRFLOW RDSTRM RTI PCOMP )
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
> scsi 5:0:0:0: 
>         command: Inquiry: 12 00 00 00 60 00
>  target5:0:0: Domain Validation skipping write tests
>  target5:0:0: Ending Domain Validation
>  target5:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 63)

