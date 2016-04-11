From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] IB/iser: set max_segment_size
Date: Mon, 11 Apr 2016 15:47:26 -0700
Message-ID: <1460414846-29540-3-git-send-email-hch@lst.de>
References: <1460414846-29540-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbcDKWrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 18:47:40 -0400
In-Reply-To: <1460414846-29540-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

So that we don't overflow the number of MR segments allocated because
we have to split on SGL segment into multiple MR segments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 80b6bed..784504a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -623,6 +623,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	shost->max_id = 0;
 	shost->max_channel = 0;
 	shost->max_cmd_len = 16;
+	shost->max_segment_size = PAGE_SIZE;
 
 	/*
 	 * older userspace tools (before 2.0-870) did not pass us
-- 
2.1.4

