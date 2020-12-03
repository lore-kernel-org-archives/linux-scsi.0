Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0451BC83013
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 08:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEEFF21527
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 08:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388389AbgLCIWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:22:16 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:59974 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388109AbgLCIWQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Dec 2020 03:22:16 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 42FB14138D;
        Thu,  3 Dec 2020 08:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1606983694; x=1608798095; bh=3rDzzptYBWQEIKaNxfPGPFrSpOoWPhMr0G6
        WZUAIhtM=; b=d8QKOarECU/XjGeUT/gpI3rDv8Ni+ttDlZp0QTOCVXdn/RLV5ec
        INs6eSr9mF2Yee0wbu9rOR0gpHIm+8xBCuVc5ppAxNQOZ6kqaRpKiO1oRVGm6ig+
        gXdzLiP6wsQoEOV2hB3kU3mZYvFmCZxCCNfv2/BMAs6ADg40NsbIlYr8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id heP7vBsU7tYx; Thu,  3 Dec 2020 11:21:34 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1F9724136B;
        Thu,  3 Dec 2020 11:21:34 +0300 (MSK)
Received: from localhost (172.17.204.63) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 3 Dec
 2020 11:21:33 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     <martin.petersen@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Anastasia Kovaleva <a.kovaleva@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [RESEND PATCH 2/3] scsi: target: core: Signal WRITE residuals
Date:   Thu, 3 Dec 2020 11:20:34 +0300
Message-ID: <20201203082035.54566-3-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201203082035.54566-1-a.kovaleva@yadro.com>
References: <20201203082035.54566-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.63]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to RFC 7143 11.4.5.2.:

  If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the
  SCSI Response PDU as specified in Section 11.4.5.1.  The Residual
  Count MUST be set to the numerical value of (SPDTL - EDTL).

  If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
  SCSI Response PDU as specified in Section 11.4.5.1.  The Residual
  Count MUST be set to the numerical value of (EDTL - SPDTL).

libiscsi has residual write tests that check residual kind and residual
amount and all of them (Write10Residuals, Write12Residuals,
Write16Residuals) currently fail.

One of the reasons why they fail is because target completes write
commands with INVALID FIELD IN CDB before setting the Overflow/Underflow
bit and residual amount.

Set the Overflow/Underflow bit and the residual amount before failing a
write to comply with RFC 7143.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_transport.c | 34 +++++++++++++++-----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f27a7d6cc1e0..eb51298cab4f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1313,6 +1313,26 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", cmd->se_tfo->fabric_name,
 				cmd->data_length, size, cmd->t_task_cdb[0]);
+		/*
+		 * For READ command for the overflow case keep the existing
+		 * fabric provided ->data_length. Otherwise for the underflow
+		 * case, reset ->data_length to the smaller SCSI expected data
+		 * transfer length.
+		 */
+		if (size > cmd->data_length) {
+			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
+			cmd->residual_count = (size - cmd->data_length);
+		} else {
+			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
+			cmd->residual_count = (cmd->data_length - size);
+			/*
+			 * Do not truncate ->data_length for WRITE command to
+			 * dump all payload
+			 */
+			if (cmd->data_direction == DMA_FROM_DEVICE) {
+				cmd->data_length = size;
+			}
+		}
 
 		if (cmd->data_direction == DMA_TO_DEVICE) {
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
@@ -1332,20 +1352,6 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
-		/*
-		 * For the overflow case keep the existing fabric provided
-		 * ->data_length.  Otherwise for the underflow case, reset
-		 * ->data_length to the smaller SCSI expected data transfer
-		 * length.
-		 */
-		if (size > cmd->data_length) {
-			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
-			cmd->residual_count = (size - cmd->data_length);
-		} else {
-			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-			cmd->residual_count = (cmd->data_length - size);
-			cmd->data_length = size;
-		}
 	}
 
 	return target_check_max_data_sg_nents(cmd, dev, size);
-- 
2.24.3 (Apple Git-128)

