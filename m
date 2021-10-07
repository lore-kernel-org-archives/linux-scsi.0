Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B038C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 868AB61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbhJGUcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:17 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:33458 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242324AbhJGUcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:10 -0400
Received: by mail-pf1-f174.google.com with SMTP id s16so6358499pfk.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2vgCtIwUH3Q7lKuS5Kt433H8Cece+k89C286riuvhI=;
        b=EyUNLp7hzA+jrVreDqBSmP5IcE4d76HfNPqdPvuQukyCIHrOj9LdHtVN8ymb7X/RBG
         PfnSFtN3ucnl8Vhf8Qgr8VSIjqjwyBMaQyvrIqOeFyo2zyeit5aLqsraywsTsRLl1skq
         c7Ew4KIMvkbcDKWvuV1s41yNa27ijujqEMTJJw0qcWrDkAJpqSPiuCJUWxUgNbLP4Fp2
         BGd3BB9WZb1kif9+tDc+Gxafrmlx3t0CHx6/SyXszUChm9mnBSlhvCfz1isWnfvc1y/U
         wFG7QmMVLmf0CE9QOlDrg06MI1nd51kbXDbpR3U1qk2NWtuvLMobC6L67WEh7UABci4G
         QOEg==
X-Gm-Message-State: AOAM531a0mA2YEAsFEuFAN0p+KzCu1/d+q9QUq1glBY0GQfHmvhrWGUX
        vYgiKXII0h5GCmvtJeRovSg=
X-Google-Smtp-Source: ABdhPJyIff/df62NJP8vpKYa9eWJ1bfkJBXCwwSvqBbnZokrJ4BewCCwgpLtJs/fCwyx8UGPyDwKmA==
X-Received: by 2002:a62:6d07:0:b0:446:c141:7d2d with SMTP id i7-20020a626d07000000b00446c1417d2dmr6038690pfc.28.1633638616113;
        Thu, 07 Oct 2021 13:30:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 24/88] bfa: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:19 -0700
Message-Id: <20211007202923.2174984-25-bvanassche@acm.org>
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
 drivers/scsi/bfa/bfad_im.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6b5841b1c06e..e12ae60efd33 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -96,7 +96,7 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 		}
 	}
 
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 }
 
 void
@@ -124,7 +124,7 @@ bfa_cb_ioim_good_comp(void *drv, struct bfad_ioim_s *dio)
 		}
 	}
 
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 }
 
 void
@@ -226,7 +226,7 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 			timeout *= 2;
 	}
 
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	bfa_trc(bfad, hal_io->iotag);
 	BFA_LOG(KERN_INFO, bfad, bfa_log_level,
 		"scsi%d: complete abort 0x%p iotag 0x%x\n",
@@ -1233,8 +1233,6 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 	if (sg_cnt < 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	cmnd->scsi_done = done;
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	if (!(bfad->bfad_flags & BFAD_HAL_START_DONE)) {
 		printk(KERN_WARNING
