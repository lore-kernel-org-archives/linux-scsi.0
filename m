Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0425C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D3961108
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbhJGUcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:32 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:45040 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbhJGUc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:26 -0400
Received: by mail-pf1-f171.google.com with SMTP id 145so6281770pfz.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TKwJfb6yDVg1wOa7bCXAvK3mzLQqGfvjagVj/b3Xrsw=;
        b=TzqxBN2awIFnFyZFxHKnlvEToH9wVrHCiKsI71uXtJU4Mk4P64QYc8yz6DsX8TKICk
         SehF4naEXaQojTsNPCi3+Q6O26aksLBtIy+KpuEwmqH8ftPQWJvbv0vYG9Ft++fW1iZ/
         XubdkQPnauCVGFEMuuBnnYVfPWUzV67XUo9cCEu+YN3Fs1wOgJ4qadGunOAXKCNvUii6
         DuwQf6kDd8zBR/Cgxnn9i5WV23tGo7VPsiUdBbGkDyQlb+uhmUOuHnK3E6EuZJd9tLN8
         /P6M6PoT+w4zqx6gdriXQawhOGSafZUqdWHUBXr6OZbeRY7lxfHh9cJ1ApS198xrtRMY
         dkEw==
X-Gm-Message-State: AOAM531wW7JuXW0zDYewOOIjWthNiqeixS9/bsLN1aRFSluSOs6bRUWk
        FHlZGAOJJxyOPXkTI4ZXwlM=
X-Google-Smtp-Source: ABdhPJxNeBDiL2Y3kGStw5x72ovwtO+b82+/HUUgsyqBB0sbfGHWykO9ipI6zds0SlfjpqzG2vmlTA==
X-Received: by 2002:a62:dd0a:0:b0:44b:bd85:9387 with SMTP id w10-20020a62dd0a000000b0044bbd859387mr6414471pff.49.1633638632155;
        Thu, 07 Oct 2021 13:30:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 33/88] fas216: Stop using scsi_cmnd.scsi_done
Date:   Thu,  7 Oct 2021 13:28:28 -0700
Message-Id: <20211007202923.2174984-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Store the completion callback pointer in struct fas216_cmd_priv instead of
in struct scsi_cmnd. This patch prepares for removal of the scsi_done
member from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/fas216.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index bbb8635782b1..9926383f79ea 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2017,7 +2017,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 	 * correctly by fas216_std_done.
 	 */
 	scsi_eh_restore_cmnd(SCpnt, &info->ses);
-	SCpnt->scsi_done(SCpnt);
+	fas216_cmd_priv(SCpnt)->scsi_done(SCpnt);
 }
 
 /**
@@ -2088,8 +2088,8 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	}
 
 done:
-	if (SCpnt->scsi_done) {
-		SCpnt->scsi_done(SCpnt);
+	if (fas216_cmd_priv(SCpnt)->scsi_done) {
+		fas216_cmd_priv(SCpnt)->scsi_done(SCpnt);
 		return;
 	}
 
@@ -2205,7 +2205,7 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 	fas216_log_command(info, LOG_CONNECT, SCpnt,
 			   "received command (%p)", SCpnt);
 
-	SCpnt->scsi_done = done;
+	fas216_cmd_priv(SCpnt)->scsi_done = done;
 	SCpnt->host_scribble = (void *)fas216_std_done;
 	SCpnt->result = 0;
 
