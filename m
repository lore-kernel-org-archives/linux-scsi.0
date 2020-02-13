Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AD4C3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 811EB218AC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgBMOF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:05:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:46212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbgBMOF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 09:05:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51362AF87;
        Thu, 13 Feb 2020 14:05:27 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/13] dpt_i2o: use scsi_host_complete_all_commands() to abort outstanding commands
Date:   Thu, 13 Feb 2020 15:04:12 +0100
Message-Id: <20200213140422.128382-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213140422.128382-1-hare@suse.de>
References: <20200213140422.128382-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rather than traversing all outstanding commands manually use the
scsi_host_complete_all_commands() helper to terminate all commands during
reset.
With that we can drop the cmd_list usage from the midlayer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/dpt_i2o.c | 20 +-------------------
 drivers/scsi/dpti.h    |  1 -
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index c30ace9f251e..ac27323ea135 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -817,7 +817,7 @@ static int adpt_hba_reset(adpt_hba* pHba)
 	}
 	pHba->state &= ~DPTI_STATE_RESET;
 
-	adpt_fail_posted_scbs(pHba);
+	scsi_host_complete_all_commands(pHba->host, DID_RESET);
 	return 0;	/* return success */
 }
 
@@ -2335,7 +2335,6 @@ static s32 adpt_scsi_host_alloc(adpt_hba* pHba, struct scsi_host_template *sht)
 	host->unique_id = (u32)sys_tbl_pa + pHba->unit;
 	host->sg_tablesize = pHba->sg_tablesize;
 	host->can_queue = pHba->post_fifo_size;
-	host->use_cmd_list = 1;
 
 	return 0;
 }
@@ -2646,23 +2645,6 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 	return 0;
 }
 
-static void adpt_fail_posted_scbs(adpt_hba* pHba)
-{
-	struct scsi_cmnd* 	cmd = NULL;
-	struct scsi_device* 	d = NULL;
-
-	shost_for_each_device(d, pHba->host) {
-		unsigned long flags;
-		spin_lock_irqsave(&d->list_lock, flags);
-		list_for_each_entry(cmd, &d->cmd_list, list) {
-			cmd->result = (DID_OK << 16) | (QUEUE_FULL <<1);
-			cmd->scsi_done(cmd);
-		}
-		spin_unlock_irqrestore(&d->list_lock, flags);
-	}
-}
-
-
 /*============================================================================
  *  Routines from i2o subsystem
  *============================================================================
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 3ec391134bb0..72293b8450b6 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -295,7 +295,6 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba);
 static s32 adpt_send_nop(adpt_hba*pHba,u32 m);
 static void adpt_i2o_delete_hba(adpt_hba* pHba);
 static void adpt_inquiry(adpt_hba* pHba);
-static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u64 lun);
 static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
-- 
2.16.4

