From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFR] a new SCSI driver
Date: Tue, 27 May 2003 21:38:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED34E4A.8040601@torque.net>
References: <20030524195123.GA8394@gtf.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:49936 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263274AbTE0LYZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 07:24:25 -0400
In-Reply-To: <20030524195123.GA8394@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> 
<snip>

> * Only supports Intel PATA and SATA right now

Jeff,
Your patch applies to lk 2.5.70 without problems.

I found that my dual Celeron (abit mobo) has this
Intel IDE controller:
   00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)

so I tried a 2.5.70 kernel with this patch. Two disks
connected:
   - SCSI disk to a Tekram 390u3w controller (sym53c8xx_2
     driver). Root partition on this disk
   - a Maxtor ATA disk (D740X-6L) to the Intel IDE
     controller.

Didn't get too far. After finding the SCSI controller and
SCSI disk at boot up, this came out just before it locked up:
  ata1:PATA max UDMA/33 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14

So I disabled the IDE controllers in the BIOS and then
this came out:
  ....
  PCI: Enabling device 00:07.1 (0000->0001)
  ata1:PATA max UDMA/33 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
  ATA: abnormal status 0xFF on port 0x1F7
  ATA: abnormal status 0xFF on port 0x1F7

and it locked up again.

Doug Gilbert

