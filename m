Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B760CCA473
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 19:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiF3T51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236020AbiF3T5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 15:57:19 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950CB4505D
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:57:18 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id go6so527334pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:57:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tdhxj9S6ner+YcYKbqTbN5cq18Icg6VtwCC5orIZL2E=;
        b=NcG9fwPjs6g+Du99meyYOK5LQtN3BrJACIxvyFJHc0TURlugxD32XUA0WK5zT45MHN
         bZh1Lw+jDFGsA5bmykqans5H2YtyuPnXelCsDAz/skjdLbSy15RycaxaUoQIRh+lM/vh
         58fb0SHfyBr2iIfGavz/Zzb7XUN+637dyfJgIveztxPR2z0HUFoMM1nZOF+4L6xJbXQ9
         m2ebri/Sm9AWhODbNKX/tijSOeOTcHdJaIZDjeEG/niFXdIDu8Gs9giGzqCANvg9ec8u
         MFUnAYWBu1CUsNbU3dvsSLVhqVKdKX4p6nTjK6Niu4DggFYlTFLg+vo/MTouH0FplYHC
         k9sg==
X-Gm-Message-State: AJIora/OKi6D+RfMGY9E7tdnhppSG8l0yAAE06N1F+9eItkKeMfZ7Su0
        yDF9xOWHssJwBrsiModD4gQ=
X-Google-Smtp-Source: AGRyM1tYOEr2jGA3l0KbUfo/I0lPvrZpHpTF9qkW3kF4IUN/lFBeYlDmubsiU8xfFYUlbPaJVWh5eA==
X-Received: by 2002:a17:902:d145:b0:16a:25e:d4ef with SMTP id t5-20020a170902d14500b0016a025ed4efmr17521876plt.162.1656619038033;
        Thu, 30 Jun 2022 12:57:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x1-20020a17090300c100b0016a33177d3csm13789452plc.160.2022.06.30.12.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:57:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/2] scsi: core: Move the definition of SCSI_QUEUE_DELAY
Date:   Thu, 30 Jun 2022 12:57:02 -0700
Message-Id: <20220630195703.10155-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630195703.10155-1-bvanassche@acm.org>
References: <20220630195703.10155-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the definition of SCSI_QUEUE_DELAY to just above the function that
uses it.

Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6ffc9e4258a8..2aca0a838ca5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -75,13 +75,6 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 	return ret;
 }
 
-/*
- * When to reinvoke queueing after a resource shortage. It's 3 msecs to
- * not change behaviour from the previous unplug mechanism, experimentation
- * may prove this needs changing.
- */
-#define SCSI_QUEUE_DELAY	3
-
 static void
 scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 {
@@ -1648,6 +1641,13 @@ static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 	sbitmap_put(&sdev->budget_map, budget_token);
 }
 
+/*
+ * When to reinvoke queueing after a resource shortage. It's 3 msecs to
+ * not change behaviour from the previous unplug mechanism, experimentation
+ * may prove this needs changing.
+ */
+#define SCSI_QUEUE_DELAY 3
+
 static int scsi_mq_get_budget(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
