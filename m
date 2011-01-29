From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/28] libfc: fix sparse static and non-ANSI warnings
Date: Fri, 28 Jan 2011 16:03:57 -0800
Message-ID: <20110129000357.1784.33332.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21546 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A2AD6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:58 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning for non-ANSI function declaration.
Declare workqueue structs as static.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Robert Love <robert.w.love@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c  |    6 +++---
 drivers/scsi/libfc/fc_fcp.c   |    6 +++---
 drivers/scsi/libfc/fc_rport.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d21367d..e0b5b15 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -38,7 +38,7 @@ u16	fc_cpu_mask;		/* cpu mask for possible cpus */
 EXPORT_SYMBOL(fc_cpu_mask);
 static u16	fc_cpu_order;	/* 2's power to represent total possible cpus */
 static struct kmem_cache *fc_em_cachep;	       /* cache for exchanges */
-struct workqueue_struct *fc_exch_workqueue;
+static struct workqueue_struct *fc_exch_workqueue;
 
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
@@ -2357,7 +2357,7 @@ EXPORT_SYMBOL(fc_exch_init);
 /**
  * fc_setup_exch_mgr() - Setup an exchange manager
  */
-int fc_setup_exch_mgr()
+int fc_setup_exch_mgr(void)
 {
 	fc_em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
 					 0, SLAB_HWCACHE_ALIGN, NULL);
@@ -2395,7 +2395,7 @@ int fc_setup_exch_mgr()
 /**
  * fc_destroy_exch_mgr() - Destroy an exchange manager
  */
-void fc_destroy_exch_mgr()
+void fc_destroy_exch_mgr(void)
 {
 	destroy_workqueue(fc_exch_workqueue);
 	kmem_cache_destroy(fc_em_cachep);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f4eb1ab..383a982 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -42,7 +42,7 @@
 
 #include "fc_libfc.h"
 
-struct kmem_cache *scsi_pkt_cachep;
+static struct kmem_cache *scsi_pkt_cachep;
 
 /* SRB state definitions */
 #define FC_SRB_FREE		0		/* cmd is free */
@@ -2244,7 +2244,7 @@ void fc_fcp_destroy(struct fc_lport *lport)
 }
 EXPORT_SYMBOL(fc_fcp_destroy);
 
-int fc_setup_fcp()
+int fc_setup_fcp(void)
 {
 	int rc = 0;
 
@@ -2260,7 +2260,7 @@ int fc_setup_fcp()
 	return rc;
 }
 
-void fc_destroy_fcp()
+void fc_destroy_fcp(void)
 {
 	if (scsi_pkt_cachep)
 		kmem_cache_destroy(scsi_pkt_cachep);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 325bc42..309e3e7 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -58,7 +58,7 @@
 
 #include "fc_libfc.h"
 
-struct workqueue_struct *rport_event_queue;
+static struct workqueue_struct *rport_event_queue;
 
 static void fc_rport_enter_flogi(struct fc_rport_priv *);
 static void fc_rport_enter_plogi(struct fc_rport_priv *);
@@ -1890,7 +1890,7 @@ EXPORT_SYMBOL(fc_rport_init);
 /**
  * fc_setup_rport() - Initialize the rport_event_queue
  */
-int fc_setup_rport()
+int fc_setup_rport(void)
 {
 	rport_event_queue = create_singlethread_workqueue("fc_rport_eq");
 	if (!rport_event_queue)
@@ -1901,7 +1901,7 @@ int fc_setup_rport()
 /**
  * fc_destroy_rport() - Destroy the rport_event_queue
  */
-void fc_destroy_rport()
+void fc_destroy_rport(void)
 {
 	destroy_workqueue(rport_event_queue);
 }

