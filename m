From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/3] target: Reject EXTENDED_COPY when emulate_3pc is disabled
Date: Tue,  8 Oct 2013 19:56:33 +0000
Message-ID: <1381262193-19797-4-git-send-email-nab@daterainc.com>
References: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381262193-19797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch rejects EXTENDED_COPY when the emulate_3pc attribute has
been explicitly disabled for the receiving device.

It also adds a similar check in target_xcopy_locate_se_dev_e4() to
ignore these devices when doing a search based upon the identifier
WWN provided by EXTENDED_COPY parameter list target descriptors.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index fe98555..eeeaf99 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -82,6 +82,9 @@ static int target_xcopy_locate_se_dev_e4(struct se_cmd *se_cmd, struct xcopy_op
 	mutex_lock(&g_device_mutex);
 	list_for_each_entry(se_dev, &g_device_list, g_dev_node) {
 
+		if (!se_dev->dev_attrib.emulate_3pc)
+			continue;
+
 		memset(&tmp_dev_wwn[0], 0, XCOPY_NAA_IEEE_REGEX_LEN);
 		target_xcopy_gen_naa_ieee(se_dev, &tmp_dev_wwn[0]);
 
@@ -884,12 +887,18 @@ out:
 
 sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 {
+	struct se_device *dev = se_cmd->se_dev;
 	struct xcopy_op *xop = NULL;
 	unsigned char *p = NULL, *seg_desc;
 	unsigned int list_id, list_id_usage, sdll, inline_dl, sa;
 	int rc;
 	unsigned short tdll;
 
+	if (!dev->dev_attrib.emulate_3pc) {
+		pr_err("EXTENDED_COPY operation explicitly disabled\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	sa = se_cmd->t_task_cdb[1] & 0x1f;
 	if (sa != 0x00) {
 		pr_err("EXTENDED_COPY(LID4) not supported\n");
-- 
1.7.10.4
