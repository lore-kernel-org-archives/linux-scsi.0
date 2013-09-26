From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Thu, 26 Sep 2013 15:41:38 +0200
Message-ID: <52443992.4040806@fastmail.fm>
References: <20130919161043.GA27081@redhat.com>	<20130920212142.GA17898@redhat.com>	<yq1eh8jf8wq.fsf@sermon.lab.mkp.net>	<1379960325.4010.32.camel@localhost.localdomain>	<52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com>	<yq1hadaba87.fsf@sermon.lab.mkp.net> <52434D0C.1090008@fastmail.fm> <yq1vc1o9ztd.fsf@sermon.lab.mkp.net> <5243C880.6050609@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34985 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IZNlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 09:41:46 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r8QDfg3Q005691
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2013 15:41:43 +0200
In-Reply-To: <5243C880.6050609@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On 09/26/2013 07:39 AM, Douglas Gilbert wrote:
> On 13-09-25 08:44 PM, Martin K. Petersen wrote:
>>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
>>
>> Hey Bernd,
>>
>> Bernd> I'm afraid we have another problem. I'm currently working on to
>> Bernd> get discard working for our LSI2008 HBAs with attached sata-SSDs
>> Bernd> and the heuristics in sd_read_write_same with based on VPD page
>> Bernd> 0x89 is not correct for this HBA - its SATL supports write-same
>>
>> This has nothing to do with the WRITE SAME heuristics.
>>
>> It's true that depending on wind and whether we might issue WRITE
>> SAME(10) or (16) with the UNMAP bit set to perform discard operations on
>> the low level device. But we use a set of different (and somewhat more
>> reliable) heuristics to decide which command to send down for that
>> purpose.
>>
>> For discards to a SATA device to work you need a recent phase LSI
>> firmware. And you need the target mode firmware (IT). There is no
>> UNMAP->DSM TRIM translation in the RAID (IR) firmware.
>>
>> If your SATA SSDs reports DSM TRIM support, the LSI firmware will set
>> LBPME=1 in READ CAPACITY(16) and the LOGICAL BLOCK PROVISIONING VPD page
>> will indicate a preference for the UNMAP command (LBPU=1).
>>
>> Also, LSI firmware is well-behaved in general and will report ILLEGAL
>> REQUEST when you send down a command that can't be handled.
>
> An example with a LSI 9212-4i4e running the latest firmware
> (P17) connected to a SATA SSD (via an expander):
>
> # sg_vpd /dev/sg1 -p sinq
> standard INQUIRY:
>    PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
>    [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
>    SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
>    EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>    [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>    Vendor_identification: ATA
>    Product_identification: INTEL SSDSA2M080
>    Product_revision_level: 02M3
>
> # sg_vpd /dev/sg1 -p bl
> Block limits VPD page (SBC):
>    Write same no zero (WSNZ): 0
>    Maximum compare and write length: 0 blocks
>    Optimal transfer length granularity: 0 blocks
>    Maximum transfer length: 0 blocks
>    Optimal transfer length: 0 blocks
>    Maximum prefetch length: 0 blocks
>    Maximum unmap LBA count: 4194303
>    Maximum unmap block descriptor count: 32
>    Optimal unmap granularity: 1
>    Unmap granularity alignment valid: 0
>    Unmap granularity alignment: 0
>    Maximum write same length: 0x0 blocks
>
> # sg_vpd /dev/sg1 -p lbpv
> Logical block provisioning VPD page (SBC):
>    Unmap command supported (LBPU): 1
>    Write same (16) with unmap bit supported (LBWS): 1
>    Write same (10) with unmap bit supported (LBWS10): 0
>    Logical block provisioning read zeros (LBPRZ): 0
>    Anchored LBAs supported (ANC_SUP): 1
>    Threshold exponent: 0
>    Descriptor present (DP): 0
>    Provisioning type: 0
>
> # sg_opcodes -n /dev/sg1
> Report supported operation codes: operation not supported
>
>
> Room for improvement there. It also supports a useful set
> of mode pages (including some chageable fields) and two
> log pages.
>

Both types of systems we have in-house neither block limits vpd nor 
READ_CAP16 return anything that would indicate discard is supported. But 
UNMAP and WRITE SAME unmap(*) just work fine.

I certainly don't want to cause any more write-same trouble, but as all 
layers initially have to assume write same is supported anyway and need 
to dynamically disable it if it fails, can't we also enable discard by 
default with WRITE SAME16 unmap?
I'm going to send a PoC patch later on.

The older system I can play with for a few days has an Intel510 
(SSDSC2MH25) connected to an LSI SAS9211-8i via a sas enclosure.
Ignoring identificication string and revision level, sg_vdp output is 
almost the same here, but with the exception of

(wheezy)node02:~# sg_vpd /dev/sdb -p bl
Block limits VPD page (SBC):
[...]
   Maximum unmap LBA count: 0
   Maximum unmap block descriptor count: 0
   Optimal unmap granularity: 0
[...]


I think interesting for discard is also read cap 16:

> (wheezy)node02:~# sg_readcap --16 /dev/sda
> Read Capacity results:
>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>    Logical block provisioning: lbpme=0, lbprz=0
>    Last logical block address=490350671 (0x1d3a284f), Number of logical blocks=490350672
>    Logical block length=512 bytes
>    Logical blocks per physical block exponent=0
>    Lowest aligned logical block address=0
> Hence:
>    Device size: 251059544064 bytes, 239429.0 MiB, 251.06 GB


So again no indication of discard support.


We also long ago flushed  the IT fw and just recently updated to fw 
version 17
> mpt2sas0: LSISAS2008: FWVersion(17.00.01.00), ChipRevision(0x03), BiosVersion(07.33.00.00)
> mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)


Thanks,
Bernd


PS: LSI SATL with FWv17 seems to have an unmap bug - I cannot unmap the 
last sector:

> (wheezy)node02:~# cat /sys/block/sdb/size
> 488397168

> (wheezy)node02:~# sg_write_same --16 --unmap --verbose --lba=488397167 --num=1 /dev/sdb
> Default data-out buffer set to 512 zeros

So write same works. But then unmap fails:

> (wheezy)node02:~# sg_unmap --verbose --lba=488397167 --num=1 /dev/sdb
>     unmap cdb: 42 00 00 00 00 00 00 00 18 00
> unmap:  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Logical block address out of range
>   Info fld=0x1d1c596f [488397167]
> bad field in UNMAP cdb

All sectors before that work fine:

> (wheezy)node02:~# sg_unmap --verbose --lba=0 --num=488397167 /dev/sdb
>     unmap cdb: 42 00 00 00 00 00 00 00 18 00
> (







