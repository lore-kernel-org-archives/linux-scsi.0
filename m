Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AE0EE4998
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379823AbjHRTql (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379886AbjHRTqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:46:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1EB4222;
        Fri, 18 Aug 2023 12:46:03 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1bdf4752c3cso9655895ad.2;
        Fri, 18 Aug 2023 12:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387848; x=1692992648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZcvkVqEgcZDFQS81H9kWGylORDZIjImpoq5H3+tcVc=;
        b=GjIpXLlNXitfjsuDnjX4WP8ZQ4HOE5ie4xK/Nu7TfTxLEUJ5HRqnr5nY0dltLaPpjx
         A0loBtuxgub3YhtG8OYL8DvnQ45RS4F8Od905pq4E5im+4Ilb/o69A8OA/ZsIMm2Qdgx
         8kDyFCfHxbYrge4wFYro+RPYGrCOYw6/MiNzpasOt4RldrCeMm7HFxWUFNkfgJHnV4nx
         QM1WYTfEzLQOaeKPdvB1Yl5o5EpTy+fEtSqIOQD1ZM9CuhptqEZblJqOgT2yMUmS+/Ip
         Jq2GI1Ucoc5XncnkQ1o9zvAF0jDH4zKw0xCRCKqacaDYf6q+0duhk2ZGITthXZzDonQH
         hH3g==
X-Gm-Message-State: AOJu0Yx/Bhq/bIQzjlmaBk/MyOG6e/OWpoCYrcYcfSUPAKYGfoxlckfh
        FmOv0EXdx0Pir+tFwwI9lkU=
X-Google-Smtp-Source: AGHT+IEV1C9zA43zMqSI+JkbfJmRb0iMdmLvh/+5xAajttb3+NI7TnYzzudwcf4SLdwlJOlRLyQjVg==
X-Received: by 2002:a17:902:c409:b0:1bc:6266:d0e4 with SMTP id k9-20020a170902c40900b001bc6266d0e4mr144999plk.69.1692387847876;
        Fri, 18 Aug 2023 12:44:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:44:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH v10 13/18] scsi: ufs: mediatek: Rework the code for disabling auto-hibernation
Date:   Fri, 18 Aug 2023 12:34:16 -0700
Message-ID: <20230818193546.2014874-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call ufshcd_auto_hibern8_update() instead of writing directly into the
auto-hibernation control register. This patch is part of an effort to
move all auto-hibernation register changes into the UFSHCI driver core.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e68b05976f9e..266898a877b0 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1252,7 +1252,7 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	int ret;
 
 	/* disable auto-hibern8 */
-	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
+	WARN_ON_ONCE(ufshcd_auto_hibern8_update(hba, 0) != 0);
 
 	/* wait host return to idle state when auto-hibern8 off */
 	ufs_mtk_wait_idle_state(hba, 5);
