Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AB8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 896786140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347207AbhI2WKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:08 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:40562 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347221AbhI2WKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:10:00 -0400
Received: by mail-pl1-f172.google.com with SMTP id j15so2523285plh.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpMLKEAQ8ZkhXGCq5V3OlmKDQmWr8j5hk29K2ff1j4M=;
        b=vunwuc4SYhPU2rPOB8LfgNeOJEfSL+cUJgbhv17wij/ppW4T+fnzsZtb/evnYixiHZ
         g52IXzqNfjeiZ+iyNWlzf0XpHBX/rwlxenbbCFIhjG5VL3LQd5X7HXXUbiZ4qlgDPYWH
         XGP/sB4sQipTuUSz8ExhYhBSMi9jrqGjCBbmUfwm79kp9R80V1As1WtlM2Pc9pQNelQ/
         2mQZ4ah8dEYM6CHLdrFogtdPUv5+JBDRZQXpxL0bxHHx5SKkxFhzUxRgtwUnYay+jtod
         tW3SSoQiuQmCmwQFiARrzpBaIJp7M0Ffn6YveaYRE6GWrSYNJRCnPVZKwtXthcdp46Wv
         onBA==
X-Gm-Message-State: AOAM531PfoUhW3IA/6G4PQXzQaNFEySXaPjyCQmumDhlba4NOzHGSs1O
        BQJDHAX2VqGtL7x5Z3RgiyQ=
X-Google-Smtp-Source: ABdhPJx747don92fxcYsjtBpuygt+do66tUzSgZuRLWRcaFmN2/ry0UKzRWNc1a9LCEWGUzlN8iDRw==
X-Received: by 2002:a17:903:1247:b0:139:f1af:c044 with SMTP id u7-20020a170903124700b00139f1afc044mr923871plh.23.1632953298274;
        Wed, 29 Sep 2021 15:08:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 75/84] virtio_scsi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:51 -0700
Message-Id: <20210929220600.3509089-76-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 
