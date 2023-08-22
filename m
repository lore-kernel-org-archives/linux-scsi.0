Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1E2EE49AE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjHVTTK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjHVTTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:19:08 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD1E58;
        Tue, 22 Aug 2023 12:19:00 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-26d1a17ce06so2623114a91.0;
        Tue, 22 Aug 2023 12:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731940; x=1693336740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzaYxnCqQNUVR3i3khEB0a4wN2TqC5S5bjyD6Ki8qwY=;
        b=hAANT55DS4FJNI3IuUoo/gzHbVLLeaWTRNOOJeY5WIPOAA21Xhs89nhozm0ahGk0QC
         El52Xy/blj2FsFGm+oXWU/IiGcSJduBB2XpIUlJUd775FEb82ljSwhEChZF9Jy9M6cRT
         6on28pAvYxA5j9ibaDuBM6YzLo71g3UltZxUFNmlBd3MYCiGVN7gaw48YNeSYAJv4QnB
         NJOX9xkkTtg5TuiYRmwYtY9GeshSD3jkzrp2UDuBA210CiQmUHBmYarbAZTQ25zqWedb
         ZyrQWl4DGPSSklA5Bl2fY0fLJ/F+x0/5YpfXMYvmvXyyTPXsp+Clw8nckF3aeL6uN1Ln
         LYKQ==
X-Gm-Message-State: AOJu0YxnWfOK8ux8XlAv8HuzYygdphj9IkC6luwWNOvkuEzdAB1Y3MEU
        +Wd3D5qe86t46JDP7ZJyrN4=
X-Google-Smtp-Source: AGHT+IFFrhNhX8cPPRiyPyqNnRiitqqSD/xaFBDpQWM0lselcoSgUxBylWwBo3gMs0rApvVtUB4jgw==
X-Received: by 2002:a17:90a:5646:b0:26f:2998:fca9 with SMTP id d6-20020a17090a564600b0026f2998fca9mr6794178pji.28.1692731940043;
        Tue, 22 Aug 2023 12:19:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:18:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v11 08/16] scsi: sd_zbc: Only require an I/O scheduler if needed
Date:   Tue, 22 Aug 2023 12:17:03 -0700
Message-ID: <20230822191822.337080-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
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
