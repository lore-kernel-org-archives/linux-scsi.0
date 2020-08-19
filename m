Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AF6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC97D20897
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgHSP1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:27:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9851 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726894AbgHSPZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 97823174EF24E6297F9B;
        Wed, 19 Aug 2020 23:25:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:54 +0800
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
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 18/18] smartpqi: enable host tagset
Date:   Wed, 19 Aug 2020 23:20:36 +0800
Message-ID: <1597850436-116171-19-git-send-email-john.garry@huawei.com>
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

From: Hannes Reinecke <hare@suse.de>

Enable host tagset for smartpqi; with this we can use the request
tag to look command from the pool avoiding the list iteration in
the hot path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
[jpg: Mod ctrl_info->next_io_request_slot calc]
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 45 ++++++++++++++++++---------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index bd38c8cea56e..870ed1400a9e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -575,22 +575,33 @@ static inline void pqi_reinit_io_request(struct pqi_io_request *io_request)
 }
 
 static struct pqi_io_request *pqi_alloc_io_request(
-	struct pqi_ctrl_info *ctrl_info)
+	struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	struct pqi_io_request *io_request;
-	u16 i = ctrl_info->next_io_request_slot;	/* benignly racy */
+	unsigned int limit = PQI_RESERVED_IO_SLOTS;
+	u16 i;
 
-	while (1) {
+	if (scmd) {
+		u32 blk_tag = blk_mq_unique_tag(scmd->request);
+
+		i = blk_mq_unique_tag_to_tag(blk_tag) + limit;
 		io_request = &ctrl_info->io_request_pool[i];
-		if (atomic_inc_return(&io_request->refcount) == 1)
-			break;
-		atomic_dec(&io_request->refcount);
-		i = (i + 1) % ctrl_info->max_io_slots;
+		if (WARN_ON(atomic_inc_return(&io_request->refcount) > 1)) {
+			atomic_dec(&io_request->refcount);
+			return NULL;
+		}
+	} else {
+		i = ctrl_info->next_io_request_slot;	/* benignly racy */
+		while (1) {
+			io_request = &ctrl_info->io_request_pool[i];
+			if (atomic_inc_return(&io_request->refcount) == 1)
+				break;
+			atomic_dec(&io_request->refcount);
+			i = (i + 1) % limit;
+		}
+		ctrl_info->next_io_request_slot = (i + 1) % limit;
 	}
 
-	/* benignly racy */
-	ctrl_info->next_io_request_slot = (i + 1) % ctrl_info->max_io_slots;
-
 	pqi_reinit_io_request(io_request);
 
 	return io_request;
@@ -4075,7 +4086,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	atomic_inc(&ctrl_info->sync_cmds_outstanding);
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 
 	put_unaligned_le16(io_request->index,
 		&(((struct pqi_raid_path_request *)request)->request_id));
@@ -5032,7 +5043,9 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 {
 	struct pqi_io_request *io_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	return pqi_raid_submit_scsi_cmd_with_io_request(ctrl_info, io_request,
 		device, scmd, queue_group);
@@ -5230,7 +5243,10 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_io_request *io_request;
 	struct pqi_aio_path_request *request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	io_request->io_complete_callback = pqi_aio_io_complete;
 	io_request->scmd = scmd;
 	io_request->raid_bypass = raid_bypass;
@@ -5657,7 +5673,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct pqi_task_management_request *request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
 
@@ -6504,6 +6520,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
+	.host_tagset = 1,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.26.2

