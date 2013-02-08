From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 3/3] target: Fix parameter list length checking in MODE SELECT
Date: Fri,  8 Feb 2013 15:18:40 -0800
Message-ID: <1360365520-11972-3-git-send-email-roland@kernel.org>
References: <1360365520-11972-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:52852 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1947299Ab3BHXSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 18:18:51 -0500
Received: by mail-da0-f69.google.com with SMTP id q36so2979356dad.8
        for <linux-scsi@vger.kernel.org>; Fri, 08 Feb 2013 15:18:50 -0800 (PST)
In-Reply-To: <1360365520-11972-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

An empty parameter list (length == 0) is not an error, so succeed MODE
SELECT in this case.  If the parameter list length is too small,
return the correct sense code of PARAMETER LIST LENGTH ERROR.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_spc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 2d88f08..73c5d53 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -983,6 +983,14 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	int ret = 0;
 	int i;
 
+	if (!cmd->data_length) {
+		target_complete_cmd(cmd, GOOD);
+		return 0;
+	}
+
+	if (cmd->data_length < off + 2)
+		return TCM_PARAMETER_LIST_LENGTH_ERROR;
+
 	buf = transport_kmap_data_sg(cmd);
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1007,6 +1015,11 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 	goto out;
 
 check_contents:
+	if (cmd->data_length < off + length) {
+		ret = TCM_PARAMETER_LIST_LENGTH_ERROR;
+		goto out;
+	}
+
 	if (memcmp(buf + off, tbuf, length))
 		ret = TCM_INVALID_PARAMETER_LIST;
 
-- 
1.8.1.2

