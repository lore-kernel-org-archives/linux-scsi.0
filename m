From: Colin King <colin.king@canonical.com>
Subject: [PATCH] target/iscsi: make function target_parse_xcopy_cmd static
Date: Thu, 11 May 2017 11:16:16 +0100
Message-ID: <20170511101616.19790-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Making target_parse_xcopy_cmd static fixes sparse warning:

"warning: symbol 'target_parse_xcopy_cmd' was not declared.  Should
it be static?"

Fixes: 1bd05294519f76 ("target/iscsi: Fix a deadlock between the XCOPY code and session shutdown")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_xcopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index aecb36d955f0..00e0269e6be4 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -886,7 +886,7 @@ static void target_xcopy_do_work(struct work_struct *work)
  * Returns TCM_NO_SENSE upon success or a sense code != TCM_NO_SENSE if parsing
  * fails.
  */
-sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
+static sense_reason_t target_parse_xcopy_cmd(struct xcopy_op *xop)
 {
 	struct se_cmd *se_cmd = xop->xop_se_cmd;
 	unsigned char *p = NULL, *seg_desc;
-- 
2.11.0
