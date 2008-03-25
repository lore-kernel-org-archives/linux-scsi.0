From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_debug: fix lba and data length calculation bugs
Date: Tue, 25 Mar 2008 17:04:46 +0900
Message-ID: <20080325170446H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:56420 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYCYIF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 04:05:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dougg@torque.net

This fixes lba calculation bugs in scsi_debug (it might happen only
with over 1TB virtual devices).

This is against scsi-misc. scsi-fixes, 2.6.24, 2.6.23, ... probably
all the versions of scsi_debug have the same bugs too but I guess that
there are few people who play scsi_debug with over virtual 1TB devices
(though this can be cleanly applied to scsi-fixes).

Several LLDs have the own code to do the same calculation. It might be
nice to sweep up them?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

For example, `modprobe scsi_debug virtual_gb=1100` gives:

scsi7 : scsi_debug, version 1.81 [20070104], dev_size_mb=8, opts=0x0
scsi 7:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdc] 2306867200 512-byte hardware sectors (1181116 MB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 73 00 10 08
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 7:0:0:0: [sdc] 2306867200 512-byte hardware sectors (1181116 MB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 73 00 10 08
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdc: unknown partition table
sd 7:0:0:0: [sdc] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg6 type 0
end_request: I/O error, dev sdc, sector 2306867072
Buffer I/O error on device sdc, logical block 288358384
end_request: I/O error, dev sdc, sector 2306867072
Buffer I/O error on device sdc, logical block 288358384
end_request: I/O error, dev sdc, sector 2306867192

(snip)

Note that this converts all the calculations (including the correct
calculations) for unification.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4f4c5b7..46a136a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -251,33 +251,37 @@ static struct bus_type pseudo_lld_bus;
 static void get_data_transfer_info(unsigned char *cmd,
 				   unsigned long long *lba, unsigned int *num)
 {
-	int i;
-
 	switch (*cmd) {
 	case WRITE_16:
 	case READ_16:
-		for (*lba = 0, i = 0; i < 8; ++i) {
-			if (i > 0)
-				*lba <<= 8;
-			*lba += cmd[2 + i];
-		}
-		*num = cmd[13] + (cmd[12] << 8) +
-			(cmd[11] << 16) + (cmd[10] << 24);
+		*lba = (u64)cmd[9] | (u64)cmd[8] << 8 |
+			(u64)cmd[7] << 16 | (u64)cmd[6] << 24 |
+			(u64)cmd[5] << 32 | (u64)cmd[4] << 40 |
+			(u64)cmd[3] << 48 | (u64)cmd[2] << 56;
+
+		*num = (u32)cmd[13] | (u32)cmd[12] << 8 | (u32)cmd[11] << 16 |
+			(u32)cmd[10] << 24;
 		break;
 	case WRITE_12:
 	case READ_12:
-		*lba = cmd[5] + (cmd[4] << 8) +	(cmd[3] << 16) + (cmd[2] << 24);
-		*num = cmd[9] + (cmd[8] << 8) +	(cmd[7] << 16) + (cmd[6] << 24);
+		*lba = (u32)cmd[5] | (u32)cmd[4] << 8 | (u32)cmd[3] << 16 |
+			(u32)cmd[2] << 24;
+
+		*num = (u32)cmd[9] | (u32)cmd[8] << 8 | (u32)cmd[7] << 16 |
+			(u32)cmd[6] << 24;
 		break;
 	case WRITE_10:
 	case READ_10:
 	case XDWRITEREAD_10:
-		*lba = cmd[5] + (cmd[4] << 8) +	(cmd[3] << 16) + (cmd[2] << 24);
-		*num = cmd[8] + (cmd[7] << 8);
+		*lba = (u32)cmd[5] | (u32)cmd[4] << 8 |	(u32)cmd[3] << 16 |
+			(u32)cmd[2] << 24;
+
+		*num = (u32)cmd[8] | (u32)cmd[7] << 8;
 		break;
 	case WRITE_6:
 	case READ_6:
-		*lba = cmd[3] + (cmd[2] << 8) + ((cmd[1] & 0x1f) << 16);
+		*lba = (u32)cmd[3] | (u32)cmd[2] << 8 |
+			(u32)(cmd[1] & 0x1f) << 16;
 		*num = (0 == cmd[4]) ? 256 : cmd[4];
 		break;
 	default:
-- 
1.5.3.6

