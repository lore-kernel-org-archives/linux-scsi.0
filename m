Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AB6C47083
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1994361159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhEXDMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:12:00 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:41728 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhEXDLy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:54 -0400
Received: by mail-pl1-f170.google.com with SMTP id z4so11714560plg.8
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S3d59RIMa2BhUQqIB9HkpiER7EhrQoJJ0TNsQqpTHho=;
        b=VklYJS6daubBgHrZGhlOtkMbUIoG2Trqv4Ldw2a2/2xrjue0myw9SORf6RV5biyhyg
         QnhznNwl0gElvdqaFAKhmaDZsh4bEKxKTMQTBeSZgXMGZs4tpCDOivgkGgfSoglI5ztn
         e+mdsmTWfV2D99Cj7CurGGsko6eMIw35gTm6h84E3MMDsA+BQrQbiB+VUlClDvs6RE3V
         be9yzA3VufOjq6zALXpII/N5fX5FMWrjYmDzgNs1iFUoV5T+qy4fOQ+4QU7sl4gsmJEP
         V59ymtH3owZ6GtyJEPDIgCW+FxUPmD6rlSA2UnDmGmHtvFq8AaykayOnry5hoWP+xeYX
         MScQ==
X-Gm-Message-State: AOAM531qHZ95pn9f7GB5WtbkmY6F1YgJxYw8B4I+sdqcRX+3Ij11KcED
        +CfcWYZpZ5gLWJhPNuOA/Uk=
X-Google-Smtp-Source: ABdhPJwrPPugEa6iAIReBVjvOtjFnLiOAnG2QqasmUEx7q1BnyII6bCIXwvrGZ6GKi046vLsZA8EUQ==
X-Received: by 2002:a17:90a:dc82:: with SMTP id j2mr22937060pjv.138.1621825825234;
        Sun, 23 May 2021 20:10:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 47/51] virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:52 -0700
Message-Id: <20210524030856.2824-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9c86a7e3b97..8ae4b8441519 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -521,7 +521,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 				    struct virtio_scsi_cmd_req_pi *cmd_pi,
 				    struct scsi_cmnd *sc)
 {
-	struct request *rq = sc->request;
+	struct request *rq = scsi_cmd_to_rq(sc);
 	struct blk_integrity *bi;
 
 	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi, sc);
@@ -545,7 +545,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
 						  struct scsi_cmnd *sc)
 {
-	u32 tag = blk_mq_unique_tag(sc->request);
+	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(sc));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
 
 	return &vscsi->req_vqs[hwq];
