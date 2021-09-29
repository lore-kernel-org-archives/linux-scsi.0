Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1DDAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC0E06140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347111AbhI2WIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:50 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:51743 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347121AbhI2WIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:48 -0400
Received: by mail-pj1-f52.google.com with SMTP id h12so2708285pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrjaDQynpsanZ6aSkHdGiM11iP+I2iU8QPoNUiJ3poU=;
        b=Ya9kbO+sJTui4Hfxa6zw4WR5KxpltEXeD+Z8PW8yBbj5PPtyefNRVu0jYp36hQyyVc
         oobHLU2D98/YvHddw0GQ0+bb1iFEjet4zrIbLuIiKaBeu0obHddFqOBfF1xuenSNvjh8
         wWvINmi11pUuhqvVzR7u9mILsFh6Yatg0RCLyiorK6PzUn4yiWZJfMljKvx1VOyCx6MB
         gBb0XcqREJbNA/ocwAx5VayP9uCrVy2k9Wf+ElVYvn5hKD+6n05mWt6SSj8dgs60+oCP
         cJqEVGAnHnDsnqieBZ4zyt5KogyVWIDHRCIBG16O4vpZYCxB6RIgGXcigma5+G1X4ott
         xLiQ==
X-Gm-Message-State: AOAM531Q4I0qlfZZqONMiL4wc73SXcMRzNBz5rrXfJX3Q4Sspzg5D0u8
        JLGn8szhjnp7cMRCkSR1Sa4=
X-Google-Smtp-Source: ABdhPJzfZUd5nyGmJpHLVV8Wu/I5H80DnORpdfOjWNYxBYYOob/0IwkUNHE9vfpXeEZC1g1s+RTSrw==
X-Received: by 2002:a17:902:c086:b0:13e:2b52:29e1 with SMTP id j6-20020a170902c08600b0013e2b5229e1mr798381pld.8.1632953226477;
        Wed, 29 Sep 2021 15:07:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 30/84] esas2r: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:06 -0700
Message-Id: <20210929220600.3509089-31-bvanassche@acm.org>
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
 drivers/scsi/esas2r/esas2r_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 647f82898b6e..7a4eadad23d7 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -828,7 +828,7 @@ int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	if (unlikely(test_bit(AF_DEGRADED_MODE, &a->flags))) {
 		cmd->result = DID_NO_CONNECT << 16;
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		return 0;
 	}
 
@@ -988,7 +988,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		scsi_set_resid(cmd, 0);
 
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 
 		return SUCCESS;
 	}
@@ -1054,7 +1054,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 	scsi_set_resid(cmd, 0);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	return SUCCESS;
 }
@@ -1535,7 +1535,7 @@ void esas2r_complete_request_cb(struct esas2r_adapter *a,
 			scsi_set_resid(rq->cmd, 0);
 	}
 
-	rq->cmd->scsi_done(rq->cmd);
+	scsi_done(rq->cmd);
 
 	esas2r_free_request(a, rq);
 }
