Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C548FC4320A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 14:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA0360F58
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 14:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbhHCOz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 10:55:29 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36192 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234206AbhHCOz2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Aug 2021 10:55:28 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3606A496BD;
        Tue,  3 Aug 2021 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1628002514; x=1629816915; bh=mzEJ4F3NGW1bkfWYlIFWacknsinD2nmebG7
        1BqQnndo=; b=aVFJn2Z8XaP2+kiI2I381ku/F/IF3ZVx3jwBRa6EqcB5vyf1J8J
        WA2LC0cRb//ugan0ljiklr5tLTYargnzqE2As7/WQwIvWn97CwxFqU05RLJ5VPNd
        njpd8lasvpADe6/BTP+v+OGnlbW6OY55kQ/IFBsDOrdXDzpql70Je9qo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id of1hemMpAl8o; Tue,  3 Aug 2021 17:55:14 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BCD0149455;
        Tue,  3 Aug 2021 17:55:14 +0300 (MSK)
Received: from yadro.com (10.199.0.12) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 3 Aug
 2021 17:55:13 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <ddiss@suse.de>, <bvanassche@acm.org>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Sergey Samoylenko <s.samoylenko@yadro.com>
Subject: [v3 1/2] scsi: target: allows backend drivers to fail with specific sense codes
Date:   Tue, 3 Aug 2021 17:54:09 +0300
Message-ID: <20210803145410.80147-2-s.samoylenko@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803145410.80147-1-s.samoylenko@yadro.com>
References: <20210803145410.80147-1-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.12]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, backend drivers can fail IO with
SAM_STAT_CHECK_CONDITION which gets us
TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE. The patch adds
a new helper that allows backend drivers to fail with
specific sense codes.

This is based on a patch from Mike Christie <michael.christie@oracle.com>.

Cc: Mike Christie <michael.christie@oracle.com>

Reviewed-by: David Disseldorp <ddiss@suse.de>
[ Moved target_complete_cmd_with_sense() helper to mainline ]
Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
---
 drivers/target/target_core_transport.c | 15 ++++++++++++---
 include/target/target_core_backend.h   |  1 +
 include/target/target_core_base.h      |  2 ++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 065834480179..72cbf006d9d1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -736,8 +736,7 @@ static void target_complete_failure_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
 
-	transport_generic_request_failure(cmd,
-			TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	transport_generic_request_failure(cmd, cmd->sense_reason);
 }
 
 /*
@@ -855,7 +854,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
 }
 
 /* May be called from interrupt context so must not sleep. */
-void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+void target_complete_cmd_with_sense(struct se_cmd *cmd, u8 scsi_status,
+				    sense_reason_t sense_reason)
 {
 	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
 	int success, cpu;
@@ -865,6 +865,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		return;
 
 	cmd->scsi_status = scsi_status;
+	cmd->sense_reason = sense_reason;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	switch (cmd->scsi_status) {
@@ -893,6 +894,14 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	queue_work_on(cpu, target_completion_wq, &cmd->work);
 }
+EXPORT_SYMBOL(target_complete_cmd_with_sense);
+
+void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+{
+	target_complete_cmd_with_sense(cmd, scsi_status, scsi_status ?
+			      TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE :
+			      TCM_NO_SENSE);
+}
 EXPORT_SYMBOL(target_complete_cmd);
 
 void target_set_cmd_data_length(struct se_cmd *cmd, int length)
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1f78b09bba55..675f3a1fe613 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -75,6 +75,7 @@ void	target_backend_unregister(const struct target_backend_ops *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
 void	target_set_cmd_data_length(struct se_cmd *, int);
+void	target_complete_cmd_with_sense(struct se_cmd *, u8, sense_reason_t);
 void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f53e0f160695..fb11c7693b25 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -457,6 +457,8 @@ enum target_core_dif_check {
 #define TCM_ACA_TAG	0x24
 
 struct se_cmd {
+	/* Used for fail with specific sense codes */
+	sense_reason_t		sense_reason;
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
 	u16			scsi_sense_length;
-- 
2.25.1

