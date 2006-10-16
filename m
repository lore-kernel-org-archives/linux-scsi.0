From: Mark Rustad <mrustad@mac.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Sun, 15 Oct 2006 20:27:08 -0500
Message-ID: <0E9A17FC-4047-48AE-A283-520B87E7F28D@mac.com>
References: <453027A9.3060606@us.ibm.com> <1160934124.3544.7.camel@mulgrave.il.steeleye.com> <45328141.5020705@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout.mac.com ([17.250.248.184]:51660 "EHLO smtpout.mac.com")
	by vger.kernel.org with ESMTP id S1751285AbWJPB1O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 21:27:14 -0400
In-Reply-To: <45328141.5020705@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

On Oct 15, 2006, at 1:43 PM, Darrick J. Wong wrote:

> James Bottomley wrote:
>
>> This doesn't seem to quite work for me on a SATA-1 disc:
>>
>> sas: DOING DISCOVERY on port 1, pid:1897
>> sas: sas_ata_phy_reset: Found ATA device.
>> ata1.00: ATA-7, max UDMA/133, 781422768 sectors: LBA48 NCQ (depth  
>> 31/32)
>> ata1.00: configured for UDMA/133
>> scsi 2:0:1:0: Direct-Access     ATA      ST3400832AS      3.03 PQ: 0
>> ANSI: 5
>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>> sdc: Write Protect is off
>> SCSI device sdc: drive cache: write back
>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>> sdc: Write Protect is off
>> SCSI device sdc: drive cache: write back
>>  sdc: unknown partition table
>> sd 2:0:1:0: Attached scsi disk sdc
>> sas: DONE DISCOVERY on port 1, pid:1897, result:0
>> sas: command 0xf785f3c0, task 0x00000000, timed out: EH_HANDLED
>> sas: command 0xf785f3c0, task 0x00000000, timed out: EH_HANDLED
>> [...]
>>
>> It looks like the first few commands get through (read capacity, ATA
>> IDENTIFY etc) and it hangs up on the read for the partition table.
>
> Hm... if I put in some debug printks in the qc_issue code, I get the
> same symptoms.  I've observed that once again we get hung up on ATA
> commands where the tag number > 0.  I also noticed this pattern:
>
> 1. ATA command w/ tag 0 (command A) issued.
> 2. Command A goes out to sas-ata.
> 2. ATA command w/ tag 1 (command B) issued.
> 3. Command A completes
> 4. Command B goes out to sas-ata.
> [...]
> 5. Command B times out.
>
> Very odd that this all works if there are no printks.  I don't see
> anything obvious that would suggest why this apparent race seems to
> happen--unless there's some conflict between issuing an ATA command
> while completing another one.

We have found in our system, using libata with Luben's driver, that  
the aic94xx sequencer expects the SATA commands to always have a tag  
of 0. The sequencer assigns its own tag before passing it to the  
drive. Interestingly, it seems to OR-in its generated tag value, so  
if a non-zero tag value is passed in, a real mess ensues.

Andy Warner can provide a lot more details on this.

-- 
Mark Rustad, MRustad@mac.com

