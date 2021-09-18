Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7589CC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DFA8610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345077AbhIRAKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:32 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41978 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345105AbhIRAJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:34 -0400
Received: by mail-pg1-f179.google.com with SMTP id k24so11113904pgh.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3kwkp9RPpQX5SuOt71gSstEbEO312gWBI1qgz1y1kw=;
        b=jET8su6dF+y8hHL0g5zFBYLCsmFGmIitLN0vngYIiQG0YRPh5uaNkzBdAGuc2/WrHL
         2+ZXYiNrpebl+uaP+RfL0kGybXciUUerPNo7NXL29G/sLe4YT0n5zOV2eWSA9zyVJJry
         6Qh4r0mN2WkhSI56E11K9m4dsZK5qm8QJE7T5IeBCsPnaJlTUIp+cWq4LYhIOLNjNgmF
         9L3XgfRBBiw6cy/DVil31dxQD38dzcGxGgThzUUucYgvyNgtirpVH3SYlHRhpg0SU76d
         ETggJTC9mkRapdjs1H7IOR79zP0Ft5thX5PKEMVQzyOXDzaIi14OQ1uWRtukeDpn1G6W
         eeeQ==
X-Gm-Message-State: AOAM531bH1jtvAES8XLEJ43mr0PxEhd+T83XH3BdGhmkPvTi61NzPpKb
        etDcLMjacAwmluCxAfw8eP4=
X-Google-Smtp-Source: ABdhPJxjLRpZu4XI7RErur7zeHU5Mmw8hR8mizk2zFPVx3o3PvnAMpSVqwmZXjkwrGAJtjq1rKoXVQ==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr4551901pgr.188.1631923691912;
        Fri, 17 Sep 2021 17:08:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 71/84] stex: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:54 -0700
Message-Id: <20210918000607.450448-72-bvanassche@acm.org>
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
 drivers/scsi/stex.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f1ba7f5b52a8..2f96a2fdaa40 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -574,7 +574,7 @@ static void return_abnormal_state(struct st_hba *hba, int status)
 		if (ccb->cmd) {
 			scsi_dma_unmap(ccb->cmd);
 			ccb->cmd->result = status << 16;
-			ccb->cmd->scsi_done(ccb->cmd);
+			scsi_done(ccb->cmd);
 			ccb->cmd = NULL;
 		}
 	}
@@ -688,8 +688,6 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		break;
 	}
 
-	cmd->scsi_done = done;
-
 	tag = scsi_cmd_to_rq(cmd)->tag;
 
 	if (unlikely(tag >= host->can_queue))
@@ -764,7 +762,7 @@ static void stex_scsi_done(struct st_ccb *ccb)
 	}
 
 	cmd->result = result;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 static void stex_copy_data(struct st_ccb *ccb,
