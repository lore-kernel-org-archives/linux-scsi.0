From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sg_requests for descriptor sense data
Date: Mon, 12 Dec 2011 11:33:52 -0500
Message-ID: <4EE62CF0.7020303@interlog.com>
References: <B2FD678A64EAAD45B089B123FDFC3ED70D912FFADD@inbmail01.lsi.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52354 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1LLQeA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2011 11:34:00 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70D912FFADD@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11-12-12 10:43 AM, Desai, Kashyap wrote:
> Douglas,
>
> I am trying to generate Descriptor format sense data from driver attached to LSI controller.
> I have tried few sets of commands on my linux machine. Please help me if anything is wrong here.

Which version of sg3_utils are you using? 1.32 is the current
stable version. From the output of #3 it seems that a very
old Linux kernel or old version of sg3_utils (or both) is being
used.

> 1. Output of " sg_inq -d /dev/sg0"
>
> [root@dhcp-135-24-192-117 ~]# sg_inq -d /dev/sg0
> standard INQUIRY:
>    PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
>    [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
>    SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>    EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>    [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>    [SPI: Clocking=0x0  QAS=0  IUS=0]
>      length=74 (0x4a)   Peripheral device type: disk
>   Vendor identification: ATA
>   Product identification: WDC WD30EZRS-00J
>   Product revision level: 0A80
>   Unit serial number:      WD-WCAWZ0036672
>
>    Version descriptors:
>      SAM-4 (no version claimed)
>      SAT-2 (no version claimed)
>      SPC-4 (no version claimed)
>      SBC-3 (no version claimed)
>      SAS ANSI INCITS 376-2003
>      ATA/ATAPI-8 ATA-ACS ATA/ATAPI command set (no version claimed)

That is an ATA disk so there is a SATL somewhere. This output
looks good (and looks like libata and _not_ the better
SATL found in the firmware of LSI's MPT SAS HBAs).

> 2. Output of " sg_requests -v /dev/sg0 -d"
>
> [root@dhcp-135-24-192-117 ~]# sg_requests -v /dev/sg0 -d
>      Request Sense cmd: 03 01 00 00 fc 00
> request sense:  Fixed format, current;  Sense key: Illegal Request
>   Additional sense: Invalid field in cdb
> bad field in Request Sense cdb

Ah, that looks like libata's SATL! Whoever programmed
that didn't understand the SCSI REQUEST SENSE command.
I think libata's SATL has been broken with respect
to REQUEST SENSE since day one.

> 3. Reading beyond the range of drive to get sense data.
> Output of "sg_read if=/dev/sg0 cdbsz=16 skip=0x15d50a3af00 bs=512 verbose=3 count=512"
> [root@dhcp-135-24-192-117 ~]# sg_read if=/dev/sg0 cdbsz=16 skip=0x15d50a3af00 bs=512 verbose=3 count=512
> Opened /dev/sg0 for SG_IO with flags=0x2
>    SG_GET_RESERVED_SIZE yields: 32768
>      read cdb: 88 00 00 00 01 5d 50 a3 af 00 00 00 00 80 00 00
>        duration=123 ms
> reading: SCSI status: Check Condition
>   Fixed format, current;  Sense key: Illegal Request
>   Additional sense: Logical block address out of range
>   Raw sense data (in hex):
>          70 00 05 00 00 00 00 0a  00 00 00 00 21 00 00 00
>          00 00
> sg_read: SCSI READ failed
> Some error occurred,  remaining block count=512
> 0+0 records in

Could you try that again with ddpt? The "Logical block
address out of range" is correct but I haven't seen
a SG_GET_RESERVED_SIZE error in a very long time.

> My Drive is SPC-4 complaint and sg_requests suggested to have SPC-3 or higher version to enable descriptor format.
> _But_ for me it is not working.

Hmmm, hopefully your drive is compliant with some ATA standard,
perhaps ACS-1. The issues we are looking at here are SAT (or
SAT-2) compliance. Not sure how libata handles the D_SENSE
field in Control mode page but I wouldn't be surprised if it
is broken.

A recent Seagate 3 TB SAS disk with 512 byte blocks comes from
the factory like this:
   D_SENSE     1  [cha: y, def:  1, sav:  1]  Descriptor format sense data

and it does return descriptor sense data when appropriate.

> Eventually, When I try to run command as mentioned in #3, I want to see Descriptor format sense instead of Fixed one.

Well when a disk is over 2 TB in size then descriptor
sense format is required to represent LBAs that are
bigger than 32 bits (assuming a LB size of 512 bytes).

Doug Gilbert

