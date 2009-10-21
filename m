From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/20] libfc: removes initializing fc_cpu_order and
	fc_cpu_mask per lport
Date: Wed, 21 Oct 2009 16:27:28 -0700
Message-ID: <20091021232728.12986.47873.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZJUX2I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:28:08 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Initializing these libfc globals per lport could mess up exch
allocation/free for existing lport.

So this patch moves their initialization to fc_setup_exch_mgr
so that these globals gets initialized only once for libfc.

Reported-by: Alex Lyakas <alexl@mellanox.co.il>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index ae8f9e9..bdae9a9 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2046,6 +2046,20 @@ int fc_exch_init(struct fc_lport *lp)
 	if (!lp->tt.seq_exch_abort)
 		lp->tt.seq_exch_abort = fc_seq_exch_abort;
 
+	return 0;
+}
+EXPORT_SYMBOL(fc_exch_init);
+
+/**
+ * fc_setup_exch_mgr() - Setup an exchange manager
+ */
+int fc_setup_exch_mgr()
+{
+	fc_em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
+					 0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!fc_em_cachep)
+		return -ENOMEM;
+
 	/*
 	 * Initialize fc_cpu_mask and fc_cpu_order. The
 	 * fc_cpu_mask is set for nr_cpu_ids rounded up
@@ -2070,16 +2084,6 @@ int fc_exch_init(struct fc_lport *lp)
 
 	return 0;
 }
-EXPORT_SYMBOL(fc_exch_init);
-
-int fc_setup_exch_mgr(void)
-{
-	fc_em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
-					 0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!fc_em_cachep)
-		return -ENOMEM;
-	return 0;
-}
 
 void fc_destroy_exch_mgr(void)
 {

