Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456AAC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjEQWcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjEQWcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:32:05 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A191B4EC4
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:04 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-52caed90d17so900672a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362724; x=1686954724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5GXl1OOPFdy+snLabovbQEqHFmPQkRWU+Sc7m9i61PQ=;
        b=H2Qq6+4fP8bGgey9NU0rfspwQk2uhT6RKHq49Yr7gRwzuTnv5vgLnVnni7opTYVw4E
         qkyGu4c0RISodQwlS93bec4jUYtIM2tjBL9lnt6snWbsmKF7jWrAix8BPJiBf7VkxrYX
         jP3fh3Gf7bwd76qX1vHvYgOJWjGqXiWLoCZqRWOfl3eJTCbsRbz+8owP/Q5VqNV6BsRX
         xEYKWKRbL+c7QCvvr7Ah+zDLeghAKvdYu1xp7IuHsZkocIIgiB+Dp4SwqaloqL885IAi
         H08Bc+3toh9HcEC3skLEZsUWiNK2HPgknpSbhwtTkeISOz1gW0bJqqoYADj80GvbO8mE
         tJdw==
X-Gm-Message-State: AC+VfDyLtt0HE7D+C0wQvYpnwlQGap8ngmMQCUsyukfELtlr/wxrTXLh
        ZFdbd75tmVHLPXRkYmHjSNad7Qwd0rI=
X-Google-Smtp-Source: ACHHUZ7vxIe8groj+twGcKSfNEP2tJAv0HOqOLscRlSUO5Sase4lSSByABHL/r18bp4I/OKLWkT/pg==
X-Received: by 2002:a17:90a:b395:b0:24e:31bd:5079 with SMTP id e21-20020a17090ab39500b0024e31bd5079mr420896pjr.18.1684362724028;
        Wed, 17 May 2023 15:32:04 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a9f0100b00250d908a771sm61938pjp.50.2023.05.17.15.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:32:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 1/4] scsi: ufs: Increase the START STOP UNIT timeout from one to ten seconds
Date:   Wed, 17 May 2023 15:31:54 -0700
Message-ID: <20230517223157.1068210-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517223157.1068210-1-bvanassche@acm.org>
References: <20230517223157.1068210-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
Hence this patch that increases the UFS timeout to 10 s. This patch can
cause the total timeout to exceed 20 s, the Android shutdown timeout.
This is fine since the loop around ufshcd_execute_start_stop() exists to
deal with unit attentions and because unit attentions are reported
quickly.

Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4f14a8f72da6..37337d411466 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9167,7 +9167,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
