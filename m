From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/4] target: Use common error handling code in three functions
Date: Sat, 4 Nov 2017 14:15:17 +0100
Message-ID: <437fc193-6cf4-e9e3-3a0c-be34c9d1d58d@users.sourceforge.net>
References: <27e27d42-473d-e8db-fe9e-803fed646881@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <27e27d42-473d-e8db-fe9e-803fed646881@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Nov 2017 13:13:20 +0100

Adjust jump targets so that a bit of exception handling can be better
reused at the end of these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_xcopy.c | 49 +++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 9ee89e00cd77..b06877c57765 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -701,11 +701,8 @@ static int target_xcopy_read_source(
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port, true);
-	if (rc < 0) {
-		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
-	}
+	if (rc < 0)
+		goto set_status;
 
 	xop->xop_data_sg = se_cmd->t_data_sg;
 	xop->xop_data_nents = se_cmd->t_data_nents;
@@ -713,11 +710,9 @@ static int target_xcopy_read_source(
 		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
 
 	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
-	if (rc < 0) {
-		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
-	}
+	if (rc < 0)
+		goto set_status;
+
 	/*
 	 * Clear off the allocated t_data_sg, that has been saved for
 	 * zero-copy WRITE submission reuse in struct xcopy_op..
@@ -726,6 +721,11 @@ static int target_xcopy_read_source(
 	se_cmd->t_data_nents = 0;
 
 	return 0;
+
+set_status:
+	ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
+	transport_generic_free_cmd(se_cmd, 0);
+	return rc;
 }
 
 static int target_xcopy_write_destination(
@@ -775,19 +775,21 @@ static int target_xcopy_write_destination(
 		src_cmd->t_data_sg = xop->xop_data_sg;
 		src_cmd->t_data_nents = xop->xop_data_nents;
 
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
+		goto err_free_cmd;
 	}
 
 	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
 	if (rc < 0) {
 		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
 		se_cmd->se_cmd_flags &= ~SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
-		transport_generic_free_cmd(se_cmd, 0);
-		return rc;
+		goto err_free_cmd;
 	}
 
 	return 0;
+
+err_free_cmd:
+	transport_generic_free_cmd(se_cmd, 0);
+	return rc;
 }
 
 static void target_xcopy_do_work(struct work_struct *work)
@@ -801,10 +803,10 @@ static void target_xcopy_do_work(struct work_struct *work)
 	unsigned short nolb, cur_nolb, max_nolb, copied_nolb = 0;
 
 	if (target_parse_xcopy_cmd(xop) != TCM_NO_SENSE)
-		goto err_free;
+		goto err_free_xop;
 
 	if (WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev))
-		goto err_free;
+		goto err_free_xop;
 
 	src_dev = xop->src_dev;
 	dst_dev = xop->dst_dev;
@@ -835,7 +837,7 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 		rc = target_xcopy_read_source(ec_cmd, xop, src_dev, src_lba, cur_nolb);
 		if (rc < 0)
-			goto out;
+			goto err_undepend_device;
 
 		src_lba += cur_nolb;
 		pr_debug("target_xcopy_do_work: Incremented READ src_lba to %llu\n",
@@ -846,10 +848,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 
 		rc = target_xcopy_write_destination(ec_cmd, xop, dst_dev,
 						dst_lba, cur_nolb);
-		if (rc < 0) {
-			transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
-			goto out;
-		}
+		if (rc < 0)
+			goto err_free_cmd;
 
 		dst_lba += cur_nolb;
 		pr_debug("target_xcopy_do_work: Incremented WRITE dst_lba to %llu\n",
@@ -876,10 +876,11 @@ static void target_xcopy_do_work(struct work_struct *work)
 	target_complete_cmd(ec_cmd, SAM_STAT_GOOD);
 	return;
 
-out:
+err_free_cmd:
+	transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
+err_undepend_device:
 	xcopy_pt_undepend_remotedev(xop);
-
-err_free:
+err_free_xop:
 	kfree(xop);
 	/*
 	 * Don't override an error scsi status if it has already been set
-- 
2.15.0
