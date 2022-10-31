Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2EFECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Oct 2022 22:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJaWry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJaWru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2022 18:47:50 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D1F15737
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:49 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id c15-20020a17090a1d0f00b0021365864446so11466502pjd.4
        for <linux-scsi@vger.kernel.org>; Mon, 31 Oct 2022 15:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AGJA+sOwnLK/4cwPoFnL1ULIW3kGKI5Ced+JfTYKsKw=;
        b=hkmA5F4eM52wiF9lFyBGGL0g7Wb4iraOCoV1T7Ur0U/JrQxavE9UZwryqrUe3XLiS7
         nBCVYeTC49pkAMbXaW/j3jFw7lUKRgCyCuG92rkqoHyxtQgN1QFit99H8TgzOImrqtbu
         5sgOUqxu3J5/xe9kOxy4bisvRdTd1FuoIcgEMso1enlNoqY6D+uuIKCFiQ8dmWjvO+nO
         nb9MMSGUv4m4wLYdR8ETMOlArg7KA/Ms9TuKbXgHcxvKyA91lcDUD2nB9XPurnbEAkuz
         qWrkSiFnYOG30ruXCQ1pDrvMvFWG+OhO9ngK5t1Ykk1ymA+oF1P618H3VNMJfrFTR6nZ
         8uag==
X-Gm-Message-State: ACrzQf3a62Xt6uZ66ujjlN/LLSfPGk8njRKeRlsnrHUGUFWYldolJOIJ
        lfp9WQ036fJc6Dy+bU2ktJY=
X-Google-Smtp-Source: AMsMyM6pcKPk2+QWppTJY0i0PcVYj8zQHsLStF8vvr39GhIypiFfmXmEIby01bAp9V5HKIcUE1qEnw==
X-Received: by 2002:a17:902:8e84:b0:178:71f2:113c with SMTP id bg4-20020a1709028e8400b0017871f2113cmr16275312plb.79.1667256468891;
        Mon, 31 Oct 2022 15:47:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8574:e82f:b860:3ad0])
        by smtp.gmail.com with ESMTPSA id x6-20020a626306000000b00565c8634e55sm5096019pfb.135.2022.10.31.15.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 15:47:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4/4] scsi: bfa: Rework bfad_reset_sdev_bflags()
Date:   Mon, 31 Oct 2022 15:47:28 -0700
Message-Id: <20221031224728.2607760-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
In-Reply-To: <20221031224728.2607760-1-bvanassche@acm.org>
References: <20221031224728.2607760-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since commit f93ed747e2c7 ("scsi: core: Release SCSI devices
synchronously") it is no longer allowed to call scsi_device_put() from
atomic context. Hence this patch that reworks bfad_reset_sdev_bflags()
such that scsi_device_put() is no longer called. This patch fixes the
following smatch warning:

drivers/scsi/bfa/bfad_bsg.c:2551 bfad_iocmd_lunmask_reset_lunscan_mode() warn: sleeping in atomic context

bfad_iocmd_lunmask() <- disables preempt
-> bfad_iocmd_lunmask_reset_lunscan_mode()
   -> scsi_device_put()

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 73754032e25c..79d4f7ee5bcb 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2553,18 +2553,20 @@ static void bfad_reset_sdev_bflags(struct bfad_im_port_s *im_port,
 	const u32 scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;
 	struct bfad_itnim_s *itnim;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
+	spin_lock_irqsave(im_port->shost->host_lock, flags);
 	list_for_each_entry(itnim, &im_port->itnim_mapped_list, list_entry) {
-		sdev = scsi_device_lookup(im_port->shost, itnim->channel,
-					  itnim->scsi_tgt_id, 0);
+		sdev = __scsi_device_lookup(im_port->shost, itnim->channel,
+					    itnim->scsi_tgt_id, 0);
 		if (sdev) {
 			if (lunmask_cfg == BFA_TRUE)
 				sdev->sdev_bflags |= scan_flags;
 			else
 				sdev->sdev_bflags &= ~scan_flags;
-			scsi_device_put(sdev);
 		}
 	}
+	spin_unlock_irqrestore(im_port->shost->host_lock, flags);
 }
 
 /* Function to reset the LUN SCAN mode */
