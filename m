From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] allow registering individual HBAs
Date: Mon, 4 Nov 2002 22:27:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021104222730.A16172@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Yes, this is the patch every maintainer of a modern HBA waited for the
last years </shameless plug>.

With all my recent changes there's no more reason to call scsi_register_host
except for the intialization it performs to every host found in
scsi_register.  But a driver can aswell do that at the end of it's
per-HBA detection routine (i.e. in ->probe for a modern PCI driver), so
export that code as scsi_add_host to drivers.  Do the same for the
release path (scsi_remove_host).  Such a new-style driver needs neither
->detect or ->release and is in theory hotplug-capable (well, once all
the races in the scsi midlayer are fixed..)


--- 1.21/drivers/scsi/hosts.c	Sun Nov  3 19:48:14 2002
+++ edited/drivers/scsi/hosts.c	Mon Nov  4 22:04:04 2002
@@ -90,7 +90,7 @@
  * 	This is the default case for the release function.  Its completely
  *	useless for anything but old ISA adapters
  **/
-static void scsi_host_generic_release(struct Scsi_Host *shost)
+static void scsi_host_legacy_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
@@ -100,18 +100,35 @@
 		release_region(shost->io_port, shost->n_io_port);
 }
 
+static int scsi_remove_legacy_host(struct Scsi_Host *shost)
+{
+	int error, pcount = scsi_hosts_registered;
+
+	error = scsi_remove_host(shost);
+	if (error)
+		return error;
+
+	if (shost->hostt->release)
+		(*shost->hostt->release)(shost);
+	else
+		scsi_host_legacy_release(shost);
+
+	if (pcount == scsi_hosts_registered)
+		scsi_unregister(shost);
+	return 0;
+}
+
 /**
- * scsi_host_chk_and_release - check a scsi host for release and release
+ * scsi_remove_host - check a scsi host for release and release
  * @shost:	a pointer to a scsi host to release
  *
  * Return value:
  * 	0 on Success / 1 on Failure
  **/
-int scsi_host_chk_and_release(struct Scsi_Host *shost)
+int scsi_remove_host(struct Scsi_Host *shost)
 {
-	int pcount;
-	Scsi_Device *sdev;
-	Scsi_Cmnd *scmd;
+	struct scsi_device *sdev;
+	struct scsi_cmnd *scmd;
 
 	/*
 	 * Current policy is all shosts go away on unregister.
@@ -199,18 +216,30 @@
 		kfree(sdev);
 	}
 
-	/* Remove the instance of the individual hosts */
-	pcount = scsi_hosts_registered;
-	if (shost->hostt->release)
-		(*shost->hostt->release) (shost);
-	else {
-		scsi_host_generic_release(shost);
-	}
+	return 0;
+}
 
-	if (pcount == scsi_hosts_registered)
-		scsi_unregister(shost);
+int scsi_add_host(struct Scsi_Host *shost)
+{
+	Scsi_Host_Template *sht = shost->hostt;
+	struct scsi_device *sdev;
+	int error = 0;
+
+	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
+			sht->info ? sht->info(shost) : sht->name);
+
+	device_register(&shost->host_driverfs_dev);
+	scan_scsis(shost, 0, 0, 0, 0);
+			
+	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
+		if (sdev->host->hostt != sht)
+			continue; /* XXX(hch): can this really happen? */
+		error = scsi_attach_device(sdev);
+		if (error)
+			break;
+	}
 
