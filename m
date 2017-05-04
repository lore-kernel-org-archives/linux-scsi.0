From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V4 10/12] hpsa: send ioaccel requests with 0 length down
 raid path
Date: Thu, 4 May 2017 17:51:42 -0500
Message-ID: <149393830281.19382.9158146356007036104.stgit@brunhilda>
References: <149393820493.19382.11709906672864416473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0056.outbound.protection.outlook.com ([104.47.40.56]:5664
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751972AbdEDWv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 May 2017 18:51:59 -0400
In-Reply-To: <149393820493.19382.11709906672864416473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

 - Block I/O requests with 0 length transfers which go down
   the ioaccel path. This causes lockup issues down in the basecode.
   - These issues have been fixed, but there are customers who are
     experiencing the issues when running older firmware.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2ec9079..ea778cc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4591,7 +4591,55 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 	return 0;
 }
 
-#define IO_ACCEL_INELIGIBLE (1)
+#define BUFLEN 128
+static inline void warn_zero_length_transfer(struct ctlr_info *h,
+						u8 *cdb, int cdb_len,
+						const char *func)
+{
+	char buf[BUFLEN];
+	int outlen;
+	int i;
+
+	outlen = scnprintf(buf, BUFLEN,
+				"%s: Blocking zero-length request: CDB:", func);
+	for (i = 0; i < cdb_len; i++)
+		outlen += scnprintf(buf+outlen, BUFLEN - outlen,
+					"%02hhx", cdb[i]);
+	dev_warn(&h->pdev->dev, "%s\n", buf);
+}
+
+#define IO_ACCEL_INELIGIBLE 1
+/* zero-length transfers trigger hardware errors. */
+static bool is_zero_length_transfer(u8 *cdb)
+{
+	u32 block_cnt;
+
+	/* Block zero-length transfer sizes on certain commands. */
+	switch (cdb[0]) {
+	case READ_10:
+	case WRITE_10:
+	case VERIFY:		/* 0x2F */
+	case WRITE_VERIFY:	/* 0x2E */
+		block_cnt = get_unaligned_be16(&cdb[7]);
+		break;
+	case READ_12:
+	case WRITE_12:
+	case VERIFY_12: /* 0xAF */
+	case WRITE_VERIFY_12:	/* 0xAE */
+		block_cnt = get_unaligned_be32(&cdb[6]);
+		break;
+	case READ_16:
+	case WRITE_16:
+	case VERIFY_16:		/* 0x8F */
+		block_cnt = get_unaligned_be32(&cdb[10]);
+		break;
+	default:
+		return false;
+	}
+
+	return block_cnt == 0;
+}
+
 static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
 {
 	int is_write = 0;
@@ -4658,6 +4706,12 @@ static int hpsa_scsi_ioaccel1_queue_command(struct ctlr_info *h,
 
 	BUG_ON(cmd->cmd_len > IOACCEL1_IOFLAGS_CDBLEN_MAX);
 
+	if (is_zero_length_transfer(cdb)) {
+		warn_zero_length_transfer(h, cdb, cdb_len, __func__);
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		return IO_ACCEL_INELIGIBLE;
+	}
+
 	if (fixup_ioaccel_cdb(cdb, &cdb_len)) {
 		atomic_dec(&phys_disk->ioaccel_cmds_out);
 		return IO_ACCEL_INELIGIBLE;
@@ -4822,6 +4876,12 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 
 	BUG_ON(scsi_sg_count(cmd) > h->maxsgentries);
 
+	if (is_zero_length_transfer(cdb)) {
+		warn_zero_length_transfer(h, cdb, cdb_len, __func__);
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		return IO_ACCEL_INELIGIBLE;
+	}
+
 	if (fixup_ioaccel_cdb(cdb, &cdb_len)) {
 		atomic_dec(&phys_disk->ioaccel_cmds_out);
 		return IO_ACCEL_INELIGIBLE;
