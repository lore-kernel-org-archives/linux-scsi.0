Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11DAC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF846109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhDTAKx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:53 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:45646 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbhDTAKh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:37 -0400
Received: by mail-pj1-f52.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so15266798pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tDv2Pt5GfFmpgE06V3b0Lu85dw/Q4yR+fT581QmRIEo=;
        b=o/ewW9jUroN5eudNqYg4rE0BxLoLiRziZFSnuIIVKPAhFEzOt3xySn5iZNnakoom7w
         EGnEJvYlv5I7QRg/HhmCqS3sqVQQQHc4jfkqAxlRjlgp3cYXLLNTfnNza5lAVOu7ULeB
         6x2qNQHDex62eurI/4Na/wIWzrlrRlZe/yLaay2zM2xF+RoMtdt+QS2zzOAnQzQwo08S
         AcKgaqCKSmAFNN5glA4YIh61EstbKoybZGNzG71px33PkdbkypjvAI4EYKA6GXbJBWH2
         WQUKZEGYRDIxlJ5kOQKdKpakMpLQydfS1DX0uW2Aa4LTq6333LXmKALzpbD4GE4g0+9l
         diaQ==
X-Gm-Message-State: AOAM5306I+RODyw2FOXmzlaVRCSTwI4dnerIhdetTLXxugQvQViwz7Wz
        sMh8eG7BM+DBCTsmWzeKtCM=
X-Google-Smtp-Source: ABdhPJzVQbyFEt/A7MV3HZDppza6d8ZGSS2ey0wJ0JmeTsLf3XhTJhseC30IdHqTaEKw7aFMbOpDUQ==
X-Received: by 2002:a17:90b:60a:: with SMTP id gb10mr1817316pjb.71.1618877405640;
        Mon, 19 Apr 2021 17:10:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 064/117] sas: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:52 -0700
Message-Id: <20210420000845.25873-65-bvanassche@acm.org>
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

Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_scsi_host.c | 8 ++++----
 drivers/scsi/scsi_transport_sas.c   | 7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 0be979caf7e3..efa0ef958ed3 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -94,7 +94,7 @@ static void sas_end_task(struct scsi_cmnd *sc, struct sas_task *task)
 		}
 	}
 
-	sc->result = (hs << 16) | stat;
+	sc->status.combined = (hs << 16) | stat;
 	ASSIGN_SAS_TASK(sc, NULL);
 	sas_free_task(task);
 }
@@ -170,7 +170,7 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* If the device fell off, no sense in issuing commands */
 	if (test_bit(SAS_DEV_GONE, &dev->state)) {
-		cmd->result = DID_BAD_TARGET << 16;
+		cmd->status.combined = DID_BAD_TARGET << 16;
 		goto out_done;
 	}
 
@@ -195,9 +195,9 @@ int sas_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	ASSIGN_SAS_TASK(cmd, NULL);
 	sas_free_task(task);
 	if (res == -SAS_QUEUE_FULL)
-		cmd->result = DID_SOFT_ERROR << 16; /* retry */
+		cmd->status.combined = DID_SOFT_ERROR << 16; /* retry */
 	else
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 out_done:
 	cmd->scsi_done(cmd);
 	return 0;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index c9abed8429c9..2caa1393cf94 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1229,13 +1229,14 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	char *buffer = kzalloc(BUF_SIZE, GFP_KERNEL), *msdata;
 	struct sas_end_device *rdev = sas_sdev_to_rdev(sdev);
 	struct scsi_mode_data mode_data;
-	int res, error;
+	union scsi_status res;
+	int error;
 
 	if (!buffer)
 		return -ENOMEM;
 
-	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
-			      &mode_data, NULL);
+	res.combined = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ,
+				       3, &mode_data, NULL);
 
 	error = -EINVAL;
 	if (!scsi_status_is_good(res))
