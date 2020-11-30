Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C43C83019
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE14B2076C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgK3CrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:17 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39710 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgK3CrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:16 -0500
Received: by mail-pg1-f195.google.com with SMTP id f17so9195871pge.6;
        Sun, 29 Nov 2020 18:47:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lkvYW585n0gw4FHLOeoVk4lRx4G25yxo/9FkfuXk+tM=;
        b=P/CS1B6mknzTb7+Kqz245lrJsHJ/xjOdwhuc/4O2lW9NPvIOrf7L/sOPRx4WN3pv9e
         l1ykkmU5WqTNkDf3dBDK6i175wHX11njGl4THeTS7KgsYLkecY227oUbcS1b/o6ZH9iG
         tTIxovTmUDTcP/Rc+qiU8Avtv9xN48sAUINncYjxZOhuSXlbmJlS/0z/GE/74hGK+YTn
         Jv2g4TMpCQXJA5Wgga+DsptUjTbDfAYUt/G3ZQPfyUsCVNxTbgQmeBrGZ1ZIj8/8v57Z
         Rnk4UwYgjTZXk07F5wo+EFsOssX05sNpcVEEAgxVGGkaPTpc7RHw8istfhdpiAnSdbAP
         nmJw==
X-Gm-Message-State: AOAM531ZqTvsNZcQUGrEr93jRBMgC/bAYZP1020JydvuHHTtR0VGfxw9
        dFTvSDeHwcPIMehHa+w450k=
X-Google-Smtp-Source: ABdhPJx0ilH2wM+f45myJ+MHvaNdFfxB7PAffN43zNaSwNk4K/5XpxS0CtlYRArG8QR67DlzuZ2lXg==
X-Received: by 2002:a63:4b1f:: with SMTP id y31mr9577098pga.29.1606704395241;
        Sun, 29 Nov 2020 18:46:35 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Stan Johnson <userm57@yahoo.com>
Subject: [PATCH v4 6/9] scsi_transport_spi: Set RQF_PM for domain validation commands
Date:   Sun, 29 Nov 2020 18:46:12 -0800
Message-Id: <20201130024615.29171-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Disable runtime power management during domain validation. Since a later
patch removes RQF_PREEMPT, set RQF_PM for domain validation commands such
that these are executed in the quiesced SCSI device state.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Woody Suwalski <terraluna977@gmail.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f3d5b1bbd5aa..c37dd15d16d2 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -117,12 +117,16 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		sshdr = &sshdr_tmp;
 
 	for(i = 0; i < DV_RETRIES; i++) {
+		/*
+		 * The purpose of the RQF_PM flag below is to bypass the
+		 * SDEV_QUIESCE state.
+		 */
 		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
 				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
-				      0, NULL);
+				      RQF_PM, NULL);
 		if (driver_byte(result) != DRIVER_SENSE ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -1005,23 +1009,26 @@ spi_dv_device(struct scsi_device *sdev)
 	 */
 	lock_system_sleep();
 
+	if (scsi_autopm_get_device(sdev))
+		goto unlock_system_sleep;
+
 	if (unlikely(spi_dv_in_progress(starget)))
-		goto unlock;
+		goto put_autopm;
 
 	if (unlikely(scsi_device_get(sdev)))
-		goto unlock;
+		goto put_autopm;
 
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
-		goto out_put;
+		goto put_sdev;
 
 	/* We need to verify that the actual device will quiesce; the
 	 * later target quiesce is just a nice to have */
 	if (unlikely(scsi_device_quiesce(sdev)))
-		goto out_free;
+		goto free_buffer;
 
 	scsi_target_quiesce(starget);
 
@@ -1041,12 +1048,16 @@ spi_dv_device(struct scsi_device *sdev)
 
 	spi_initial_dv(starget) = 1;
 
- out_free:
+free_buffer:
 	kfree(buffer);
- out_put:
+
+put_sdev:
 	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
-unlock:
+put_autopm:
+	scsi_autopm_put_device(sdev);
+
+unlock_system_sleep:
 	unlock_system_sleep();
 }
 EXPORT_SYMBOL(spi_dv_device);
