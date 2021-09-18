Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F131BC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCAA1610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345095AbhIRAKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:38 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:34606 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbhIRAJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:44 -0400
Received: by mail-pl1-f172.google.com with SMTP id o8so7248167pll.1
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpMLKEAQ8ZkhXGCq5V3OlmKDQmWr8j5hk29K2ff1j4M=;
        b=E+E6VqJi8xn8pdukGZmyG44QMQN3/11NCijuxb28qGIcguufGuaQ4VpbCUF5N65/qC
         3PGqmOXveznQYdSm9tYjTyn2egkLXNM6bMMunc7N8D2CzTfifqVDwP8I6sQrAepuF4K1
         iZp49inp/XBqTs78hvJURnVVisOY3Cl4/zFuHxKCGgpuonwJvYf39XA6Gwi3+vLomTZ9
         DRBjjcpmW3L4lw39mE+7N1UX2L91Bxex4PWkZlf/XSfUwaUmpr40NpfOnWV89E8wOTVb
         XgBPp9fM1hLH3eN9Ea6oG7lanwMnbGO9Q1bPhDZO4CAPfyUeTDX4dgo43lnSOl639nVj
         /BsA==
X-Gm-Message-State: AOAM533Zep8CWNGUb74LDnwXypFCsb5EqeyKlWXYUKxTpJLHkQDMNtkZ
        73liFZSXu1dawdLt2gaLwk0=
X-Google-Smtp-Source: ABdhPJzi08fqIwub0D5BAFeHP3MQZMpil0f7x/JvSMm4L9J7qOMlXtHGMrL9Z34A08GzDxCCbPWybg==
X-Received: by 2002:a17:903:41cd:b0:13c:87ab:d58d with SMTP id u13-20020a17090341cd00b0013c87abd58dmr11927165ple.55.1631923702049;
        Fri, 17 Sep 2021 17:08:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 75/84] virtio_scsi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:58 -0700
Message-Id: <20210918000607.450448-76-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly. Additionally, update a comment that refers to the
REQ_ATOM_COMPLETE flag since that flag has been removed a long time ago.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c25ce8f0e0af..574195cbd5c3 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -163,7 +163,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 			     VIRTIO_SCSI_SENSE_SIZE));
 	}
 
-	sc->scsi_done(sc);
+	scsi_done(sc);
 }
 
 static void virtscsi_vq_done(struct virtio_scsi *vscsi,
@@ -619,9 +619,8 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	 * we're using independent interrupts (e.g. MSI).  Poll the
 	 * virtqueues once.
 	 *
-	 * In the abort case, sc->scsi_done will do nothing, because
-	 * the block layer must have detected a timeout and as a result
-	 * REQ_ATOM_COMPLETE has been set.
+	 * In the abort case, scsi_done() will do nothing, because the
+	 * command timed out and hence SCMD_STATE_COMPLETE has been set.
 	 */
 	virtscsi_poll_requests(vscsi);
 
