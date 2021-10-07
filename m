Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C358C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E8A60E54
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241394AbhJGUs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:27 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:38554 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbhJGUsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:25 -0400
Received: by mail-pg1-f175.google.com with SMTP id s75so957667pgs.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PWVeYvXbqPAfLuLOiGEd4XTahvGXwmFbcZsubce6MX4=;
        b=qW7h7poa1c+RiTn0Q5lfbwuwr+0dCniUAQuXVUk3Mztv2bIMZHdmuDIfXYTFjCfBwT
         AHA9NnvKYod69sm6s0m13RCd1AguQz7xlMS5kJXY4SBpc0hEVKWjhGB+yMghp0SpZzud
         3wcDHUNmpQCdK2SPkEoAqQMNxiuUg5nfVTPve+gWQwCWF3GUSPY5hlYmxBp4qrcihVyQ
         vx5CuyWYtBiMR7LHFrtheAa1Gqq+e6T26bApNalyBfy5L03PimO1oEIi2Grh1yNF77Ht
         aB/k7tvXxFrWLXlVoRLBy1o6G3P2Bx6/dqnMArZcMcmDkhLV8KhVbGvJgoUFaSFLS0my
         z64g==
X-Gm-Message-State: AOAM533kEPwX2OIEUaxB9zCLcJN7AO5flwBg9rVarjI/p+tKPhRcS4UZ
        PPRZNRdmQ/aYo+/atrMfLhI=
X-Google-Smtp-Source: ABdhPJzV7Wck/Yqx5U5CSOB+ZMF+bECoXmsSfMM2UuMwiJEOSirMQtrX52mC4bHTNjAn5TQoXfgeTw==
X-Received: by 2002:a65:5385:: with SMTP id x5mr1423106pgq.140.1633639590753;
        Thu, 07 Oct 2021 13:46:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>
Subject: [PATCH v3 77/88] vmw_pvscsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:03 -0700
Message-Id: <20211007204618.2196847-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
