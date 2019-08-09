Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FF9C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D075B216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405250AbfHIDD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39973 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDD3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so45218661pfp.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C/uZkwG3cQ8sZBeTDh6AvIFhsMwtbgJm5swMRIBxCr4=;
        b=QXqr48RMnUqtikFDLUEdXA8+yYSZxlsnEWkdlTHJpOa49PREOG876EV2iGgpwLGm5z
         BY67unPt/vr+HXazeGD0EgVURyGrOZqoHdD3UC2m2ZOWnsoofNTX6jpk5yIQRRanquyD
         8GTGikbzp/P8+lH40ARVg2PLjyJ6nvPRRr5RJ4u5i2CaQyXeeJpIvta84hZ2MEvdzAz3
         7pzLtJLJQjiTxigHn2GyZ24h3JBh/rg26W/Mlx1J8YVJCFBzDeoAYWOM+aOmXT4EsKo5
         X5URl+B2SB2QaOvQeRWKtBiR0y+ewlMqSSvwsOQF6RpNvMw2SFPEbpmoLHPpN5ksrhcr
         6ikQ==
X-Gm-Message-State: APjAAAXrVAC6YZb6czj0Iv2/ZFT4ahk8jrk/fkkY5BPSK5yp9z8umUxq
        PGdBnREuU+Hb6AUN1CYtJj4=
X-Google-Smtp-Source: APXvYqwoyQvExc601m3+KiqnxE8JKnXMrlXqhYkqrNNzJjqLvi1b2xWdFK6dj5Jl3f9B279oU88Ujw==
X-Received: by 2002:a62:1c93:: with SMTP id c141mr19524679pfc.9.1565319808397;
        Thu, 08 Aug 2019 20:03:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 39/58] qla2xxx: Check secondary image if reading the primary image fails
Date:   Thu,  8 Aug 2019 20:02:00 -0700
Message-Id: <20190809030219.11296-40-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes several Coverity complaints about reading data that
has not been initialized.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5258d2486e25..a6a66b5d36a3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7562,8 +7562,12 @@ qla27xx_get_active_image(struct scsi_qla_host *vha,
 		goto check_sec_image;
 	}
 
-	qla24xx_read_flash_data(vha, (void *)(&pri_image_status),
-	    ha->flt_region_img_status_pri, sizeof(pri_image_status) >> 2);
+	if (qla24xx_read_flash_data(vha, (void *)(&pri_image_status),
+	    ha->flt_region_img_status_pri, sizeof(pri_image_status) >> 2) !=
+	    QLA_SUCCESS) {
+		WARN_ON_ONCE(true);
+		goto check_sec_image;
+	}
 	qla27xx_print_image(vha, "Primary image", &pri_image_status);
 
 	if (qla27xx_check_image_status_signature(&pri_image_status)) {
-- 
2.22.0

