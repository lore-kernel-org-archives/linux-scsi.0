Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55106C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDDF6112F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 19:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbhHETUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 15:20:33 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:44554 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242897AbhHETUc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 15:20:32 -0400
Received: by mail-pj1-f44.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11979041pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 12:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pn1VtD1tYrSQKn6a7r5bpjdxUKUUURP2YmONsgIBodw=;
        b=F+ds0CF5/NM3AaEX4o4xJ7qbcO1D5TJIYKycK8skgWtkrFFrs4hrDUpJ+DDcE+4mjC
         Aldwwe/PYV/q9fbKfh0mlxJ6p7A2X1TlvQmLgPxa1mVKGBy1659924Sgq8RnW76zDepG
         BiC0WmfLbdmf+KWZWBmAbT4xFbol8sOLxA2svDsZfDwVrdSux9k9FsOuG8rtWfBwek3T
         JrBEi0GivrtpgBSQXo1HJL8up00KPFKyRWhLA1B/BNc7/j4PHqZgtez3XZCAFYbF39CW
         k1aT2rD1d3mlIY7VtSiyp39r6wHZE8vlcWEnzm2d78plJ9Aum2WFbhro6VF2Gnq/Xass
         4Ylw==
X-Gm-Message-State: AOAM530Eb5gHovdvDmFmHO2LgN8+BKgOAZR4w9bKPp8AY6w0mH4hyKhW
        JIxxHG1JKAqrciPQt3WBNUQ=
X-Google-Smtp-Source: ABdhPJwGun3JNpImYNZW9KXc5yEkqFRnXeyEvxLO7siFw7BR++5EOccqD35pg8Kn8ET64o3CyoNiZg==
X-Received: by 2002:a63:c14a:: with SMTP id p10mr180481pgi.311.1628191216731;
        Thu, 05 Aug 2021 12:20:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:93c2:eaf5:530d:627d])
        by smtp.gmail.com with ESMTPSA id t1sm8859429pgr.65.2021.08.05.12.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 12:20:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 48/52] virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Thu,  5 Aug 2021 12:18:24 -0700
Message-Id: <20210805191828.3559897-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210805191828.3559897-1-bvanassche@acm.org>
References: <20210805191828.3559897-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b0deaf4af5a3..c25ce8f0e0af 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -519,7 +519,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 				    struct virtio_scsi_cmd_req_pi *cmd_pi,
 				    struct scsi_cmnd *sc)
 {
-	struct request *rq = sc->request;
+	struct request *rq = scsi_cmd_to_rq(sc);
 	struct blk_integrity *bi;
 
 	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi, sc);
@@ -543,7 +543,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
 static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
 						  struct scsi_cmnd *sc)
 {
-	u32 tag = blk_mq_unique_tag(sc->request);
+	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(sc));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
 
 	return &vscsi->req_vqs[hwq];
