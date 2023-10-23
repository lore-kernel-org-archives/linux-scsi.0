Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152D8C25B49
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbjJWV52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjJWV5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:20 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA8A10D4;
        Mon, 23 Oct 2023 14:57:18 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-27d0251d305so2477117a91.2;
        Mon, 23 Oct 2023 14:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098238; x=1698703038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzaYxnCqQNUVR3i3khEB0a4wN2TqC5S5bjyD6Ki8qwY=;
        b=lt4UT+cZArwJUfLCtu78yynM/OV/s875M7KdhWDns+029oirX0ztFP4z8AyBf3O++t
         v4V5dFH0cNgxjz11RM51qitE6QyEUpldcH0DZIT/EDVbKM8tvJGGE8SSn7ECRvtg2Ix8
         u9Dnf5xj8HQGyNzBurLbM9hjMTb/jN9o+qJfBEtD6CCKM5faWePAfpoUVdf86WQEfp5f
         PyaJriskLxl7Ia04oBJ4kv3BejG6GohEwMnlk1aN6EDmVlcRP0MmOYpzu93WYIcKWPwA
         h8dqC+1I73pjYCswtSoPOihlnKI74FcA94JtFt2Lm+n83T/qgZL3ikkrU/uFJaek7x25
         7EUA==
X-Gm-Message-State: AOJu0YxpnVUFEJaNQT/BLATDBMtDj5VzLpFe3LcMBjf7cVEhvG6ttE7J
        ZJ2fhjch/VRzfSa4c3C6FOg=
X-Google-Smtp-Source: AGHT+IEc95mRiWYe19QEf1c6PbttdDZO+usFDQZzlmhFSnlCgbhpscBLmMPz769p1kK7+UrBGFYMBA==
X-Received: by 2002:a17:90b:3717:b0:27d:98f3:21a7 with SMTP id mg23-20020a17090b371700b0027d98f321a7mr7706129pjb.8.1698098237793;
        Mon, 23 Oct 2023 14:57:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v14 11/19] scsi: sd_zbc: Only require an I/O scheduler if needed
Date:   Mon, 23 Oct 2023 14:54:02 -0700
Message-ID: <20231023215638.3405959-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An I/O scheduler that serializes zoned writes is only needed if the SCSI
LLD does not preserve the write order. Hence only set
ELEVATOR_F_ZBD_SEQ_WRITE if the LLD does not preserve the write order.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index a25215507668..718b31bed878 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -955,7 +955,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 
 	/* The drive satisfies the kernel restrictions: set it up */
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
+	if (!q->limits.driver_preserves_write_order)
+		blk_queue_required_elevator_features(q,
+						     ELEVATOR_F_ZBD_SEQ_WRITE);
 	if (sdkp->zones_max_open == U32_MAX)
 		disk_set_max_open_zones(disk, 0);
 	else
