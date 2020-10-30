Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5E6C4742C
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 21:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A81722228
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 21:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgJ3Vjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 17:39:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:56814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3Vjx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 17:39:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 21F7DAE0F;
        Fri, 30 Oct 2020 21:39:51 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 1/4] scsi: target: rename struct sense_info to sense_detail
Date:   Fri, 30 Oct 2020 22:39:28 +0100
Message-Id: <20201030213931.10720-2-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030213931.10720-1-ddiss@suse.de>
References: <20201030213931.10720-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This helps distinguish it from the SCSI sense INFORMATION field.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0a5f60..caa3a7b34826 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3094,14 +3094,14 @@ bool transport_wait_for_tasks(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
-struct sense_info {
+struct sense_detail {
 	u8 key;
 	u8 asc;
 	u8 ascq;
 	bool add_sector_info;
 };
 
-static const struct sense_info sense_info_table[] = {
+static const struct sense_detail sense_detail_table[] = {
 	[TCM_NO_SENSE] = {
 		.key = NOT_READY
 	},
@@ -3261,39 +3261,39 @@ static const struct sense_info sense_info_table[] = {
  */
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
-	const struct sense_info *si;
+	const struct sense_detail *sd;
 	u8 *buffer = cmd->sense_buffer;
 	int r = (__force int)reason;
 	u8 key, asc, ascq;
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
-	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
-		si = &sense_info_table[r];
+	if (r < ARRAY_SIZE(sense_detail_table) && sense_detail_table[r].key)
+		sd = &sense_detail_table[r];
 	else
-		si = &sense_info_table[(__force int)
+		sd = &sense_detail_table[(__force int)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
-	key = si->key;
+	key = sd->key;
 	if (reason == TCM_CHECK_CONDITION_UNIT_ATTENTION) {
 		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
 						       &ascq)) {
 			cmd->scsi_status = SAM_STAT_BUSY;
 			return;
 		}
-	} else if (si->asc == 0) {
+	} else if (sd->asc == 0) {
 		WARN_ON_ONCE(cmd->scsi_asc == 0);
 		asc = cmd->scsi_asc;
 		ascq = cmd->scsi_ascq;
 	} else {
-		asc = si->asc;
-		ascq = si->ascq;
+		asc = sd->asc;
+		ascq = sd->ascq;
 	}
 
 	cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 	cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
 	scsi_build_sense_buffer(desc_format, buffer, key, asc, ascq);
-	if (si->add_sector_info)
+	if (sd->add_sector_info)
 		WARN_ON_ONCE(scsi_set_sense_information(buffer,
 							cmd->scsi_sense_length,
 							cmd->bad_sector) < 0);
-- 
2.26.2

