From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sata disk model/firmware length smaller
Date: Thu, 06 Jan 2011 11:34:08 -0500
Message-ID: <4D25EF00.7020301@interlog.com>
References: <201101061538027183872@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56156 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab1AFQe1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2011 11:34:27 -0500
In-Reply-To: <201101061538027183872@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kernel.majianpeng" <kernel.majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11-01-06 02:38 AM, kernel.majianpeng wrote:
>
> At present,I using WD SATA disk:
> [root@kedacom device]# smartctl -i /dev/sdo
> smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> === START OF INFORMATION SECTION ===
> Device Model:     WDC WD2003FYYS-02W0B0
> Serial Number:    WD-WMAY00749168
> Firmware Version: 01.01D01
> User Capacity:    2,000,398,934,016 bytes
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   8
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Thu Jan  6 15:12:37 2011 UTC
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> [root@kedacom device]# cat /sys/block/sdo/device/rev
> 01.0
> [root@kedacom device]# cat /sys/block/sdo/device/model
> WDC WD2003FYYS-0
> I read ATA spec7, The INQUERY DEVICE command return valued:
> Firmware revision 8byte
> Model Number 40byte
>
> This may be a bug?

Not our bug. There is a size mismatch between the
ATA 'firmware revision' field (8 bytes) and the
SCSI 'product revision level' field (4 bytes). Given
the mappings defined in the SAT and SAT-2 standards
when an ATA device is being viewed via a SCSI INQUIRY
command only the first 4 bytes of the revision field
are taken.

A compliant SAT layer should support the ATA Information
VPD page which is accessed via the SCSI INQUIRY command
with the EVPD bit set. libata does this:

# sg_inq /dev/sda
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
   [SPI: Clocking=0x0  QAS=0  IUS=0]
     length=96 (0x60)   Peripheral device type: disk
  Vendor identification: ATA
  Product identification: INTEL SSDSA2M080
  Product revision level: 2CV1
  Unit serial number: xxxxxx

# sg_vpd -p ai /dev/sda
ATA information VPD page:
   SAT Vendor identification: linux
   SAT Product identification: libata
   SAT Product revision level: 2CV1
   ATA command IDENTIFY DEVICE response summary:
     model: INTEL SSDSA2M080G2GC
     serial number: xxxxxx
     firmware revision: 2CV102HD

The whole of an ATA disk's IDENTIFY DEVICE response (512
bytes) is available in the SCSI ATA Information VPD page.

Doug Gilbert
