From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] qla2xxx - perform proper SNS scans with ISP2200 HBAs.
Date: Fri, 23 Jan 2004 12:18:30 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040123011830.GH11236@krispykreme>
References: <B179AE41C1147041AA1121F44614F0B0598E5D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:43964 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S265126AbUAWBWt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 20:22:49 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E5D@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

 
Hi,

> Hmm, I think I know what the problem is.  Could you try the attached
> small patch.  The handles that get passed down to the firmware should
> be opaque.  Unfortuantely when using RIO mode 3 (as is done with the
> 2100 and 2200s) the handle is truncated down from 32bits to 16bits. 

Gave it a go but it still seems to have problems (see below).

> Looks like I need to add the ppc64 machine to my test ring.  BTW: any
> quick doc-pointers or suggestions on how to get 2.6 running on a ppc64
> machine.  

Current -mm should run on everything. Linus tree is missing a one line
fix in the pci probe code, we still need to convince him to take it.
Let me know if you have any problems.

Anton

QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver (c00000000063a028)
PCI: Enabling device: (0003:41:01.0), cmd 143
qla2200 0003:41:01.0: Found an ISP2200, irq 183, iobase 0xa000000080020000
qla2200 0003:41:01.0: Configuring PCI space...
qla2200 0003:41:01.0: Configure NVRAM parameters...
qla2200 0003:41:01.0: Verifying loaded RISC code...
qla2200 0003:41:01.0: LIP reset occured (0).
qla2200 0003:41:01.0: Waiting for LIP to complete...
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi0 : qla2xxx
qla2200 0003:41:01.0:
 QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: 8.00.00b8
  QLogic QLA22xx -
  ISP2200: PCI (66 MHz) @ 0003:41:01.0 hdma-, host#=0, fw=2.02.06 TP
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (0).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
qla2200 0003:41:01.0: Invalid SCSI completion handle 16777216.
qla2200 0003:41:01.0: Performing ISP error recovery - ha= c00000000fd202e0.
qla2200 0003:41:01.0: LIP reset occured (f7f7).
qla2200 0003:41:01.0: LOOP UP detected (1 Gbps).
