Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A497AC433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDCD208A9
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgHSPZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:25:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728758AbgHSPZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E2FC13F36854AB68B766;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:51 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 12/18] scsi: Add host and host template flag 'host_tagset'
Date:   Wed, 19 Aug 2020 23:20:30 +0800
Message-ID: <1597850436-116171-13-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Add Host and host template flag 'host_tagset' so hostwide tagset can be
shared on multiple reply queues after the SCSI device's reply queue is
converted to blk-mq hw queue.

Tested-by: Don Brace<don.brace@microsemi.com> #SCSI resv cmds patches used
Signed-off-by: Hannes Reinecke <hare@suse.com>
[jpg: Update comment on .can_queue and add Scsi_Host.host_tagset]
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hosts.c     | 1 +
 drivers/scsi/scsi_lib.c  | 2 ++
 include/scsi/scsi_host.h | 9 ++++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 37d1c5565d90..2f162603876f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -421,6 +421,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->no_write_same = sht->no_write_same;
+	shost->host_tagset = sht->host_tagset;
 
 	if (shost_eh_deadline == -1 || !sht->eh_host_reset_handler)
 		shost->eh_deadline = -1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7c6dd6f75190..cdef5d1777cb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1891,6 +1891,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	tag_set->flags |=
 		BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
 	tag_set->driver_data = shost;
+	if (shost->host_tagset)
+		tag_set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
 
 	return blk_mq_alloc_tag_set(tag_set);
 }
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 46ef8cccc982..701f178b20ae 100644
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
@@ -634,6 +638,9 @@ struct Scsi_Host {
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
+	/* True if the host uses host-wide tagspace */
+	unsigned host_tagset:1;
+
 	/* Host responded with short (<36 bytes) INQUIRY result */
 	unsigned short_inquiry:1;
 
-- 
2.26.2

