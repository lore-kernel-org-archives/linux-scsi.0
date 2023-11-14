Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79846C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbjKNVS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234060AbjKNVSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:52 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F66CE;
        Tue, 14 Nov 2023 13:18:48 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cc316ccc38so47915365ad.1;
        Tue, 14 Nov 2023 13:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996728; x=1700601528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzaYxnCqQNUVR3i3khEB0a4wN2TqC5S5bjyD6Ki8qwY=;
        b=wtwomS/B6NAHkI0aQd5LGv/6avBX99ZZNowgwo7RKOz4W55M0ypq58HoGbaKODGNWM
         y7BPsw74/p4xk550BygWcKCNQq9z+6asuyt2OmtIgeYxM8QMAKDkeMz96J0ugoIk4XnD
         5XckP+XlcBQ1jzwthxJrxv8FtMsn+a0Q8KoVGHuTE/5ZVn6j/bdBIoOcUaObaIvMNjiT
         e3v05rxFJlt9TzHZUJe4QCwEA+NtkBoPu2SKjw1oQaEh7LQZVMkwmGHCpH360AbPnGVM
         NuOwd4gWTkFZBD+3OSZS5dkLtE7RkVi6MU1Tr1p99VLXYTTpugeMe1/peRzLrUtPP4gB
         pWfQ==
X-Gm-Message-State: AOJu0YxkjIALFGpyzFhW5X6jz6QhlEDon53ATH0/jYXT7TtIaPLPgbdq
        uA7l+moHqpnDpPXTGNQU0O0=
X-Google-Smtp-Source: AGHT+IG85bUY2TGtdUU0k7nmDZaddRK4qcnB44Hr/BLvuCFyQe0iwL4X2hrB4t7fuBEqPgsTiHr7jQ==
X-Received: by 2002:a17:902:ac8f:b0:1cc:b460:e6cc with SMTP id h15-20020a170902ac8f00b001ccb460e6ccmr3717355plr.12.1699996728371;
        Tue, 14 Nov 2023 13:18:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v15 11/19] scsi: sd_zbc: Only require an I/O scheduler if needed
Date:   Tue, 14 Nov 2023 13:16:19 -0800
Message-ID: <20231114211804.1449162-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
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
