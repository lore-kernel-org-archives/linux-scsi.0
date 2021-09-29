Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2A6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEDEC6140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347154AbhI2WJJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:09 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38686 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347135AbhI2WJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:01 -0400
Received: by mail-pg1-f179.google.com with SMTP id s75so4154475pgs.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asTCRK8UCuP9cf3jAjV+qpw0oMPn5K4gL3nWXJ5ZJ6g=;
        b=Wkz+6bg370jhI8/whaqTPMz6nTCPXe63puRdzgOjwX0ugQbymZzj8T5iffW/qIX0CZ
         w/IdyilCQgd2TpVnstfYEtH1j7T3Ff5i0SiKh2XUbqZ7KLq1VMGvpGk1oQ/CuicVjmU2
         EgesgHtvWbHzAFa2OdAoOKCp/2aOsX9K0JV1ELdkrSjwCL06+6sxSN1KYIA/zW80Y10f
         KJD3Hq3mL4tkNSeId/Ldzj1E7rE3OyKODswaphkh7UUOwkgxZRyhHZQ27LYgAgL+VG/6
         oG01COePu3iXikq0E3ynLz4oDiq5QnWAHueh7q1vEhJdrXIc5BukyJu1BZVw+kxYzQhK
         hn2g==
X-Gm-Message-State: AOAM532vN9NMvu30CPjdB0+iSr9d6qq/c5PvR0IefeT8xcAq2CzVVh50
        taS3gdXc+iMSXSENY+r1mZU=
X-Google-Smtp-Source: ABdhPJyn6+soXDdp+nDpzMSjH/3vtVoMr4Xs3GyRL5FTFMEynLwYGkfYIWvJDSfyqjGhafSMhDdc6w==
X-Received: by 2002:a62:cf06:0:b0:438:ac39:5303 with SMTP id b6-20020a62cf06000000b00438ac395303mr998099pfg.26.1632953238821;
        Wed, 29 Sep 2021 15:07:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 39/84] imm: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:15 -0700
Message-Id: <20210929220600.3509089-40-bvanassche@acm.org>
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
 drivers/scsi/imm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 943c9102a7eb..be8edcff0177 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -769,7 +769,7 @@ static void imm_interrupt(struct work_struct *work)
 
 	spin_lock_irqsave(host->host_lock, flags);
 	dev->cur_cmd = NULL;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	spin_unlock_irqrestore(host->host_lock, flags);
 	return;
 }
@@ -922,7 +922,6 @@ static int imm_queuecommand_lck(struct scsi_cmnd *cmd,
 	dev->failed = 0;
 	dev->jstart = jiffies;
 	dev->cur_cmd = cmd;
-	cmd->scsi_done = done;
 	cmd->result = DID_ERROR << 16;	/* default return code */
 	cmd->SCp.phase = 0;	/* bus free */
 
