From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 04/13] block: export blk_register_queue
Date: Wed, 19 Mar 2008 18:09:19 -0500 (EST)
Message-ID: <20080319.180919.118947998.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch exports blk_register_queue().

blk_register_queue() is called through add_disk().

Request-based dm defers queue allocation/initialization until
a mapping table is loaded, since the way to initialize queue
is different between bio-based mapping and request-based mapping.
So request-based dm needs to call add_disk() and blk_register_queue()
separately.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-sysfs.c |    1 +
 1 files changed, 1 insertion(+)

Index: 2.6.25-rc5/block/blk-sysfs.c
===================================================================
--- 2.6.25-rc5.orig/block/blk-sysfs.c
+++ 2.6.25-rc5/block/blk-sysfs.c
@@ -295,6 +295,7 @@ int blk_register_queue(struct gendisk *d
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_register_queue);
 
 void blk_unregister_queue(struct gendisk *disk)
 {
