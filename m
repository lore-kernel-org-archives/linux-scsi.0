Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84137C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 21:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiF3Vhq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 17:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbiF3Vhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 17:37:46 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F0452389
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:45 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso4048430pjz.0
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruy+HzkJh5fyvvy7vygnAW78d3wREw7aR0/vgCotARc=;
        b=rvV5BooFaJJhI6v3cS9fWzjvDEIRUZqWigculuUuYZdxwJESu/mVwPIO1f4flrsq6+
         xek6sG9f13zXQ/Z1hD1AQ0Cjp/C0NSBCHsRYSgObeAA5fuonm9neBqRf9bEDuS1xBeBK
         15ZX4EGLEwUQz3fC8XyBCscLTOuavkhb7QQ9k90eQ8D/67UGWmoYhtDNr9zDlO0NAk+x
         01UWeWasdYknfP2rWsIUWfp9WpyI9puHYSxW6CjlA/uox4F+gV/leoqFo9PgeIzQJN47
         KtK6CRl9DdpmfvPgcxC6H8mOXQrqI8u7qdk8M6q8xs7YeCCL4z8UO66wAi8FUggn/Gnz
         5UWg==
X-Gm-Message-State: AJIora+XOwKKDcXN+dZ0kwghI6fez5NY9z3VIckPvBXyURG7XYu9P06s
        ZXCGMDsfYGbQkg+evdkX7G0=
X-Google-Smtp-Source: AGRyM1uhuboo0hA4QEo/25C/K1WRq2HQVMmp0NWXycuCldKvBFWxeP5ERcFlA+2W+9/491ebZQJjJw==
X-Received: by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id h8-20020a170902f70800b00153839fbf2cmr17451066plo.113.1656625064970;
        Thu, 30 Jun 2022 14:37:44 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id mt18-20020a17090b231200b001e0899052f1sm2484701pjb.3.2022.06.30.14.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 14:37:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 2/3] scsi: Make scsi_forget_host() wait for request queue removal
Date:   Thu, 30 Jun 2022 14:37:32 -0700
Message-Id: <20220630213733.17689-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630213733.17689-1-bvanassche@acm.org>
References: <20220630213733.17689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for freeing the host tag set earlier by making scsi_forget_host()
wait until all activity on the host tag set has stopped.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5c3bb4ceeac3..c8331ccdde95 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1961,6 +1961,16 @@ void scsi_scan_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_scan_host);
 
+/**
+ * scsi_forget_host() - Remove all SCSI devices from a host.
+ * @shost: SCSI host to remove devices from.
+ *
+ * Removes all SCSI devices that have not yet been removed. For the SCSI devices
+ * for which removal started before scsi_forget_host(), wait until the
+ * associated request queue has reached the "dead" state. In that state it is
+ * guaranteed that no new requests will be allocated and also that no requests
+ * are in progress anymore.
+ */
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
@@ -1970,8 +1980,21 @@ void scsi_forget_host(struct Scsi_Host *shost)
  restart:
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
-		if (sdev->sdev_state == SDEV_DEL)
+		if (sdev->sdev_state == SDEV_DEL &&
+		    blk_queue_dead(sdev->request_queue)) {
 			continue;
+		}
+		if (sdev->sdev_state == SDEV_DEL) {
+			get_device(&sdev->sdev_gendev);
+			spin_unlock_irq(shost->host_lock);
+
+			while (!blk_queue_dead(sdev->request_queue))
+				msleep(10);
+
+			spin_lock_irq(shost->host_lock);
+			put_device(&sdev->sdev_gendev);
+			goto restart;
+		}
 		spin_unlock_irq(shost->host_lock);
 		__scsi_remove_device(sdev);
 		goto restart;
