Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A8AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DB48611C3
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347100AbhI2WNk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:13:40 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:45866 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346932AbhI2WNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:13:39 -0400
Received: by mail-pg1-f182.google.com with SMTP id n18so4123549pgm.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d8yo3E0Ky4NiLJqvqmbht3RUKRalGSPl0jLvLPGTxB0=;
        b=0r5u79PXxtX4ECssk/P6HGIFjdgUqk4s1g+GeJU6/RmM3gqaoSA1amKkLa5ugdBqrO
         0pQBoEi9yvaLosI5gM4hHqmwR1raQWVYZfz4ZkCljZW9IDfbegdnq4sKqFoaj00k/Qkp
         oR3UX3gN3qPpcEN00qU/owLOx7b8eODrwG/oepAowQi5iIBk9PzBrgLdMlnu+1A1yv9v
         oS2VsFC2LwpUtjB1Wq2qv0IrYIKayOl+yuM1zj4sjKWwhY0cVeNc714ZrH/TFLWtuqgC
         H8stEKCwb3N9Sfww7uksdQP2N5zIJf3PMXr7bMNgAvo/I9FnxfUYjq9Od+D1RqrrWov4
         L3XQ==
X-Gm-Message-State: AOAM530RkLXgq0V8fKHXZoyM6B45RFXLQGCFFZoMr87QUslyJUh4tWBK
        Wpc8ZkcQb5ReoK0GSwPKkLQ=
X-Google-Smtp-Source: ABdhPJx3cF23Tgu0IUrhuvvNebk7ugeR9kkMHdLAGTIwA3g8ChylzPwkvy0WtDyqUgXbea3rXdCc3w==
X-Received: by 2002:a63:555d:: with SMTP id f29mr1948867pgm.33.1632953518048;
        Wed, 29 Sep 2021 15:11:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id 139sm706461pfz.35.2021.09.29.15.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:11:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 84/84] scsi: core: Call scsi_done directly
Date:   Wed, 29 Sep 2021 15:11:35 -0700
Message-Id: <20210929221138.3511208-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly. Since this patch removes the last user of the
scsi_done member, also remove that data structure member.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
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
index 47bfd12abdda..57c3c33311cf 100644
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
