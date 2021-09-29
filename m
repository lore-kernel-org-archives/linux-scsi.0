Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768EFC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D75061423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347124AbhI2WI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:58 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43900 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347126AbhI2WIw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:52 -0400
Received: by mail-pl1-f181.google.com with SMTP id y1so2513352plk.10
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GU/YclxeljBjSiFb6ritcs1MGl/cithSS3ZGuHyUxWM=;
        b=ZU06C4YVHDy0OJN7lwc/OGmSbnzajIznkc4Bjm5TpQ/WooRl/IoPsYeIN37DOoyneA
         N3GLW/BnpK1+Tpw+QdZlYfv0KN5XJJst/DARMFP/WgUHrB6jjVogbe6ZjD0jxSH7eKag
         q0/wlC6amGrmFEPsY32F6ifodKoWsUHIW6v1SbcnmVPdOTMGM761Re/CGiCNovGXlT1y
         odIuhQE/KiIswTLH8Q6+op0sqh54IT8WP2ONC0lAzFTtPqgiLWRggEZ+hqTK+v9/q5Ak
         3A9thCjv+pv1znI9c0BsQQeotFSxXZu49tTkZmwBPe5f9eoh3iIPAHZRYE2JyRFQ+4TA
         jDWw==
X-Gm-Message-State: AOAM53199zC8+Q9tncnI9zhLA5SRREZ27bTq23203uGatTe9yPJ9nF8q
        1KyZBSHMbdpC5Y0QVsuW838=
X-Google-Smtp-Source: ABdhPJzZgARDYlM2MNAjiJxRqVlvB5eXXP4+l5GWpFVEDVKHkyocwm7eKjC0fPO+gPKW294v4gdPkw==
X-Received: by 2002:a17:903:1247:b0:139:f1af:c044 with SMTP id u7-20020a170903124700b00139f1afc044mr919889plh.23.1632953230631;
        Wed, 29 Sep 2021 15:07:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 33/84] fas216: Stop using scsi_cmnd.scsi_done
Date:   Wed, 29 Sep 2021 15:05:09 -0700
Message-Id: <20210929220600.3509089-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Store the completion callback pointer in struct fas216_cmd_priv instead of in
struct scsi_cmnd. This patch prepares for removal of the scsi_done member
from struct scsi_cmnd.

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
 
