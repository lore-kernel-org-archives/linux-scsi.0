Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6125FC43215
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4535F2073F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfKZJO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:14:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:41716 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727479AbfKZJO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 04:14:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E42F5BA1F;
        Tue, 26 Nov 2019 09:14:23 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/8] smartpqi: enable host tagset
Date:   Tue, 26 Nov 2019 10:14:15 +0100
Message-Id: <20191126091416.20052-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191126091416.20052-1-hare@suse.de>
References: <20191126091416.20052-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Enable host tagset for smartpqi; with this we can use the request
tag to look command from the pool avoiding the list iteration in
the hot path.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 38 ++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7b7ef3acb504..c17b533c84ad 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -575,17 +575,29 @@ static inline void pqi_reinit_io_request(struct pqi_io_request *io_request)
 }
 
 static struct pqi_io_request *pqi_alloc_io_request(
-	struct pqi_ctrl_info *ctrl_info)
+	struct pqi_ctrl_info *ctrl_info, struct scsi_cmnd *scmd)
 {
 	struct pqi_io_request *io_request;
+	unsigned int limit = PQI_RESERVED_IO_SLOTS;
 	u16 i = ctrl_info->next_io_request_slot;	/* benignly racy */
 
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
+		while (1) {
+			io_request = &ctrl_info->io_request_pool[i];
+			if (atomic_inc_return(&io_request->refcount) == 1)
+				break;
+			atomic_dec(&io_request->refcount);
+			i = (i + 1) % limit;
+		}
 	}
 
 	/* benignly racy */
@@ -4075,7 +4087,7 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 
 	atomic_inc(&ctrl_info->sync_cmds_outstanding);
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 
 	put_unaligned_le16(io_request->index,
 		&(((struct pqi_raid_path_request *)request)->request_id));
@@ -5032,7 +5044,9 @@ static inline int pqi_raid_submit_scsi_cmd(struct pqi_ctrl_info *ctrl_info,
 {
 	struct pqi_io_request *io_request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, scmd);
+	if (!io_request)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	return pqi_raid_submit_scsi_cmd_with_io_request(ctrl_info, io_request,
 		device, scmd, queue_group);
@@ -5230,7 +5244,10 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
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
@@ -5657,7 +5674,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct pqi_task_management_request *request;
 
-	io_request = pqi_alloc_io_request(ctrl_info);
+	io_request = pqi_alloc_io_request(ctrl_info, NULL);
 	io_request->io_complete_callback = pqi_lun_reset_complete;
 	io_request->context = &wait;
 
@@ -6504,6 +6521,7 @@ static struct scsi_host_template pqi_driver_template = {
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
+	.host_tagset = 1,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.16.4

