Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A37C41513
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 12:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjGZMOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 08:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbjGZMOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 08:14:33 -0400
Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B482619B5;
        Wed, 26 Jul 2023 05:14:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com D008BC0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
        t=1690372546; bh=RXHNlK+J34Gch7AuwTA6STlGivOlgCC2+rOrTiYymHw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=lXT96hBUCZk0nf7DfimDbnxLgQfk2Cf7KKydxT+i1pXhhy70+eQhUMjjl4lU6z9e/
         G4UZ1c2VR0LQZTw7BPOs1JmuWVHwvQjtZnyceGaWd/0yyhds4LTj/k8ma38qMAnMKt
         rdPh5XTGhYWyM8J8xqSZfSBtVvc6t8Smj9+3swUwHjXdEJb9BCM6IqQbwly9mER3MA
         52sVtvu49vjXSfQdHgV2C4nkMmfDiLbgKRIeXKI+ssytx9evZYMzrHQWh5HDyta4YY
         VNqu/JzVDS+KD+WE6uo8T2O4xfDF4Hj1xSpmApUsJDhYN1Drb9FATp/9BvyZrt4/wj
         ggGlu/U/GfGqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
        t=1690372546; bh=RXHNlK+J34Gch7AuwTA6STlGivOlgCC2+rOrTiYymHw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=haKYp3ZPw7/TnlrM1WvF687JrkswEKvQ6F6bisMYWDiX5wT09yZKBHoh/lg3eJClW
         taWm6qsfvfzP1I+yw+u2wh0vhmEIiJzpvpUHT26YxWWx6MsXoYaADclDqODaMhvoOW
         MnS+ZeJy5Dnc+JYaMliA4cCtq5BeiaG3Oci/UhUKlzuKe05+A4KHyTMApxEP9rUhrn
         np7SwwBHDRSm0IKF5WanaicZhQw31dVfuvIbgDLvCpczU2W13Vs0HAPj2VkKz+h1zQ
         RrVkMEU/R/6YJYRp9XDGAJdGnOhxy7by4ik4GPFiqDKOHJg6yKhw3hfO06TyeLtlLA
         AL71+T2IqJw0A==
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux@yadro.com>
Subject: [RFC PATCH 2/3] target: core: apply the new wrapper to spc
Date:   Wed, 26 Jul 2023 14:55:08 +0300
Message-ID: <20230726115509.357-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230726115509.357-1-a.kovaleva@yadro.com>
References: <20230726115509.357-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
---
 drivers/target/target_core_spc.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 50290abc07bc..8defcf11cde3 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -25,6 +25,8 @@
 #include "target_core_ua.h"
 #include "target_core_xcopy.h"
 
+#define TARGET_PREFIX "core"
+
 static void spc_fill_alua_data(struct se_lun *lun, unsigned char *buf)
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
@@ -742,7 +744,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 	buf = kzalloc(SE_INQUIRY_BUF, GFP_KERNEL);
 	if (!buf) {
-		pr_err("Unable to allocate response buffer for INQUIRY\n");
+		target_cmd_err(cmd, "Unable to allocate response buffer for INQUIRY\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -750,8 +752,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 
 	if (!(cdb[1] & 0x1)) {
 		if (cdb[2]) {
-			pr_err("INQUIRY with EVPD==0 but PAGE CODE=%02x\n",
-			       cdb[2]);
+			target_cmd_err(cmd, "INQUIRY with EVPD==0 but PAGE CODE=%02x\n", cdb[2]);
 			ret = TCM_INVALID_CDB_FIELD;
 			goto out;
 		}
@@ -770,7 +771,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 		}
 	}
 
-	pr_debug("Unknown VPD Code: 0x%02x\n", cdb[2]);
+	target_cmd_debug(cmd, "Unknown VPD Code: 0x%02x\n", cdb[2]);
 	ret = TCM_INVALID_CDB_FIELD;
 
 out:
@@ -1085,7 +1086,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 
 	if (page == 0x3f) {
 		if (subpage != 0x00 && subpage != 0xff) {
-			pr_warn("MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
+			target_cmd_warn(cmd, "MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -1119,8 +1120,8 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	 *  - obsolete page 03h "format parameters" (checked by Solaris)
 	 */
 	if (page != 0x03)
-		pr_err("MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n",
-		       page, subpage);
+		target_cmd_err(cmd, "MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n",
+				 page, subpage);
 
 	return TCM_UNKNOWN_MODE_PAGE;
 
@@ -1212,8 +1213,7 @@ static sense_reason_t spc_emulate_request_sense(struct se_cmd *cmd)
 	memset(buf, 0, SE_SENSE_BUF);
 
 	if (cdb[1] & 0x01) {
-		pr_err("REQUEST_SENSE description emulation not"
-			" supported\n");
+		target_cmd_err(cmd, "REQUEST_SENSE description emulation not supported\n");
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -2113,7 +2113,6 @@ static sense_reason_t
 spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 {
 	struct target_opcode_descriptor *descr;
-	struct se_session *sess = cmd->se_sess;
 	unsigned char *cdb = cmd->t_task_cdb;
 	u8 opts = cdb[2] & 0x3;
 	u8 requested_opcode;
@@ -2125,11 +2124,9 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 	*opcode = NULL;
 
 	if (opts > 3) {
-		pr_debug("TARGET_CORE[%s]: Invalid REPORT SUPPORTED OPERATION CODES"
-			" with unsupported REPORTING OPTIONS %#x for 0x%08llx from %s\n",
-			cmd->se_tfo->fabric_name, opts,
-			cmd->se_lun->unpacked_lun,
-			sess->se_node_acl->initiatorname);
+		target_cmd_debug(cmd,
+				 "Invalid REPORT SUPPORTED OPERATION CODES with unsupported REPORTING OPTIONS %#x for 0x%08llx\n",
+				 opts, cmd->se_lun->unpacked_lun);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-- 
2.40.1

