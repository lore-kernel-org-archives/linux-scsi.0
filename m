Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394C8C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21AF8611CA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 13:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFBNcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:32:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229876AbhFBNcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 09:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622640659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zs5thUCzzMflTBqmeziZ9dfRocubSyhR9ZnK5FyaX1o=;
        b=GKv/sYIUAKO/Ba+3jq59p7c9JPNfriLnL4b/eDpt4aMHnJ6UyK+wA08U59aOcC28nJIpGd
        EPjf4ijaV2o4hvVarFAIv2htOD4ndk4tNfgRaYCHvw6v56P9J6p7gkRCatEDjYVdAcd89T
        +A2AghDV+bhgeA2VWazzOcWJUaWJXlQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-GRmxQegLPBGwWfI5FF8yDA-1; Wed, 02 Jun 2021 09:30:58 -0400
X-MC-Unique: GRmxQegLPBGwWfI5FF8yDA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E8706D241;
        Wed,  2 Jun 2021 13:30:57 +0000 (UTC)
Received: from localhost (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 034EB687F6;
        Wed,  2 Jun 2021 13:30:52 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] scsi: core: put .shost_dev in failure path if host state becomes running
Date:   Wed,  2 Jun 2021 21:30:28 +0800
Message-Id: <20210602133029.2864069-4-ming.lei@redhat.com>
In-Reply-To: <20210602133029.2864069-1-ming.lei@redhat.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_host_dev_release() only works around for us by freeing
dev_name(&shost->shost_dev) when host state is SHOST_CREATED. After host
state is changed to SHOST_RUNNING, scsi_host_dev_release() doesn't do
that any more.

So fix the issue by put .shost_dev in failure path if host state becomes
running, meantime move get_device(&shost->shost_gendev) before
device_add(&shost->shost_dev), so that scsi_host_cls_release() can put
this reference.

Reported-by: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 796736e47764..7049844adb6b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -257,12 +257,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	device_enable_async_suspend(&shost->shost_dev);
 
+	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
 	if (error)
 		goto out_del_gendev;
 
-	get_device(&shost->shost_gendev);
-
 	if (shost->transportt->host_size) {
 		shost->shost_data = kzalloc(shost->transportt->host_size,
 					 GFP_KERNEL);
@@ -300,6 +299,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
  out_del_dev:
 	device_del(&shost->shost_dev);
  out_del_gendev:
+	/*
+	 * host state has become SHOST_RUNNING, so we have to release
+	 * ->shost_dev explicitly
+	 */
+	put_device(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
  out_disable_runtime_pm:
 	device_disable_async_suspend(&shost->shost_gendev);
-- 
2.29.2

