From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don's export proc_scsi
Date: Mon, 25 Aug 2003 14:22:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122220.GC15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:53147 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261763AbTHYMWX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:22:23 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

proc_mkdir can also take absolute pathes, so we can avoid the export.


diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Mon Aug 25 13:37:20 2003
+++ b/drivers/scsi/scsi_proc.c	Mon Aug 25 13:37:20 2003
@@ -37,9 +37,7 @@
 /* 4K page size, but our output routines, use some slack for overruns */
 #define PROC_BLOCK_SIZE (3*1024)
 
-/* XXX: this shouldn't really be exposed to drivers. */
-struct proc_dir_entry *proc_scsi;
-EXPORT_SYMBOL(proc_scsi);
+static struct proc_dir_entry *proc_scsi;
 
 /* Protect sht->present and sht->proc_dir */
 static DECLARE_MUTEX(global_host_template_sem);
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Mon Aug 25 13:37:20 2003
+++ b/drivers/scsi/sg.c	Mon Aug 25 13:37:20 2003
@@ -2583,7 +2583,7 @@
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
 
-static char sg_proc_sg_dirname[] = "sg";
+static char sg_proc_sg_dirname[] = "scsi/sg";
 
 static int sg_proc_adio_read(char *buffer, char **start, off_t offset,
 			     int size, int *eof, void *data);
@@ -2657,10 +2657,6 @@
 				size : begin + len - offset;    \
     } while(0)
 
-/* this should _really_ be private to the scsi midlayer.  But
-   /proc/scsi/sg is an established name, so.. */
-extern struct proc_dir_entry *proc_scsi;
-
 static int
 sg_proc_init(void)
 {
@@ -2670,10 +2666,8 @@
 	struct proc_dir_entry *pdep;
 	struct sg_proc_leaf * leaf;
 
-	if (!proc_scsi)
-		return 1;
 	sg_proc_sgp = create_proc_entry(sg_proc_sg_dirname,
-					S_IFDIR | S_IRUGO | S_IXUGO, proc_scsi);
+					S_IFDIR | S_IRUGO | S_IXUGO, NULL);
 	if (!sg_proc_sgp)
 		return 1;
 	for (k = 0; k < num_leaves; ++k) {
@@ -2696,11 +2690,11 @@
 	int num_leaves =
 	    sizeof (sg_proc_leaf_arr) / sizeof (sg_proc_leaf_arr[0]);
 
-	if ((!proc_scsi) || (!sg_proc_sgp))
+	if (!sg_proc_sgp)
 		return;
 	for (k = 0; k < num_leaves; ++k)
 		remove_proc_entry(sg_proc_leaf_arr[k].name, sg_proc_sgp);
-	remove_proc_entry(sg_proc_sg_dirname, proc_scsi);
+	remove_proc_entry(sg_proc_sg_dirname, NULL);
 }
 
 static int
