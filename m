From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Mon, 4 Nov 2002 08:22:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021104082207.A1865@baldur.yggdrasil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	It looks like scsi_host_tmp_list and template.shtp_list are
not used.  This patch deletes them, but I have not tested beyond
verifying that my hosts.c still compiles.

	This is a step toward eliminating the need for a routine to
register scsi templates at all (modules would just register SCSI
hosts, simplifying hot plugging of controllers).

-- 
Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi.diff"

--- linux-2.5.45/drivers/scsi/hosts.h	2002-10-30 16:42:24.000000000 -0800
+++ linux/drivers/scsi/hosts.h	2002-11-04 08:10:05.000000000 -0800
@@ -58,8 +58,6 @@
 typedef struct	SHT
 {
 
-    struct list_head	shtp_list;
-
     /* Used with loadable modules so that we know when it is safe to unload */
     struct module * module;
 
@@ -326,6 +324,11 @@
      */
     unsigned use_blk_tcq:1;
 
+    /* Have the high level code automatically handle DMA mapping of
+       Scsi_Request->request_buffer and Scsi_Request->sense_buf. */
+    unsigned dma_map_request:1;
+    unsigned dma_map_sense:1;
+
     /*
      * Name of proc directory
      */
--- linux-2.5.45/drivers/scsi/hosts.c	2002-10-30 16:41:40.000000000 -0800
+++ linux/drivers/scsi/hosts.c	2002-11-04 08:09:58.000000000 -0800
@@ -45,7 +45,6 @@
 #include "scsi.h"
 #include "hosts.h"
 
-LIST_HEAD(scsi_host_tmpl_list);
 LIST_HEAD(scsi_host_hn_list);
 
 LIST_HEAD(scsi_host_list);
@@ -475,8 +474,6 @@
 	struct list_head *lh;
 	struct Scsi_Host *shost;
 
-	INIT_LIST_HEAD(&shost_tp->shtp_list);
-
 	/*
 	 * Check no detect routine.
 	 */
@@ -526,8 +523,6 @@
 			}
 		}
 
-		list_add_tail(&shost_tp->shtp_list, &scsi_host_tmpl_list);
-
 		/* The next step is to call scan_scsis here.  This generates the
 		 * Scsi_Devices entries
 		 */
@@ -614,14 +609,6 @@
 		printk(KERN_INFO "scsi : %d host%s left.\n", scsi_hosts_registered,
 		       (scsi_hosts_registered == 1) ? "" : "s");
 
-	/*
-	 * Remove it from the list if all
-	 * hosts were successfully removed (ie preset == 0)
-	 */
-	if (!shost_tp->present) {
-		list_del(&shost_tp->shtp_list);
-	}
-
 	MOD_DEC_USE_COUNT;
 
 	unlock_kernel();

--2oS5YaxWCcQjTEyO--
