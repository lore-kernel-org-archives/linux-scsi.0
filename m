From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix libfc sparse warnings
Date: Wed, 1 Dec 2010 11:04:05 -0800
Message-ID: <20101201110405.1cc8f6c6.randy.dunlap@oracle.com>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:52218 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0LATEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2010 14:04:30 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org


If not already included elsewhere, this could be added.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning for non-ANSI function declaration.
Declare workqueue structs as static.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/libfc/fc_exch.c  |    6 +++---
 drivers/scsi/libfc/fc_fcp.c   |    6 +++---
 drivers/scsi/libfc/fc_rport.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

--- lnx-2637-rc4.orig/drivers/scsi/libfc/fc_exch.c
+++ lnx-2637-rc4/drivers/scsi/libfc/fc_exch.c
@@ -38,7 +38,7 @@ u16	fc_cpu_mask;		/* cpu mask for possib
 EXPORT_SYMBOL(fc_cpu_mask);
 static u16	fc_cpu_order;	/* 2's power to represent total possible cpus */
 static struct kmem_cache *fc_em_cachep;	       /* cache for exchanges */
-struct workqueue_struct *fc_exch_workqueue;
+static struct workqueue_struct *fc_exch_workqueue;
 
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
@@ -2325,7 +2325,7 @@ EXPORT_SYMBOL(fc_exch_init);
 /**
  * fc_setup_exch_mgr() - Setup an exchange manager
  */
-int fc_setup_exch_mgr()
+int fc_setup_exch_mgr(void)
 {
 	fc_em_cachep = kmem_cache_create("libfc_em", sizeof(struct fc_exch),
 					 0, SLAB_HWCACHE_ALIGN, NULL);
@@ -2363,7 +2363,7 @@ int fc_setup_exch_mgr()
 /**
  * fc_destroy_exch_mgr() - Destroy an exchange manager
  */
-void fc_destroy_exch_mgr()
+void fc_destroy_exch_mgr(void)
 {
 	destroy_workqueue(fc_exch_workqueue);
 	kmem_cache_destroy(fc_em_cachep);
--- lnx-2637-rc4.orig/drivers/scsi/libfc/fc_fcp.c
+++ lnx-2637-rc4/drivers/scsi/libfc/fc_fcp.c
@@ -42,7 +42,7 @@
 
 #include "fc_libfc.h"
 
-struct kmem_cache *scsi_pkt_cachep;
+static struct kmem_cache *scsi_pkt_cachep;
 
 /* SRB state definitions */
 #define FC_SRB_FREE		0		/* cmd is free */
@@ -2196,7 +2196,7 @@ void fc_fcp_destroy(struct fc_lport *lpo
 }
 EXPORT_SYMBOL(fc_fcp_destroy);
 
-int fc_setup_fcp()
+int fc_setup_fcp(void)
 {
 	int rc = 0;
 
@@ -2212,7 +2212,7 @@ int fc_setup_fcp()
 	return rc;
 }
 
-void fc_destroy_fcp()
+void fc_destroy_fcp(void)
 {
 	if (scsi_pkt_cachep)
 		kmem_cache_destroy(scsi_pkt_cachep);
--- lnx-2637-rc4.orig/drivers/scsi/libfc/fc_rport.c
+++ lnx-2637-rc4/drivers/scsi/libfc/fc_rport.c
@@ -58,7 +58,7 @@
 
 #include "fc_libfc.h"
 
-struct workqueue_struct *rport_event_queue;
+static struct workqueue_struct *rport_event_queue;
 
 static void fc_rport_enter_flogi(struct fc_rport_priv *);
 static void fc_rport_enter_plogi(struct fc_rport_priv *);
@@ -1888,7 +1888,7 @@ EXPORT_SYMBOL(fc_rport_init);
 /**
  * fc_setup_rport() - Initialize the rport_event_queue
  */
-int fc_setup_rport()
+int fc_setup_rport(void)
 {
 	rport_event_queue = create_singlethread_workqueue("fc_rport_eq");
 	if (!rport_event_queue)
@@ -1899,7 +1899,7 @@ int fc_setup_rport()
 /**
  * fc_destroy_rport() - Destroy the rport_event_queue
  */
-void fc_destroy_rport()
+void fc_destroy_rport(void)
 {
 	destroy_workqueue(rport_event_queue);
 }
