Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E85CC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0984D60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347069AbhI2WKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:10 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:51809 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347229AbhI2WKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:10:05 -0400
Received: by mail-pj1-f49.google.com with SMTP id h12so2710167pjj.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7xilU3jHyni/CWHIueSREihH47952Ir/XFwBVJMSJEU=;
        b=u16pgtrZGr4VA4HGGJeaHEMK3ZhMTRVHFW1Y/rOGbn4ya2/Q7FIxChjiEq1iECM5QI
         qYI2l/wB/O52zd8YrqEQSHG+obzp57xtR16IDVMXkW27uNgVkOyC/00otpvCDn6OMxYs
         7k8ZSGMGgvuiXRw1SepoWV/pxOlWIntzGHYX4d3/SZ5tkKwi7N05lX6DZ9OmxnS/bhqs
         pJQxOJ/l6e/awo+VemdLR4kTOMZe3zmbSySkGly8wRAhaL6C3bA4WuT9M+eYD5hf7NQt
         Su32pa6siKmbj5GyYu2rssO4Lj6SOdD9A2ark96naYgxrpsTpi6twljii3yOeuqFSaKC
         BOqA==
X-Gm-Message-State: AOAM5310Sl4stY1BeFqnIF1xYjnpqKbzj+CdR1hXTGe8mmWvyuOowHpj
        8hMEYG6bOr0D05VQCWdf/p8uTYTV3pfhZQ==
X-Google-Smtp-Source: ABdhPJxRj77aWZ2uD1/QFr2BRmxGlGEcrZ5cyohqY2iekyID5UslBv7wYVRYMLW+DEU8gBXYGJukVg==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr2361626pjb.161.1632953303496;
        Wed, 29 Sep 2021 15:08:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 79/84] xen-scsifront: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:55 -0700
Message-Id: <20210929220600.3509089-80-bvanassche@acm.org>
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

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 0204e314b482..12c10a5e3d93 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -276,7 +276,7 @@ static void scsifront_cdb_cmd_done(struct vscsifrnt_info *info,
 	if (sense_len)
 		memcpy(sc->sense_buffer, ring_rsp->sense_buffer, sense_len);
 
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static void scsifront_sync_cmd_done(struct vscsifrnt_info *info,
@@ -558,7 +558,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		if (err == -ENOMEM)
 			return SCSI_MLQUEUE_HOST_BUSY;
 		sc->result = DID_ERROR << 16;
-		sc->scsi_done(sc);
+		scsi_done(sc);
 		return 0;
 	}
 
