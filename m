From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill scsihosts= boot parameter
Date: Fri, 6 Jun 2003 09:59:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606075954.GB18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:10705 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265392AbTFFHqZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 03:46:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This feature is seriously racy, and doesn't work under many
circumstances.  As we have proper ways to find devices by their
their locical naming (UUID, fs label) or physical connectivity
(scsidev, sysfs) it shouldn't be nessecary anymore.


diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Jun  5 12:05:04 2003
+++ b/drivers/scsi/hosts.c	Thu Jun  5 12:05:04 2003
@@ -49,96 +49,6 @@
 static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
 
 static int scsi_host_next_hn;		/* host_no for next new host */
-static char *scsihosts;
-
-MODULE_PARM(scsihosts, "s");
-MODULE_PARM_DESC(scsihosts, "scsihosts=driver1,driver2,driver3");
-#ifndef MODULE
-int __init scsi_setup(char *str)
-{
-	scsihosts = str;
-	return 1;
-}
-
-__setup("scsihosts=", scsi_setup);
-#endif
-
-/**
-  * scsi_find_host_by_num - get a Scsi_Host by host no
-  *
-  * @host_no:	host number to locate
-  *
-  * Return value:
-  *	A pointer to located Scsi_Host or NULL.
-  **/
-static struct Scsi_Host *scsi_find_host_by_num(unsigned short host_no)
-{
-	struct Scsi_Host *shost, *shost_found = NULL;
-
-	spin_lock(&scsi_host_list_lock);
-	list_for_each_entry(shost, &scsi_host_list, sh_list) {
-		if (shost->host_no > host_no) {
-			/*
-			 * The list is sorted.
-			 */
-			break;
-		} else if (shost->host_no == host_no) {
-			shost_found = shost;
-			break;
-		}
-	}
-	spin_unlock(&scsi_host_list_lock);
-	return shost_found;
-}
-
-/**
- * scsi_alloc_hostnum - choose new SCSI host number based on host name.
- * @name:	String to store in name field
- *
- * Return value:
- *	Pointer to a new Scsi_Host_Name
- **/
-static int scsi_alloc_host_num(const char *name)
-{
-	int hostnum;
-	int namelen;
-	const char *start, *end;
-
-	if (name) {
-		hostnum = 0;
-		namelen = strlen(name);
-		start = scsihosts; 
-		while (1) {
-			int hostlen;
-
-			if (start && start[0] != '\0') {
-				end = strpbrk(start, ",:");
-				if (end) {
-					hostlen = (end - start);
-					end++;
-				} else
-					hostlen = strlen(start);
-				/*
-				 * Look for a match on the scsihosts list.
-				 */
-				if ((hostlen == namelen) && 
-				    (strncmp(name, start, hostlen) == 0) && 
-				    (!scsi_find_host_by_num(hostnum)))
-					return hostnum;
-				start = end;
-			} else  {
-				/*
-				 * Look for any unused numbers.
-				 */
-				if (!scsi_find_host_by_num(hostnum))
-					return hostnum;
-			}
-			hostnum++;
-		}
-	} else
-		return scsi_host_next_hn++;
-}
-
 
 /**
  * scsi_tp_for_each_host - call function for each scsi host off a template
@@ -307,7 +217,7 @@
 
 	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
 
-	shost->host_no = scsi_alloc_host_num(shost_tp->proc_name);
+	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
 
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
@@ -514,26 +424,8 @@
  **/
 void scsi_host_put(struct Scsi_Host *shost)
 {
-
 	class_device_put(&shost->class_dev);
 	put_device(&shost->host_gendev);
-}
-
-/**
- * scsi_host_init - set up the scsi host number list based on any entries
- * scsihosts.
- **/
-void __init scsi_host_init(void)
-{
-	char *shost_hn;
-
-	shost_hn = scsihosts;
-	while (shost_hn) {
-		scsi_host_next_hn++;
-		shost_hn = strpbrk(shost_hn, ":,");
-		if (shost_hn)
-			shost_hn++;
-	}
 }
 
 void scsi_host_busy_inc(struct Scsi_Host *shost, Scsi_Device *sdev)
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Thu Jun  5 12:05:04 2003
+++ b/drivers/scsi/scsi.c	Thu Jun  5 12:05:04 2003
@@ -987,7 +987,6 @@
 	for (i = 0; i < NR_CPUS; i++)
 		INIT_LIST_HEAD(&done_q[i]);
 
-	scsi_host_init();
 	devfs_mk_dir("scsi");
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
