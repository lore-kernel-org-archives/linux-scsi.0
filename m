Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B8CC83013
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 11:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FA4C22206
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 11:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388286AbgLBLyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 06:54:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:38736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbgLBLy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 06:54:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1A2FFAD63;
        Wed,  2 Dec 2020 11:53:04 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 13/34] qla4xxx: use standard SAM status definitions
Date:   Wed,  2 Dec 2020 12:52:28 +0100
Message-Id: <20201202115249.37690-14-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201202115249.37690-1-hare@suse.de>
References: <20201202115249.37690-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Use standard SAM status definitions and drop the
driver-defined ones.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h  | 1 -
 drivers/scsi/qla4xxx/ql4_isr.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index b9142464d3f0..4e1764df0a73 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -1181,7 +1181,6 @@ struct status_entry {
 	uint32_t handle;	/* 04-07 */
 
 	uint8_t scsiStatus;	/* 08 */
-#define SCSI_CHECK_CONDITION		  0x02
 
 	uint8_t iscsiFlags;	/* 09 */
 #define ISCSI_FLAG_RESIDUAL_UNDER	  0x02
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index a51910ae9525..6f0e77dc2a34 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -182,7 +182,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 		cmd->result = DID_OK << 16 | scsi_status;
 
-		if (scsi_status != SCSI_CHECK_CONDITION)
+		if (scsi_status != SAM_STAT_CHECK_CONDITION)
 			break;
 
 		/* Copy Sense Data into sense buffer. */
-- 
2.16.4

