From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Sun, 15 Oct 2006 12:42:54 -0700 (PDT)
Message-ID: <20061015194254.58866.qmail@web31808.mail.mud.yahoo.com>
References: <45328141.5020705@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:38008 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932141AbWJOTmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 15:42:55 -0400
In-Reply-To: <45328141.5020705@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

--- "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> James Bottomley wrote:
> 
> > This doesn't seem to quite work for me on a SATA-1 disc:
> > 
> > sas: DOING DISCOVERY on port 1, pid:1897
> > sas: sas_ata_phy_reset: Found ATA device.
> > ata1.00: ATA-7, max UDMA/133, 781422768 sectors: LBA48 NCQ (depth 31/32)
> > ata1.00: configured for UDMA/133
> > scsi 2:0:1:0: Direct-Access     ATA      ST3400832AS      3.03 PQ: 0
> > ANSI: 5
> > SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> > sdc: Write Protect is off
> > SCSI device sdc: drive cache: write back
> > SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
> > sdc: Write Protect is off
> > SCSI device sdc: drive cache: write back
> >  sdc: unknown partition table
> > sd 2:0:1:0: Attached scsi disk sdc
> > sas: DONE DISCOVERY on port 1, pid:1897, result:0
> > sas: command 0xf785f3c0, task 0x00000000, timed out: EH_HANDLED
> > sas: command 0xf785f3c0, task 0x00000000, timed out: EH_HANDLED
> > [...]
> > 
> > It looks like the first few commands get through (read capacity, ATA
> > IDENTIFY etc) and it hangs up on the read for the partition table.
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

Keep debugging.

The GPL open sourced SCSI/ATA Translation Layer (SATL) I maintain,
works perfectly for any SATA drive w/ NCQ (through the aic94xx
SDS/interconnect), and I haven't heard any complaints from people
using it.

    Luben

