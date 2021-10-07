Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46525C43219
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECC661108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242363AbhJGUci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:38 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:35391 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242204AbhJGUca (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:30 -0400
Received: by mail-pj1-f50.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so7842933pjw.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pgmaWbpH/nc41CqD55iaw+VDjWvWUX/PaAX77qHWYm0=;
        b=uSHPT4oMTMRdG1UUQ5O5UnBY8KaRG/s9I+ajKzjCg/zKyiV5YiVEs/xq08TkVhx0XF
         IM7qwjpSg/vIH38xxwiyW7gSNm01dBdz3ZZpLMibwm/iprPTGvJ72rn567d7NIhphMrJ
         HT981IqKC9/iMqdohZzuEuO2loGXNEKlRD8iB4eyPW8k1GZ0LV0JQI7QdkRQ+x57Vk/G
         AUK0+TGu8P9YDG9wbLscoikmkEYBPvYrwB/DcbzKPtwsOa2nUHjHITY+bK3udyC2yfDW
         /PnyJmqZUDolWCippN/Rg3I4dva8NfsxRUUv7q13n43mBck4EAmKb5MU9KfFmdYDrqEf
         OQ9w==
X-Gm-Message-State: AOAM531uEJadYf07UNcYDXzl1v4AX5b1YG0X/K9hCflMel7AmOeg6vSZ
        b7bP6JHIR8GAJh3+94qasOQ=
X-Google-Smtp-Source: ABdhPJwwFIDXzNrphwju72uWV8SovOJ7cl0QqeKtdU/n42KHCQqE2rFKqjK65Pt9AOr26qdxpDA42g==
X-Received: by 2002:a17:903:32cc:b0:13f:c3:4ff3 with SMTP id i12-20020a17090332cc00b0013f00c34ff3mr5821341plr.33.1633638636225;
        Thu, 07 Oct 2021 13:30:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 36/88] hpsa: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:31 -0700
Message-Id: <20211007202923.2174984-37-bvanassche@acm.org>
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
 drivers/scsi/hpsa.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3faa87fa296a..a1153449344a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2482,8 +2482,8 @@ static void hpsa_cmd_free_and_done(struct ctlr_info *h,
 		struct CommandList *c, struct scsi_cmnd *cmd)
 {
 	hpsa_cmd_resolve_and_free(h, c);
-	if (cmd && cmd->scsi_done)
-		cmd->scsi_done(cmd);
+	if (cmd)
+		scsi_done(cmd);
 }
 
 static void hpsa_retry_cmd(struct ctlr_info *h, struct CommandList *c)
@@ -5671,7 +5671,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		 * if it encountered a dma mapping failure.
 		 */
 		cmd->result = DID_IMM_RETRY << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 	}
 }
 
@@ -5691,19 +5691,19 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
 	if (dev->removed) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
 	if (unlikely(lockup_detected(h))) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
