Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BECC433EB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4982070B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgFJRdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:33:39 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbgFJRdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 13:33:36 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4331E5A829A4F59AED6D;
        Thu, 11 Jun 2020 01:33:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 11 Jun 2020 01:33:20 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>, <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v7 08/12] scsi: Add template flag 'host_tagset'
Date:   Thu, 11 Jun 2020 01:29:15 +0800
Message-ID: <1591810159-240929-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Add a host template flag 'host_tagset' so hostwide tagset can be
shared on multiple reply queues after the SCSI device's reply queue
is converted to blk-mq hw queue.

Signed-off-by: Hannes Reinecke <hare@suse.com>
jpg: Update comment on can_queue
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/scsi_lib.c  | 2 ++
 include/scsi/scsi_host.h | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0ba7a65e7c8d..0652acdcec22 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1894,6 +1894,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	tag_set->driver_data = shost;
+	if (shost->hostt->host_tagset)
+		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
 
 	return blk_mq_alloc_tag_set(tag_set);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 46ef8cccc982..9b7e333a681d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -436,6 +436,9 @@ struct scsi_host_template {
 	/* True if the controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
+	/* True if the host uses host-wide tagspace */
+	unsigned host_tagset:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -603,7 +606,8 @@ struct Scsi_Host {
 	 *
 	 * Note: it is assumed that each hardware queue has a queue depth of
 	 * can_queue. In other words, the total queue depth per host
-	 * is nr_hw_queues * can_queue.
+	 * is nr_hw_queues * can_queue. However, for when host_tagset is set,
+	 * the total queue depth is can_queue.
 	 */
 	unsigned nr_hw_queues;
 	unsigned active_mode:2;
-- 
2.26.2

