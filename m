From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove proc_print_scsidevice abuse from drivers
Date: Wed, 23 Apr 2003 10:47:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030423104749.A13844@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:30474 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263208AbTDWIfu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 04:35:50 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

proc_print_scsidevice is used for the scsi device listing in
/proc/scsi/scsi, but in addition two drivers (advansys and eata_pio)
are using it to duplicate the same information in their proc_info
method.  Remove that output and make the function static to
scsi_proc.c.  Also remove proc_scsi from the public headers - it
should really be private to the scsi midlayer but I don't think
we can shange the sg procfs name anymore.


--- 1.28/drivers/scsi/advansys.c	Thu Mar  6 17:05:42 2003
+++ edited/drivers/scsi/advansys.c	Wed Apr 23 08:04:51 2003
@@ -4395,32 +4395,6 @@
     curbuf += cnt;
 
     /*
-     * Display target driver information for each device attached
-     * to the board.
-     */
-    list_for_each_entry (scd, &shp->my_devices, siblings)
-    {
-        if (scd->host == shp) {
-            cp = boardp->prtbuf;
-            /*
-             * Note: If proc_print_scsidevice() writes more than
-             * ASC_PRTBUF_SIZE bytes, it will overrun 'prtbuf'.
-             */
-            proc_print_scsidevice(scd, cp, &cplen, 0);
-            ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
-            cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-            totcnt += cnt;
-            leftlen -= cnt;
-            if (leftlen == 0) {
-                ASC_DBG1(1, "advansys_proc_info: totcnt %d\n", totcnt);
-                return totcnt;
-            }
-            advoffset += cplen;
-            curbuf += cnt;
-        }
-    }
-
-    /*
      * Display EEPROM configuration for the board.
      */
     cp = boardp->prtbuf;
--- 1.13/drivers/scsi/eata_pio.c	Thu Feb 20 12:57:04 2003
+++ edited/drivers/scsi/eata_pio.c	Wed Apr 23 08:05:22 2003
@@ -155,24 +155,6 @@
     if (pos > offset + length)
 	goto stop_output;
     
-    size = sprintf(buffer+len,"Attached devices: %s\n", 
-		   (!list_empty(&shost->my_devices))?"":"none");
-    len += size; 
-    pos = begin + len;
-    
-    list_for_each_entry(sdev, &shost->my_devices, siblings) {
-	    proc_print_scsidevice(sdev, buffer, &size, len);
-	    len += size; 
-	    pos = begin + len;
-	    
-	    if (pos < offset) {
-		len = 0;
-		begin = pos;
-	    }
-	    if (pos > offset + length)
-		goto stop_output;
-    }
-    
  stop_output:
     DBG(DBG_PROC, printk("2pos: %ld offset: %ld len: %d\n", pos, offset, len));
     *start=buffer+(offset-begin);   /* Start of wanted data */
--- 1.74/drivers/scsi/scsi.h	Mon Apr 21 06:10:01 2003
+++ edited/drivers/scsi/scsi.h	Wed Apr 23 08:06:29 2003
@@ -455,13 +455,9 @@
 
 extern void scsi_proc_host_add(struct Scsi_Host *);
 extern void scsi_proc_host_rm(struct Scsi_Host *);
-
-extern struct proc_dir_entry *proc_scsi;
-extern void proc_print_scsidevice(Scsi_Device * sdev, char *buffer, int *size, int len);
 #else
 static inline int scsi_init_procfs(void) { return 0; }
 static inline void scsi_exit_procfs(void) { ; }
-static inline void proc_print_scsidevice(Scsi_Device * sdev, char *buffer, int *size, int len) { ; }
 
 static inline void scsi_proc_host_add(struct Scsi_Host *);
 static inline void scsi_proc_host_rm(struct Scsi_Host *);
--- 1.18/drivers/scsi/scsi_proc.c	Sun Feb 23 13:34:56 2003
+++ edited/drivers/scsi/scsi_proc.c	Wed Apr 23 08:03:43 2003
@@ -150,7 +150,7 @@
 }
 
-/* XXX: this shouldn't really be exposed to drivers. */
-void proc_print_scsidevice(Scsi_Device * sdev, char *buffer, int *size, int len)
+static void proc_print_scsidevice(struct scsi_device* sdev, char *buffer,
+				  int *size, int len)
 {
 
 	int x, y = *size;
@@ -195,7 +197,6 @@
 	*size = y;
 	return;
 }
-EXPORT_SYMBOL(proc_print_scsidevice);
 
 /* 
  * proc_scsi_dev_info_read: dump the scsi_dev_info_list via
--- 1.50/drivers/scsi/sg.c	Fri Apr 18 11:57:20 2003
+++ edited/drivers/scsi/sg.c	Wed Apr 23 08:07:32 2003
@@ -2771,6 +2773,10 @@
 	return (size < (begin + len - offset)) ?                \
 				size : begin + len - offset;    \
     } while(0)
+
+/* this should _really_ be private to the scsi midlayer.  But
+   /proc/scsi/sg is an established name, so.. */
+extern struct proc_dir_entry *proc_scsi;
 
 static int
 sg_proc_init()
