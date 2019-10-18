Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3673CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 14:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C045321925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 14:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408322AbfJROGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:06:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:51560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390337AbfJROED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 10:04:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 269A3B250;
        Fri, 18 Oct 2019 14:04:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Martin Wilck <martin.wilck@suse.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH] scsi: fixup scsi_device_from_queue()
Date:   Fri, 18 Oct 2019 16:03:55 +0200
Message-Id: <20191018140355.108106-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After commit 8930a6c20791 ("scsi: core: add support for request batching")
scsi_device_from_queue() will not work for devices implementing the
new scsi_mq_ops_no_commit template.
Hence multipath is not able to detect the underlying scsi devices
and multipath startup will fail.

Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c1c2998297b2..cd3e21a0098c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1924,7 +1924,8 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = NULL;
 
-	if (q->mq_ops == &scsi_mq_ops)
+	if (q->mq_ops == &scsi_mq_ops ||
+	    q->mq_ops == &scsi_mq_ops_no_commit)
 		sdev = q->queuedata;
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		sdev = NULL;
-- 
2.16.4

