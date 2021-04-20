Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6C0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA3B61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhDTCO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:59 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:53827 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhDTCO4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:56 -0400
Received: by mail-pj1-f42.google.com with SMTP id nk8so5842532pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4u7CEhZwPwkwMecAFNNqAt5zws8JO0YJ75gzoFdeUOo=;
        b=AwgKEZiXjUBPAXsFmU3nurcc2gmV4qdc+h/+ncgyqW5xkpleKh0t9OgwBjGMO97BDD
         FIv99Ktmt9tfds9NE3EkYChjDXdauAQpI5RSCpGlhl2nPN5azVU4pRniev2C8TTshWmA
         bxcuFys1+TpufflKDZXYVmtMUSjncq1tdCI0l557wNV53reRuvznWWR6mrYoaLsEbGSX
         hsr6+w7MoG9KRhsk+Nw+AH2nZSLpZIpiYVuAD4ivukRshjZSHV3WhssFmv845IaASLmF
         DnnGgUbLCaNMwyKVaNCKelKMmrWrjB/FHceHH/x7Q0Rb4zNd139CaDQSux1fpDXu9hXc
         A1Gw==
X-Gm-Message-State: AOAM532Z2swbdEBBY7S+sffOzDMco2o5B2NAuRgYiH5vyp7JqzI6ggPt
        5Rn8oqqi73Hz6QDl4wxwueE=
X-Google-Smtp-Source: ABdhPJySMdLFFJgmVKUiXu6f7aH/Hcm2bcvZNtD0Tc+1O8Lt3yTvDd75Ae0c2SENZq4H+N61Zgdd8g==
X-Received: by 2002:a17:90b:19ca:: with SMTP id nm10mr2294171pjb.175.1618884865313;
        Mon, 19 Apr 2021 19:14:25 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 104/117] virtio-scsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:49 -0700
Message-Id: <20210420021402.27678-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index b9c86a7e3b97..bc937cc74f20 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -115,7 +115,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		"cmd %p response %u status %#02x sense_len %u\n",
 		sc, resp->response, resp->status, resp->sense_len);
 
-	sc->result = resp->status;
+	sc->status.combined = resp->status;
 	virtscsi_compute_resid(sc, virtio32_to_cpu(vscsi->vdev, resp->resid));
 	switch (resp->response) {
 	case VIRTIO_SCSI_S_OK:
@@ -336,7 +336,8 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
-	int result, inquiry_len, inq_result_len = 256;
+	int inquiry_len, inq_result_len = 256;
+	union scsi_status result;
 	char *inq_result = kmalloc(inq_result_len, GFP_KERNEL);
 
 	shost_for_each_device(sdev, shost) {
@@ -348,11 +349,12 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
+		result.combined =
+			scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, inquiry_len, NULL,
 					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
 
-		if (result == 0 && inq_result[0] >> 5) {
+		if (result.combined == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
 			scsi_remove_device(sdev);
 		} else if (host_byte(result) == DID_BAD_TARGET) {
