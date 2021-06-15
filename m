Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3B3C48BE5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 10:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0843761454
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 10:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhFOKzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 06:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhFOKzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 06:55:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6810C061574
        for <linux-scsi@vger.kernel.org>; Tue, 15 Jun 2021 03:53:04 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e1so8253076pld.13
        for <linux-scsi@vger.kernel.org>; Tue, 15 Jun 2021 03:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=77abVvtdAdpsdW3TjnJbPbQceAD3ngpH/aIswkPaxEg=;
        b=Tds1GT4722acJuoNKaEMvAWaA5jVqpeaFseEXRr4CEjsZ+sfaupbI4X1/nZ6k0dr9y
         OYfv7o4sX3rV3oWwgL5Z6vG3F7Fpf+9kWzj3krKou8Ng04U5gjxRPPjOJ0bivqaNR0p0
         EQLz5jB2n8Sfqm0XEnOdk7og6nyuMMD905ZP8mZhRwh0H0gezjRmQVQzfkguifvE/IP2
         1aDMqRsWalb9xqDVyl/g6yjTZE2mf10cSyPLbjBhV4fUqdXtlPrsFFuwO7Kp0wX3DHtu
         Gq1T8Y4Pf+PhX39zYEeouiXnjg38o8KJpcERHDaVrTwDE5WpL7uVdDrpsvJM5uoW3NMk
         trgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=77abVvtdAdpsdW3TjnJbPbQceAD3ngpH/aIswkPaxEg=;
        b=jWn4J4HMR5yxHmNFdfYyCkenc4lCAxbQCFoOdCwe2sPCzubKThM6C9x4bPrGzWRcq0
         lBK2aY54JwQ2gOzWGlLzeB2lUUI3cGoequ1kXQkn9gjmsjU4p4hp4PIm6gpqD+z9TMNM
         0/9OSCQygRVg8VmXQRRb/dg2qwjwURvQRAu8uDdP7vSp56Pmzdq7V8hDxOIOEQBJJ8Et
         Pqbpc5dIAUvrEljKWgn6VEisf18GUmAIqbl5Ua9ResVqz++Iq4sKlhvD5Wl4pBMXc6y4
         NvUi6Agyt48yMWSArgEAg7UWZ8N7U1RXXsrRVPLTtDALzM3RjCxGafI0arTd+RQCwJUL
         lOAg==
X-Gm-Message-State: AOAM5314RmjCVORnNID3UwRWA0SGy0hcLdSfq1bQUZ438nQf4VyGorzB
        qpXPM80vd5bZdFdlOUfynw4p
X-Google-Smtp-Source: ABdhPJzseDWG1hjfL7mLTTag7psIODvVANSAUopVS9dBKHkwKyJbNHvAanyQPDK+CDEj8Lfxl/ttsg==
X-Received: by 2002:a17:902:c3d5:b029:100:742f:fce9 with SMTP id j21-20020a170902c3d5b0290100742ffce9mr3438730plj.46.1623754384193;
        Tue, 15 Jun 2021 03:53:04 -0700 (PDT)
Received: from localhost ([61.120.150.78])
        by smtp.gmail.com with ESMTPSA id g6sm15522184pfq.110.2021.06.15.03.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 03:53:03 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] virtio_scsi: Add validation for residual bytes from response
Date:   Tue, 15 Jun 2021 18:52:18 +0800
Message-Id: <20210615105218.214-1-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This ensures that the residual bytes in response (might come
from an untrusted device) will not exceed the data buffer length.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9c86a7e3b97..2badc3c80d73 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -97,7 +97,7 @@ static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
 static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
 {
 	if (resid)
-		scsi_set_resid(sc, resid);
+		scsi_set_resid(sc, min(resid, scsi_bufflen(sc)));
 }
 
 /*
-- 
2.11.0

