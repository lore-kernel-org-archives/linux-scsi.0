Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76456C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F0D3613D6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFBNcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:32:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50273 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhFBNci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622640655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20YYFLVaa8L5M/MJszhr1uRhV900ACMgcrFhUGBNHoU=;
        b=LDwcf/pJ9CUX0gnIlHnawKuYyiM4BFZzmhP9ImfkCcoUWwcQxwnuF6TNPkUQpnHXvIqtiQ
        s3ZgW9Z4aHD9iLknhal3y3QHl0YOpW1GVGdfP3OF7CqrphaO3OKxl0KvDXVWLoiPvYDsGe
        Fz/8yDQ6/sFCqGOdHFvCATycfgp70aA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-f-3EOdzhOIGDhMdQB1NX8g-1; Wed, 02 Jun 2021 09:30:51 -0400
X-MC-Unique: f-3EOdzhOIGDhMdQB1NX8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C19B719251A4;
        Wed,  2 Jun 2021 13:30:50 +0000 (UTC)
Received: from localhost (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB945620DE;
        Wed,  2 Jun 2021 13:30:46 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] scsi: core: fix failure handling of scsi_add_host_with_dma
Date:   Wed,  2 Jun 2021 21:30:27 +0800
Message-Id: <20210602133029.2864069-3-ming.lei@redhat.com>
In-Reply-To: <20210602133029.2864069-1-ming.lei@redhat.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
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
index 25cf76e73595..796736e47764 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -281,23 +281,22 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
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
@@ -307,7 +306,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
-	scsi_mq_destroy_tags(shost);
  fail:
 	return error;
 }
-- 
2.29.2

