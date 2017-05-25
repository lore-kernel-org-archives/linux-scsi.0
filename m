From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 4/7] qla2xxx: Modify T262 FW dump template to specify same start/end to debug customer issues.
Date: Wed, 24 May 2017 18:06:21 -0700
Message-ID: <20170525010624.8886-5-himanshu.madhani@cavium.com>
References: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0082.outbound.protection.outlook.com ([104.47.40.82]:5229
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162163AbdEYBGg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:36 -0400
In-Reply-To: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Firmware dump allows for debugging customer issues. This patch fixes
start/end pointer calculation to capture T262 template entryfor dump
tool.

Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 8a58ef3adab4..c197972a3e2d 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -371,7 +371,7 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 		goto done;
 	}
 
-	if (end <= start || start == 0 || end == 0) {
+	if (end < start || start == 0 || end == 0) {
 		ql_dbg(ql_dbg_misc, vha, 0xd023,
 		    "%s: unusable range (start=%x end=%x)\n", __func__,
 		    ent->t262.end_addr, ent->t262.start_addr);
-- 
2.12.0
