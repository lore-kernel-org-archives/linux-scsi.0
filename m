Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BA3C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536916141C
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245000AbhDURvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:52406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245096AbhDURtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 222CBB2FD;
        Wed, 21 Apr 2021 17:48:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/42] advansys: use SCSI result accessors
Date:   Wed, 21 Apr 2021 19:47:43 +0200
Message-Id: <20210421174749.11221-37-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert the driver to use SCSI result accessors.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 28748df36c2f..df6add4a2724 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -5980,7 +5980,8 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	/*
 	 * 'done_status' contains the command's ending status.
 	 */
-	scp->result = 0;
+	set_host_byte(scp, DID_OK);
+	set_status_byte(scp, SAM_STAT_GOOD);
 	switch (scsiqp->done_status) {
 	case QD_NO_ERROR:
 		ASC_DBG(2, "QD_NO_ERROR\n");
@@ -6731,7 +6732,8 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 	/*
 	 * 'qdonep' contains the command's ending status.
 	 */
-	scp->result = 0;
+	set_host_byte(scp, DID_OK);
+	set_status_byte(scp, SAM_STAT_GOOD);
 	switch (qdonep->d3.done_stat) {
 	case QD_NO_ERROR:
 		ASC_DBG(2, "QD_NO_ERROR\n");
@@ -6760,6 +6762,7 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  SCSI_SENSE_BUFFERSIZE);
 			}
+			set_status_byte(scp, qdonep->d3.scsi_stat);
 			break;
 
 		default:
-- 
2.29.2

