From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/4] bsg: device hash table cleanup
Date: Tue, 17 Jul 2007 19:08:47 +0900
Message-ID: <32592fb9ca102dcd2a867999b577fad63d61a0f1.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
References: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:34318 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbXGQKJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 06:09:20 -0400
In-Reply-To: <40eb9fb0d327856034312127350a427a50eb4222.1184666104.git.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, tomof@acm.org

- kill unused bsg_list_idx macro.
- add bsg_dev_idx_hash() that returns an appropriate hlist_head.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index b253784..55a4303 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -72,7 +72,6 @@ static DEFINE_MUTEX(bsg_mutex);
 static int bsg_device_nr, bsg_minor_idx;
 
 #define BSG_LIST_ARRAY_SIZE	8
-#define bsg_list_idx(minor)	((minor) & (BSG_LIST_ARRAY_SIZE - 1))
 static struct hlist_head bsg_device_list[BSG_LIST_ARRAY_SIZE];
 
 static struct class *bsg_class;
@@ -139,9 +138,9 @@ out:
 	return bc;
 }
 
-static inline void
-bsg_add_done_cmd(struct bsg_device *bd, struct bsg_command *bc)
+static inline struct hlist_head *bsg_dev_idx_hash(int index)
 {
+	return &bsg_device_list[index & (BSG_LIST_ARRAY_SIZE - 1)];
 }
 
 static int bsg_io_schedule(struct bsg_device *bd)
@@ -748,8 +747,7 @@ #endif
 	atomic_set(&bd->ref_count, 1);
 	bd->minor = iminor(inode);
 	mutex_lock(&bsg_mutex);
-	hlist_add_head(&bd->dev_list,
-		&bsg_device_list[bd->minor & (BSG_LIST_ARRAY_SIZE - 1)]);
+	hlist_add_head(&bd->dev_list, bsg_dev_idx_hash(bd->minor));
 
 	strncpy(bd->name, rq->bsg_dev.class_dev->class_id, sizeof(bd->name) - 1);
 	dprintk("bound to <%s>, max queue %d\n",
@@ -761,14 +759,12 @@ #endif
 
 static struct bsg_device *__bsg_get_device(int minor)
 {
-	struct hlist_head *list;
 	struct bsg_device *bd = NULL;
 	struct hlist_node *entry;
 
 	mutex_lock(&bsg_mutex);
 
-	list = &bsg_device_list[minor & (BSG_LIST_ARRAY_SIZE - 1)];
-	hlist_for_each(entry, list) {
+	hlist_for_each(entry, bsg_dev_idx_hash(minor)) {
 		bd = hlist_entry(entry, struct bsg_device, dev_list);
 		if (bd->minor == minor) {
 			atomic_inc(&bd->ref_count);
-- 
1.4.3.2

