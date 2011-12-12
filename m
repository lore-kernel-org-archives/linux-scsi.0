From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: sg_requests for descriptor sense data
Date: Mon, 12 Dec 2011 21:13:22 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70D912FFADD@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:39716 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026Ab1LLPn3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2011 10:43:29 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

Douglas,

I am trying to generate Descriptor format sense data from driver attached to LSI controller.
I have tried few sets of commands on my linux machine. Please help me if anything is wrong here.

1. Output of " sg_inq -d /dev/sg0"

[root@dhcp-135-24-192-117 ~]# sg_inq -d /dev/sg0
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=74 (0x4a)   Peripheral device type: disk
 Vendor identification: ATA     
 Product identification: WDC WD30EZRS-00J
 Product revision level: 0A80
 Unit serial number:      WD-WCAWZ0036672
 
  Version descriptors:
    SAM-4 (no version claimed)
    SAT-2 (no version claimed)
    SPC-4 (no version claimed)
    SBC-3 (no version claimed)
    SAS ANSI INCITS 376-2003
    ATA/ATAPI-8 ATA-ACS ATA/ATAPI command set (no version claimed)

2. Output of " sg_requests -v /dev/sg0 -d"

[root@dhcp-135-24-192-117 ~]# sg_requests -v /dev/sg0 -d
    Request Sense cmd: 03 01 00 00 fc 00 
request sense:  Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid field in cdb
bad field in Request Sense cdb

3. Reading beyond the range of drive to get sense data.
Output of "sg_read if=/dev/sg0 cdbsz=16 skip=0x15d50a3af00 bs=512 verbose=3 count=512"
[root@dhcp-135-24-192-117 ~]# sg_read if=/dev/sg0 cdbsz=16 skip=0x15d50a3af00 bs=512 verbose=3 count=512
Opened /dev/sg0 for SG_IO with flags=0x2
  SG_GET_RESERVED_SIZE yields: 32768
    read cdb: 88 00 00 00 01 5d 50 a3 af 00 00 00 00 80 00 00 
      duration=123 ms
reading: SCSI status: Check Condition 
 Fixed format, current;  Sense key: Illegal Request
 Additional sense: Logical block address out of range
 Raw sense data (in hex):
        70 00 05 00 00 00 00 0a  00 00 00 00 21 00 00 00    
        00 00                                               
sg_read: SCSI READ failed
Some error occurred,  remaining block count=512
0+0 records in


My Drive is SPC-4 complaint and sg_requests suggested to have SPC-3 or higher version to enable descriptor format.
_But_ for me it is not working.


Eventually, When I try to run command as mentioned in #3, I want to see Descriptor format sense instead of Fixed one.


Thanks, Kashyap






