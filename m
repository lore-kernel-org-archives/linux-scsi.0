From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/4] target: Improve a size determination in three functions
Date: Sat, 4 Nov 2017 14:17:45 +0100
Message-ID: <a708f62c-6a03-9a10-e9e1-0a72e8953652@users.sourceforge.net>
References: <27e27d42-473d-e8db-fe9e-803fed646881@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <27e27d42-473d-e8db-fe9e-803fed646881@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Nov 2017 13:35:08 +0100

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_xcopy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 46cac36014df..1519e399392b 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -680,7 +680,7 @@ static int target_xcopy_read_source(
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_DEST_RECV_OP);
 
-	xpt_cmd = kzalloc(sizeof(struct xcopy_pt_cmd), GFP_KERNEL);
+	xpt_cmd = kzalloc(sizeof(*xpt_cmd), GFP_KERNEL);
 	if (!xpt_cmd) {
 		pr_err("Unable to allocate xcopy_pt_cmd\n");
 		return -ENOMEM;
@@ -742,7 +742,7 @@ static int target_xcopy_write_destination(
 	unsigned char cdb[16];
 	bool remote_port = (xop->op_origin == XCOL_SOURCE_RECV_OP);
 
-	xpt_cmd = kzalloc(sizeof(struct xcopy_pt_cmd), GFP_KERNEL);
+	xpt_cmd = kzalloc(sizeof(*xpt_cmd), GFP_KERNEL);
 	if (!xpt_cmd) {
 		pr_err("Unable to allocate xcopy_pt_cmd\n");
 		return -ENOMEM;
@@ -1010,7 +1010,7 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		return TCM_PARAMETER_LIST_LENGTH_ERROR;
 	}
 
-	xop = kzalloc(sizeof(struct xcopy_op), GFP_KERNEL);
+	xop = kzalloc(sizeof(*xop), GFP_KERNEL);
 	if (!xop)
 		goto err;
 	xop->xop_se_cmd = se_cmd;
-- 
2.15.0
