Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32AFCC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiGFXfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiGFXf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:28 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5DD2CC85;
        Wed,  6 Jul 2022 16:35:28 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CAB2EC06E8;
        Wed,  6 Jul 2022 23:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150527; bh=CFa3kMjkUHA5vD1AUam1eiYQgAj3Bq4ibvH20BkWmqQ=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=ZgGGfPGsH6/3iYgkZT20Rqm84RAFL3h1JR3uvQAYiMa6u+G8X8rgELJfkcw+vpwwc
         LUQ29770dsEz8FHHYMtRYpNMI7BkPXoZYTzwFAM5HAtXO7vZV2iWpkozgq40qq8gCC
         XeVMfj7eCkFla161PQlJGsYd6nYMKIKhTAF6kjtwpQWCgD/QcGMPWLQCUNaKVKWE3b
         1SorV+4hrhJW0dvezTSKMNOpJPRYS1ZxwfER1V1Zd0W8xqgMYP7eKtUeu6L0b4SuuD
         XMnAx2U17OCZ2CFzIYHyLqOAQHgxfyxgsNP+PfMhWR9AGI32ceQIVBDvFLlNkHBPjI
         rw+eHmoBEjM+A==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 91F95A0096;
        Wed,  6 Jul 2022 23:35:26 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:26 -0700
Date:   Wed, 06 Jul 2022 16:35:26 -0700
Message-Id: <0004ae8cc8650a32f2aaab0ef9ee3b6e6eb6b69c.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 10/36] target: Implement TMR_ABORT_TASK_SET
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Task ABORT TASK SET function is required by SCSI transport protocol
standards (SAM-4 r14 section 7.3). It is similar to ABORT TASK
function, but it applies to all commands received on a specified I_T
nexus rather than a specific referenced command. Modify
core_tmr_abort_task() to support TMR_ABORT_TASK_SET.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_tmr.c       | 16 +++++++++++-----
 drivers/target/target_core_transport.c |  2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 3e73f60319d5..e77721db1ea9 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -132,11 +132,13 @@ void core_tmr_abort_task(
 				continue;
 
 			ref_tag = se_cmd->tag;
-			if (tmr->ref_task_tag != ref_tag)
-				continue;
+			if (tmr->function == TMR_ABORT_TASK) {
+				if (tmr->ref_task_tag != ref_tag)
+					continue;
 
-			pr_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
-			       se_cmd->se_tfo->fabric_name, ref_tag);
+				pr_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
+				       se_cmd->se_tfo->fabric_name, ref_tag);
+			}
 
 			spin_lock(&se_sess->sess_cmd_lock);
 			rc = __target_check_io_state(se_cmd, se_sess, 0);
@@ -159,7 +161,11 @@ void core_tmr_abort_task(
 			target_put_cmd_and_wait(se_cmd);
 
 			atomic_long_inc(&dev->aborts_complete);
-			goto exit;
+
+			if (tmr->function == TMR_ABORT_TASK)
+				goto exit;
+
+			spin_lock_irqsave(&dev->queues[i].lock, flags);
 		}
 		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cbd876e44cf0..bc1e4a7c4538 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3519,9 +3519,9 @@ static void target_tmr_work(struct work_struct *work)
 
 	switch (tmr->function) {
 	case TMR_ABORT_TASK:
+	case TMR_ABORT_TASK_SET:
 		core_tmr_abort_task(dev, tmr, cmd->se_sess);
 		break;
-	case TMR_ABORT_TASK_SET:
 	case TMR_CLEAR_ACA:
 	case TMR_CLEAR_TASK_SET:
 		tmr->response = TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
-- 
2.28.0

