Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0C1C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJOAYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiJOAYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:40 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BD6115E
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:38 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id i3so6295195pfk.9
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3/UcHz4Yu/uLoBW7ZX3VNFRCJXoSeaQ3+8QJCWsGL0=;
        b=3Nww7lqHMLJlrAyr54vSJoRsq4xHV/8ffrOdxM5i/UWVHT/a7buoqG06KZI09LriTU
         zMhO32OazgrFKHynu8abeAYcl88uupRJzmOugdx7ZyueW5gsXev/vTLPj4z90lLEYnJm
         7UU6RIePuzVYIeA6VPPOpu1wEMi4MXxqGfdZLkOx8otF8fPs9ySN30WYGr5Edc1axCVi
         NOjSLVaJqEkoD8qu/aHguVrZ4DX+C/AR1jg79dlZ2CoIWOosIXQ1NEUZhMQF9r9T/ajH
         W4JP7pT7wMSgecnw+dwOgut7Vxe0rfrNrOPzx0rDaR1diC2LrAhCpljkDdmg+KRA26hP
         hniw==
X-Gm-Message-State: ACrzQf3kxkx8jk+pIiFz00GouzwFRS55ISExlqKnN+rYXhYRVhuwimuY
        UHxBWSJsVVoWFOFXdRJ+PaUJT9zwh6I=
X-Google-Smtp-Source: AMsMyM5gtK6+vrRhG4ZdTqCKFR/Tkbp6E+sfPRATFz+j7tN3vVYpj2S9cR8SzrJ8VlkyjOTyzRz3ww==
X-Received: by 2002:a65:674e:0:b0:43c:3b91:236e with SMTP id c14-20020a65674e000000b0043c3b91236emr427266pgu.510.1665793477951;
        Fri, 14 Oct 2022 17:24:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 5/8] scsi: core: Rework scsi_single_lun_run()
Date:   Fri, 14 Oct 2022 17:24:15 -0700
Message-Id: <20221015002418.30955-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use __starget_for_each_device() instead of open-coding
starget_for_each_device(). Run the queues asynchronously instead of
synchronously.

This patch removes code that calls scsi_device_put() from atomic context.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8b89fab7c420..fa96d3cfdfa3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -307,6 +307,18 @@ static void scsi_kick_queue(struct request_queue *q)
 	blk_mq_run_hw_queues(q, false);
 }
 
+/*
+ * Kick the queue of SCSI device @sdev if @sdev != current_sdev. Called with
+ * interrupts disabled.
+ */
+static void scsi_kick_sdev_queue(struct scsi_device *sdev, void *data)
+{
+	struct scsi_device *current_sdev = data;
+
+	if (sdev != current_sdev)
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 /*
  * Called for single_lun devices on IO completion. Clear starget_sdev_user,
  * and call blk_run_queue for all the scsi_devices on the target -
@@ -317,7 +329,6 @@ static void scsi_kick_queue(struct request_queue *q)
 static void scsi_single_lun_run(struct scsi_device *current_sdev)
 {
 	struct Scsi_Host *shost = current_sdev->host;
-	struct scsi_device *sdev, *tmp;
 	struct scsi_target *starget = scsi_target(current_sdev);
 	unsigned long flags;
 
@@ -334,22 +345,9 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 	scsi_kick_queue(current_sdev->request_queue);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (starget->starget_sdev_user)
-		goto out;
-	list_for_each_entry_safe(sdev, tmp, &starget->devices,
-			same_target_siblings) {
-		if (sdev == current_sdev)
-			continue;
-		if (scsi_device_get(sdev))
-			continue;
-
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_kick_queue(sdev->request_queue);
-		spin_lock_irqsave(shost->host_lock, flags);
-
-		scsi_device_put(sdev);
-	}
- out:
+	if (!starget->starget_sdev_user)
+		__starget_for_each_device(starget, current_sdev,
+					  scsi_kick_sdev_queue);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
