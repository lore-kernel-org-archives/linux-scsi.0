From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Thu, 26 Sep 2013 01:39:12 -0400
Message-ID: <5243C880.6050609@interlog.com>
References: <20130919161043.GA27081@redhat.com>	<20130920212142.GA17898@redhat.com>	<yq1eh8jf8wq.fsf@sermon.lab.mkp.net>	<1379960325.4010.32.camel@localhost.localdomain>	<52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com>	<yq1hadaba87.fsf@sermon.lab.mkp.net> <52434D0C.1090008@fastmail.fm> <yq1vc1o9ztd.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55206 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3IZFji (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 01:39:38 -0400
In-Reply-To: <yq1vc1o9ztd.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On 13-09-25 08:44 PM, Martin K. Petersen wrote:
>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
>
> Hey Bernd,
>
> Bernd> I'm afraid we have another problem. I'm currently working on to
> Bernd> get discard working for our LSI2008 HBAs with attached sata-SSDs
> Bernd> and the heuristics in sd_read_write_same with based on VPD page
> Bernd> 0x89 is not correct for this HBA - its SATL supports write-same
>
> This has nothing to do with the WRITE SAME heuristics.
>
> It's true that depending on wind and whether we might issue WRITE
> SAME(10) or (16) with the UNMAP bit set to perform discard operations on
> the low level device. But we use a set of different (and somewhat more
> reliable) heuristics to decide which command to send down for that
> purpose.
>
> For discards to a SATA device to work you need a recent phase LSI
> firmware. And you need the target mode firmware (IT). There is no
> UNMAP->DSM TRIM translation in the RAID (IR) firmware.
>
> If your SATA SSDs reports DSM TRIM support, the LSI firmware will set
> LBPME=1 in READ CAPACITY(16) and the LOGICAL BLOCK PROVISIONING VPD page
> will indicate a preference for the UNMAP command (LBPU=1).
>
> Also, LSI firmware is well-behaved in general and will report ILLEGAL
> REQUEST when you send down a command that can't be handled.

An example with a LSI 9212-4i4e running the latest firmware
(P17) connected to a SATA SSD (via an expander):

# sg_vpd /dev/sg1 -p sinq
standard INQUIRY:
   PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
   [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
   Vendor_identification: ATA
   Product_identification: INTEL SSDSA2M080
   Product_revision_level: 02M3

# sg_vpd /dev/sg1 -p bl
Block limits VPD page (SBC):
   Write same no zero (WSNZ): 0
   Maximum compare and write length: 0 blocks
   Optimal transfer length granularity: 0 blocks
   Maximum transfer length: 0 blocks
   Optimal transfer length: 0 blocks
   Maximum prefetch length: 0 blocks
   Maximum unmap LBA count: 4194303
   Maximum unmap block descriptor count: 32
   Optimal unmap granularity: 1
   Unmap granularity alignment valid: 0
   Unmap granularity alignment: 0
   Maximum write same length: 0x0 blocks

# sg_vpd /dev/sg1 -p lbpv
Logical block provisioning VPD page (SBC):
   Unmap command supported (LBPU): 1
   Write same (16) with unmap bit supported (LBWS): 1
   Write same (10) with unmap bit supported (LBWS10): 0
   Logical block provisioning read zeros (LBPRZ): 0
   Anchored LBAs supported (ANC_SUP): 1
   Threshold exponent: 0
   Descriptor present (DP): 0
   Provisioning type: 0

# sg_opcodes -n /dev/sg1
Report supported operation codes: operation not supported


Room for improvement there. It also supports a useful set
of mode pages (including some chageable fields) and two
log pages.

Doug Gilbert




