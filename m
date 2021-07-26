Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B98C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 15:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1B460F51
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 15:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhGZOhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 10:37:05 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44226 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234985AbhGZOhD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 10:37:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id A1440488E6;
        Mon, 26 Jul 2021 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1627312648; x=1629127049; bh=VovvD/DzUmEBh0Fcm/HkRR9e2bn2i3hanHA
        OJjPW3Vw=; b=DcrBcNmFRdCNApk9nhun3I/cJJkv7hA6oN4kdRq1p85hMeg8uSH
        7FwXi7wvb8Jgv3Lbq/z/LFgMBFbVxI8IueILVaNOdJYmw6f1xHDKp1tJud9FXEtc
        t22zN9TE5gJTU0GGX26ClpNN+Ha/jObsj4JWJtLjHGgEAR9bFB/oNTTE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5zFT40KB23mW; Mon, 26 Jul 2021 18:17:28 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 40C74412C6;
        Mon, 26 Jul 2021 18:17:28 +0300 (MSK)
Received: from yadro.com (10.199.0.6) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 26
 Jul 2021 18:17:27 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     <martin.petersen@oracle.com>, <michael.christie@oracle.com>,
        <ddiss@suse.de>, <bvanassche@acm.org>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Sergey Samoylenko <s.samoylenko@yadro.com>
Subject: [v2 1/2] target: allows backend drivers to fail with specific sense codes
Date:   Mon, 26 Jul 2021 18:16:45 +0300
Message-ID: <20210726151646.32631-2-s.samoylenko@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726151646.32631-1-s.samoylenko@yadro.com>
References: <20210726151646.32631-1-s.samoylenko@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.6]
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
Cc: David Disseldorp <ddiss@suse.de>
[ Moved target_complete_cmd_with_sense() helper to mainline ]
Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
---
 drivers/target/target_core_transport.c | 21 ++++++++++++++++++---
 include/target/target_core_backend.h   |  1 +
 include/target/target_core_base.h      |  2 ++
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 26ceabe34de5..d2a2892bda9c 100644
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
+static void __target_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
+				  sense_reason_t sense_reason)
 {
 	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
 	int success, cpu;
@@ -865,6 +865,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		return;
 
 	cmd->scsi_status = scsi_status;
+	cmd->sense_reason = sense_reason;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	switch (cmd->scsi_status) {
@@ -893,8 +894,22 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	queue_work_on(cpu, target_completion_wq, &cmd->work);
 }
+
+void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
+{
+	__target_complete_cmd(cmd, scsi_status, scsi_status ?
+			      TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE :
+			      TCM_NO_SENSE);
+}
 EXPORT_SYMBOL(target_complete_cmd);
 
+void target_complete_cmd_with_sense(struct se_cmd *cmd,
+				    sense_reason_t sense_reason)
+{
+	__target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION, sense_reason);
+}
+EXPORT_SYMBOL(target_complete_cmd_with_sense);
+
 void target_set_cmd_data_length(struct se_cmd *cmd, int length)
 {
 	if (length < cmd->data_length) {
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1f78b09bba55..3cc50d30231a 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -75,6 +75,7 @@ void	target_backend_unregister(const struct target_backend_ops *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
 void	target_set_cmd_data_length(struct se_cmd *, int);
+void	target_complete_cmd_with_sense(struct se_cmd *, sense_reason_t);
 void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 85c16c266eac..8c85d3b83a70 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -453,6 +453,8 @@ enum target_core_dif_check {
 #define TCM_ACA_TAG	0x24
 
 struct se_cmd {
+	/* Used for fail with specific sense codes */
+	sense_reason_t		sense_reason;
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
 	u8			scsi_asc;
-- 
2.25.1

