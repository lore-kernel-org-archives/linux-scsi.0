Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9FAC77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 00:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDKALt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Apr 2023 20:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjDKALs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2023 20:11:48 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FB926B7
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2023 17:11:43 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2467cc6dd4cso224982a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2023 17:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681171903; x=1683763903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jeNsMkVkFSaqUdr1caAEtilUawB8rSSZ8uA+pLfTHxY=;
        b=klKXvIKk1zhkwxjx0j2SD2juAMX46rv+J+dUjXV8i+TgluuiL8ovy5mSfQWBAqFcv+
         JfpVcT6DWOi+iHPDzscgPIhGYBYZDH1paKfhReF0EUXFemmix++E28ar+9bgy2MOD81L
         R1DsR3elZ0Baxa+A67NGeioS0HuQPAZJ95pUz9yDjfkfgg66Ra8Gf17KsSM3IMj9aWdH
         yxwG3/U2/Uo/EtiZl7jQ/U6maqqRwDOb7PaTpIcnjtbtgvC/ip56wtcNa6j4Ci6Gltu2
         SXG+PvXew+2L/JbGaUh/i5OIA6gj0g1osAMQZGe77DaXJg0emXpGOs7yif5cvpU1F/sC
         8dIA==
X-Gm-Message-State: AAQBX9fUWXLTWUjlKLjevazLyq5vYzwxDS5VAsMT4vt6YgVatWUVdDAt
        HSc3RTRJaXtx35KDaQxbuZI=
X-Google-Smtp-Source: AKy350aF7WH09/zpZtRqq3RDf5NUtUpu1t8RvQF/2OHneZ7UcAVK0StT/qBLeb2RBFTQbaBsvIWROA==
X-Received: by 2002:aa7:9adc:0:b0:625:e77b:93b2 with SMTP id x28-20020aa79adc000000b00625e77b93b2mr1004867pfp.5.1681171902599;
        Mon, 10 Apr 2023 17:11:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:11fd:f446:f156:c8])
        by smtp.gmail.com with ESMTPSA id g9-20020a636b09000000b00502e7115cbdsm7551643pgc.51.2023.04.10.17.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 17:11:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH] scsi: ufs: Increase the START STOP UNIT timeout from 1 s to 10 s
Date:   Mon, 10 Apr 2023 17:11:19 -0700
Message-Id: <20230411001132.1239225-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 03c47f9a2750..8363a1667feb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9181,7 +9181,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
