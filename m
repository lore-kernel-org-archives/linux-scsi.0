Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2167C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCBD260551
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhEaFX0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 01:23:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhEaFXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 01:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622438506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6jn5R/szg4G/9zdVuyITzIJcU5AWehqbSYIrM4R7wpA=;
        b=ZS1AHG+6y0RXbXo8YRsU6m95xCcykUNW35IQ+C/0Lzwbzwp104Emo/lsNZNYVpPe/ZC5ve
        tJDx5YTtUNdEf5ZXkR9pILSqWD1ourZ/4Q9c4Z+a8RZuoDv2ir+gsYJ46doY2WBCUQY5gW
        WC+KXR00lobmQ9VQN7TFhJl6yxHY6vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-VO0WuawdM9S8dzUWRQ8vVw-1; Mon, 31 May 2021 01:21:41 -0400
X-MC-Unique: VO0WuawdM9S8dzUWRQ8vVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A9E3FCB2;
        Mon, 31 May 2021 05:21:40 +0000 (UTC)
Received: from T590 (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E37B421F;
        Mon, 31 May 2021 05:21:33 +0000 (UTC)
Date:   Mon, 31 May 2021 13:21:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V4 1/3] scsi: core: use put_device() to release host
Message-ID: <YLRyWTFXKIT2R8vK@T590>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <20210531050727.2353973-2-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531050727.2353973-2-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From 2a70cffeca09156faf68d933157586b5bf9278fa Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Mon, 31 May 2021 11:02:01 +0800
Subject: [PATCH V4 1/3] scsi: core: use put_device() to release host

After device is initialized via device_initialize(), or its name is
set via dev_set_name(), the device has to be freed via put_device(),
otherwise device name will be leaked because it is allocated
dynamically in dev_set_name().

Fixes the issue by replacing kfree(shost) via two put_device() since
both .shost_dev and .shost_gendev share same lifetime. Meantime move
get_device(shost->shost_gendev) from scsi_add_host_with_dma to
scsi_host_alloc(), so that we can grab parent's refcnt explicitly when
assigning .shost_dev->parent. With this way code becomes more readable.

Also call put_device(dev->parent) in scsi_host_cls_release() so that
code readability can be improved.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V4:
	- avoid to touch un-initialized device instance

 drivers/scsi/hosts.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 624e2582c3df..181a5d6e3c7b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -55,7 +55,7 @@ static DEFINE_IDA(host_index_ida);
 
 static void scsi_host_cls_release(struct device *dev)
 {
-	put_device(&class_to_shost(dev)->shost_gendev);
+	put_device(dev->parent);
 }
 
 static struct class shost_class = {
@@ -261,8 +261,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	if (error)
 		goto out_del_gendev;
 
-	get_device(&shost->shost_gendev);
-
 	if (shost->transportt->host_size) {
 		shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL);
@@ -391,8 +389,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	mutex_init(&shost->scan_mutex);
 
 	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
-	if (index < 0)
-		goto fail_kfree;
+	if (index < 0) {
+		kfree(shost);
+		return NULL;
+	}
 	shost->host_no = index;
 
 	shost->dma_channel = 0xff;
@@ -473,7 +473,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
-	shost->shost_dev.parent = &shost->shost_gendev;
+	shost->shost_dev.parent = get_device(&shost->shost_gendev);
 	shost->shost_dev.class = &shost_class;
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
 	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
@@ -502,8 +502,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	kthread_stop(shost->ehandler);
  fail_index_remove:
 	ida_simple_remove(&host_index_ida, shost->host_no);
- fail_kfree:
-	kfree(shost);
+	/* free host instance */
+	put_device(&shost->shost_dev);
+	put_device(&shost->shost_gendev);
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_host_alloc);
-- 
2.29.2

