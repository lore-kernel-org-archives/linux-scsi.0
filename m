From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 06/19] qla2xxx: Make debug buffer log easier to view.
Date: Wed, 6 Jul 2016 11:14:22 -0400
Message-ID: <1467818075-15246-7-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:44448 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbcGFP7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:47 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 907a7ac..589cd13 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -13,7 +13,7 @@
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x018f       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
- * |                              |                    | 0x016e-0x0170  |
+ * |                              |                    | 0x016e		|
  * | Mailbox commands             |       0x1192       |		|
  * |                              |                    |		|
  * | Device Discovery             |       0x2003       | 0x2016		|
@@ -2698,29 +2698,24 @@ ql_dump_regs(uint32_t level, scsi_qla_host_t *vha, int32_t id)
 
 void
 ql_dump_buffer(uint32_t level, scsi_qla_host_t *vha, int32_t id,
-	uint8_t *b, uint32_t size)
+	uint8_t *buf, uint size)
 {
-	uint32_t cnt;
-	uint8_t c;
+	uint cnt;
 
 	if (!ql_mask_match(level))
 		return;
 
-	ql_dbg(level, vha, id, " 0   1   2   3   4   5   6   7   8   "
-	    "9  Ah  Bh  Ch  Dh  Eh  Fh\n");
-	ql_dbg(level, vha, id, "----------------------------------"
-	    "----------------------------\n");
-
-	ql_dbg(level, vha, id, " ");
-	for (cnt = 0; cnt < size;) {
-		c = *b++;
-		printk("%02x", (uint32_t) c);
-		cnt++;
-		if (!(cnt % 16))
+	ql_dbg(level, vha, id,
+	    "%-+5d  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n", size);
+	ql_dbg(level, vha, id,
+	    "----- -----------------------------------------------\n");
+	for (cnt = 0; cnt < size; cnt++, buf++) {
+		if (cnt % 16 == 0)
+			ql_dbg(level, vha, id, "%04x:", cnt & ~0xFU);
+		printk(" %02x", *buf);
+		if (cnt % 16 == 15)
 			printk("\n");
-		else
-			printk("  ");
 	}
-	if (cnt % 16)
-		ql_dbg(level, vha, id, "\n");
+	if (cnt % 16 != 0)
+		printk("\n");
 }
-- 
2.7.2

