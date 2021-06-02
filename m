Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477F5C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29948611CA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFBNca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhFBNca (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622640647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E0clE7oUgmYprbx5VRb/XN2QBzVz2hh0Wwbt0Jz64fQ=;
        b=Z9ujpTD11NXpSzeIgqw174Xne0KAiVCBg5ExGrEeqSh1/SwXYeOjouxs7RyhRu7WH3k58h
        +1u53oRrQp2vsksWbqk92Jmgsc/yoIgAtX7lxrZFFDcRJ/GWQErTSopdW4TsD7auT7ueEC
        vN0LMDVxCpFNmAtk/K9wegZ04OAeDwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-fV73b7dYPcmhbceHLxgfmw-1; Wed, 02 Jun 2021 09:30:46 -0400
X-MC-Unique: fV73b7dYPcmhbceHLxgfmw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9446F6D241;
        Wed,  2 Jun 2021 13:30:44 +0000 (UTC)
Received: from localhost (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F88819D9B;
        Wed,  2 Jun 2021 13:30:40 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi: core: fix error handling of scsi_host_alloc
Date:   Wed,  2 Jun 2021 21:30:26 +0800
Message-Id: <20210602133029.2864069-2-ming.lei@redhat.com>
In-Reply-To: <20210602133029.2864069-1-ming.lei@redhat.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After device is initialized via device_initialize(), or its name is
set via dev_set_name(), the device has to be freed via put_device(),
otherwise device name will be leaked because it is allocated
dynamically in dev_set_name().

Fixes the issue by replacing kfree(shost) via put_device(&shost->shost_gendev)
which can help to free dev_name(&shost->shost_dev) when host state is
in SHOST_CREATED. Meantime needn't to remove IDA and stop the kthread of
shost->ehandler in the error handling code.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 624e2582c3df..25cf76e73595 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -391,8 +391,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
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
@@ -484,7 +486,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_index_remove;
+		goto fail;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -493,17 +495,18 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	if (!shost->tmf_work_q) {
 		shost_printk(KERN_WARNING, shost,
 			     "failed to create tmf workq\n");
-		goto fail_kthread;
+		goto fail;
 	}
 	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
+ fail:
+	/*
+	 * host state is still SHOST_CREATED, and it is enough to release
+	 * ->shost_gendev since scsi_host_dev_release() can help to free
+	 * dev_name(&shost->shost_dev)
+	 */
+	put_device(&shost->shost_gendev);
 
- fail_kthread:
-	kthread_stop(shost->ehandler);
- fail_index_remove:
-	ida_simple_remove(&host_index_ida, shost->host_no);
- fail_kfree:
-	kfree(shost);
 	return NULL;
 }
 EXPORT_SYMBOL(scsi_host_alloc);
-- 
2.29.2

