From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove qla_hostlist
Date: Thu, 13 May 2004 11:11:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040513091116.GA28124@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:63706 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263969AbUEMJLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 05:11:55 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

it's only used in proc_info currently and there we already have a
scsi_host as argument anyway.


--- 1.7/drivers/scsi/qla2xxx/qla_gbl.h	Fri Mar 12 18:09:07 2004
+++ edited/drivers/scsi/qla2xxx/qla_gbl.h	Sun May  9 11:46:00 2004
@@ -74,9 +74,6 @@
 #if defined(MODULE)
 extern char *ql2xopts;
 #endif
-extern struct list_head qla_hostlist;
-extern rwlock_t qla_hostlist_lock;
-
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
 extern void qla2x00_cmd_timeout(srb_t *);
===== drivers/scsi/qla2xxx/qla_os.c 1.16 vs edited =====
--- 1.16/drivers/scsi/qla2xxx/qla_os.c	Wed Apr 21 22:42:05 2004
+++ edited/drivers/scsi/qla2xxx/qla_os.c	Sun May  9 11:45:41 2004
@@ -128,13 +128,6 @@
 static void copy_mem_info(struct info_str *, char *, int);
 static int copy_info(struct info_str *, char *, ...);
 
-
-/*
- * List of host adapters
- */
-LIST_HEAD(qla_hostlist);
-rwlock_t qla_hostlist_lock = RW_LOCK_UNLOCKED;
-
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -2107,11 +2100,6 @@
 	/* Enable chip interrupts. */
 	qla2x00_enable_intrs(ha);
 
-	/* Insert new entry into the list of adapters */
-	write_lock(&qla_hostlist_lock);
-	list_add_tail(&ha->list, &qla_hostlist);
-	write_unlock(&qla_hostlist_lock);
-
 	/* v2.19.5b6 */
 	/*
 	 * Wait around max loop_reset_delay secs for the devices to come
@@ -2173,10 +2161,6 @@
 
 	ha = pci_get_drvdata(pdev);
 
-	write_lock(&qla_hostlist_lock);
-	list_del(&ha->list);
-	write_unlock(&qla_hostlist_lock);
-
 	sysfs_remove_bin_file(&ha->host->shost_gendev.kobj,
 	    &sysfs_fw_dump_attr);
 	sysfs_remove_bin_file(&ha->host->shost_gendev.kobj, &sysfs_nvram_attr);
@@ -2321,7 +2305,6 @@
 	uint32_t        tmp_sn;
 	unsigned long   *flags;
 	uint8_t		*loop_state;
-	int	found;
 	scsi_qla_host_t *ha;
 	char fw_info[30];
 
@@ -2329,27 +2312,7 @@
 	    "Entering proc_info buff_in=%p, offset=0x%lx, length=0x%x\n",
 	    buffer, offset, length);)
 
-	ha = NULL;
-
-	/* Find the host that was specified */
-	found = 0;
-	read_lock(&qla_hostlist_lock);
-	list_for_each_entry(ha, &qla_hostlist, list) {
-		if (ha->host == shost) {
-			found++;
-			break;
-		}
-	}
-	read_unlock(&qla_hostlist_lock);
-
-	/* if host wasn't found then exit */
-	if (!found) {
-		DEBUG2_3(printk(KERN_WARNING
-		    "%s: Can't find adapter for host %p\n", 
-		    __func__, shost);)
-
-		return (retval);
-	}
+	ha = (scsi_qla_host_t *) shost->hostdata;
 
 	if (inout == TRUE) {
 		/* Has data been written to the file? */
