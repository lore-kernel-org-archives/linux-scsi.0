Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDC2C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92F66140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347144AbhI2WJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:13 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:46635 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347152AbhI2WJI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:08 -0400
Received: by mail-pj1-f42.google.com with SMTP id me3-20020a17090b17c300b0019f44d2e401so1053021pjb.5
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLaNG9rt/zFe/pIkr9pS0qXJyuLLR5D+UhSMUNrkTkg=;
        b=4hO6ZCZkZCMixpfVUFgX15fWq81ZAXjxmxSMfLhue10Tyho9R+JLd9l1eYRaILbChU
         QD1/9VRlb8DkumLuldWeFgLcVrvmpo+xy7X7bLAT2VI+dnfF+rB1hofF6d7arvXqrVg9
         JejvAFCEfzOlbIAk39FnS1Op0HzagGSN1HdUcqNFZxr9sCY+n81EyY3piSC2LGyWP5rt
         JrSa0fP+IHw2bJwRfAeXNJd/fRWQXXZgacdc8tQR8dotKCRhWnIl2+n08SSfJ9gG0vYd
         HmTy/K6aHrfVNn6j4vVUKeyoI5b+kEhmNbQRY1x7NS5d/SC85heTYO/TYBycGzw8dExu
         Ca1Q==
X-Gm-Message-State: AOAM531MS0VtowXiVs5MKFbXg5LDj9U0U4brGeNINnc8suXMF0V7BQJB
        UUgAzrxkzeSIXfDonw0a654=
X-Google-Smtp-Source: ABdhPJyEFiLJfFDT2kztLdom4OV2p6IS76CQqnS+0dXaaTPz1yp+tTMAIBI/biXRG3oPa6J8HuKnCw==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr2352019pjo.29.1632953245544;
        Wed, 29 Sep 2021 15:07:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 44/84] libiscsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:20 -0700
Message-Id: <20210929220600.3509089-45-bvanassche@acm.org>
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

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 712a45368385..7beedc59d0c6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -468,7 +468,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 		 * it will decide how to return sc to scsi-ml.
 		 */
 		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
-			sc->scsi_done(sc);
+			scsi_done(sc);
 	}
 }
 
@@ -1807,7 +1807,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
-	sc->scsi_done(sc);
+	scsi_done(sc);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
