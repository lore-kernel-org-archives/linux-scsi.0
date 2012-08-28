From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: SECURITY ERASE UNIT gets IDNF instead of ABRT?
Date: Tue, 28 Aug 2012 15:10:46 +0900 (JST)
Message-ID: <6865.81457.qm@web100011.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100011.mail.kks.yahoo.co.jp ([114.111.98.185]:44318 "HELO
	web100011.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751214Ab2H1GR3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Aug 2012 02:17:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If I understand the standard correctly, if SECURITY ERASE UNIT fails to erase a bad block then the result should have the ABRT bit set.

There are some kinds of operations where a drive might set IDNF instead of ABRT, but if I understand correctly, SECURITY ERASE UNIT is not one of them.

In one case I've pretty much determined that the drive has bad blocks, where Write commands succeed but Read commands fail.  It makes sense to me that SECURITY ERASE UNIT would do a read-after-write and report ABRT but not IDNF.  My latest repro on this drive was done with a direct connection to the motherboard with no port multiplier (the motherboard's Intel chipset doesn't support port multipliers anyway).

[ 6966.365779] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 6966.365786] ata5.00: irq_stat 0x40000001
[ 6966.365793] ata5.00: failed command: SECURITY ERASE UNIT
[ 6966.365805] ata5.00: cmd f4/00:01:00:00:00/00:00:00:00:00/40 tag 0 pio 512 out
[ 6966.365808]          res 51/10:00:00:00:00/00:00:00:00:00/40 Emask 0x81 (invalid argument)
[ 6966.365814] ata5.00: status: { DRDY ERR }
[ 6966.365819] ata5.00: error: { IDNF }
[ 6966.374810] ata5.00: configured for UDMA/133
[ 6966.374834] ata5: EH complete

How is this possible?

On some other drives, SECURITY ERASE UNIT also gave me IDNF, sometimes both IDNF and ABRT, but I haven't tested them without a port multiplier yet.
