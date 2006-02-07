From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/6] SCSI Userspace Target code: move bio-list header
Date: Tue, 07 Feb 2006 21:11:00 +0900
Message-ID: <20060207211100A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59344 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965047AbWBGMLC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 07:11:02 -0500
Received: from vcs3.rdh.ecl.ntt.co.jp (vcs3.rdh.ecl.ntt.co.jp [129.60.39.110])
	by tama5.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CB0JF021166
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:11:00 +0900 (JST)
Received: from mfs3.rdh.ecl.ntt.co.jp (mfs3.rdh.ecl.ntt.co.jp [129.60.39.112])
	by vcs3.rdh.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CB0lc029725
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:11:00 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp ([129.60.39.100])
	by mfs3.rdh.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CAxTI007409
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:10:59 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.12.11/8.12.11) with ESMTP id k17CAxi4014409
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 21:10:59 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move bio-list header file from drivers/md to linux/include

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---

 drivers/md/dm-bio-list.h  |   71 ---------------------------------------------
 drivers/md/dm-mpath.c     |    2 +
 drivers/md/dm-raid1.c     |    2 +
 drivers/md/dm-snap.c      |    2 +
 drivers/md/dm.c           |    2 +
 drivers/md/raid1.c        |    2 +
 drivers/md/raid10.c       |    2 +
 include/linux/bio-list.h  |   71 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/raid/md_k.h |    3 +-
 9 files changed, 78 insertions(+), 79 deletions(-)
 delete mode 100644 drivers/md/dm-bio-list.h
 create mode 100644 include/linux/bio-list.h

732b8a85158b1c773e9dfcfaf104d379451dddaf
diff --git a/drivers/md/dm-bio-list.h b/drivers/md/dm-bio-list.h
deleted file mode 100644
index bbf4615..0000000
--- a/drivers/md/dm-bio-list.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/*
- * Copyright (C) 2004 Red Hat UK Ltd.
- *
- * This file is released under the GPL.
- */
-
-#ifndef DM_BIO_LIST_H
-#define DM_BIO_LIST_H
-
-#include <linux/bio.h>
-
-struct bio_list {
-	struct bio *head;
-	struct bio *tail;
-};
-
-static inline void bio_list_init(struct bio_list *bl)
-{
-	bl->head = bl->tail = NULL;
-}
-
-static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
-{
-	bio->bi_next = NULL;
-
-	if (bl->tail)
-		bl->tail->bi_next = bio;
-	else
-		bl->head = bio;
-
-	bl->tail = bio;
-}
-
-static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
-{
-	if (!bl2->head)
-		return;
-
-	if (bl->tail)
-		bl->tail->bi_next = bl2->head;
-	else
-		bl->head = bl2->head;
-
-	bl->tail = bl2->tail;
-}
-
-static inline struct bio *bio_list_pop(struct bio_list *bl)
-{
-	struct bio *bio = bl->head;
-
-	if (bio) {
-		bl->head = bl->head->bi_next;
-		if (!bl->head)
-			bl->tail = NULL;
-
-		bio->bi_next = NULL;
-	}
-
-	return bio;
-}
-
-static inline struct bio *bio_list_get(struct bio_list *bl)
-{
-	struct bio *bio = bl->head;
-
-	bl->head = bl->tail = NULL;
-
-	return bio;
-}
-
-#endif
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f72a82f..c6e206f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -8,9 +8,9 @@
 #include "dm.h"
 #include "dm-path-selector.h"
 #include "dm-hw-handler.h"
-#include "dm-bio-list.h"
 #include "dm-bio-record.h"
 
+#include <linux/bio-list.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/mempool.h>
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 6cfa8d4..53f589b 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -5,11 +5,11 @@
  */
 
 #include "dm.h"
-#include "dm-bio-list.h"
 #include "dm-io.h"
 #include "dm-log.h"
 #include "kcopyd.h"
 
+#include <linux/bio-list.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/mempool.h>
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f3759dd..2e65db8 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -18,9 +18,9 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/bio-list.h>
 
 #include "dm-snap.h"
-#include "dm-bio-list.h"
 #include "kcopyd.h"
 
 /*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e9adeb9..020f415 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -6,8 +6,8 @@
  */
 
 #include "dm.h"
-#include "dm-bio-list.h"
 
+#include <linux/bio-list.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d39f584..4e43ce2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -31,7 +31,7 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include "dm-bio-list.h"
+#include <linux/bio-list.h>
 #include <linux/raid/raid1.h>
 #include <linux/raid/bitmap.h>
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ab90a6d..3ced1b9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -18,7 +18,7 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include "dm-bio-list.h"
+#include <linux/bio-list.h>
 #include <linux/raid/raid10.h>
 #include <linux/raid/bitmap.h>
 
diff --git a/include/linux/bio-list.h b/include/linux/bio-list.h
new file mode 100644
index 0000000..4653516
--- /dev/null
+++ b/include/linux/bio-list.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2004 Red Hat UK Ltd.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef _BIO_LIST_H
+#define _BIO_LIST_H
+
+#include <linux/bio.h>
+
+struct bio_list {
+	struct bio *head;
+	struct bio *tail;
+};
+
+static inline void bio_list_init(struct bio_list *bl)
+{
+	bl->head = bl->tail = NULL;
+}
+
+static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = NULL;
+
+	if (bl->tail)
+		bl->tail->bi_next = bio;
+	else
+		bl->head = bio;
+
+	bl->tail = bio;
+}
+
+static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
+{
+	if (!bl2->head)
+		return;
+
+	if (bl->tail)
+		bl->tail->bi_next = bl2->head;
+	else
+		bl->head = bl2->head;
+
+	bl->tail = bl2->tail;
+}
+
+static inline struct bio *bio_list_pop(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	if (bio) {
+		bl->head = bl->head->bi_next;
+		if (!bl->head)
+			bl->tail = NULL;
+
+		bio->bi_next = NULL;
+	}
+
+	return bio;
+}
+
+static inline struct bio *bio_list_get(struct bio_list *bl)
+{
+	struct bio *bio = bl->head;
+
+	bl->head = bl->tail = NULL;
+
+	return bio;
+}
+
+#endif
diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
index 617b950..2323360 100644
--- a/include/linux/raid/md_k.h
+++ b/include/linux/raid/md_k.h
@@ -15,8 +15,7 @@
 #ifndef _MD_K_H
 #define _MD_K_H
 
-/* and dm-bio-list.h is not under include/linux because.... ??? */
-#include "../../../drivers/md/dm-bio-list.h"
+#include <linux/bio-list.h>
 
 #define	LEVEL_MULTIPATH		(-4)
 #define	LEVEL_LINEAR		(-1)
-- 
1.1.3
