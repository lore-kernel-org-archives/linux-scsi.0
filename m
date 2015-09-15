From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 03/17] Update the st driver to use idr helper functions.
Date: Tue, 15 Sep 2015 09:46:03 -0700
Message-ID: <0999c39931090daa5a78996039b5d58812a71e34.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Kai.Makisara@kolumbus.fi
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/st.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b37b9b00c4b4..51e1ce721d9f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4265,11 +4265,8 @@ static int st_probe(struct device *dev)
 	    tpnt->blksize_changed = 0;
 	mutex_init(&tpnt->lock);
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&st_index_lock);
-	error = idr_alloc(&st_index_idr, tpnt, 0, ST_MAX_TAPES + 1, GFP_NOWAIT);
-	spin_unlock(&st_index_lock);
-	idr_preload_end();
+	error = idr_get_index_in_range(&st_index_idr, &st_index_lock, tpnt,
+				       0, ST_MAX_TAPES + 1);
 	if (error < 0) {
 		pr_warn("st: idr allocation failed: %d\n", error);
 		goto out_put_queue;
@@ -4303,9 +4300,7 @@ out_remove_devs:
 	remove_cdevs(tpnt);
 	kfree(tpnt->stats);
 out_idr_remove:
-	spin_lock(&st_index_lock);
-	idr_remove(&st_index_idr, tpnt->index);
-	spin_unlock(&st_index_lock);
+	idr_put_index(&st_index_idr, &st_index_lock, tpnt->index);
 out_put_queue:
 	blk_put_queue(disk->queue);
 out_put_disk:
@@ -4330,9 +4325,7 @@ static int st_remove(struct device *dev)
 	mutex_lock(&st_ref_mutex);
 	kref_put(&tpnt->kref, scsi_tape_release);
 	mutex_unlock(&st_ref_mutex);
-	spin_lock(&st_index_lock);
-	idr_remove(&st_index_idr, index);
-	spin_unlock(&st_index_lock);
+	idr_put_index(&st_index_idr, &st_index_lock, index);
 	return 0;
 }
 
-- 
2.1.4
