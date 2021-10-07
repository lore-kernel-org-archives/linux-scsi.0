Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E437C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FCB60FDC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhJGUs4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:56 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:46845 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbhJGUsz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:55 -0400
Received: by mail-pj1-f49.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so6120493pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=78ianirfYGQ4QAVLEalJc/GMV3lcbEv13eh5LlG11m8=;
        b=ZhqrVgqvqxOIov9B1VEWa6E74Q/nReUU9BaIG9KLZ1NGssTh49wFivPHQao8lbkUyR
         0sgxb1euW8eEpF4pG/jQwIk+RsITeOpvaPbFE+Gai8AQQ1o7Zxzu/eSxe9RERrAVo0gA
         r2eER1fQziMWptx0ePVocWt8MErz3Y11IRHKLFS0F7u5w22xIg/opP09dBUgu8yUqw/+
         DRDV7kP/SNauzzaZGGq/IGIgfLBowyeXIKNoZ5xeiKC5DENuXCb8LHouJkQ4OqUsdABI
         sCuLReK6YRpOnG2Vea/SXtr4eun5bQm6LDpwiMX9TSYZ1Z108UYPkdLHZgRXRDRrszbj
         rNog==
X-Gm-Message-State: AOAM531MwLcdQgFMyJOc+e9YEDyfGm0VTX+hwsJxmgg4eIvy+XFObc0E
        SmWWCyaesUj+bcVvP7sH8F5FAROXln7DMg==
X-Google-Smtp-Source: ABdhPJzQE1XkCT2kobW3O0w2lSsCz9iqECYujIDCItnpgF0gNFKqfk6AqVB/ebrlKshdLavlcEMI3w==
X-Received: by 2002:a17:90b:2393:: with SMTP id mr19mr5143427pjb.130.1633639621412;
        Thu, 07 Oct 2021 13:47:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:47:00 -0700 (PDT)
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
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH v3 85/88] scsi: core: Call scsi_done directly
Date:   Thu,  7 Oct 2021 13:46:11 -0700
Message-Id: <20211007204618.2196847-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly. Since this patch removes the last user of the
scsi_done member, also remove that data structure member.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 2 +-
 drivers/scsi/scsi_lib.c  | 3 +--
 include/scsi/scsi_cmnd.h | 4 ----
 include/scsi/scsi_host.h | 2 +-
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f0cafb..de5f5949a7a9 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -666,7 +666,7 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 	scsi_dma_unmap(scmd);
 	scmd->result = 0;
 	set_host_byte(scmd, status);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 	return true;
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f690a2da21ea..d0b7c6dc74f8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1520,7 +1520,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 
 	return rtn;
  done:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 
@@ -1694,7 +1694,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
-	cmd->scsi_done = scsi_done;
 
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 4edaadc293a7..7958a604f979 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -123,10 +123,6 @@ struct scsi_cmnd {
 				 * command (auto-sense). Length must be
 				 * SCSI_SENSE_BUFFERSIZE bytes. */
 
-	/* Low-level done function - can be used by low-level driver to point
-	 *        to completion function.  Not used by mid/upper level code. */
-	void (*scsi_done) (struct scsi_cmnd *);
-
 	/*
 	 * The following fields can be written to by the host specific code. 
 	 * Everything else should be left alone. 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index bc9c45ced145..04e9b821c0c7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -516,7 +516,7 @@ struct scsi_host_template {
 		unsigned long irq_flags;				\
 		int rc;							\
 		spin_lock_irqsave(shost->host_lock, irq_flags);		\
-		rc = func_name##_lck (cmd, cmd->scsi_done);			\
+		rc = func_name##_lck(cmd, scsi_done);			\
 		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
 		return rc;						\
 	}
