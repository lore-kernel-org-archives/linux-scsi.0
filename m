Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF9EC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EF960F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbhIRAIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:21 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:43760 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245368AbhIRAIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:19 -0400
Received: by mail-pg1-f182.google.com with SMTP id r2so11112113pgl.10
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L2vgCtIwUH3Q7lKuS5Kt433H8Cece+k89C286riuvhI=;
        b=3xPRuY+4n8ej0QrbC+7XtJV309yGGJ1xSUHG39sZCr1mvXjvtb4R+nFQf9KZxz5L0X
         HNE+IL7ORX8CHQMPK04l8AeVhXYI7PucMh4dSR3vRSOwE4m8lLxqHk8q80UUkzMSxqH8
         Dg4mF1OzEHRjcxjHNVX0IkScPnJ+tfjfTIE7aSXEhaU6Z5CKyAnlR+WKdPsZXqEmsynb
         VqcqrRWCfD0pqvGpt8lCKsYlAVMwuwxTNyI9nxA5X+zCvY/Dn6bXZlMZUWExAX+wpz2w
         NT7ezCfmM8uoypS59aZWScDQVe7h+x0LN8QEWaKbWuj+gT/jd85Khcl0Y71zuQWhYJii
         qUwg==
X-Gm-Message-State: AOAM53192vsCQZaGLQlp712yFmigQIICmGjq+ncHc42p3+YPxq4XNzGt
        tTwoqnFag9nEK12+ErRY3JoJieNkVbo=
X-Google-Smtp-Source: ABdhPJyBmkTM6HacLSPNoTgXV99+VS6FQ4QeCMZ35NcF163yMyuhgPPhoG7scha5xN6HXG1c0nQ67A==
X-Received: by 2002:a63:ed03:: with SMTP id d3mr12214983pgi.24.1631923616116;
        Fri, 17 Sep 2021 17:06:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 25/84] bfa: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:08 -0700
Message-Id: <20210918000607.450448-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
