From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5 scsi-misc-2.5 remove scsi_host_hn_list
Date: Tue, 12 Nov 2002 12:24:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021112122431.A23657@eng2.beaverton.ibm.com>
References: <20021112104759.A21739@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e33.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gACKOYWR055566
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2002 15:24:34 -0500
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gACKOWnU064188
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2002 13:24:33 -0700
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id gACKKFV20211
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2002 12:20:15 -0800
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id gACKOWp23723
	for linux-scsi@vger.kernel.org; Tue, 12 Nov 2002 12:24:32 -0800 (PST)
In-Reply-To: <20021112104759.A21739@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Nov 12, 2002 at 10:47:59AM -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There were two static scsihosts with the previous patch.

This version gets rid of the one in scsi.c, and moves all the scsihosts
related code in scsi.c (except the scsi_host_hn_init) call into hosts.c.

 hosts.c |  225 +++++++++++++++++++++++++++++-----------------------------------
 hosts.h |    3 
 scsi.c  |   17 ----
 3 files changed, 104 insertions(+), 141 deletions(-)

diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Tue Nov 12 12:09:31 2002
+++ b/drivers/scsi/hosts.c	Tue Nov 12 12:09:31 2002
@@ -45,13 +45,102 @@
 #include "scsi.h"
 #include "hosts.h"
 
-static LIST_HEAD(scsi_host_hn_list);
 static LIST_HEAD(scsi_host_list);
 static spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
 
 static int scsi_host_next_hn;		/* host_no for next new host */
 static int scsi_hosts_registered;	/* cnt of registered scsi hosts */
 static int scsi_ignore_no_error_handling = 0;
+static char *scsihosts;
+
+MODULE_PARM(scsihosts, "s");
+MODULE_PARM_DESC(scsihosts, "scsihosts=driver1,driver2,driver3");
+#ifndef MODULE
+int __init scsi_setup(char *str)
+{
+	scsihosts = str;
+	return 1;
+}
+
+__setup("scsihosts=", scsi_setup);
+#endif
+
+/**
+  * scsi_find_host_by_num - get a Scsi_Host by host no
+  *
+  * @host_no:	host number to locate
+  *
+  * Return value:
+  *	A pointer to located Scsi_Host or NULL.
+  **/
+static struct Scsi_Host *scsi_find_host_by_num(unsigned short host_no)
+{
+	struct Scsi_Host *shost, *shost_found = NULL;
+
+	spin_lock(&scsi_host_list_lock);
+	list_for_each_entry(shost, &scsi_host_list, sh_list) {
+		if (shost->host_no > host_no) {
+			/*
+			 * The list is sorted.
+			 */
+			break;
+		} else if (shost->host_no == host_no) {
+			shost_found = shost;
+			break;
+		}
+	}
+	spin_unlock(&scsi_host_list_lock);
+	return shost_found;
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
+	int hostnum;
+	int namelen;
+	const char *start, *end;
+
+	if (name) {
+		hostnum = 0;
+		namelen = strlen(name);
+		start = scsihosts; 
+		while (1) {
+			int hostlen;
+
+			if (start && start[0] != '\0') {
+				end = strpbrk(start, ",:");
+				if (end) {
+					hostlen = (end - start);
+					end++;
+				} else
+					hostlen = strlen(start);
+				/*
+				 * Look for a match on the scsihosts list.
+				 */
+				if ((hostlen == namelen) && 
+				    (strncmp(name, start, hostlen) == 0) && 
+				    (!scsi_find_host_by_num(hostnum)))
+					return hostnum;
+				start = end;
+			} else  {
+				/*
+				 * Look for any unused numbers.
+				 */
+				if (!scsi_find_host_by_num(hostnum))
+					return hostnum;
+			}
+			hostnum++;
+		}
+	} else
+		return scsi_host_next_hn++;
+}
+
 
 /**
  * scsi_tp_for_each_host - call function for each scsi host off a template
@@ -244,21 +333,11 @@
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
 	/*
 	 * Next, kill the kernel error recovery thread for this host.
 	 */
@@ -285,43 +364,6 @@
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
@@ -338,28 +380,17 @@
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
 
-	/*
-	 * Determine host number. Check reserved first before allocating
-	 * new one
-	 */
-	hname = (shost_tp->proc_name) ?  shost_tp->proc_name : "";
-	hname_len = strlen(hname);
-
         /* Check to see if this host has any error handling facilities */
         if(shost_tp->eh_strategy_handler == NULL &&
            shost_tp->eh_abort_handler == NULL &&
            shost_tp->eh_device_reset_handler == NULL &&
            shost_tp->eh_bus_reset_handler == NULL &&
            shost_tp->eh_host_reset_handler == NULL) {
-		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\nERROR: This is not a safe way to run your SCSI host\nERROR: The error handling must be added to this driver\n", hname);
+		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\nERROR: This is not a safe way to run your SCSI host\nERROR: The error handling must be added to this driver\n", shost_tp->proc_name);
 		dump_stack();
         } 
 	gfp_mask = GFP_KERNEL;
@@ -374,26 +405,7 @@
 
 	memset(shost, 0, sizeof(struct Scsi_Host) + xtr_bytes);
 
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
@@ -642,22 +654,8 @@
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
@@ -677,35 +675,16 @@
  * scsi_host_hn_init - init scsi host number list from string
  * @shost_hn:	string of scsi host driver names.
  **/
-void __init scsi_host_hn_init(char *shost_hn)
-{
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
+void __init scsi_host_hn_init(void)
 {
-	struct list_head *lh, *next;
-	Scsi_Host_Name *shn;
+	char *shost_hn;
 
-	list_for_each_safe(lh, next, &scsi_host_hn_list) {
-		shn = list_entry(lh, Scsi_Host_Name, shn_list);
-		if (shn->name)
-			kfree(shn->name);
-		kfree(shn);
+	shost_hn = scsihosts;
+	while (shost_hn) {
+		scsi_host_next_hn++;
+		shost_hn = strpbrk(shost_hn, ":,");
+		if (shost_hn)
+			shost_hn++;
 	}
 }
 
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Tue Nov 12 12:09:31 2002
+++ b/drivers/scsi/hosts.h	Tue Nov 12 12:09:31 2002
@@ -578,8 +578,7 @@
 extern struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
 extern void scsi_host_put(struct Scsi_Host *);
-extern void scsi_host_hn_init(char *);
-extern void scsi_host_hn_release(void);
+extern void scsi_host_hn_init(void);
 
 /*
  * host_busy inc/dec/test functions
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Tue Nov 12 12:09:31 2002
+++ b/drivers/scsi/scsi.c	Tue Nov 12 12:09:31 2002
@@ -2241,22 +2241,9 @@
 }
 #endif				/* CONFIG_PROC_FS */
 
-static char *scsihosts;
-
-MODULE_PARM(scsihosts, "s");
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
 
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
 static void *scsi_pool_alloc(int gfp_mask, void *data)
 {
 	return kmem_cache_alloc(data, gfp_mask);
@@ -2381,7 +2368,7 @@
 
         scsi_devfs_handle = devfs_mk_dir (NULL, "scsi", NULL);
 
-	scsi_host_hn_init(scsihosts);
+	scsi_host_hn_init();
 
 	bus_register(&scsi_driverfs_bus_type);
 
@@ -2396,8 +2383,6 @@
 	int i;
 
         devfs_unregister (scsi_devfs_handle);
-
-	scsi_host_hn_release();
 
 #ifdef CONFIG_PROC_FS
 	/* No, we're not here anymore. Don't show the /proc/scsi files. */
