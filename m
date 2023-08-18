Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FDEEE49A1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379833AbjHRTqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346250AbjHRTqI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:46:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745934234;
        Fri, 18 Aug 2023 12:45:46 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bf1935f6c2so9101805ad.1;
        Fri, 18 Aug 2023 12:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387806; x=1692992606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzaYxnCqQNUVR3i3khEB0a4wN2TqC5S5bjyD6Ki8qwY=;
        b=akqkrTSFy0N40Hp2gF+Ri7ZxvGQoq7gibzEyQ45KfN0pyKyd7k5A71afP2GBMy62fC
         lMPwYJg3IFkWTgWUVtXaRDqq+qFLfX2ldkKpOe/X00IgCvgAYMZ0Dr6/tfAX7o/Lakdb
         Me4KJvnMaFIcUUrH9UvUvh02BLXscwqQkGEv0eraiyFNA6dJIgPzEkgZ+OtpizbxVuJ2
         M6YoG1pXHxMHK3bOnu7q7BRy8KfX8Bpy2QDrNPbjpXp6sDOcFp0fajNfPmtMVW4RPRA0
         ZUiZf8qo6UWoHyaXlYhD3mShpUJz7KdO6mgDnnoZzvABDW+NRSL9D/x32jV7MgF9SzYG
         Y6Eg==
X-Gm-Message-State: AOJu0Yzz4t8VwJCGJCeoKEKQOkrxlM8hFy77h81qToOg34/Y8UxM6C5k
        8YS3eQkmo4H0rRrSjJwWRBs=
X-Google-Smtp-Source: AGHT+IHAWW7ymWFXjV8zJ0Xl1YvuSwu8blcDtuhTdeE5FxGsNC0vGOoXyYGnyAWrfp5UY+zwgUE5SQ==
X-Received: by 2002:a17:902:da87:b0:1b4:5699:aac1 with SMTP id j7-20020a170902da8700b001b45699aac1mr291880plx.12.1692387805963;
        Fri, 18 Aug 2023 12:43:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:43:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 08/18] scsi: sd_zbc: Only require an I/O scheduler if needed
Date:   Fri, 18 Aug 2023 12:34:11 -0700
Message-ID: <20230818193546.2014874-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
