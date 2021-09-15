Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D43DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:12:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651DA60FA0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237336AbhIOJNj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 05:13:39 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3811 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbhIOJNe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 05:13:34 -0400
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8ZDW6GNpz685Bk;
        Wed, 15 Sep 2021 17:10:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:12:14 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:12:12 +0100
From:   John Garry <john.garry@huawei.com>
To:     <linux@armlinux.org.uk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/3] fas216: kill scmd->tag
Date:   Wed, 15 Sep 2021 17:07:13 +0800
Message-ID: <1631696835-136198-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The driver is attempting to allocated a tag internally, which is
is no-go with blk-mq. Switch the driver to use the request tag and
kill usage of scmd->tag and scmd->device->current_tag.

Signed-off-by: Hannes Reinecke <hare@suse.de>
jpg: Change to use scsi_cmd_to_rq()
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/arm/fas216.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 9c4458a99025..cf71ef488e36 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -77,7 +77,6 @@
  *  I was thinking that this was a good chip until I found this restriction ;(
  */
 #define SCSI2_SYNC
-#undef  SCSI2_TAG
 
 #undef DEBUG_CONNECT
 #undef DEBUG_MESSAGES
@@ -990,7 +989,7 @@ fas216_reselected_intr(FAS216_Info *info)
 		info->scsi.disconnectable = 0;
 		if (info->SCpnt->device->id  == target &&
 		    info->SCpnt->device->lun == lun &&
-		    info->SCpnt->tag         == tag) {
+		    scsi_cmd_to_rq(info->SCpnt)->tag == tag) {
 			fas216_log(info, LOG_CONNECT, "reconnected previously executing command");
 		} else {
 			queue_add_cmd_tail(&info->queues.disconnected, info->SCpnt);
@@ -1791,8 +1790,9 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 	/*
 	 * add tag message if required
 	 */
-	if (SCpnt->tag)
-		msgqueue_addmsg(&info->scsi.msgs, 2, SIMPLE_QUEUE_TAG, SCpnt->tag);
+	if (SCpnt->device->simple_tags)
+		msgqueue_addmsg(&info->scsi.msgs, 2, SIMPLE_QUEUE_TAG,
+				scsi_cmd_to_rq(SCpnt)->tag);
 
 	do {
 #ifdef SCSI2_SYNC
@@ -1815,20 +1815,8 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 
 static void fas216_allocate_tag(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 {
-#ifdef SCSI2_TAG
-	/*
-	 * tagged queuing - allocate a new tag to this command
-	 */
-	if (SCpnt->device->simple_tags && SCpnt->cmnd[0] != REQUEST_SENSE &&
-	    SCpnt->cmnd[0] != INQUIRY) {
-	    SCpnt->device->current_tag += 1;
-		if (SCpnt->device->current_tag == 0)
-		    SCpnt->device->current_tag = 1;
-			SCpnt->tag = SCpnt->device->current_tag;
-	} else
-#endif
-		set_bit(SCpnt->device->id * 8 +
-			(u8)(SCpnt->device->lun & 0x7), info->busyluns);
+	set_bit(SCpnt->device->id * 8 +
+		(u8)(SCpnt->device->lun & 0x7), info->busyluns);
 
 	info->stats.removes += 1;
 	switch (SCpnt->cmnd[0]) {
@@ -2117,7 +2105,6 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	init_SCp(SCpnt);
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
 	/*
@@ -2223,7 +2210,6 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 	init_SCp(SCpnt);
 
 	info->stats.queues += 1;
-	SCpnt->tag = 0;
 
 	spin_lock(&info->host_lock);
 
@@ -3003,9 +2989,8 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
 		dev = &info->device[scd->id];
 		seq_printf(m, "     %d/%llu   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
-			seq_printf(m, "%3sabled(%3d) ",
-				     scd->simple_tags ? "en" : "dis",
-				     scd->current_tag);
+			seq_printf(m, "%3sabled ",
+				     scd->simple_tags ? "en" : "dis");
 		else
 			seq_puts(m, "unsupported   ");
 
-- 
2.26.2

