From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 3/4] dm mpath: move trigger_event member to the end of 'struct multipath'
Date: Thu, 31 Mar 2016 16:04:25 -0400
Message-ID: <1459454666-76428-4-git-send-email-snitzer@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741AbcCaUEa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 16:04:30 -0400
In-Reply-To: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, hare@suse.de, sagig@dev.mellanox.co.il, Mike Snitzer <snitzer@redhat.com>

Allows the 'work_mutex' member to no longer cross a cacheline.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 780e5d0..54daf96 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -89,8 +89,6 @@ struct multipath {
 	atomic_t pg_init_in_progress;	/* Only one pg_init allowed at once */
 	atomic_t pg_init_count;		/* Number of times pg_init called */
 
-	struct work_struct trigger_event;
-
 	/*
 	 * We must use a mempool of dm_mpath_io structs so that we
 	 * can resubmit bios on error.
@@ -98,6 +96,7 @@ struct multipath {
 	mempool_t *mpio_pool;
 
 	struct mutex work_mutex;
+	struct work_struct trigger_event;
 };
 
 /*
-- 
2.6.4 (Apple Git-63)

