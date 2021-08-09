Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB7FC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C86BE60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhHIXFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:46 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:35436 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbhHIXFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:44 -0400
Received: by mail-pj1-f46.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so1522749pjs.0
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pn1VtD1tYrSQKn6a7r5bpjdxUKUUURP2YmONsgIBodw=;
        b=PxdmI41YqQkiWPlNjfs/NSWCFVn6bAdbWVHZCj5Yn1nZiUmaf+6Ffs+ghB8l33pJfW
         cK/+9e1BoxpbpAgt7H7zwigVsKEl97ki0mzz/v3Uj96MGUCwqccGPDBb2UaeUjYwmQED
         p+WYHosN3u8vBkhqahtI+UfyiD+iE8sE8qj2RzIwkuW5b/n3rv0YfJeAqUbIrL/xwIp4
         TCQmpR39NpUFVB6dxx61AKtGLWiQPVS57M8PQgoUyBAl4FCRFnEcuGmXX1gutp+bmK4V
         PAxrwcDYB7KuKIoS8edMei1E5w88IZ/foNhsDTh13DVFaptHZ7Zg5FCYhy+FicYjXWgE
         sE6A==
X-Gm-Message-State: AOAM5331j/RuUJfM3GzVekRu6/WtL0S4JqFJ5Mifo2FyJxTABi3wW/tJ
        gajU+U4JSCUyi24nH0c0pr4=
X-Google-Smtp-Source: ABdhPJzX8rNlN9tnaXEwT01nFtafh1e0nEfTC23JQ28e9iA6wGZGgNvhm4GtA9BGG2dTv03caTGBOg==
X-Received: by 2002:a17:90a:e00b:: with SMTP id u11mr1502090pjy.166.1628550323252;
        Mon, 09 Aug 2021 16:05:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 48/52] virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:51 -0700
Message-Id: <20210809230355.8186-49-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
