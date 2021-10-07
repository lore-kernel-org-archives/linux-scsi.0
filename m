Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D235C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B8561139
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbhJGUsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:24 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:40642 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbhJGUsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:23 -0400
Received: by mail-pl1-f174.google.com with SMTP id j15so4721057plh.7
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpMLKEAQ8ZkhXGCq5V3OlmKDQmWr8j5hk29K2ff1j4M=;
        b=tpQbJHDxLGfU3bGZJ8iHBKOp4B+mHMgTvGRC5qtGKUhfnDSlRQZgfE7cS5h6dTZ8kC
         NpItn+vsjpcx24Fo1JU8yDp/L8E3R7A23dU6l2wwACdZ+XfUhI03r+EKN/3suYFIo9wc
         ZEfSVgrywb8dtYn3qA0UYcgC+zSe6GTbVPTE7t9LFzzP0/kQZ3hZbQw73Mp6a8hxWjRV
         xP1LdTlWXlC05dNwKOQ7XNflRZureOzwnA2w+5Cn5GlsDgzwPoLrKzQIaLaYon/Kd8S5
         HiIEEtzGqx+XwW4o6twwTNyWALsGgtnT5hxYG3df96jaa4sxj+2CLfgo3qckaP07stgt
         PVJQ==
X-Gm-Message-State: AOAM531UvhL7DKcYmV3cjttuMlM9Ernctc4Dj4GTf83r3WReuFrLrZVr
        58rvitSlfs4zaUsl21VF0Ns=
X-Google-Smtp-Source: ABdhPJxH5b/IFGKG/P1zQFsOvi50LqQi2jJ7WFRYnbvkWd87ieZWxgGP2bhi2A7nzlxGE338VSfwrQ==
X-Received: by 2002:a17:902:8bc1:b0:13d:e884:125a with SMTP id r1-20020a1709028bc100b0013de884125amr5770975plo.38.1633639589018;
        Thu, 07 Oct 2021 13:46:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v3 76/88] virtio_scsi: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:02 -0700
Message-Id: <20211007204618.2196847-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
 
