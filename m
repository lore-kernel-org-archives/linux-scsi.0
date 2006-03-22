From: Ingo Flaschberger <if@xip.at>
Subject: Re: Compaq Fiber Channel Array RM4000 / Scsi middle ware driver
Date: Wed, 22 Mar 2006 19:17:52 +0100 (CET)
Message-ID: <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>
References: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at>
 <Pine.GSO.4.64.0602280120290.25994@filebunker.xip.at>
 <Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at>
 <20060228004043.GH27759@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:57735 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S932325AbWCVSRy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 13:17:54 -0500
In-Reply-To: <20060228004043.GH27759@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, mark@markschaefer.org

Hi!

IT WORKS *GGG*
(but only with already supported fc cards, cpqfc card is still missing).

---snip---
qla2200 0000:00:0d.0: Found an ISP2200, irq 10, iobase 0xe0810000
qla2200 0000:00:0d.0: Configuring PCI space...
qla2200 0000:00:0d.0: Configure NVRAM parameters...
qla2200 0000:00:0d.0: Verifying loaded RISC code...
Error handler scsi_eh_0 sleeping
qla2200 0000:00:0d.0: LIP reset occured (f7f7).
qla2200 0000:00:0d.0: Waiting for LIP to complete...
qla2200 0000:00:0d.0: LIP occured (f7f7).
qla2200 0000:00:0d.0: LOOP UP detected (1 Gbps).
qla2200 0000:00:0d.0: Topology - (Loop), Host Loop address 0x7d
scsi0 : qla2xxx
qla2200 0000:00:0d.0:
  QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
   QLogic QLA22xx -
   ISP2200: PCI (33 MHz) @ 0000:00:0d.0 hdma-, host#=0, fw=2.02.08 TP
   Vendor: COMPAQ    Model: ARRAY CONTROLLER  Rev: 2.60
   Type:   RAID                               ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: LOGICAL VOLUME    Rev: 2.60
   Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 83844000 512-byte hdwr sectors (42928 MB)
sda: Write Protect is off
sda: Mode Sense: 17 00 00 08
SCSI device sda: drive cache: write back
SCSI device sda: 83844000 512-byte hdwr sectors (42928 MB)
sda: Write Protect is off
sda: Mode Sense: 17 00 00 08
SCSI device sda: drive cache: write back
  sda: sda1
sd 0:0:0:16384: Attached scsi disk sda
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
---snap---

uname -a
Linux test 2.6.16 #23 SMP Wed Mar 22 19:13:00 CET 2006 i686  GNU/Linux

The only modifications are in:
drivers/scsi/scsi_scan.c	modification of the lun search code

I have now to program a clean patch, the currenty patch is a quick hack 
which only supports this array and may break other devices.
I think, I need to invent a new BLIST_??? value to provide a clean 
implementation.

Patch for 2.6.16 will follow soon.

Kind regards,
 	ingo flaschberger

geschaeftsleitung
crossip communications gmbH
------------------------------------------------------------------_------------
sebastian kneipp gasse 1          _____ _____ ____   _____ _____ (_)____
a-1020 wien                      / ___// ___// __ \ / ___// ___// // __ \
fix: +43-1-726 15 22-217        / /__ / /   / /_/ /(__  )(__  )/ // /_/ /
fax: +43-1-726 15 22-111        \___//_/    \____//____//____//_// .___/
mob: +43-699-105 86 719                                 _______ / /
www.xip.at                      communications gmbh    /______//_/
-------------------------------------------------------------------------------
