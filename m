Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E53C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F32613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347056AbhI2WIT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:19 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:41967 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347083AbhI2WIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:13 -0400
Received: by mail-pj1-f43.google.com with SMTP id oa12-20020a17090b1bcc00b0019f2d30c08fso3174904pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpY/lBLTe7tQQ0l8dXTUh8Aq73Wg1MJRRB+jRfiBtws=;
        b=QEKKtK6UeZfl83+dYTXpaBgd9BR1i00tk/DhDbxgNXImLHeJVE43R8ypZy41nmBy5n
         hlSXhzMVG40Y3nbdMmPpk4tPeFYYrmo8lQ9PxLGYe+OxN2pS6rFciJIjfO24Qpc2hzmm
         LKscQAwjxwwHwvz7mHQm2zIyad8Er2W7Boy6jG/nlaXkV3AnbL7sN+opvcc/RMOwUYFt
         2NF3/ROekJPCKB+h9UVmnjQd8o4FXb7r2Q2nbo0U7nr6P15U25mSTXp2ubjLNXTaGyCx
         kPQvx8DFVGkR48YWVQQzsyVqKhDwnT42f2eC/4l46F7vu3ojVeXsccMgb448H9ywW7jU
         PRTw==
X-Gm-Message-State: AOAM532EjjURUYS7Q2gPEkDQkRaqiuD/uDEfiLyvdYvQtlM23z0/BOBr
        b4sN0yAH0UyPO2t+gbYIM4HOg9ocWrI=
X-Google-Smtp-Source: ABdhPJzg/kZoFqXsAUnLU0AVp9Nrsz0ZVmbwW/RwlM0iVxLcOl69U+YWXHL0NUoQGQBUmhuAlKoIyw==
X-Received: by 2002:a17:90b:4b4b:: with SMTP id mi11mr8850818pjb.41.1632953192181;
        Wed, 29 Sep 2021 15:06:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 11/84] 53c700: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:47 -0700
Message-Id: <20210929220600.3509089-12-bvanassche@acm.org>
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
 drivers/scsi/53c700.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index a12e3525977d..e7ed2fd6cdec 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -634,7 +634,7 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 
 		SCp->host_scribble = NULL;
 		SCp->result = result;
-		SCp->scsi_done(SCp);
+		scsi_done(SCp);
 	} else {
 		printk(KERN_ERR "53c700: SCSI DONE HAS NULL SCp\n");
 	}
@@ -1571,7 +1571,7 @@ NCR_700_intr(int irq, void *dev_id)
 				 * deadlock on the
 				 * hostdata->state_lock */
 				SCp->result = DID_RESET << 16;
-				SCp->scsi_done(SCp);
+				scsi_done(SCp);
 			}
 			mdelay(25);
 			NCR_700_chip_setup(host);
@@ -1792,7 +1792,6 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	slot->cmnd = SCp;
 
-	SCp->scsi_done = done;
 	SCp->host_scribble = (unsigned char *)slot;
 	SCp->SCp.ptr = NULL;
 	SCp->SCp.buffer = NULL;
