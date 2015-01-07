From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: ->queue_rq can't sleep
Date: Wed,  7 Jan 2015 15:20:53 +0100
Message-ID: <1420640453-3493-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34427 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbAGOVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 09:21:42 -0500
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y8rUS-00040A-Mo
	for linux-scsi@vger.kernel.org; Wed, 07 Jan 2015 14:21:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The blk-mq ->queue_rq method is always called from process context,
but might have preemption disabled.  This means we still always
have to use GFP_ATOMIC for memory allocations, and thus need to
revert part of commit 3c356bde1 ("scsi: stop passing a gfp_mask
argument down the command setup path").

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ea95dd..6d5c0b8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -591,7 +591,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 {
 	struct scatterlist *first_chunk = NULL;
-	gfp_t gfp_mask = mq ? GFP_NOIO : GFP_ATOMIC;
 	int ret;
 
 	BUG_ON(!nents);
@@ -606,7 +605,7 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 	}
 
 	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
-			       first_chunk, gfp_mask, scsi_sg_alloc);
+			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
 	if (unlikely(ret))
 		scsi_free_sgtable(sdb, mq);
 	return ret;
-- 
1.9.1

