Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788E1C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2AA61423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbhI2WKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:08 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:34755 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347224AbhI2WKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:10:01 -0400
Received: by mail-pl1-f181.google.com with SMTP id b22so2542276pls.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWVeYvXbqPAfLuLOiGEd4XTahvGXwmFbcZsubce6MX4=;
        b=FsPBtO8SrUsMb/XdFiNs0fzg8k4dgzFhi/CNxOWXK4E5wcwVkwFJd/rcELbsk/zHj7
         o2p+MZbHnuWX3X6B2A1WTeF0fGmk6V6vNt74OLLT2m+N5iAgHxMMQLp4Fzu+EXhCeKrE
         wqy3jNiT69uaUjGQ1T7QXX8pWLsjmJVx2N3WbsEboqaWvBm0Jp2x0OnQuLpt1gH5uNLa
         djgDX1b9bQ++T0vvKr9+hFcaoB3hRGfBzVQluVwb3rpoxkfLDi4VKzZrWxQNKYfzvH9R
         ZReLDLdyaxryfOm/QD7wb6B8HyIW+kg4YxsP0rVmvZuRfWuQ4NrkKghYJucvErCvqYWa
         qijg==
X-Gm-Message-State: AOAM531fNUCz/uxmBdn2g+g3aUB89B/YNVzWrzNrYJLBr7lr2+Siqt6p
        DkNocxVEsSHmpPEWU6b2TdM=
X-Google-Smtp-Source: ABdhPJwp7QCDVcnZmgZJmViRBAeV1GYEXF/uXJWQUr/YA05on0rDAR205AS9NbDaB9ABo7n72plbiQ==
X-Received: by 2002:a17:90a:f0cc:: with SMTP id fa12mr2386146pjb.166.1632953299624;
        Wed, 29 Sep 2021 15:08:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 76/84] vmw_pvscsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:52 -0700
Message-Id: <20210929220600.3509089-77-bvanassche@acm.org>
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
