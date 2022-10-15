Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25B9C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJOAYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJOAYo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:44 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7DC265E
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:40 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id f193so5703612pgc.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EgkuSrNjHum1/Z6a5Iip+2bn6a7aorWuDIy1hT/cXe0=;
        b=dYOGJDdYbTP+URQinfu9u+l5M+oXqKH8eH5rK32keRtRoKG3vWiNSuarMR7uLf7AYx
         hnsbs6m1oq8ZHLPmNPfBSosmEelGBBaMzrgTsXlYws7Go3LnmKy1ggutERnQZtaHcH2J
         wi2EsAS13wK1nMJgmyX3n9MytosA3kkKgvjzQhGDMONBfvdFHkP10+FhUZldwgjsnmkc
         +dmvcbdjqJCjjeufTcudmSbWMpcXlZMe9/cigDZHNtJ4ztcmAwanlppX0BLQjsI2JpCU
         tbfrMIyDFLH0G5B3FCvwHaHx9PZdCoC0eOm7vKaj+7Eu4kh9jTkcnCJyDS+LXOZPLPdG
         O+mg==
X-Gm-Message-State: ACrzQf1A6p+hQ7LnKZzrLj4iU07V3Kdr1ChC5/18TZ8SumW8lnhOX+3B
        SniHcveo4C9p5m0nCnYSSrg=
X-Google-Smtp-Source: AMsMyM4zchBm15Omz2KBcGKdxuy1yzLUwPnE27hJ1wgHW0VQ6poIvjaKQrW37sOCQ9QLGUAipSHt9g==
X-Received: by 2002:a63:4307:0:b0:464:a24d:8201 with SMTP id q7-20020a634307000000b00464a24d8201mr454525pga.116.1665793479523;
        Fri, 14 Oct 2022 17:24:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 6/8] scsi: ufs: Simplify ufshcd_set_dev_pwr_mode()
Date:   Fri, 14 Oct 2022 17:24:16 -0700
Message-Id: <20221015002418.30955-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the code for incrementing the SCSI device reference count in
ufshcd_set_dev_pwr_mode(). This patch removes one scsi_device_put() call
that happens from atomic context.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..c8f0fe740005 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8752,15 +8752,10 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
-	if (sdp) {
+	if (sdp && scsi_device_online(sdp))
 		ret = scsi_device_get(sdp);
-		if (!ret && !scsi_device_online(sdp)) {
-			ret = -ENODEV;
-			scsi_device_put(sdp);
-		}
-	} else {
+	else
 		ret = -ENODEV;
-	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (ret)
