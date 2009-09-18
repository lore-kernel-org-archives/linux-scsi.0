From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/24] libfc: removes initializing fc_cpu_order and
	fc_cpu_mask per lport
Date: Fri, 18 Sep 2009 15:49:36 -0700
Message-ID: <20090918224936.5928.87339.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758783AbZIRWtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:49:32 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
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

 drivers/scsi/libfc/fc_exch.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index dec61e5..d58111f 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2303,6 +2303,20 @@ int fc_exch_init(struct fc_lport *lport)
 	if (!lport->tt.seq_exch_abort)
 		lport->tt.seq_exch_abort = fc_seq_exch_abort;
 
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
@@ -2327,19 +2341,6 @@ int fc_exch_init(struct fc_lport *lport)
 
 	return 0;
 }
-EXPORT_SYMBOL(fc_exch_init);
-
-/**
- * fc_setup_exch_mgr() - Setup an exchange manager
- */
-int fc_setup_exch_mgr()
-{
-	fc_em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
-					 0, SLAB_HWCACHE_ALIGN, NULL);
-	if (!fc_em_cachep)
-		return -ENOMEM;
-	return 0;
-}
 
 /**
  * fc_destroy_exch_mgr() - Destroy an exchange manager

