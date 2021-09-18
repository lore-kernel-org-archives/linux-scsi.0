Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26A4C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE6C361164
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345090AbhIRAKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:37 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:33443 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243788AbhIRAJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:43 -0400
Received: by mail-pl1-f180.google.com with SMTP id t4so7276198plo.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cZnpKKijdv4/tlpu2sHFtdvAEpWRYdAavZQx67lTeQ8=;
        b=bDZN72hABAXl2SndSv4iZXH+6hc65bRobs9f4lmqqqYQe9w7tSIwk51cWFlHufxw89
         0dL9EpT0v65vB31HOGPGA47ClzNosMpdLjpJjei70ywBgey3aUbqJx585krVz7jlyCRu
         K1LZWX0rWKCynIdwaFSZsXf318DGxoTOCfGTOLrgyHKn5ML3Ek3xl7LRgkP9s6NUlevz
         TlrkDzK7vQ0X3xE1CJFfSQVH2XTJtSFrrHFQhFdjg5NobqTRErsZMM2xjSdXxY6lKmDF
         ZgWEQ0RuMaQAoOAgTl+A8oNxs2XpRb/YFjRoFB+tb4LVbUKKMN+XbucMhNuaNCy6YkZq
         pgTw==
X-Gm-Message-State: AOAM533UC9L8Xf5VdDxkygY20J5mN8fUrkeSek89aE0PXpJ0w3KxkNFw
        m3eq9kxJrS9jqWBNaQdkLQ0=
X-Google-Smtp-Source: ABdhPJwrqINRgBjhddTcK7vmZvJi0/SiDF+V4GpwUDg+vteLC3qB6AJV5cBwXyPNLUsNPpVrfPQ1AQ==
X-Received: by 2002:a17:903:234a:b0:13c:9439:5cf1 with SMTP id c10-20020a170903234a00b0013c94395cf1mr11837878plh.2.1631923700631;
        Fri, 17 Sep 2021 17:08:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 74/84] ufs: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:57 -0700
Message-Id: <20210918000607.450448-75-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..ec9461d9977e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2703,7 +2703,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		if (hba->pm_op_in_progress) {
 			hba->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			goto out;
 		}
 		fallthrough;
@@ -2712,7 +2712,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	case UFSHCD_STATE_ERROR:
 		set_host_byte(cmd, DID_ERROR);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		goto out;
 	}
 
@@ -5294,7 +5294,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			/* Do not touch lrbp after scsi done */
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			ufshcd_release(hba);
 			update_scaling = true;
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
