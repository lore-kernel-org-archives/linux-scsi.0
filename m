Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3084CCA48A
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 17:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbiGYRfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 13:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiGYRfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 13:35:36 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D646026DC
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 10:35:35 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id y24so11047755plh.7
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 10:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2TQvHzsK9K8uSunlyMMUv1UL653YQ5v+iwrcscS8V8=;
        b=brk3XVM8SVMPvFTOJWJ71KH1atxxMiKqkyBYgFEXZVOFNosyaGo11uTmWvyE6C0goX
         icJJn5mBWKAeCDE2lbZKgE+9sH9EYsSmvRjDPMDb+KhSH7sCO2d0fvPjjn9GJlVTShEG
         +Ls/w3bZyVW8sWe9qzdlvY6n5vXqK+pY5FJFdYl07Jg4KanOWjqzeIIJ7aeIWCwTdfkU
         b2hdQapQYC+qwZblQPEAjdA+VDCJLMNKchtHi3Um+Xs1dfERTkTAg6PQm9fPgz/75Zef
         qaAfFAmMv9AuDizD5jsbbtdaw55zAWl9Tz8DC0oViKfF1Ja9yJa0k65If32UoTh55lLT
         LVVg==
X-Gm-Message-State: AJIora86ugtI7M0xKCLZOVm7SdTpplOn5vbDGw/GsZlnVbXl0Ct+eOnV
        JfDE7YWtrVO2r4ud/vP0iK8=
X-Google-Smtp-Source: AGRyM1sqU3uJuMwx4AyRX4Qpjhfu26MCZrudyL3r+Q9rkR42Et4eS8CpnL8dVQ6hp4ZMv7ZFMp9tuQ==
X-Received: by 2002:a17:902:da89:b0:16c:49ee:9e71 with SMTP id j9-20020a170902da8900b0016c49ee9e71mr12884287plx.71.1658770535136;
        Mon, 25 Jul 2022 10:35:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:54bc:1b55:1813:e7a8])
        by smtp.gmail.com with ESMTPSA id i188-20020a6287c5000000b005251b9102dbsm10216098pfe.144.2022.07.25.10.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 10:35:34 -0700 (PDT)
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
Subject: [PATCH v2] scsi: ufs: Increase the maximum data buffer size
Date:   Mon, 25 Jul 2022 10:35:17 -0700
Message-Id: <20220725173528.849643-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Measurements have shown that for some UFS devices the maximum sequential
I/O throughput is achieved with a transfer size above 512 KiB. Hence
increase the maximum size of the data buffer associated with a single
request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes = 512 KiB into
255 MiB.

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
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 36b7212e9cb5..a6fddf4c546e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8365,6 +8365,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
+	.max_sectors		= 65535 * 4096 / SECTOR_SIZE, /* 255 MiB */
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
