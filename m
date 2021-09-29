Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22035C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06381613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347088AbhI2WIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:40 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:36359 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347077AbhI2WIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:36 -0400
Received: by mail-pj1-f52.google.com with SMTP id u1-20020a17090ae00100b0019ec31d3ba2so5219184pjy.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2vgCtIwUH3Q7lKuS5Kt433H8Cece+k89C286riuvhI=;
        b=qeoHrt+MqLlJUXDlKLT4zreRIHYmoTeRcUmRnBh3h8vpA53FhGB82SZPNKDCQPTuQB
         RoqRSzQQ2CPGveb8Ve7tCSEW+WR9TIyXmr8yw42vYwNZIJzCEP6XZiuqfrJJYV/6BwW6
         xpvGCH107JW3893s5UAxYh36PxMwVi3xUWDNmhpPIOUfKURT0WVti99WuWaY8BD6b66F
         dszyrLeltZO0mOrqUG1rkH1KB46n/jq/yttPMZZuoANgHr9M/uznmcxY5gmyLCj1Db6M
         PY5WeJszyRzVvPDoX97jykDLe5LQYnDZQESgujlqIsFJV/tcDqStC4CYqpf8tdZ6Ha+b
         TXGA==
X-Gm-Message-State: AOAM5316pL2T1LTSdGBr2BzeGhTHHoVo6JpKzHuwWnoaUuIL1PrytsqK
        GYUM84rjwcbryewUhYtdt3yF8jVWR6s=
X-Google-Smtp-Source: ABdhPJz5F+B4z4AAICWq7Skcid9rS5GZ4nwMTrvs3kP7ZgSYJBe9zECVbSRnfKZVigpVrTDievgVPg==
X-Received: by 2002:a17:902:8206:b0:13e:19b2:af4b with SMTP id x6-20020a170902820600b0013e19b2af4bmr904075pln.82.1632953215148;
        Wed, 29 Sep 2021 15:06:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 24/84] bfa: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:00 -0700
Message-Id: <20210929220600.3509089-25-bvanassche@acm.org>
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
