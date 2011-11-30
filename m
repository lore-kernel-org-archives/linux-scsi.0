From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: Clear map_context pointer when requeuing
Date: Wed, 30 Nov 2011 15:25:18 +0100
Message-ID: <1322663118-53387-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab1K3OZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 09:25:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>

When requeing a request we should be clearing the map_context
pointer, otherwise we might access an invalid memory location.

Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/md/dm-mpath.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5e0090e..e6fad46 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -920,8 +920,10 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 	map_context->ptr = mpio;
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	r = map_io(m, clone, mpio, 0);
-	if (r < 0 || r == DM_MAPIO_REQUEUE)
+	if (r < 0 || r == DM_MAPIO_REQUEUE) {
 		mempool_free(mpio, m->mpio_pool);
+		map_context->ptr = NULL;
+	}
 
 	return r;
 }
-- 
1.6.0.2

