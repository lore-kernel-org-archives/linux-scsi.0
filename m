From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi tgt: fix the user/kernel ring buffer interface
Date: Tue, 13 Feb 2007 23:21:52 +0900 (JST)
Message-ID: <20070213062055H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:51525 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXBMOWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 09:22:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This patches fixes two bugs in the scsi target infrastructure's
user/kernel interface.

- It wrongly assumes that the ring buffer size of the interface (64KB)
is larger than or equal to the system page size. This patch sets the
ring buffer size to PAGE_SIZE if the system page size is larger.

- It uses PAGE_SIZE in the header file exported to userspace. This
patch removes it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_tgt_if.c |    8 ++++++++
 include/scsi/scsi_tgt_if.h |    3 ---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 37bbfbd..f5d4412 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -33,6 +33,14 @@ #include <asm/cacheflush.h>
 
 #include "scsi_tgt_priv.h"
 
+#if TGT_RING_SIZE < PAGE_SIZE
+#  define TGT_RING_SIZE PAGE_SIZE
+#endif
+
+#define TGT_RING_PAGES (TGT_RING_SIZE >> PAGE_SHIFT)
+#define TGT_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct tgt_event))
+#define TGT_MAX_EVENTS (TGT_EVENT_PER_PAGE * TGT_RING_PAGES)
+
 struct tgt_ring {
 	u32 tr_idx;
 	unsigned long tr_pages[TGT_RING_PAGES];
diff --git a/include/scsi/scsi_tgt_if.h b/include/scsi/scsi_tgt_if.h
index 46d5e70..07d6e77 100644
--- a/include/scsi/scsi_tgt_if.h
+++ b/include/scsi/scsi_tgt_if.h
@@ -83,8 +83,5 @@ struct tgt_event {
 } __attribute__ ((aligned (sizeof(uint64_t))));
 
 #define TGT_RING_SIZE (1UL << 16)
-#define TGT_RING_PAGES (TGT_RING_SIZE >> PAGE_SHIFT)
-#define TGT_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct tgt_event))
-#define TGT_MAX_EVENTS (TGT_EVENT_PER_PAGE * TGT_RING_PAGES)
 
 #endif
-- 
1.4.3.2

