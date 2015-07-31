From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/15] drivers: target: Drop unlikely before IS_ERR(_OR_NULL)
Date: Fri, 31 Jul 2015 14:08:31 +0530
Message-ID: <f45b26389ac65b23eb41b90da8680a98d433cd86.1438331416.git.viresh.kumar@linaro.org>
References: <cover.1438331416.git.viresh.kumar@linaro.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <cover.1438331416.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1438331416.git.viresh.kumar@linaro.org>
References: <cover.1438331416.git.viresh.kumar@linaro.org>
Sender: target-devel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Odin.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, martin.petersen@oracle.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag and there
is no need to do that again from its callers. Drop it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/target/tcm_fc/tfc_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 68031723e5be..aa3caca8bace 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -255,7 +255,7 @@ static void ft_recv_seq(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 	struct ft_cmd *cmd = arg;
 	struct fc_frame_header *fh;
 
-	if (unlikely(IS_ERR(fp))) {
+	if (IS_ERR(fp)) {
 		/* XXX need to find cmd if queued */
 		cmd->seq = NULL;
 		cmd->aborted = true;
-- 
2.4.0
