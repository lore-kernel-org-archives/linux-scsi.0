From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove implicit scsi_register()
Date: Sat, 23 Nov 2002 03:14:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021123031432.A11239@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

hosts.c has some crufty old code to implicitly do scsi_register/
scsi_unregister for drivers that don't do it.  This seems to be
a left-over from the very early days and apparently no driver
in the tree uses it (at least according to some grepping).

This patch removes it.


--- 1.35/drivers/scsi/hosts.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/hosts.c	Sat Nov 23 02:12:54 2002
@@ -36,7 +36,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 
 #define __KERNEL_SYSCALLS__
 
@@ -50,7 +49,6 @@
 static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
 
 static int scsi_host_next_hn;		/* host_no for next new host */
-static int scsi_hosts_registered;	/* cnt of registered scsi hosts */
 static char *scsihosts;
 
 MODULE_PARM(scsihosts, "s");
@@ -192,7 +190,7 @@
 
 static int scsi_remove_legacy_host(struct Scsi_Host *shost)
 {
-	int error, pcount = scsi_hosts_registered;
+	int error;
 
 	error = scsi_remove_host(shost);
 	if (error)
@@ -203,8 +201,6 @@
 	else
 		scsi_host_legacy_release(shost);
 
-	if (pcount == scsi_hosts_registered)
-		scsi_unregister(shost);
 	return 0;
 }
 
@@ -343,7 +331,6 @@
 		shost->eh_notify = NULL;
 	}
 
-	scsi_hosts_registered--;
 	shost->hostt->present--;
 
 	/* Cleanup proc and driverfs */
@@ -395,7 +382,6 @@
 	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
 
 	shost->host_no = scsi_alloc_host_num(shost_tp->proc_name);
-	scsi_hosts_registered++;
 
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
@@ -491,7 +477,6 @@
 int scsi_register_host(Scsi_Host_Template *shost_tp)
 {
 	struct Scsi_Host *shost;
-	int cur_cnt;
 
 	/*
 	 * Check no detect routine.
@@ -503,8 +488,6 @@
 	if (!shost_tp->max_sectors)
 		shost_tp->max_sectors = 1024;
 
-	cur_cnt = scsi_hosts_registered;
-
 	/*
 	 * The detect routine must carefully spinunlock/spinlock if it
 	 * enables interrupts, since all interrupt handlers do spinlock as
@@ -520,28 +503,6 @@
 	if (!shost_tp->present)
 		return 0;
 
-	if (cur_cnt == scsi_hosts_registered) {
-		if (shost_tp->present > 1) {
-			printk(KERN_ERR "scsi: Failure to register"
-			       "low-level scsi driver");
-			scsi_unregister_host(shost_tp);
-			return 1;
-		}
-
-		/*
-		 * The low-level driver failed to register a driver.
-		 * We can do this now.
-		 *
-	 	 * XXX Who needs manual registration and why???
-		 */
-		if (!scsi_register(shost_tp, 0)) {
-			printk(KERN_ERR "scsi: register failed.\n");
-			scsi_unregister_host(shost_tp);
-			return 1;
-		}
-	}
-
-	
 	/*
 	 * XXX(hch) use scsi_tp_for_each_host() once it propagates
 	 *	    error returns properly.
@@ -575,20 +536,7 @@
  **/
 int scsi_unregister_host(Scsi_Host_Template *shost_tp)
 {
-	int pcount;
-
-	/* get the big kernel lock, so we don't race with open() */
-	lock_kernel();
-
-	pcount = scsi_hosts_registered;
-
 	scsi_tp_for_each_host(shost_tp, scsi_remove_legacy_host);
-
-	if (pcount != scsi_hosts_registered)
-		printk(KERN_INFO "scsi : %d host%s left.\n", scsi_hosts_registered,
-		       (scsi_hosts_registered == 1) ? "" : "s");
-
-	unlock_kernel();
 	return 0;
 
 }
