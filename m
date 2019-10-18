Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E03CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 13:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF125222BD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 13:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633957AbfJRNzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 09:55:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:47268 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2633933AbfJRNzk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 09:55:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8996B1E4;
        Fri, 18 Oct 2019 13:55:38 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH] scsi_dh_alua: Do not run STPG for implicit ALUA
Date:   Fri, 18 Oct 2019 15:55:37 +0200
Message-Id: <20191018135537.69462-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a target only supports implicit ALUA sending a SET TARGET PORT GROUPS
command is not only pointless, but might actually cause issues.
So don't.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4971104b1817..0053277721d0 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -832,6 +832,10 @@ static void alua_rtpg_work(struct work_struct *work)
 		if (err != SCSI_DH_OK)
 			pg->flags &= ~ALUA_PG_RUN_STPG;
 	}
+	/* Do not run STPG if only implicit ALUA is supported */
+	if (scsi_device_tpgs(sdev) == TPGS_MODE_IMPLICIT)
+		pg->flags &= ~ALUA_PG_RUN_STPG;
+
 	if (pg->flags & ALUA_PG_RUN_STPG) {
 		pg->flags &= ~ALUA_PG_RUN_STPG;
 		spin_unlock_irqrestore(&pg->lock, flags);
-- 
2.16.4

