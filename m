Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D406C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 21:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbiF3Vhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 17:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235422AbiF3Vho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 17:37:44 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078D852395
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:44 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id w24so704561pjg.5
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdPo0AGtAKzj7cgayrchgsMnlGLIIHjbow2/bR1BTH8=;
        b=NmawTTtga41MoYLiEbH+51jHdjpdIYBYSeDopcZ4V4ZCkJM+Dk7AEFpseGC2nsyLa0
         WOiqKE7gO1uu6J+FLBdQMGFmMzIEcWVfr1hA0+yNn/q5hgMq6MmOdr7u8qy5/vUdlXBa
         d7JFGZPNOWcIy0u8Aiwu5R9+BVW5La1S1I8ECWEsO8l1tcLHVJ/jaK62jA6EXZVVEwPF
         46+oCgbr+2t9EQABF+FsZpgstd3lW0OFu1lsSr4PfVM0/pLGW963jCiGTLrOGEkG6L3K
         rGDuCbbCbkrCpJ1834WYomoW90egNZhtrDGdQlRaiREZjjEoSf8YZvkaNSnmh2pbOiG/
         I6Bg==
X-Gm-Message-State: AJIora+Z38GMancC2Qj5wI4q4ZBMYCssfktTumieeJhgsfxrzpaMBdkb
        RAWG1lIxFwtRkPqNpeKMI5c=
X-Google-Smtp-Source: AGRyM1t/mQNFtmkXkI6PT+n7QNzUP6gLWJCBwHkF72lupx6jYwI4NYcdyjT+PAALDfLtUM8uvO8OvQ==
X-Received: by 2002:a17:90b:278e:b0:1ee:f086:9c9d with SMTP id pw14-20020a17090b278e00b001eef0869c9dmr13956369pjb.182.1656625063389;
        Thu, 30 Jun 2022 14:37:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id mt18-20020a17090b231200b001e0899052f1sm2484701pjb.3.2022.06.30.14.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 14:37:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/3] scsi: Simplify scsi_forget_host()
Date:   Thu, 30 Jun 2022 14:37:31 -0700
Message-Id: <20220630213733.17689-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630213733.17689-1-bvanassche@acm.org>
References: <20220630213733.17689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_forget_host() has only one caller, namely scsi_remove_host(). That
function may sleep. Additionally, scsi_forget_host() calls a function
that may sleep (__scsi_remove_device()). Simplify scsi_forget_host() by
removing support for saving and restoring the interrupt state.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a6682..5c3bb4ceeac3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1964,17 +1964,18 @@ EXPORT_SYMBOL(scsi_scan_host);
 void scsi_forget_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
-	unsigned long flags;
+
+	might_sleep();
 
  restart:
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->sdev_state == SDEV_DEL)
 			continue;
-		spin_unlock_irqrestore(shost->host_lock, flags);
+		spin_unlock_irq(shost->host_lock);
 		__scsi_remove_device(sdev);
 		goto restart;
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irq(shost->host_lock);
 }
 
