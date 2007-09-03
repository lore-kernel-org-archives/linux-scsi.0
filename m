From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 1/2] revert sg segment size ifdefs
Date: Mon, 3 Sep 2007 18:40:20 +0900
Message-ID: <20070903103501F.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:36913 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbXICJlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2007 05:41:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

The patchset is against Jens' sg chaining branch.

Jens removed old SCSI_MAX_PHYS_SEGMENTS hack and the maximum is always
128:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=d6beb57f48231f5c012fb7d55b369bc0af6b0c41

I talked to James at linuxconf.eu and he likes to provide a way to
reduce sgpool memory consumption because with libata everyone
(including small machines) uses the mid layer.

This patch reverts sg segment size ifdefs that the current mid layer
has. Later we might do something better like relating
SCSI_MAX_SG_SEGMENTS with other config options like CONFIG_EMBEDDED or
just having SCSI_MAX_SG_SEGMENTS in menuconfig.

Now we have sg chaining code in -mm. As discussed before, it would be
nice to test sg chaining code in -mm with a small SCSI_MAX_SG_SEGMENTS
value like 32.

---
>From 4692956cdc3db1d0cfb3f26dc7aa3925f591d392 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Sat, 18 Aug 2007 19:00:47 +0900
Subject: [PATCH 1/2] revert sg segment size ifdefs

This reverts sg segment size ifdefs that the current code has in order
to provide a way to reduce sgpool memory consumption.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_lib.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f05f006..2fc2380 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -34,6 +34,13 @@
 #define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		2
 
+/*
+ * The maximum number of SG segments that we will put inside a scatterlist
+ * (unless chaining is used). Should ideally fit inside a single page, to
+ * avoid a higher order allocation.
+ */
+#define SCSI_MAX_SG_SEGMENTS	128
+
 struct scsi_host_sg_pool {
 	size_t		size;
 	char		*name;
@@ -45,9 +52,15 @@ struct scsi_host_sg_pool {
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
 	SP(8),
 	SP(16),
+#if (SCSI_MAX_SG_SEGMENTS > 16)
 	SP(32),
+#if (SCSI_MAX_SG_SEGMENTS > 32)
 	SP(64),
+#if (SCSI_MAX_SG_SEGMENTS > 64)
 	SP(128),
+#endif
+#endif
+#endif
 };
 #undef SP
 
@@ -690,13 +703,6 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 }
 
 /*
- * The maximum number of SG segments that we will put inside a scatterlist
- * (unless chaining is used). Should ideally fit inside a single page, to
- * avoid a higher order allocation.
- */
-#define SCSI_MAX_SG_SEGMENTS	128
-
-/*
  * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
  * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
  */
@@ -713,15 +719,21 @@ static inline unsigned int scsi_sgtable_index(unsigned short nents)
 	case 9 ... 16:
 		index = 1;
 		break;
+#if (SCSI_MAX_SG_SEGMENTS > 16)
 	case 17 ... 32:
 		index = 2;
 		break;
+#if (SCSI_MAX_SG_SEGMENTS > 32)
 	case 33 ... 64:
 		index = 3;
 		break;
-	case 65 ... SCSI_MAX_SG_SEGMENTS:
+#if (SCSI_MAX_SG_SEGMENTS > 64)
+	case 65 ... 128:
 		index = 4;
 		break;
+#endif
+#endif
+#endif
 	default:
 		printk(KERN_ERR "scsi: bad segment count=%d\n", nents);
 		BUG();
-- 
1.5.2.4

