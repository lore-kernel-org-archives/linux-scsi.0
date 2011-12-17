From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sg_requests for descriptor sense data
Date: Fri, 16 Dec 2011 21:32:35 -0500
Message-ID: <4EEBFF43.5090607@interlog.com>
References: <B2FD678A64EAAD45B089B123FDFC3ED70D912FFADD@inbmail01.lsi.com> <4EE62CF0.7020303@interlog.com> <B2FD678A64EAAD45B089B123FDFC3ED70D91352AFB@inbmail01.lsi.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47295 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1LQCcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 21:32:45 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70D91352AFB@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11-12-15 12:53 AM, Desai, Kashyap wrote:
>
>
>> -----Original Message-----
>> From: Douglas Gilbert [mailto:dgilbert@interlog.com]
>> Sent: Monday, December 12, 2011 10:04 PM
>> To: Desai, Kashyap
>> Cc: linux-scsi@vger.kernel.org
>> Subject: Re: sg_requests for descriptor sense data
>>
>> On 11-12-12 10:43 AM, Desai, Kashyap wrote:
>>> Douglas,
>>>
>>> I am trying to generate Descriptor format sense data from driver
>> attached to LSI controller.
>>> I have tried few sets of commands on my linux machine. Please help me
>> if anything is wrong here.
>>
>> Which version of sg3_utils are you using? 1.32 is the current
>> stable version. From the output of #3 it seems that a very
>> old Linux kernel or old version of sg3_utils (or both) is being
>> used.
>
> It is a RHEL6 and 1.32 version of sg util.
>
>>
>>> 1. Output of " sg_inq -d /dev/sg0"
>>>
>>> [root@dhcp-135-24-192-117 ~]# sg_inq -d /dev/sg0
>>> standard INQUIRY:
>>>     PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
>>>     [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
>>>     SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>>>     EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>>>     [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>>>     [SPI: Clocking=0x0  QAS=0  IUS=0]
>>>       length=74 (0x4a)   Peripheral device type: disk
>>>    Vendor identification: ATA
>>>    Product identification: WDC WD30EZRS-00J
>>>    Product revision level: 0A80
>>>    Unit serial number:      WD-WCAWZ0036672
>>>
>>>     Version descriptors:
>>>       SAM-4 (no version claimed)
>>>       SAT-2 (no version claimed)
>>>       SPC-4 (no version claimed)
>>>       SBC-3 (no version claimed)
>>>       SAS ANSI INCITS 376-2003
>>>       ATA/ATAPI-8 ATA-ACS ATA/ATAPI command set (no version claimed)
>>
>> That is an ATA disk so there is a SATL somewhere. This output
>> looks good (and looks like libata and _not_ the better
>> SATL found in the firmware of LSI's MPT SAS HBAs).
>
> I agree.! I am not sure about what is a theory behind it, but yes your input clears my doubt
> Thanks.
>
>>
>>> 2. Output of " sg_requests -v /dev/sg0 -d"
>>>
>>> [root@dhcp-135-24-192-117 ~]# sg_requests -v /dev/sg0 -d
>>>       Request Sense cmd: 03 01 00 00 fc 00
>>> request sense:  Fixed format, current;  Sense key: Illegal Request
>>>    Additional sense: Invalid field in cdb
>>> bad field in Request Sense cdb
>>
>> Ah, that looks like libata's SATL! Whoever programmed
>> that didn't understand the SCSI REQUEST SENSE command.
>> I think libata's SATL has been broken with respect
>> to REQUEST SENSE since day one.
>>
>>> 3. Reading beyond the range of drive to get sense data.
>>> Output of "sg_read if=/dev/sg0 cdbsz=16 skip=0x15d50a3af00 bs=512
>> verbose=3 count=512"
>>> [root@dhcp-135-24-192-117 ~]# sg_read if=/dev/sg0 cdbsz=16
>> skip=0x15d50a3af00 bs=512 verbose=3 count=512
>>> Opened /dev/sg0 for SG_IO with flags=0x2
>>>     SG_GET_RESERVED_SIZE yields: 32768
>>>       read cdb: 88 00 00 00 01 5d 50 a3 af 00 00 00 00 80 00 00
>>>         duration=123 ms
>>> reading: SCSI status: Check Condition
>>>    Fixed format, current;  Sense key: Illegal Request
>>>    Additional sense: Logical block address out of range
>>>    Raw sense data (in hex):
>>>           70 00 05 00 00 00 00 0a  00 00 00 00 21 00 00 00
>>>           00 00
>>> sg_read: SCSI READ failed
>>> Some error occurred,  remaining block count=512
>>> 0+0 records in
>>
>> Could you try that again with ddpt? The "Logical block
>> address out of range" is correct but I haven't seen
>> a SG_GET_RESERVED_SIZE error in a very long time.
>
> I am trying this. Do you have any default "ddpt" command to be executed ?
> I am seeing some issue while running ddpt command related to ": undefined symbol: set_scsi_pt_flags"

That implies there is an old version of the sgutils dev
library on your system. On Debian/Ubuntu it would have
a name like libsgutils2-dev_1.33-0.1_i386.deb but for
that error it will be version 1.28 [20091002] or earlier.
You need to delete that old sgutils dev library package.
Once it is gone ddpt will build what it needs and link it
in statically.
Another approach is to fetch a recent sg3_utils tarball,
build it and install all three packages the build generates.
After that ddpt will run properly.


Advice to others: if you have pressure from distribution
maintainers to share common code between packages in
shared libraries; politely ignore them.

Doug Gilbert


> [root@dhcp-135-24-192-117 ddpt-0.92]# ddpt if=/dev/sg3 of=/dev/null count=10 verbose=2
> Assume block size of 512 bytes for both input and output
>   >>  Input file type: pass-through [pt] device
> open /dev/sg3 with flags=0x802
>      inquiry cdb: 12 00 00 00 24 00
>      /dev/sg3: ATA       WDC WD30EZRS-00J  0A80  [pdt=0]
>   >>  Output file type: null device
>      read capacity (10) cdb: 25 00 00 00 00 00 00 00 00 00
>      READ CAPACITY (10) response cannot represent this capacity
>      read capacity (16) cdb: 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
>    /dev/sg3 [pt]: blocks=5860533168 [0x15d50a3b0], _bs=512, 3.00 TB
> skip=0 (blocks on input), seek=0 (blocks on output)
>    ibs=512 bytes, obs=512 bytes, OBPC=0
>    initial count=10 (blocks of input), blocks_per_transfer=128
> ddpt: symbol lookup error: ddpt: undefined symbol: set_scsi_pt_flags
> [root@dhcp-135-24-192-117 ddpt-0.92]#
>
>
>>
>>> My Drive is SPC-4 complaint and sg_requests suggested to have SPC-3 or
>> higher version to enable descriptor format.
>>> _But_ for me it is not working.
>>
>> Hmmm, hopefully your drive is compliant with some ATA standard,
>> perhaps ACS-1. The issues we are looking at here are SAT (or
>> SAT-2) compliance. Not sure how libata handles the D_SENSE
>> field in Control mode page but I wouldn't be surprised if it
>> is broken.
>>
>> A recent Seagate 3 TB SAS disk with 512 byte blocks comes from
>> the factory like this:
>>     D_SENSE     1  [cha: y, def:  1, sav:  1]  Descriptor format sense
>> data
>>
>> and it does return descriptor sense data when appropriate.
>
> I tried with another 3TB SAS drive and yes things are as expected there. I am able to see Descriptor sense data.
>
>>
>>> Eventually, When I try to run command as mentioned in #3, I want to
>> see Descriptor format sense instead of Fixed one.
>>
>> Well when a disk is over 2 TB in size then descriptor
>> sense format is required to represent LBAs that are
>> bigger than 32 bits (assuming a LB size of 512 bytes).
>>
>> Doug Gilbert
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

