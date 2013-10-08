From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/3] target: Make target_do_xcopy failures return INVALID_PARAMETER_LIST
Date: Tue,  8 Oct 2013 19:56:31 +0000
Message-ID: <1381262193-19797-2-git-send-email-nab@daterainc.com>
References: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes target_do_xcopy() to properly return
TCM_INVALID_PARAMETER_LIST instead of TCM_INVALID_CDB_FIELD
for failures related to the EXTENDED_COPY parameter list parsing.

Also, move struct xcopy_op allocation ahead of kmapping to
handle the special TCM_OUT_OF_RESOURCES case.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 3da4fd1..6b9774c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -896,9 +896,17 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
 
+	xop = kzalloc(sizeof(struct xcopy_op), GFP_KERNEL);
+	if (!xop) {
+		pr_err("Unable to allocate xcopy_op\n");
+		return TCM_OUT_OF_RESOURCES;
+	}
+	xop->xop_se_cmd = se_cmd;
+
 	p = transport_kmap_data_sg(se_cmd);
 	if (!p) {
 		pr_err("transport_kmap_data_sg() failed in target_do_xcopy\n");
+		kfree(xop);
 		return TCM_OUT_OF_RESOURCES;
 	}
 
@@ -920,13 +928,6 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		goto out;
 	}
 
-	xop = kzalloc(sizeof(struct xcopy_op), GFP_KERNEL);
-	if (!xop) {
-		pr_err("Unable to allocate xcopy_op\n");
-		goto out;
-	}
-	xop->xop_se_cmd = se_cmd;
-
 	pr_debug("Processing XCOPY with list_id: 0x%02x list_id_usage: 0x%02x"
 		" tdll: %hu sdll: %u inline_dl: %u\n", list_id, list_id_usage,
 		tdll, sdll, inline_dl);
@@ -957,7 +958,7 @@ out:
 	if (p)
 		transport_kunmap_data_sg(se_cmd);
 	kfree(xop);
-	return TCM_INVALID_CDB_FIELD;
+	return TCM_INVALID_PARAMETER_LIST;
 }
 
 static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
-- 
1.7.10.4
