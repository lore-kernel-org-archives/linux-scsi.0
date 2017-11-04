From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/4] target: Delete an error message for a failed memory
 allocation in two functions
Date: Sat, 4 Nov 2017 14:18:59 +0100
Message-ID: <e6282832-737d-f3a5-bb1a-70fc53c58451@users.sourceforge.net>
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
Date: Sat, 4 Nov 2017 13:43:22 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_xcopy.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 1519e399392b..c2b3d3158208 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -681,10 +681,9 @@ static int target_xcopy_read_source(
 	bool remote_port = (xop->op_origin == XCOL_DEST_RECV_OP);
 
 	xpt_cmd = kzalloc(sizeof(*xpt_cmd), GFP_KERNEL);
-	if (!xpt_cmd) {
-		pr_err("Unable to allocate xcopy_pt_cmd\n");
+	if (!xpt_cmd)
 		return -ENOMEM;
-	}
+
 	init_completion(&xpt_cmd->xpt_passthrough_sem);
 	se_cmd = &xpt_cmd->se_cmd;
 
@@ -743,10 +742,9 @@ static int target_xcopy_write_destination(
 	bool remote_port = (xop->op_origin == XCOL_SOURCE_RECV_OP);
 
 	xpt_cmd = kzalloc(sizeof(*xpt_cmd), GFP_KERNEL);
-	if (!xpt_cmd) {
-		pr_err("Unable to allocate xcopy_pt_cmd\n");
+	if (!xpt_cmd)
 		return -ENOMEM;
-	}
+
 	init_completion(&xpt_cmd->xpt_passthrough_sem);
 	se_cmd = &xpt_cmd->se_cmd;
 
-- 
2.15.0
