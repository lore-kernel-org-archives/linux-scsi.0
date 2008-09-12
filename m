From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 07/13] dm: tidy local_init
Date: Fri, 12 Sep 2008 10:44:55 -0400 (EDT)
Message-ID: <20080912.104455.27955868.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@HansenPartnership.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch tidies local_init() as preparation for another patch
(PATCH 08), which creates some kmem_cache for request-based dm.
No functional change.

This patch is just a clean up of the codes and not functionally
related to request-based dm.  But included here due to literal
dependency.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

Index: 2.6.27-rc6/drivers/md/dm.c
===================================================================
--- 2.6.27-rc6.orig/drivers/md/dm.c
+++ 2.6.27-rc6/drivers/md/dm.c
@@ -150,40 +150,40 @@ static struct kmem_cache *_tio_cache;
 
 static int __init local_init(void)
 {
-	int r;
+	int r = -ENOMEM;
 
 	/* allocate a slab for the dm_ios */
 	_io_cache = KMEM_CACHE(dm_io, 0);
 	if (!_io_cache)
-		return -ENOMEM;
+		return r;
 
 	/* allocate a slab for the target ios */
 	_tio_cache = KMEM_CACHE(dm_target_io, 0);
-	if (!_tio_cache) {
-		kmem_cache_destroy(_io_cache);
-		return -ENOMEM;
-	}
+	if (!_tio_cache)
+		goto out_free_io_cache;
 
 	r = dm_uevent_init();
-	if (r) {
-		kmem_cache_destroy(_tio_cache);
-		kmem_cache_destroy(_io_cache);
-		return r;
-	}
+	if (r)
+		goto out_free_tio_cache;
 
 	_major = major;
 	r = register_blkdev(_major, _name);
-	if (r < 0) {
-		kmem_cache_destroy(_tio_cache);
-		kmem_cache_destroy(_io_cache);
-		dm_uevent_exit();
-		return r;
-	}
+	if (r < 0)
+		goto out_uevent_exit;
 
 	if (!_major)
 		_major = r;
 
 	return 0;
+
+out_uevent_exit:
+	dm_uevent_exit();
+out_free_tio_cache:
+	kmem_cache_destroy(_tio_cache);
+out_free_io_cache:
+	kmem_cache_destroy(_io_cache);
+
+	return r;
 }
 
 static void local_exit(void)
