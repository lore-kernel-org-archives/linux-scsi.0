Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049E1C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEC1C61108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242324AbhJGUci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:38 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:52959 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242220AbhJGUce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:34 -0400
Received: by mail-pj1-f53.google.com with SMTP id oa4so5095186pjb.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asTCRK8UCuP9cf3jAjV+qpw0oMPn5K4gL3nWXJ5ZJ6g=;
        b=UE9oOL/pVnqZDEstYSe1n+GUzfK7fbzxxZsoiWvGeDUPUIB0kI/MiywTdCAkuaKIwS
         teFZfNRbwBtmUFwR9pMjPSBpJXgWzfyofAfuxN3GfeJEaqvrLgFP8SQsSAC831d5+SNz
         1wu0trLy7I0f5VE2SCXmVxMhMcy4k+PM0BO91R+dyTTOJzsWd4ovA3q3D5A4JC9zy9U0
         HjAyNfgCBxTjo6FDHKk5Q0dqFfjldIgPR0LCQfXuzbluBiAsR5rJUw16Knf5Q45T+VjB
         vc7zB63Pjp0MjYbu7NmRGdSih2DpXNAy11gD/GtcoSoyPwGwBBfaF+YaYQrhZYOJPm5B
         IYUw==
X-Gm-Message-State: AOAM530b4WrgzkT5AfK3KDBvbTuge4NLRi269KOL0FmI2G7o/2lyQKD2
        2tjGq8eNZ8waAPXZXVPRhxo=
X-Google-Smtp-Source: ABdhPJwhV+w2xh0AYQuQ27zsMLkLrXLJ7ZrIp7Rbf7KYqELoPG6iAWA6JKRSplojiFZtKrUGpwlQuQ==
X-Received: by 2002:a17:903:1c6:b0:13f:2b8:afe8 with SMTP id e6-20020a17090301c600b0013f02b8afe8mr5740755plh.81.1633638640364;
        Thu, 07 Oct 2021 13:30:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 39/88] imm: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:34 -0700
Message-Id: <20211007202923.2174984-40-bvanassche@acm.org>
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
 
