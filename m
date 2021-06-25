Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9302C2B9F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 17:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92FB76194F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Jun 2021 17:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFYRGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Jun 2021 13:06:01 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3320 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhFYRGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2021 13:06:01 -0400
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GBNS74xbPz6G8LK;
        Sat, 26 Jun 2021 00:56:07 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 19:03:38 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 18:03:35 +0100
From:   John Garry <john.garry@huawei.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hch@lst.de>, <hare@suse.de>,
        <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: Delete scsi_{get,free}_host_dev()
Date:   Sat, 26 Jun 2021 00:58:34 +0800
Message-ID: <1624640314-93055-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Functions scsi_{get,free}_host_dev() no longer have any in-tree users, so
delete them.

Signed-off-by: John Garry <john.garry@huawei.com>
---
An alt agenda of this patch is to get clarification on whether this API
should be used for Hannes' reserved commands series.

Originally the recommendation was to use it, but now it seems to be to
not use it:
https://lore.kernel.org/linux-scsi/55918d68-7385-0153-0bd9-d822d3ce4c21@suse.de/

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b059bf2b61d4..8e52ce545af3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1896,60 +1896,3 @@ void scsi_forget_host(struct Scsi_Host *shost)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-/**
- * scsi_get_host_dev - Create a scsi_device that points to the host adapter itself
- * @shost: Host that needs a scsi_device
- *
- * Lock status: None assumed.
- *
- * Returns:     The scsi_device or NULL
- *
- * Notes:
- *	Attach a single scsi_device to the Scsi_Host - this should
- *	be made to look like a "pseudo-device" that points to the
- *	HA itself.
- *
- *	Note - this device is not accessible from any high-level
- *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach.
- */
-struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev = NULL;
-	struct scsi_target *starget;
-
-	mutex_lock(&shost->scan_mutex);
-	if (!scsi_host_scan_allowed(shost))
-		goto out;
-	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
-	if (!starget)
-		goto out;
-
-	sdev = scsi_alloc_sdev(starget, 0, NULL);
-	if (sdev)
-		sdev->borken = 0;
-	else
-		scsi_target_reap(starget);
-	put_device(&starget->dev);
- out:
-	mutex_unlock(&shost->scan_mutex);
-	return sdev;
-}
-EXPORT_SYMBOL(scsi_get_host_dev);
-
-/**
- * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
- * @sdev: Host device to be freed
- *
- * Lock status: None assumed.
- *
- * Returns:     Nothing
- */
-void scsi_free_host_dev(struct scsi_device *sdev)
-{
-	BUG_ON(sdev->id != sdev->host->this_id);
-
-	__scsi_remove_device(sdev);
-}
-EXPORT_SYMBOL(scsi_free_host_dev);
-
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 75363707b73f..bc9c45ced145 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -797,16 +797,6 @@ void scsi_host_busy_iter(struct Scsi_Host *,
 
 struct class_container;
 
-/*
- * These two functions are used to allocate and free a pseudo device
- * which will connect to the host adapter itself rather than any
- * physical device.  You must deallocate when you are done with the
- * thing.  This physical pseudo-device isn't real and won't be available
- * from any high-level drivers.
- */
-extern void scsi_free_host_dev(struct scsi_device *);
-extern struct scsi_device *scsi_get_host_dev(struct Scsi_Host *);
-
 /*
  * DIF defines the exchange of protection information between
  * initiator and SBC block device.
-- 
2.26.2

