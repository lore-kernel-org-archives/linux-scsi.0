Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FFFC41513
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 20:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbjHIUYc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 16:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbjHIUYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 16:24:14 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B58F2690;
        Wed,  9 Aug 2023 13:24:06 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-26830595676so126047a91.2;
        Wed, 09 Aug 2023 13:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691612646; x=1692217446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5dO3J2D44JWA/zBVJrnrUbBeTSoS+a+K9Gvbk3ZU3w=;
        b=O0MduQoDyTZZ7O9hysuBdRSuTIFEOo3uWt38eQpYFEYMGaXQHmq0aDjIWw9rzcb2+p
         WwPGNgujY03IvRmtDniUZpX0lU1itBel6188melW70F4dCnXSuvtnJpaD4/pqXImJ2S4
         QvpTHjJ/9MeE02VASzLvYqDHy2dcXamafp8s2Gavd393CwwK+8SC7i6SIEqLQwcpAP8Y
         7QRyH8hIe6A1aHoWMKabsClZ6uj5Saps7a8EJKJggNyVY5RD0uZ/e3zEsMu5DUqutIny
         IkhNInF3ZVI9voBqdOKL0NrWVnPCjZuSf3DRTUy8l9a4HN+gYWcmkENqfIbr4FDj9HHg
         293Q==
X-Gm-Message-State: AOJu0Yw3WR1eSyXeJQGt42bsuMKAeJbEPMLdtPE0hiDFTBOxOKyL3Qzs
        ibZtYh08NAIcS4BOKZoTYdw=
X-Google-Smtp-Source: AGHT+IEganERE5UnLbYrCgpdsQUD6t+54AGWUd+9pL3pi4Wi3r33UIZuUPbyh3vz4sSEt3NKsp+HNg==
X-Received: by 2002:a17:90b:1d12:b0:268:5c2f:f0c7 with SMTP id on18-20020a17090b1d1200b002685c2ff0c7mr371579pjb.5.1691612645970;
        Wed, 09 Aug 2023 13:24:05 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id gq9-20020a17090b104900b002694da8a9cdsm1868103pjb.48.2023.08.09.13.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 13:24:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v7 5/7] scsi: scsi_debug: Support injecting unaligned write errors
Date:   Wed,  9 Aug 2023 13:23:46 -0700
Message-ID: <20230809202355.1171455-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230809202355.1171455-1-bvanassche@acm.org>
References: <20230809202355.1171455-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow user space software, e.g. a blktests test, to inject unaligned
write errors.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 22485726c534..b9712275de9d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -181,6 +181,7 @@ static const char *sdebug_version_date = "20210520";
 #define SDEBUG_OPT_NO_CDB_NOISE		0x4000
 #define SDEBUG_OPT_HOST_BUSY		0x8000
 #define SDEBUG_OPT_CMD_ABORT		0x10000
+#define SDEBUG_OPT_UNALIGNED_WRITE	0x20000
 #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
 			      SDEBUG_OPT_RESET_NOISE)
 #define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
@@ -188,7 +189,8 @@ static const char *sdebug_version_date = "20210520";
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
 				  SDEBUG_OPT_SHORT_TRANSFER | \
 				  SDEBUG_OPT_HOST_BUSY | \
-				  SDEBUG_OPT_CMD_ABORT)
+				  SDEBUG_OPT_CMD_ABORT | \
+				  SDEBUG_OPT_UNALIGNED_WRITE)
 #define SDEBUG_OPT_RECOV_DIF_DIX (SDEBUG_OPT_RECOVERED_ERR | \
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR)
 
@@ -3587,6 +3589,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
 
+	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
+		     atomic_read(&sdeb_inject_pending))) {
+		atomic_set(&sdeb_inject_pending, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE,
+				UNALIGNED_WRITE_ASCQ);
+		return check_condition_result;
+	}
+
 	switch (cmd[0]) {
 	case WRITE_16:
 		ei_lba = 0;
