Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A1DC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32248611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351339AbhERRrS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:47:18 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:45946 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245174AbhERRrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:47:11 -0400
Received: by mail-pg1-f177.google.com with SMTP id q15so7521699pgg.12
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S3d59RIMa2BhUQqIB9HkpiER7EhrQoJJ0TNsQqpTHho=;
        b=kmBBgaljBVomJuXxJjX5VKCdzwijtTcuS8rjaLcauJUNNINW8hjnSxQ/vSy+s48itR
         U+d+E2udcwwvUeWSpvdfeHSYMh7IVwCTIHQa/ykFvqTdu18gyGea+stINUC0gMVziSR5
         Ug/cY6PLxYtVl+R32IS9Eoz0BpDNB6SjPSjSKasoSr62ZMycygLConOBgLQ+gdyALm6/
         ITxLfhFd+UvuT2ttH+aV8SCR9/ZF7KSKFd68wBawXAvwuZRXKqbb2XMv8Za4kALMa8qr
         Z+NfNOHNkphdMwlumz2UT/Ae2tIFLeHSNQ7EvGkFRE+YEjc00LM+QdqXRymo458YSZjq
         usNw==
X-Gm-Message-State: AOAM5305jHrruvYhLh4N/j8fkb/tSGEZUp9Dv69loT5ba4t4q/r3K8fV
        W07PyqPegb4xuPIMvSFGRMz9OxSVQ99jgQ==
X-Google-Smtp-Source: ABdhPJyMEIe3OSQnYtejYXr0rxEAhsvYuokTsHfCWDFCPHg7lK8xHEqNzhQurDFL9Gygqk41Sjzw2A==
X-Received: by 2002:a63:4b18:: with SMTP id y24mr6191029pga.438.1621359953489;
        Tue, 18 May 2021 10:45:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 46/50] virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:46 -0700
Message-Id: <20210518174450.20664-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
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
