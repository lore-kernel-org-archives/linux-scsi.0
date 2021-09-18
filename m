Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEACC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DD260F51
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhIRAKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:39 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36509 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344052AbhIRAJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:46 -0400
Received: by mail-pf1-f180.google.com with SMTP id m26so10677959pff.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWVeYvXbqPAfLuLOiGEd4XTahvGXwmFbcZsubce6MX4=;
        b=5Z5G2k4tYXrpcahfoZEMXnp5jNji3yrvmHpK3X9QqC6BGqmX9qr8UKzREIh7RQkkO6
         wTJL51k8Rgjy4PpOvnBvtphdPv+rcwoKqCaEw6iwGlaDH4vSZX5ZE14G5AwwRUiDDdjn
         M+nb9MFOMLTc8TqFiXQ3ryo1KOlFHZQKltMGYN6OhL3ePm9OZnoSzMFgA5UBAp1q4BeZ
         tB4PwTo3GHiDu3y/I3BBXv5CCebDo1IYdQQNOue5DJUxXfLDhiZ66QbUm7cGg3+GDwxg
         saRZC37BRvFfVsi+Bk9FDOneGuTMbvx1Yu9VjoyFF4+WjzB+AliiUddhXfp0aepfwJKX
         HmEA==
X-Gm-Message-State: AOAM531S8DNSa+MK38TdetcN3oqD00RhN8STXzJs6ea4nhCkcqCwZdYG
        OH4Yv5zf5AVZN9WoTMCEABE=
X-Google-Smtp-Source: ABdhPJwVTfyp1w/piuJVn7eXO+NX20Hb2oEtfgCwWku9sSO02PM94tDFHpBuZWT4plor3lkLi4mItg==
X-Received: by 2002:a63:da54:: with SMTP id l20mr12175798pgj.341.1631923703470;
        Fri, 17 Sep 2021 17:08:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 76/84] vmw_pvscsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:59 -0700
Message-Id: <20210918000607.450448-77-bvanassche@acm.org>
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
 drivers/scsi/vmw_pvscsi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ce1ba1b93629..7bfa023d0feb 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -643,7 +643,7 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 		"cmd=%p %x ctx=%p result=0x%x status=0x%x,%x\n",
 		cmd, cmd->cmnd[0], ctx, cmd->result, btstat, sdstat);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /*
@@ -786,7 +786,6 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd->scsi_done = done;
 	op = cmd->cmnd[0];
 
 	dev_dbg(&cmd->device->sdev_gendev,
@@ -860,7 +859,7 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
 	 * Successfully aborted the command.
 	 */
 	cmd->result = (DID_ABORT << 16);
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 out:
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
@@ -887,7 +886,7 @@ static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
 			pvscsi_patch_sense(cmd);
 			pvscsi_release_context(adapter, ctx);
 			cmd->result = (DID_RESET << 16);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 		}
 	}
 }
