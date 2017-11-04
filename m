From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/4] target: Combine two condition checks into one statement
 in target_xcopy_do_work()
Date: Sat, 4 Nov 2017 14:16:36 +0100
Message-ID: <09a6b5ba-70b7-ba4d-ad4f-6450c9da6208@users.sourceforge.net>
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
Date: Sat, 4 Nov 2017 13:26:46 +0100

The same label was used by goto statements after two condition checks.
Thus use a single statement instead.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_xcopy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index b06877c57765..46cac36014df 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -802,10 +802,8 @@ static void target_xcopy_do_work(struct work_struct *work)
 	int rc = 0;
 	unsigned short nolb, cur_nolb, max_nolb, copied_nolb = 0;
 
-	if (target_parse_xcopy_cmd(xop) != TCM_NO_SENSE)
-		goto err_free_xop;
-
-	if (WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev))
+	if (target_parse_xcopy_cmd(xop) != TCM_NO_SENSE ||
+	    WARN_ON_ONCE(!xop->src_dev) || WARN_ON_ONCE(!xop->dst_dev))
 		goto err_free_xop;
 
 	src_dev = xop->src_dev;
-- 
2.15.0
