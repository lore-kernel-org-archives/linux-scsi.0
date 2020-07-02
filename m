Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C61C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 14:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66532089D
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 14:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgGBOYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 10:24:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:43864 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgGBOYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Jul 2020 10:24:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 19898AB98;
        Thu,  2 Jul 2020 14:24:41 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: allow state transitions BLOCK -> BLOCK
Date:   Thu,  2 Jul 2020 16:24:36 +0200
Message-Id: <20200702142436.98336-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_transport_srp.c will call scsi_target_block() repeatedly
without calling scsi_target_unblock() first.
So allow the idempotent state transition BLOCK -> BLOCK to avoid
a warning here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1362f4f17dfd..55666e5ef151 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2322,6 +2322,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		switch (oldstate) {
 		case SDEV_RUNNING:
 		case SDEV_CREATED_BLOCK:
+		case SDEV_BLOCK:
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 			break;
-- 
2.16.4

