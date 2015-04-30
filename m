From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] dm-mpath: don't call scsi_dh_attach when we want to retain the attached handler
Date: Thu, 30 Apr 2015 19:32:25 +0200
Message-ID: <1430415151-30948-4-git-send-email-hch@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbD3Rd4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 13:33:56 -0400
In-Reply-To: <1430415151-30948-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 9fb91ca..f6d40d3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -591,9 +591,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 			kfree(m->hw_handler_params);
 			m->hw_handler_params = NULL;
 		}
-	}
-
-	if (m->hw_handler_name) {
+	} else if (m->hw_handler_name) {
 		/*
 		 * Increments scsi_dh reference, even when using an
 		 * already-attached handler.
@@ -604,15 +602,15 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 			dm_put_device(ti, p->path.dev);
 			goto bad;
 		}
+	}
 
-		if (m->hw_handler_params) {
-			r = scsi_dh_set_params(q, m->hw_handler_params);
-			if (r < 0) {
-				ti->error = "unable to set hardware "
-							"handler parameters";
-				dm_put_device(ti, p->path.dev);
-				goto bad;
-			}
+	if (m->hw_handler_name && m->hw_handler_params) {
+		r = scsi_dh_set_params(q, m->hw_handler_params);
+		if (r < 0) {
+			ti->error = "unable to set hardware "
+						"handler parameters";
+			dm_put_device(ti, p->path.dev);
+			goto bad;
 		}
 	}
 
-- 
1.9.1

