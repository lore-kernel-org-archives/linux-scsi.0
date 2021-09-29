Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A39C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFC161423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347175AbhI2WJi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:38 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:35768 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347159AbhI2WJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:33 -0400
Received: by mail-pg1-f181.google.com with SMTP id e7so4167030pgk.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sSrM2Z9Mg4h89R9uYoLr4hjxm8pWMZLJ41n8sRkf/Tc=;
        b=KN9DuIseZyfrHx9P2jcyt5jhCvVOhD7WUI0nX7PgW9d0Uv0udWUq1m0lvwtUMfj3cp
         noqVnDhi6TL3BeB14ZgpPnamvpl+WeS79J6CwegB5bUqucpxbMqK2CuVWxQL4ufuVyKp
         NppTjBoZlwQBJo8uSF2AU9GhHKw43ui1ofyisPg3Kt1xp1W2Pzx5GZY7FBUE2WncLdxW
         uMJmVCB7m9JzHl6KLohhS1Wk1jYb6EUXWLsnwgmiuZypPUBgI6t3EH8dLPOiAXSLc+EZ
         dqtiauK6SGBZNoh+Mi6JynHfysQH20bTRg6ImJzrAXybySzvM43r0hsI1LhTNOfkcX3f
         sd6g==
X-Gm-Message-State: AOAM532VtVvMdqnK6+bWdeighrKyg/H1kC0dVJ93uO82Vay72EX5eWqi
        NqXIL+dfff4WUhaIPy6ssrg=
X-Google-Smtp-Source: ABdhPJywypQonGZsiJnHE6HMBQE0ccwnyTl7Bdp4Ko3VcC1NluyVXx9urcV1g1U9FCDPL0lf55AUgQ==
X-Received: by 2002:a05:6a00:1819:b0:44b:bd19:b029 with SMTP id y25-20020a056a00181900b0044bbd19b029mr787619pfa.80.1632953272181;
        Wed, 29 Sep 2021 15:07:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 59/84] pmcraid: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:35 -0700
Message-Id: <20210929220600.3509089-60-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pmcraid.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index bffd9a9349e7..11f36fd4e62f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -837,7 +837,7 @@ static void pmcraid_erp_done(struct pmcraid_cmd *cmd)
 
 	scsi_dma_unmap(scsi_cmd);
 	pmcraid_return_cmd(cmd);
-	scsi_cmd->scsi_done(scsi_cmd);
+	scsi_done(scsi_cmd);
 }
 
 /**
@@ -2017,7 +2017,7 @@ static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *pinstance)
 				     le32_to_cpu(resp) >> 2,
 				     cmd->ioa_cb->ioarcb.cdb[0],
 				     scsi_cmd->result);
-			scsi_cmd->scsi_done(scsi_cmd);
+			scsi_done(scsi_cmd);
 		} else if (cmd->cmd_done == pmcraid_internal_done ||
 			   cmd->cmd_done == pmcraid_erp_done) {
 			cmd->cmd_done(cmd);
@@ -2814,7 +2814,7 @@ static int _pmcraid_io_done(struct pmcraid_cmd *cmd, int reslen, int ioasc)
 
 	if (rc == 0) {
 		scsi_dma_unmap(scsi_cmd);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 	}
 
 	return rc;
@@ -3328,7 +3328,6 @@ static int pmcraid_queuecommand_lck(
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
-	scsi_cmd->scsi_done = done;
 	res = scsi_cmd->device->hostdata;
 	scsi_cmd->result = (DID_OK << 16);
 
@@ -3338,7 +3337,7 @@ static int pmcraid_queuecommand_lck(
 	if (pinstance->ioa_state == IOA_STATE_DEAD) {
 		pmcraid_info("IOA is dead, but queuecommand is scheduled\n");
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		return 0;
 	}
 
@@ -3351,7 +3350,7 @@ static int pmcraid_queuecommand_lck(
 	 */
 	if (scsi_cmd->cmnd[0] == SYNCHRONIZE_CACHE) {
 		pmcraid_info("SYNC_CACHE(0x35), completing in driver itself\n");
-		scsi_cmd->scsi_done(scsi_cmd);
+		scsi_done(scsi_cmd);
 		return 0;
 	}
 
