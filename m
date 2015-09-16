From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 05/17] Update the md driver to use idr helper functions.
Date: Wed, 16 Sep 2015 10:50:23 -0700
Message-ID: <6798bc818d81b24058b9c0a70990149d96002646.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/md/dm.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f331d888e7f5..53d6895eb13d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2202,9 +2202,7 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
  *---------------------------------------------------------------*/
 static void free_minor(int minor)
 {
-	spin_lock(&_minor_lock);
-	idr_remove(&_minor_idr, minor);
-	spin_unlock(&_minor_lock);
+	idr_put_index(&_minor_idr, &_minor_lock, minor);
 }
 
 /*
@@ -2217,13 +2215,8 @@ static int specific_minor(int minor)
 	if (minor >= (1 << MINORBITS))
 		return -EINVAL;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&_minor_lock);
-
-	r = idr_alloc(&_minor_idr, MINOR_ALLOCED, minor, minor + 1, GFP_NOWAIT);
-
-	spin_unlock(&_minor_lock);
-	idr_preload_end();
+	r = idr_get_index_in_range(&_minor_idr, &_minor_lock, MINOR_ALLOCED,
+				   minor, minor + 1);
 	if (r < 0)
 		return r == -ENOSPC ? -EBUSY : r;
 	return 0;
@@ -2233,13 +2226,8 @@ static int next_free_minor(int *minor)
 {
 	int r;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&_minor_lock);
-
-	r = idr_alloc(&_minor_idr, MINOR_ALLOCED, 0, 1 << MINORBITS, GFP_NOWAIT);
-
-	spin_unlock(&_minor_lock);
-	idr_preload_end();
+	r = idr_get_index_in_range(&_minor_idr, &_minor_lock, MINOR_ALLOCED,
+				   0, 1 << MINORBITS);
 	if (r < 0)
 		return r;
 	*minor = r;
-- 
2.1.4
