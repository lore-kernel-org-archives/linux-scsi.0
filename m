Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7D3C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B1C6109E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 08:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbhHSIku (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 04:40:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58178 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhHSIkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 04:40:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D48101F782;
        Thu, 19 Aug 2021 08:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629362412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7UkffNLqE4A6uragP9kl/8Eq7y8tkgLqc9mh0wmOjUM=;
        b=wcf/L9LFe4DJlbagcngkzw/Tsiozujh6P6SkNrRgribVJU7ZWXD47ZvdNSvzDMtkkh7eKj
        cOQ4uJxu3hLxWmtxXpEVH65tIIH4Z07nOIZirls1he26mi3ipAV16VxJzlxFMeJpEKI5R4
        Zk6iPwIJnzZpV4jKHBhqS/19yAsQG1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629362412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7UkffNLqE4A6uragP9kl/8Eq7y8tkgLqc9mh0wmOjUM=;
        b=Zcoj/IdvTzqa7/iIISpsr4iHEs1Mdnj07itnqDYnPX0FJ3DnGKpT0wjgqwWmUM94oLvhng
        cpYB3+fZQPUFAtCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2B74AA3B9E;
        Thu, 19 Aug 2021 08:40:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6C643518D261; Thu, 19 Aug 2021 10:40:12 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] fas216: kill scmd->tag
Date:   Thu, 19 Aug 2021 10:40:05 +0200
Message-Id: <20210819084007.79233-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819084007.79233-1-hare@suse.de>
References: <20210819084007.79233-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is attempting to allocated a tag internally, which is
is no-go with blk-mq. Switch the driver to use the request tag and
kill usage of scmd->tag and scmd->device->current_tag.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/fas216.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 6baa9b36367d..1752a29fdb3c 100644
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
+		    scsi_cmd_to_tag(info->SCpnt) == tag) {
 			fas216_log(info, LOG_CONNECT, "reconnected previously executing command");
 		} else {
 			queue_add_cmd_tail(&info->queues.disconnected, info->SCpnt);
@@ -1790,8 +1789,9 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 	/*
 	 * add tag message if required
 	 */
-	if (SCpnt->tag)
-		msgqueue_addmsg(&info->scsi.msgs, 2, SIMPLE_QUEUE_TAG, SCpnt->tag);
+	if (SCpnt->device->simple_tags)
+		msgqueue_addmsg(&info->scsi.msgs, 2, SIMPLE_QUEUE_TAG,
+				scsi_cmd_to_tag(SCpnt));
 
 	do {
 #ifdef SCSI2_SYNC
@@ -1814,20 +1814,8 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 
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
@@ -2116,7 +2104,6 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	init_SCp(SCpnt);
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
 	/*
@@ -2222,7 +2209,6 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 	init_SCp(SCpnt);
 
 	info->stats.queues += 1;
-	SCpnt->tag = 0;
 
 	spin_lock(&info->host_lock);
 
@@ -3002,9 +2988,8 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
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
2.29.2

