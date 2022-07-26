Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC60C00144
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 22:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiGZWwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 18:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiGZWwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 18:52:41 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6D213F1C
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 15:52:38 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id o14-20020a17090a4b4e00b001f2f2b61be5so367353pjl.4
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 15:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RjPdjDNHaGgfRGzJe//q3RZ0DCxZJJgykjoWO+QXeIE=;
        b=uIFfMYSItgB4FjvxXLegBIzLmc5Bu0jA3KLqyA1prjeoE26qyDW9+F+VSlSZopV+Jd
         GYm9bh9ZVlPYie+pGLOJKvJFxZfcy3K8WLTFSs7U/0J+svWfULVuQJfBydQPbjRo8xJV
         1443ZSqbLVbNzra8x35Bnyy7V19KYYo+pX8w1p6EOabgE7BBhl10el+/Op3WaS3LFuTr
         oBfTm2ni8cp62HNZjC9KU9+7XVoAnLVQ73e2YDrOI2U8pGyGO8/hLYcGkuAF0vBk3OMg
         5JdNIuGAPIoiYO+x0DPgfL2Z1VStc9wElbLedLiTJRDhPey/no4VFhb03bsW6YVKbXLY
         7YWQ==
X-Gm-Message-State: AJIora9sxGDJcNOcqrJJGs8BFTuk3xeif0Yta1VurBjE6GJIol0eeaWo
        zNGBj7CEGOUyGpEIUILOSIE=
X-Google-Smtp-Source: AGRyM1s0fFeyZu37VbBt09ivvxl3BwAu56n2Ib7Zp3RvjlsjtD6tzauOrWdz8Dbu1o/FyMO1Gps3gg==
X-Received: by 2002:a17:903:444:b0:16d:4873:f270 with SMTP id iw4-20020a170903044400b0016d4873f270mr19340103plb.104.1658875957870;
        Tue, 26 Jul 2022 15:52:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:34f4:7aa8:57:d456])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090aa78a00b001f2ebfdcd3asm92991pjq.54.2022.07.26.15.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 15:52:37 -0700 (PDT)
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
Subject: [PATCH v3] scsi: ufs: Increase the maximum data buffer size
Date:   Tue, 26 Jul 2022 15:52:21 -0700
Message-Id: <20220726225232.1362251-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Measurements for one particular UFS controller + UFS device show a 25%
higher read bandwidth if the maximum data buffer size is increased from
512 KiB to 1 MiB. Hence increase the maximum size of the data buffer
associated with a single request from SCSI_DEFAULT_MAX_SECTORS (1024)
* 512 bytes = 512 KiB to 1 MiB.

Notes:
- The maximum data buffer size supported by the UFSHCI specification
  is 65535 * 256 KiB or about 16 GiB.
- The maximum data buffer size for READ(10) commands is 65535 logical
  blocks. To transfer more than 65535 * 4096 bytes = 255 MiB with a
  single SCSI command, the READ(16) command is required. Support for
  READ(16) is optional in the UFS 3.1 and UFS 4.0 standards.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
Changes compared to v2: changed maximum transfer size 255 MiB to 1 MiB.
Changes compared to v1: changed maximum transfer size from 1 GiB to 255 MiB.

 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 36b7212e9cb5..678bc8d6d6aa 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8365,6 +8365,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
+	.max_sectors		= (1 << 20) / SECTOR_SIZE, /* 1 MiB */
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
