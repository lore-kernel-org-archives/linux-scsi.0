Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF981C432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 12:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE192077B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 12:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKOM2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 07:28:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:57704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbfKOM2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 07:28:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0389BB1AA;
        Fri, 15 Nov 2019 12:28:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] dpt_i2o: use midlayer tcq implementation
Date:   Fri, 15 Nov 2019 13:27:54 +0100
Message-Id: <20191115122757.132006-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191115122757.132006-1-hare@suse.de>
References: <20191115122757.132006-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to use the SCSI midlayer TCQ implementation and drop the
use of the scsi command list.
And switch to use the SAM status codes while we're at it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dpt_i2o.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index abc74fd474dc..f13e5d6649ae 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2335,7 +2335,6 @@ static s32 adpt_scsi_host_alloc(adpt_hba* pHba, struct scsi_host_template *sht)
 	host->unique_id = (u32)sys_tbl_pa + pHba->unit;
 	host->sg_tablesize = pHba->sg_tablesize;
 	host->can_queue = pHba->post_fifo_size;
-	host->use_cmd_list = 1;
 
 	return 0;
 }
@@ -2647,20 +2646,18 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 	return 0;
 }
 
-static void adpt_fail_posted_scbs(adpt_hba* pHba)
+static bool fail_posted_scbs_iter(struct scsi_cmnd *cmd,
+				  void *data, bool reserved)
 {
-	struct scsi_cmnd* 	cmd = NULL;
-	struct scsi_device* 	d = NULL;
+	cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
+	cmd->scsi_done(cmd);
 
-	shost_for_each_device(d, pHba->host) {
-		unsigned long flags;
-		spin_lock_irqsave(&d->list_lock, flags);
-		list_for_each_entry(cmd, &d->cmd_list, list) {
-			cmd->result = (DID_OK << 16) | (QUEUE_FULL <<1);
-			cmd->scsi_done(cmd);
-		}
-		spin_unlock_irqrestore(&d->list_lock, flags);
-	}
+	return true;
+}
+
+static void adpt_fail_posted_scbs(adpt_hba* pHba)
+{
+	scsi_host_busy_iter(pHba->host, fail_posted_scbs_iter, NULL);
 }
 
 
-- 
2.16.4

