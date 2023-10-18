Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBF9CDB485
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjJRR4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjJRR4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:46 -0400
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2FB116;
        Wed, 18 Oct 2023 10:56:38 -0700 (PDT)
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3af957bd7e9so4533958b6e.3;
        Wed, 18 Oct 2023 10:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651798; x=1698256598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzaYxnCqQNUVR3i3khEB0a4wN2TqC5S5bjyD6Ki8qwY=;
        b=tD80rO3E+bjqq/Du5Acj4/x13yfk/4SjprnG+vwx+2sV2mKehu0fXZTDiAcV4nvU3B
         RuhoqMhWkojmC9j1jqDUWIp9dFrp3lzIV8dlsFLiD9Lvbsmop6yhbf5QLsizWFMPtup4
         dI8z/pLNpVsadA12eXHDQ9B4DN5/1p/MI/lt6rGFP5GO5EskYM19VX/5PWMUp0pXNj6I
         kPUlBgyyZS3Ao78XU7NjCeEyCs3h3h00TtnvObYbMjXg3mK7DpZn5Gs+xhsjFv9TycD5
         1/OLUDpUlBGyAnoe321yG7ntaqMSv2lpGgPYhkSRg6IYo8BZlRE4kuHKybQqCZNNhdPK
         DVnQ==
X-Gm-Message-State: AOJu0YyucPi0laLVwYsbQc/PaOyWo9K9rtIk5LOnMSgK4qN3ja3cpPzg
        lGapff8Gtt+n/zuiB88GOhU=
X-Google-Smtp-Source: AGHT+IHGlohMVbM21pVwttuFEXoYy8SCCGWVRtFC7bENvmPZLa62ixuBoEQpD7Zi0X4Nuoe7ZbFVKQ==
X-Received: by 2002:a05:6808:499:b0:3b2:e0ac:b85e with SMTP id z25-20020a056808049900b003b2e0acb85emr4609117oid.5.1697651798012;
        Wed, 18 Oct 2023 10:56:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v13 10/18] scsi: sd_zbc: Only require an I/O scheduler if needed
Date:   Wed, 18 Oct 2023 10:54:32 -0700
Message-ID: <20231018175602.2148415-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
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
