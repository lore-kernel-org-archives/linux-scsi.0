Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31098C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 17:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiGTRD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiGTRD2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 13:03:28 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5E16A9DA
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 10:03:28 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id g4so16964053pgc.1
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 10:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2L6icZSqeGSKBB6e3KaeFatL/yTEVdCCO3S/lO2z74U=;
        b=M8OekGH/98co9LLSMsacHAjJdqCGp66SPdcYYDhjIU98rYE9PoEQPwuSwLeosc83DZ
         yatlhuqeT2EgnGL8XakgIxi9kFVdxl6G6hLVCbFoIfBpsEYMRG9N3whazSkyZeYBpJzJ
         MNGMI9Ixin0lVmqZwu9E5nVfL99HqH4J8B95lGFO1wL+OlEduBuavkphJxyiR6gwhYPo
         gXcAqkRc1Z1l5rIgFICCqiAB3rnUlQLL/TtuDT2/tBoaXiMFzAgzze6kRM1hcuu9xTOr
         hMyZeKI1cHSk2jlJXcVeeB6HYZFn/q5QHE2S5XGDxQHfs8yJjLxwfSGUqg9k6Y6sLBQR
         coPg==
X-Gm-Message-State: AJIora/+IPrjPToklJpASB0hi7IB4rp5QMA6jnONBOOikAaOkC4z0cGX
        NsjzDmI6FVb21pzGzwf5MhU=
X-Google-Smtp-Source: AGRyM1uYecnGGH//x3fmn87S6ckGImVjCBpVby9gUQs/Ss4ZJ4GfxV58SnJ/TgGRbQ6VFmYCqPpMRQ==
X-Received: by 2002:a63:6bc1:0:b0:40d:ffa7:9dc3 with SMTP id g184-20020a636bc1000000b0040dffa79dc3mr35120392pgc.111.1658336607685;
        Wed, 20 Jul 2022 10:03:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a7e0:78fc:9269:215b])
        by smtp.gmail.com with ESMTPSA id u9-20020a170902bf4900b0016c37fe48casm13928330pls.193.2022.07.20.10.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 10:03:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] scsi: ufs: Increase the maximum data buffer size
Date:   Wed, 20 Jul 2022 10:03:18 -0700
Message-Id: <20220720170323.1599006-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Measurements have shown that for some UFS devices the maximum sequential
I/O throughput is achieved with a transfer size above 512 KiB. Hence
increase the maximum size of the data buffer associated with a single
request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes = 512 KiB into
1 GiB.

Note: the maximum data buffer size supported by the UFSHCI specification
is 65535 * 256 MiB or about 16 TiB.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 36b7212e9cb5..ea7e8f329d0f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8365,6 +8365,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
+	.max_sectors		= (1 << 30) / SECTOR_SIZE, /* 1 GiB */
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
