Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F967C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 08:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6556B206C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 08:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgFVI4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:56:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:47138 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgFVI4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 04:56:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8AC9DB16B;
        Mon, 22 Jun 2020 08:56:42 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Only return started requests from scsi_host_find_tag()
Date:   Mon, 22 Jun 2020 08:30:22 +0200
Message-Id: <20200622063022.67891-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_host_find_tag() is used by the drivers to return a scsi
command based on the command tag. Typically it's used from the
interrupt handler to fetch the command associated with a value
returned from hardware. Some drivers like fnic or qla4xxx, however,
also use it also to traverse outstanding comands.
With the current implementation scsi_host_find_tag() will return
command even if they are not started (ie passed to the driver).
This will result in random errors with those drivers.
With this patch scsi_host_find_tag() will only return 'started'
commands (ie commands which have been passed to the drivers)
thus avoiding the above issue.
The other usecases will be unaffected as the interrupt handler
naturally will only ever return 'started' requests.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_tcq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 6053d46e794e..ea7848e74d25 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -34,7 +34,7 @@ static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
 					blk_mq_unique_tag_to_tag(tag));
 	}
 
-	if (!req)
+	if (!req || !blk_mq_request_started(req))
 		return NULL;
 	return blk_mq_rq_to_pdu(req);
 }
-- 
2.16.4

