Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2805EC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0984060E0B
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 05:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhEaFJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 01:09:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229730AbhEaFJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 01:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622437672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11hZ8oqStTDk4oHLoKAP7tJ8yV9mSkaG4BFzoVIlql4=;
        b=Mt8iSkW6+Q3rk2yuJNHGfSGm3dSQ3NfuM+tjLJLa/qBWlknl4KILOdajV9eUev6YMvBEu2
        Ws+6vEHmOhF9nWEciPKli8g6ItOm6F5zZHnYYv5NRogG9TtZET952B+QxsMNi7o6D5EQHK
        jTxObGlpHL2NI8HksWozMElDTKvtQuY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-hUurNkc0OgOJo9P6Q4c4UA-1; Mon, 31 May 2021 01:07:50 -0400
X-MC-Unique: hUurNkc0OgOJo9P6Q4c4UA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45AA7801107;
        Mon, 31 May 2021 05:07:49 +0000 (UTC)
Received: from localhost (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80E79690EF;
        Mon, 31 May 2021 05:07:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 2/3] scsi: core: fix failure handling of scsi_add_host_with_dma
Date:   Mon, 31 May 2021 13:07:26 +0800
Message-Id: <20210531050727.2353973-3-ming.lei@redhat.com>
In-Reply-To: <20210531050727.2353973-1-ming.lei@redhat.com>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When scsi_add_host_with_dma() return failure, the caller will call
scsi_host_put(shost) to release everything allocated for this host
instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
otherwise double free will be caused.

Strictly speaking, these host resources allocation should have been
moved to scsi_host_alloc(), but the allocation may need driver's
info which can be built between calling scsi_host_alloc() and
scsi_add_host(), so just keep the allocations in
scsi_add_host_with_dma().

Fixes the problem by relying on host device's release handler to
release everything.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ada11e3ae577..6cbc3eb16525 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -279,23 +279,22 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 		if (!shost->work_q) {
 			error = -EINVAL;
-			goto out_free_shost_data;
+			goto out_del_dev;
 		}
 	}
 
 	error = scsi_sysfs_add_host(shost);
 	if (error)
-		goto out_destroy_host;
+		goto out_del_dev;
 
 	scsi_proc_host_add(shost);
 	scsi_autopm_put_host(shost);
 	return error;
 
- out_destroy_host:
-	if (shost->work_q)
-		destroy_workqueue(shost->work_q);
- out_free_shost_data:
-	kfree(shost->shost_data);
+	/*
+	 * any host allocation in this function will be freed in
+	 * scsi_host_dev_release, so don't free them in the failure path
+	 */
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
@@ -305,7 +304,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
-	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }
-- 
2.29.2

