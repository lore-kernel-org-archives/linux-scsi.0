Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ED8C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 17:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A842C64DED
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 17:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBTRkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 12:40:20 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:42666 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBTRkU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 12:40:20 -0500
Received: by mail-pg1-f172.google.com with SMTP id o38so7433054pgm.9
        for <linux-scsi@vger.kernel.org>; Sat, 20 Feb 2021 09:40:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bvsSeGT1Ij4m6aDK95swZgdlbn7Pbj0h+vKR6Q5qF2I=;
        b=dhu8o8Yip30v4dbRMP2/KJm7nAoVGqGURRZmJrFV+63vtOQBMa81ST4TYuGsrqO52+
         YnnZTLJZhsqWJFK7u4ujUap5U1JeRFt9TY8NUWcas490qaSDoAG6CTMg0Qo5FjsjZPPM
         KlLotbgbTmWg55sJXV3+ZK37exLow57LaHqgBHyVjVz1woIvQAu3FSkeP3s7z7Jj8DbN
         Kg/P0Zkh/iPYXUUYsVXE1urb1YXGQ9xSaMZG6dm038Ez7czFRPLRNBQOJ/eNyeI/9tgK
         okuiKljlkjK9svhgHTGUEMmyFt2Y4s3TciO08JvUXdUzRYFrLBvqzIFKncIn+LHIZ0/Y
         4stw==
X-Gm-Message-State: AOAM530gnf++h41LFcRq8hlHIC+78v1TLMBL/d0rZCnG7otY67gkAeU+
        aPM2A77O/777JUQIcP7WgFo=
X-Google-Smtp-Source: ABdhPJzYX2eBZD/yx2Fz8GIopv7qAemoKbFb2ZIW/62Z0PKCt5gWgSHf8qIQ9Juow0N+4JNxYj6kGw==
X-Received: by 2002:a63:e84f:: with SMTP id a15mr13098994pgk.249.1613842779263;
        Sat, 20 Feb 2021 09:39:39 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:a813:9a51:fed9:102b])
        by smtp.gmail.com with ESMTPSA id 62sm13484763pfg.160.2021.02.20.09.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Feb 2021 09:39:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        chriscjsus@yahoo.com, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] scsi/sd: Fix Opal support
Date:   Sat, 20 Feb 2021 09:39:31 -0800
Message-Id: <20210220173931.22155-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI core has been modified recently such that it only processes PM
requests if rpm_status != RPM_ACTIVE. Since some Opal requests are
submitted while rpm_status != RPM_ACTIVE, set flag RQF_PM for Opal
requests.

See also https://bugzilla.kernel.org/show_bug.cgi?id=211227.

Fixes: d80210f25ff0 ("sd: add support for TCG OPAL self encrypting disks")
Fixes: 271822bbf9fe ("scsi: core: Only process PM requests if rpm_status != RPM_ACTIVE")
Reported-by: chriscjsus@yahoo.com
Tested-by: chriscjsus@yahoo.com
Cc: chriscjsus@yahoo.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a3d2d4bc4a3d..aaebf166066a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -707,9 +707,10 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute_req(sdev, cdb,
-			send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-			buffer, len, NULL, SD_TIMEOUT, sdkp->max_retries, NULL);
+	ret = scsi_execute(sdev, cdb,
+		send ? DMA_TO_DEVICE : DMA_FROM_DEVICE, buffer, len,
+		/*sense=*/NULL, /*sshdr=*/NULL, SD_TIMEOUT, sdkp->max_retries,
+		/*flags=*/0, /*rq_flags=*/RQF_PM, /*resid=*/NULL);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
