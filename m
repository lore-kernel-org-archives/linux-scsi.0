From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: LSI megasas and duplicate erroneous devices?
Date: Sat, 29 Aug 2015 09:00:44 -0600
Message-ID: <10175493.TuJJp3Z7hI@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([192.241.222.217]:49350 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbbH2PLE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Aug 2015 11:11:04 -0400
Received: from balsa.localnet (S0106000024ce8134.ed.shawcable.net [174.3.73.24])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: thomas@fjellstrom.ca)
	by mail.tomasu.net (Postfix) with ESMTPSA id 02CA614ACAF
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2015 15:00:46 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm seeing the strangest thing with my M1015/LSI card.

I'm getting regular DID_BAD_TARGET errors in the kernel log for a drive that
was erroneously detected.

Inital detection looks like:


[    0.860853] megasas: 06.806.08.00-rc1
[    0.860877] megasas: 0x1000:0x0073:0x1014:0x03b1: bus 1:slot 0:func 0
[    0.861172] megasas: FW now in Ready state
[    0.861796] libata version 3.00 loaded.
[    0.907832] megasas_init_mfi: fw_support_ieee=67108864
[    0.907902] megasas: INIT adapter done
[    0.955875] megaraid_sas 0000:01:00.0: Controller type: iMR
[    0.955990] scsi host0: LSI SAS based MegaRAID driver
[    0.959560] scsi 0:0:9:0: Direct-Access     ATA      ST3000DM001-1CH1 CC29 PQ: 0 ANSI: 5
[    0.964976] scsi 0:0:10:0: Direct-Access     ATA      ST3000DM001-1CH1 CC29 PQ: 0 ANSI: 5
[    0.970747] scsi 0:0:11:0: Direct-Access     ATA      ST3000DM001-1CH1 CC29 PQ: 0 ANSI: 5
[    0.975890] scsi 0:0:13:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A82 PQ: 0 ANSI: 5
[    0.981458] scsi 0:0:15:0: Direct-Access     ATA      ST3000DM001-1ER1 CC25 PQ: 0 ANSI: 5
[    0.987097] scsi 0:0:16:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A82 PQ: 0 ANSI: 5


Then after a while, the following appears:


[ 2545.701262] scsi 0:0:14:0: Direct-Access     ATA      WDC WD30EFRX-68E 0A82 PQ: 0 ANSI: 5


Note, this drive is a duplicate of either 0:0:13:0, or 0:0:16:0, there are
only two WD Reds in this system. Two of the ports on the card are unpopulated.

Then I see some errors some time later:


[ 7113.505094] sd 0:0:14:0: [sdi] FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 7113.506044] sd 0:0:14:0: [sdi] CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 08 00 00
[ 7113.506967] blk_update_request: I/O error, dev sdi, sector 0
[ 7113.508415] sd 0:0:14:0: [sdi] FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 7113.509330] sd 0:0:14:0: [sdi] CDB: Read(16) 88 00 00 00 00 01 5d 50 a3 00 00 00 00 08 00 00
[ 7113.510252] blk_update_request: I/O error, dev sdi, sector 5860532992
[ 7113.511567] sd 0:0:14:0: [sdi] FAILED Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[ 7113.512522] sd 0:0:14:0: [sdi] CDB: Read(16) 88 00 00 00 00 01 5d 50 a3 a0 00 00 00 08 00 00
[ 7113.513487] blk_update_request: I/O error, dev sdi, sector 5860533152
[ 7113.515208] sd 0:0:14:0: [sdi] Synchronizing SCSI cache


This keeps happening over and over.

Attempting to `smartctl -a` on sdi fails with "no such device", and sdi does
not currently appear in /dev

This machine is currently running a 4.0.2-1 kernel from debian sid.

What exactly can cause this, and how can I fix it?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
