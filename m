Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0CDC4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E17F610C8
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhEaFJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 01:09:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhEaFJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 01:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622437668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jXZD1O17xzElkKa2DNt6bLljbj9EZi8T5Af4aOsGUWM=;
        b=aulNjKglP8eKIXmncDA4kmTEJmX9BAJ0FQC+PUGAwBKT+BRDUlUmpPCXOi5SjCWjt3rkRr
        p3EcIhGRorfP/4oq8g1A/EvRs+EnklFNcC1parpEafJb8L+5KEJtFI1Z2qFoNV4pSc3xoH
        +upMJ7OBqzsa1T2hzSShEWmBmkDzS2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-EWZrsa-tMiaheJ7wHZvhrg-1; Mon, 31 May 2021 01:07:44 -0400
X-MC-Unique: EWZrsa-tMiaheJ7wHZvhrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B35A180FD65;
        Mon, 31 May 2021 05:07:43 +0000 (UTC)
Received: from localhost (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F3D612C82;
        Mon, 31 May 2021 05:07:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 1/3] scsi: core: use put_device() to release host
Date:   Mon, 31 May 2021 13:07:25 +0800
Message-Id: <20210531050727.2353973-2-ming.lei@redhat.com>
In-Reply-To: <20210531050727.2353973-1-ming.lei@redhat.com>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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
 drivers/scsi/hosts.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 624e2582c3df..ada11e3ae577 100644
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
@@ -473,7 +471,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->shost_gendev.type = &scsi_host_type;
 
 	device_initialize(&shost->shost_dev);
-	shost->shost_dev.parent = &shost->shost_gendev;
+	shost->shost_dev.parent = get_device(&shost->shost_gendev);
 	shost->shost_dev.class = &shost_class;
 	dev_set_name(&shost->shost_dev, "host%d", shost->host_no);
 	shost->shost_dev.groups = scsi_sysfs_shost_attr_groups;
@@ -503,7 +501,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
  fail_index_remove:
 	ida_simple_remove(&host_index_ida, shost->host_no);
  fail_kfree:
-	kfree(shost);
+	put_device(&shost->shost_dev);
+	put_device(&shost->shost_gendev);
+
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_host_alloc);
-- 
2.29.2

