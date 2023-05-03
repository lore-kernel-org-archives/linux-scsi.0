Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6B0C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 23:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjECXHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 19:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjECXHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 19:07:13 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AAF76AB
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 16:07:12 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-63b7096e2e4so4637466b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 16:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155232; x=1685747232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnPj3As1BLCvYTNotGGdgTWKfSzRv6KWsftC61e+pwY=;
        b=Qmo8DpsaCQ3mau3RXP8q+bH6WoTN42d/t57uEC89ACbVfWpcae4FIWodueiYz5TJuu
         YY7JxXquWKBi3Q844dhG8mrZvKMptOL6jdE7q+F6PKBDjUhfFKWKnK77dUbikHb1+klA
         kxYTg6HAOmSdV9DXu8UZjm8HJogloFggU1EuQyMXRcYzDurRayp347yt7CYQZAuBkS6T
         G753rcH+Bq9PWglurGApjdLRX3YPIZ2EPZevEaRI68i+AXTcXZz9AwZG/EdhKCbVHwdB
         1hIESjXujgR6nAXxo5/96JJG9y4/lh146i2sEdZKgNG49aTu4HVG5pgZWY+07qHBDNYv
         89xQ==
X-Gm-Message-State: AC+VfDwo/QTVZSzGYFQ1YLrfUyyY5JxD/D6IrbFLa1rELDnZC7ewqqqk
        OQoyv+vUkGb+VKOD7CsEpjw=
X-Google-Smtp-Source: ACHHUZ6UPloZGQef0RaUsL5I/j5qK9jdT5XJsy+YzIOmmwiX6u7DGBIjVcxAcHb63lXk7B5F35u/5w==
X-Received: by 2002:a05:6a00:15c8:b0:62a:63e6:3282 with SMTP id o8-20020a056a0015c800b0062a63e63282mr282057pfu.11.1683155232009;
        Wed, 03 May 2023 16:07:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2c3b:81e:ce21:2437])
        by smtp.gmail.com with ESMTPSA id u3-20020a056a00158300b0063f3aac78b9sm19531603pfk.79.2023.05.03.16.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:07:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 5/5] scsi: core: Delay running the queue if the host is blocked
Date:   Wed,  3 May 2023 16:06:54 -0700
Message-ID: <20230503230654.2441121-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
In-Reply-To: <20230503230654.2441121-1-bvanassche@acm.org>
References: <20230503230654.2441121-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tell the block layer to rerun the queue after a delay instead of
immediately if the SCSI LLD decided to block the host.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a34390d35f1d..370be5994a45 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1772,7 +1772,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	case BLK_STS_RESOURCE:
 	case BLK_STS_ZONE_RESOURCE:
-		if (scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev) || shost->host_self_blocked)
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	case BLK_STS_AGAIN:
