From: Christoph Hellwig <hch@lst.de>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Wed, 6 Nov 2002 00:54:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106005420.A27699@lst.de>
References: <200211051220.EAA26599@adam.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211051220.EAA26599@adam.yggdrasil.com>; from adam@yggdrasil.com on Tue, Nov 05, 2002 at 04:20:15AM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Nov 05, 2002 at 04:20:15AM -0800, Adam J. Richter wrote:
> 	Oops, I see that Chrisoph Hellwig posted a patch 19.5 earlier
> than mine that did this clean up and some other related ones, so please
> disregard my patch and apply Christoph's.
> 
> 	Chistoph, since you're in the process of doing similar
> clean-ups, you might want to try my untested patch that eliminated
> Scsi_Host_Name:
> 
> 	 http://marc.theaimsgroup.com/?l=linux-scsi&m=103643303212376&w=2
> 
> 	If it works and looks OK to you, Christoph, I'd encourage you
> to put it into your patch stream if you want, so as to reduce patch
> conflicts for James, Linus, et al.  On the other hand, if that just
> creates work for you that you weren't keen on doing, don't worry about
> it.  I don't mean to impose.

Okay, here's a version with minimal cleanups (different placements of
the functions, use of list_for_each_entry, etc..) against
scsi-for-linus-2.5.  Patch looks fine to me, but I had no chance to
actually test the boot argument.

--- 1.22/drivers/scsi/hosts.c	Mon Nov  4 17:04:04 2002
+++ edited/drivers/scsi/hosts.c	Tue Nov  5 23:44:01 2002
@@ -45,12 +45,69 @@
 #include "scsi.h"
 #include "hosts.h"
 
-static LIST_HEAD(scsi_host_hn_list);
 static LIST_HEAD(scsi_host_list);
 static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
 
 static int scsi_host_next_hn;		/* host_no for next new host */
 static int scsi_hosts_registered;	/* cnt of registered scsi hosts */
