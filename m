Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6534FC27C41
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345943AbjHPTz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345942AbjHPTzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:17 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06921E56;
        Wed, 16 Aug 2023 12:55:17 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-686be3cbea0so152869b3a.0;
        Wed, 16 Aug 2023 12:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215716; x=1692820516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OG1Q4E4gS04WVynI05SnxfmTGAZJINVqD2qG/eTVmwQ=;
        b=jgfmVdR2IaI5d25E3eweM2OAPv3/QBXjIQkOJxZx6dzUfeYITDiHXap1R4v8ic8t7/
         OxPbr5e1OeiIwvBsCkuJzQcGEoEppxfMJ8Fd1I1sUEqrSaZSuY3D3h/lljCpzVE3yznC
         EJuUZA2ZEkhYdY0JlFVPy1kd6Ie9+Y8ILjaiSpRpOSkqa+ECqT7WBuLo1oo4tGY1hpIe
         XU8ys0HpgFF+E79ZAb5qA/nLOxiyOO7u27VaGQQE/73w12JB7gOa7jSWB/8FOIup3aw8
         t/uXKsSCIWC86icGJl2O3L9ads97TDmd4qYSdrRX14uUnIFxIaKsdViIuDrCdJdaxuiI
         jA/Q==
X-Gm-Message-State: AOJu0Yz8GqvdFaPTqPdDDDLCfmMAHeoRYIZmWfrHjyE0CvRRnmqGqAE2
        UOyulTVIWOlGw/DqoqpKlHM=
X-Google-Smtp-Source: AGHT+IF1/pgihdH+GKUoHEgKc6Pfhp21iQTd+gezAbn8GmkAicJjwRZP0fR8cnW3KfjZm9vhWCOLgg==
X-Received: by 2002:a05:6a00:148f:b0:666:b22d:c6e0 with SMTP id v15-20020a056a00148f00b00666b22dc6e0mr679847pfu.11.1692215716402;
        Wed, 16 Aug 2023 12:55:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v9 08/17] scsi: sd_zbc: Only require an I/O scheduler if needed
Date:   Wed, 16 Aug 2023 12:53:20 -0700
Message-ID: <20230816195447.3703954-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An I/O scheduler that serializes zoned writes is only needed if the SCSI
LLD does not preserve the write order. Hence only set
ELEVATOR_F_ZBD_SEQ_WRITE if the LLD does not preserve the write order.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
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
