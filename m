Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7B7C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 12:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595C8207DD
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 12:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfKOM2N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 07:28:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:57696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727359AbfKOM2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 07:28:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03C62B1B0;
        Fri, 15 Nov 2019 12:28:10 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] dpt_i2o: rename adpt_i2o_to_scsi() to adpt_i2o_scsi_complete()
Date:   Fri, 15 Nov 2019 13:27:55 +0100
Message-Id: <20191115122757.132006-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191115122757.132006-1-hare@suse.de>
References: <20191115122757.132006-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the badly named function into adpt_i2o_scsi_complete(),
and make it a void function as the return value is never used.
This also fixes a potential use-after free as the return value
might be evaluated from the command result after the command
has been freed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dpt_i2o.c | 5 ++---
 drivers/scsi/dpti.h    | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index f13e5d6649ae..06ec090d5c46 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2173,7 +2173,7 @@ static irqreturn_t adpt_isr(int irq, void *dev_id)
 						 readl(reply + 12) - 1);
 			if(cmd != NULL){
 				scsi_dma_unmap(cmd);
-				adpt_i2o_to_scsi(reply, cmd);
+				adpt_i2o_scsi_complete(reply, cmd);
 			}
 		}
 		writel(m, pHba->reply_port);
@@ -2340,7 +2340,7 @@ static s32 adpt_scsi_host_alloc(adpt_hba* pHba, struct scsi_host_template *sht)
 }
 
 
-static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
+static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd)
 {
 	adpt_hba* pHba;
 	u32 hba_status;
@@ -2458,7 +2458,6 @@ static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 	if(cmd->scsi_done != NULL){
 		cmd->scsi_done(cmd);
 	} 
-	return cmd->result;
 }
 
 
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 42b1e28b5884..3ec391134bb0 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -286,7 +286,7 @@ static s32 adpt_i2o_status_get(adpt_hba* pHba);
 static s32 adpt_i2o_init_outbound_q(adpt_hba* pHba);
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
-static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
+static void adpt_i2o_scsi_complete(void __iomem *reply, struct scsi_cmnd *cmd);
 static s32 adpt_scsi_host_alloc(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
-- 
2.16.4