-	return 0;
+	return error;
 }
 
 /**
@@ -451,7 +480,6 @@
 	return shost;
 }
 
-
 /**
  * scsi_register_host - register a low level host driver
  * @shost_tp:	pointer to a scsi host driver template
@@ -461,10 +489,8 @@
  **/
 int scsi_register_host(Scsi_Host_Template *shost_tp)
 {
-	int cur_cnt;
-	Scsi_Device *sdev;
-	struct list_head *lh;
 	struct Scsi_Host *shost;
+	int cur_cnt;
 
 	/*
 	 * Check no detect routine.
@@ -492,62 +518,40 @@
 	 * registration code below.
 	 */
 	shost_tp->detect(shost_tp);
+	if (!shost_tp->present)
+		return 0;
 
-	if (shost_tp->present) {
-			/*
-			 * FIXME Who needs manual registration and why???
-			 */
-		if (cur_cnt == scsi_hosts_registered) {
-			if (shost_tp->present > 1) {
-				printk(KERN_ERR "scsi: Failure to register"
-				       "low-level scsi driver");
-				scsi_unregister_host(shost_tp);
-				return 1;
-			}
-			/*
-			 * The low-level driver failed to register a driver.
-			 * We can do this now.
-			 */
-			if(scsi_register(shost_tp, 0)==NULL) {
-				printk(KERN_ERR "scsi: register failed.\n");
-				scsi_unregister_host(shost_tp);
-				return 1;
-			}
-		}
-
-		/* The next step is to call scan_scsis here.  This generates the
-		 * Scsi_Devices entries
-		 */
-		list_for_each(lh, &scsi_host_list) {
-			shost = list_entry(lh, struct Scsi_Host, sh_list);
-			if (shost->hostt == shost_tp) {
-				const char *dm_name;
-				if (shost_tp->info) {
-					dm_name = shost_tp->info(shost);
-				} else {
-					dm_name = shost_tp->name;
-				}
-				printk(KERN_INFO "scsi%d : %s\n",
-				       shost->host_no, dm_name);
-
-				/* first register parent with driverfs */
-				device_register(&shost->host_driverfs_dev);
-				scan_scsis(shost, 0, 0, 0, 0);
-			}
+	if (cur_cnt == scsi_hosts_registered) {
+		if (shost_tp->present > 1) {
+			printk(KERN_ERR "scsi: Failure to register"
+			       "low-level scsi driver");
+			scsi_unregister_host(shost_tp);
+			return 1;
 		}
 
 		/*
-		 * Next we create the Scsi_Cmnd structures for this host 
+		 * The low-level driver failed to register a driver.
+		 * We can do this now.
+		 *
+	 	 * XXX Who needs manual registration and why???
 		 */
-		list_for_each(lh, &scsi_host_list) {
-			shost = list_entry(lh, struct Scsi_Host, sh_list);
-			for (sdev = shost->host_queue; sdev; sdev = sdev->next)
-				if (sdev->host->hostt == shost_tp)
-					if (scsi_attach_device(sdev))
-						goto out_of_space;
+		if (!scsi_register(shost_tp, 0)) {
+			printk(KERN_ERR "scsi: register failed.\n");
+			scsi_unregister_host(shost_tp);
+			return 1;
 		}
 	}
 
+	
+	/*
+	 * XXX(hch) use scsi_tp_for_each_host() once it propagates
+	 *	    error returns properly.
+	 */
+	list_for_each_entry(shost, &scsi_host_list, sh_list)
+		if (shost->hostt == shost_tp)
+			if (scsi_add_host(shost))
+				goto out_of_space;
+
 	return 0;
 
 out_of_space:
@@ -579,7 +583,7 @@
 
 	pcount = scsi_hosts_registered;
 
-	scsi_tp_for_each_host(shost_tp, scsi_host_chk_and_release);
+	scsi_tp_for_each_host(shost_tp, scsi_remove_legacy_host);
 
 	if (pcount != scsi_hosts_registered)
 		printk(KERN_INFO "scsi : %d host%s left.\n", scsi_hosts_registered,
===== drivers/scsi/hosts.h 1.29 vs edited =====
--- 1.29/drivers/scsi/hosts.h	Sun Nov  3 14:24:37 2002
+++ edited/drivers/scsi/hosts.h	Mon Nov  4 21:34:35 2002
@@ -528,8 +528,6 @@
 extern int next_scsi_host;
 
 unsigned int scsi_init(void);
-extern struct Scsi_Host * scsi_register(Scsi_Host_Template *, int);
-extern void scsi_unregister(struct Scsi_Host *);
 extern void scsi_register_blocked_host(struct Scsi_Host *);
 extern void scsi_deregister_blocked_host(struct Scsi_Host *);
 
@@ -580,10 +578,26 @@
 
 
 /*
- * Driver registration/unregistration.
+ * Highlevel driver registration/unregistration.
  */
 extern int scsi_register_device(struct Scsi_Device_Template *);
 extern int scsi_unregister_device(struct Scsi_Device_Template *);
+
+/*
+ * HBA allocation/freeing.
+ */
+extern struct Scsi_Host * scsi_register(Scsi_Host_Template *, int);
+extern void scsi_unregister(struct Scsi_Host *);
+
+/*
+ * HBA registration/unregistration.
+ */
+extern int scsi_add_host(struct Scsi_Host *);
+extern int scsi_remove_host(struct Scsi_Host *);
+
+/*
+ * Legacy HBA template registration/unregistration.
+ */
 extern int scsi_register_host(Scsi_Host_Template *);
 extern int scsi_unregister_host(Scsi_Host_Template *);
 
===== drivers/scsi/scsi_syms.c 1.16 vs edited =====
--- 1.16/drivers/scsi/scsi_syms.c	Sun Nov  3 19:36:05 2002
+++ edited/drivers/scsi/scsi_syms.c	Mon Nov  4 21:55:09 2002
@@ -32,6 +32,8 @@
 EXPORT_SYMBOL(scsi_unregister_device);
 EXPORT_SYMBOL(scsi_register_host);
 EXPORT_SYMBOL(scsi_unregister_host);
+EXPORT_SYMBOL(scsi_add_host);
+EXPORT_SYMBOL(scsi_remove_host);
 EXPORT_SYMBOL(scsi_register);
 EXPORT_SYMBOL(scsi_unregister);
 EXPORT_SYMBOL(scsicam_bios_param);
