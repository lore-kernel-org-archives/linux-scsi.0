Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26324C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B9E613C5
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhENVgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:36:47 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:42533 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbhENVgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:36:37 -0400
Received: by mail-pl1-f182.google.com with SMTP id v13so94347ple.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+BoxzK18WDiATfbb117226xoMEe0eHeSjJScLd24Qys=;
        b=FI2/rKCguoo0wjwRLU9B20o7w++psGQTvbwBrbrwYyKyuz+QWqfd+9NmnQlMs7c0lF
         V9OeOUeWUTMQ7lH3bGB1XNuRqHmejjNu531OVRlC6FMsqBLfndGf+hM8lMd13MaiMSc1
         3qha4KzLdQJIFxR2V9G3GggvNTLTdqIMZWkt+4pkqaa7KI2spEM//KLfH3cDSt+pVh1i
         1QrewiC7uLszgUOYve7N70G+yRfQPRxOLytfb5+CXS5gNjpA4CXpnq2Uslz4mxD+Q1dm
         T4/MvUEC0teNGmCZ9f5+w/ENDrnWIQDa8qpWIZXTgRgVeDKiOM+g9V7AmQM1bxg1Awla
         pkjg==
X-Gm-Message-State: AOAM531bEcW5AN6rjen0/Ow5OS0wnsN7FkWd3zlzCU46F7YtqAeUfNAr
        S40hWftCwo5yuPqZoCr3OOE=
X-Google-Smtp-Source: ABdhPJwtEG+7t4OOyH6jy/3kNHe4rISHGdIdEutFSEXy4WgwQpbu8PSSq5sWRbzeN6/LI5PTIwscXA==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr55338283pjb.213.1621028124876;
        Fri, 14 May 2021 14:35:24 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:35:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 46/50] virtio_scsi: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:01 -0700
Message-Id: <20210514213356.5264-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9c86a7e3b97..a7cd82d5620f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -521,7 +521,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 				    struct virtio_scsi_cmd_req_pi *cmd_pi,
 				    struct scsi_cmnd *sc)
 {
-	struct request *rq = sc->request;
+	struct request *rq = blk_req(sc);
 	struct blk_integrity *bi;
 
 	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi, sc);
@@ -545,7 +545,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
 						  struct scsi_cmnd *sc)
 {
-	u32 tag = blk_mq_unique_tag(sc->request);
+	u32 tag = blk_mq_unique_tag(blk_req(sc));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
 
 	return &vscsi->req_vqs[hwq];