+static char *scsihosts;
+
+/**
+  * scsi_find_host_by_num - get a Scsi_Host by host no and inc ref count
+  *			    scsi_host_list_lock must be held by caller.
+  * @host_no:	host number to locate
+  *
+  * Return value:
+  *	A pointer to located Scsi_Host or NULL.
+  **/
+static struct Scsi_Host *scsi_find_host_by_num(unsigned short host_no)
+{
+	struct Scsi_Host *shost;
+
+	spin_lock(&scsi_host_list_lock);
+	list_for_each_entry(shost, &scsi_host_list, sh_list) {
+		if (shost->host_no == host_no) {
+			spin_unlock(&scsi_host_list_lock);
+			return shost;
+		}
+	}
+	spin_unlock(&scsi_host_list_lock);
+	return NULL;
+}
+
+/**
+ * scsi_alloc_hostnum - choose new SCSI host number based on host name.
+ * @name:	String to store in name field
+ *
+ * Return value:
+ *	Pointer to a new Scsi_Host_Name
+ **/
+static int scsi_alloc_host_num(const char *name)
+{
+	int hostnum = 0;
+
+	if (name && scsihosts && scsihosts[0] != '\0') {
+		const int namelen = strlen(name);
+		const char *start, *end;
+
+		for (start = scsihosts; start; start = end, hostnum++) {
+			int hostlen;
+
+			end = strpbrk(start, ",:");
+			hostlen = end ? (end - start) : strlen(start);
+
+			if (hostlen != namelen)
+				continue;
+			if (strncmp(name, start, hostlen))
+				continue;
+			if (scsi_find_host_by_num(hostnum))
+				continue;
+			return hostnum;
+		}
+	}
+
+	return scsi_host_next_hn++;
+}
 
 /**
  * scsi_tp_for_each_host - call function for each scsi host off a template
@@ -67,7 +124,6 @@
 	struct Scsi_Host *shost;
 
 	spin_lock(&scsi_host_list_lock);
-
 	list_for_each_safe(lh, lh_sf, &scsi_host_list) {
 		shost = list_entry(lh, struct Scsi_Host, sh_list);
 		if (shost->hostt == shost_tp) {
@@ -76,14 +132,12 @@
 			spin_lock(&scsi_host_list_lock);
 		}
 	}
-
 	spin_unlock(&scsi_host_list_lock);
-
 	return 0;
 }
 
 /**
- * scsi_host_generic_release - default release function for hosts
+ * scsi_host_legacy_release - default release function for hosts
  * @shost: 
  * 
  * Description:
@@ -248,24 +302,12 @@
  **/
 void scsi_unregister(struct Scsi_Host *shost)
 {
-	struct list_head *lh;
-	Scsi_Host_Name *shost_name;
-
 	/* Remove shost from scsi_host_list */
 	spin_lock(&scsi_host_list_lock);
 	list_del(&shost->sh_list);
 	spin_unlock(&scsi_host_list_lock);
 
-	/* Unregister from scsi_host_hn_list */
-	list_for_each(lh, &scsi_host_hn_list) {
-		shost_name = list_entry(lh, Scsi_Host_Name, shn_list);
-		if (shost->host_no == shost_name->host_no)
-			shost_name->host_registered = 0;
-	}
-
-	/*
-	 * Next, kill the kernel error recovery thread for this host.
-	 */
+	/* Next, kill the kernel error recovery thread for this host. */
 	if (shost->ehandler) {
 		DECLARE_MUTEX_LOCKED(sem);
 		shost->eh_notify = &sem;
@@ -283,49 +325,12 @@
 	if (!shost->hostt->present)
 		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
 #endif
-	device_unregister(&shost->host_driverfs_dev);
 
+	device_unregister(&shost->host_driverfs_dev);
 	kfree(shost);
 }
 
 /**
- * scsi_host_hn_add - allocate and add new Scsi_Host_Name
- * @name:	String to store in name field
- *
- * Return value:
- * 	Pointer to a new Scsi_Host_Name
- **/
-Scsi_Host_Name *scsi_host_hn_add(char *name)
-{
-	Scsi_Host_Name *shost_name;
-	int len;
-
-	len = strlen(name);
-	shost_name =  kmalloc(sizeof(*shost_name), GFP_KERNEL);
-	if (!shost_name) {
-		printk(KERN_ERR "%s: out of memory at line %d.\n",
-		       __FUNCTION__, __LINE__);
-		return NULL;
-	}
-	shost_name->name = kmalloc(len + 1, GFP_KERNEL);
-	if (!shost_name->name) {
-		kfree(shost_name);
-		printk(KERN_ERR "%s: out of memory at line %d.\n",
-		       __FUNCTION__, __LINE__);
-		return NULL;
-	}
-
-	if (len)
-		strncpy(shost_name->name, name, len);
-	shost_name->name[len] = 0;
-	shost_name->host_no = scsi_host_next_hn++;
-	shost_name->host_registered = 0;
-	list_add_tail(&shost_name->shn_list, &scsi_host_hn_list);
-
-	return shost_name;
-}
-
-/**
  * scsi_register - register a scsi host adapter instance.
  * @shost_tp:	pointer to scsi host template
  * @xtr_bytes:	extra bytes to allocate for driver
@@ -342,10 +347,6 @@
 struct Scsi_Host * scsi_register(Scsi_Host_Template *shost_tp, int xtr_bytes)
 {
 	struct Scsi_Host *shost, *shost_scr;
-	Scsi_Host_Name *shost_name = NULL;
-	Scsi_Host_Name *shn = NULL;
-	char *hname;
-	size_t hname_len;
 	struct list_head *lh;
 	int gfp_mask;
 	DECLARE_MUTEX_LOCKED(sem);
@@ -362,33 +363,7 @@
 
 	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
 
-	/*
-	 * Determine host number. Check reserved first before allocating
-	 * new one
-	 */
-	hname = (shost_tp->proc_name) ?  shost_tp->proc_name : "";
-	hname_len = strlen(hname);
-
-	if (hname_len)
-		list_for_each(lh, &scsi_host_hn_list) {
-			shn = list_entry(lh, Scsi_Host_Name, shn_list);
-			if (!(shn->host_registered) &&
-			    !strncmp(hname, shn->name, hname_len)) {
-				shost_name = shn;
-				break;
-			}
-		}
-
-	if (!shost_name) {
-		shost_name = scsi_host_hn_add(hname);
-		if (!shost_name) {
-			kfree(shost);
-			return NULL;
-		}
-	}
-
-	shost->host_no = shost_name->host_no;
-	shost_name->host_registered = 1;
+	shost->host_no = scsi_alloc_host_num(shost_tp->proc_name);
 	scsi_hosts_registered++;
 
 	spin_lock_init(&shost->default_lock);
@@ -431,7 +406,7 @@
 	shost->unchecked_isa_dma = shost_tp->unchecked_isa_dma;
 	shost->use_clustering = shost_tp->use_clustering;
 	if (!blk_nohighio)
-	shost->highmem_io = shost_tp->highmem_io;
+		shost->highmem_io = shost_tp->highmem_io;
 
 	shost->max_sectors = shost_tp->max_sectors;
 	shost->use_blk_tcq = shost_tp->use_blk_tcq;
@@ -637,22 +612,8 @@
  **/
 struct Scsi_Host *scsi_host_hn_get(unsigned short host_no)
 {
-	struct list_head *lh;
-	struct Scsi_Host *shost;
-
-	spin_lock(&scsi_host_list_lock);
-	list_for_each(lh, &scsi_host_list) {
-		shost = list_entry(lh, struct Scsi_Host, sh_list);
-		if (shost->host_no == host_no) {
-			/* XXX Inc ref count */
-			goto done;
-		}
-	}
-
-	shost = (struct Scsi_Host *)NULL;
-done:
-	spin_unlock(&scsi_host_list_lock);
-	return shost;
+	/* XXX Inc ref count */
+	return scsi_find_host_by_num(host_no);
 }
 
 /**
@@ -674,33 +635,10 @@
  **/
 void __init scsi_host_hn_init(char *shost_hn)
 {
-	char *temp = shost_hn;
-
-	while (temp) {
-		while (*temp && (*temp != ':') && (*temp != ','))
-			temp++;
-		if (!*temp)
-			temp = NULL;
-		else
-			*temp++ = 0;
-		(void)scsi_host_hn_add(shost_hn);
-		shost_hn = temp;
-	}
-}
-
-/**
- * scsi_host_no_release - free all entries in scsi host number list
- **/
-void __exit scsi_host_hn_release()
-{
-	struct list_head *lh, *next;
-	Scsi_Host_Name *shn;
-
-	list_for_each_safe(lh, next, &scsi_host_hn_list) {
-		shn = list_entry(lh, Scsi_Host_Name, shn_list);
-		if (shn->name)
-			kfree(shn->name);
-		kfree(shn);
+	scsihosts = shost_hn;
+	while (shost_hn) {
+		scsi_host_next_hn++;
+		shost_hn = strpbrk(shost_hn, ":,");
 	}
 }
 
--- 1.31/drivers/scsi/hosts.h	Mon Nov  4 23:07:50 2002
+++ edited/drivers/scsi/hosts.h	Tue Nov  5 23:07:07 2002
@@ -509,14 +509,6 @@
 extern void scsi_block_requests(struct Scsi_Host *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 
-typedef struct SHN
-{
-	struct list_head shn_list;
-	char *name;
-	unsigned short host_no;
-	unsigned short host_registered;
-} Scsi_Host_Name;
-	
 extern void scsi_proc_host_mkdir(Scsi_Host_Template *);
 extern void scsi_proc_host_add(struct Scsi_Host *);
 extern void scsi_proc_host_rm(struct Scsi_Host *);
@@ -599,7 +591,6 @@
 extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
 extern void scsi_host_put(struct Scsi_Host *);
 extern void scsi_host_hn_init(char *);
-extern void scsi_host_hn_release(void);
 
 /*
  * host_busy inc/dec/test functions
--- 1.54/drivers/scsi/scsi.c	Mon Nov  4 22:51:49 2002
+++ edited/drivers/scsi/scsi.c	Tue Nov  5 23:28:43 2002
@@ -2394,9 +2394,7 @@
 {
 	int i;
 
-        devfs_unregister (scsi_devfs_handle);
-
-	scsi_host_hn_release();
+	devfs_unregister (scsi_devfs_handle);
 
 #ifdef CONFIG_PROC_FS
 	/* No, we're not here anymore. Don't show the /proc/scsi files. */
