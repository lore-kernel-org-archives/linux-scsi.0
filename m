From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/3] target: Fail on non zero scsi_status in compare_and_write_callback
Date: Wed,  2 Oct 2013 00:13:16 +0000
Message-ID: <1380672796-437-4-git-send-email-nab@daterainc.com>
References: <1380672796-437-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1380672796-437-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug for backends such as IBLOCK that perform
asynchronous completion via transport_complete_cmd(), that will call
target_complete_failure_work() -> transport_generic_request_failure(),
upon exception status and invoke cmd->transport_complete_callback()
-> compare_and_write_callback() incorrectly during the failure case.

It adds a check for a non zero se_cmd->scsi_status within the first
invocation of compare_and_write_callback(), and will jump to out plus
up se_device->caw_sem before exiting the callback.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 1393d0e..4714c6f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -372,7 +372,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *write_sg = NULL, *sg;
-	unsigned char *buf, *addr;
+	unsigned char *buf = NULL, *addr;
 	struct sg_mapping_iter m;
 	unsigned int offset = 0, len;
 	unsigned int nlbas = cmd->t_task_nolb;
@@ -387,6 +387,15 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd)
 	 */
 	if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
 		return TCM_NO_SENSE;
+	/*
+	 * Immediately exit + release dev->caw_sem if command has already
+	 * been failed with a non-zero SCSI status.
+	 */
+	if (cmd->scsi_status) {
+		pr_err("compare_and_write_callback: non zero scsi_status:"
+			" 0x%02x\n", cmd->scsi_status);
+		goto out;
+	}
 
 	buf = kzalloc(cmd->data_length, GFP_KERNEL);
 	if (!buf) {
-- 
1.8.4.rc3
