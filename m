From: Jamie Clark <jamie@zeroth.org>
Subject: qla2xxx driver/firmware versions & thermal stability
Date: Mon, 16 Aug 2004 16:07:53 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41206B59.5070703@zeroth.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moof.zeroth.org ([203.117.131.35]:51730 "EHLO moof.zeroth.org")
	by vger.kernel.org with ESMTP id S265743AbUHPIIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 04:08:02 -0400
Received: from [10.1.0.56] (neon.zeroth.org [203.117.131.24])
	(authenticated bits=0)
	by moof.zeroth.org (8.12.11/8.12.9) with ESMTP id i7G87wt2011956
	for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2004 16:07:58 +0800 (SGT)
	(envelope-from jamie@zeroth.org)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In the recent past we ran qla2300 driver version 6.04.00 with qla2300F 
cards. The driver/card often died with the following messages  (kernel  
2.4.19-pre10aa4):

Jan 12 12:54:56 prodapp4 kernel: qla2x00: Status Entry invalid handle.
Jan 12 12:54:56 prodapp4 kernel: qla2x00: Performing ISP error recovery 
- ha= c493c07c.
...
Jan 12 12:55:22 prodapp4 kernel: qla2x00(2): ISP error recovery failed - 
board disabled

These failures seem to be temperature related. A slight upward shift in 
the computer room temperature (from very cold to not-quite-as-cold) 
*always* precipitated these errors. After upgrading all the machines to 
qla2340 boards we still have the same problem.

Now, I'm quite aware that this could be caused by poor cooling 
circulation (2U Intel Server chassis / STL2 board) but my basic tests 
with temperature probes indicate nothing excessive - in fact everything 
seems chilly. The room is kept at 18degC, the server cases are cold to 
touch, internal case temperature around the cards of about 22degC. I 
have detailed 5-minute temperature data going back for a year - all of 
it well inside the Qlogic operating specs.

My question is: has anyone else seen anything like this?  Does the older 
Qlogic firmware tend to run hotter?  Is the newer any better?  At the 
moment we're on 6.04.00 as this is the release that is supposedly 
certified by Hitachi (storage vendor). I'd be happy to upgrade to later 
version if I knew it would cure the thermal sensitivity.

boot probe with 2340 and 6.04 driver:

qla2x00_set_info starts at address = c3ac0060
qla2x00: Found  VID=1077 DID=2312 SSVID=1077 SSDID=100
scsi(2): Found a QLA2312  @ bus 1, device 0xa, irq 20, iobase 0x6400
scsi(2): Allocated 4096 SRB(s).
scsi(2): Configure NVRAM parameters...
scsi(2): 32 Bit PCI Addressing Enabled.
scsi(2): Verifying loaded RISC code...
scsi(2): Verifying chip...
scsi(2): Waiting for LIP to complete...
scsi(2): LOOP UP detected.
scsi(2): Topology - (F_Port), Host Loop address 0xffff
scsi2 : QLogic QLA2312 PCI to Fibre Channel Host Adapter: bus 1 device 
10 irq 20
        Firmware version:  3.01.18, Driver version 6.04.00
  Vendor: HITACHI   Model: DF600F            Rev: 0000
  Type:   Direct-Access                      ANSI SCSI revision: 03

