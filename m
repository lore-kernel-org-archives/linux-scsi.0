From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Patch?: 2.5.45 - Eliminate Scsi_Host_Name
Date: Mon, 4 Nov 2002 10:01:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021104100106.A2328@baldur.yggdrasil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	This patch eliminates struct Scsi_Host_Name and associated
routines.  Instead, it just scans the "scsihosts=" string when it
is time to check for reserved host numbers.

	I have not tested this patch other than to verify that
hosts.c and scsi.c still compile.

	This patch applies after my patch for eliminating
scsi_host_tmpl_list.

-- 
Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
                         "Free Software For The Rest Of Us."

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi.diff2"

diff -u linux.old/drivers/scsi/hosts.h linux/drivers/scsi/hosts.h
--- linux.old/drivers/scsi/hosts.h	2002-11-04 08:10:43.000000000 -0800
+++ linux/drivers/scsi/hosts.h	2002-11-04 09:36:18.000000000 -0800
@@ -508,14 +508,6 @@
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
 extern struct Scsi_Device_Template * scsi_devicelist;
 
 extern void scsi_proc_host_mkdir(Scsi_Host_Template *);
@@ -595,7 +587,6 @@
 extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
 extern void scsi_host_put(struct Scsi_Host *);
 extern void scsi_host_hn_init(char *);
-extern void scsi_host_hn_release(void);
 
 /*
  * host_busy inc/dec/test functions
diff -u linux.old/drivers/scsi/scsi.c linux/drivers/scsi/scsi.c
--- linux.old/drivers/scsi/scsi.c	2002-10-29 20:32:33.000000000 -0800
+++ linux/drivers/scsi/scsi.c	2002-11-04 09:36:10.000000000 -0800
@@ -2472,8 +2472,6 @@
 
         devfs_unregister (scsi_devfs_handle);
 
-	scsi_host_hn_release();
-
 #ifdef CONFIG_PROC_FS
 	/* No, we're not here anymore. Don't show the /proc/scsi files. */
 	remove_proc_entry ("scsi/scsi", 0);
diff -u linux.old/drivers/scsi/hosts.c linux/drivers/scsi/hosts.c
--- linux.old/drivers/scsi/hosts.c	2002-11-04 08:10:43.000000000 -0800
+++ linux/drivers/scsi/hosts.c	2002-11-04 09:48:05.000000000 -0800
@@ -45,8 +45,6 @@
 #include "scsi.h"
 #include "hosts.h"
 
-LIST_HEAD(scsi_host_hn_list);
-
 LIST_HEAD(scsi_host_list);
 spinlock_t scsi_host_list_lock = SPIN_LOCK_UNLOCKED;
 
@@ -54,6 +52,7 @@
 
 static int scsi_host_next_hn;		/* host_no for next new host */
 static int scsi_hosts_registered;	/* cnt of registered scsi hosts */
+static char *scsihosts;
 
 /**
  * scsi_tp_for_each_host - call function for each scsi host off a template
@@ -226,21 +225,11 @@
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
@@ -267,40 +256,57 @@
 }
 
 /**
- * scsi_host_hn_add - allocate and add new Scsi_Host_Name
- * @name:	String to store in name field
+ * scsi_find_host_by_num - get a Scsi_Host by host no and inc ref count
+ *		          scsi_host_list_lock must be held by caller.
+ * @host_no:	host number to locate
  *
  * Return value:
- * 	Pointer to a new Scsi_Host_Name
+ * 	A pointer to located Scsi_Host or NULL.
  **/
-Scsi_Host_Name *scsi_host_hn_add(char *name)
+static struct Scsi_Host *scsi_find_host_by_num(unsigned short host_no)
 {
-	Scsi_Host_Name *shost_name;
-	int len;
+	struct list_head *lh;
+	struct Scsi_Host *shost;
 
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
+	list_for_each(lh, &scsi_host_list) {
+		shost = list_entry(lh, struct Scsi_Host, sh_list);
+		if (shost->host_no == host_no)
+                        return shost;
 	}
 
-	if (len)
-		strncpy(shost_name->name, name, len);
-	shost_name->name[len] = 0;
-	shost_name->host_no = scsi_host_next_hn++;
-	shost_name->host_registered = 0;
-	list_add_tail(&shost_name->shn_list, &scsi_host_hn_list);
+	return NULL;
+}
+
+
+
+/**
+ * scsi_alloc_hostnum - choose new SCSI host number based on host name.
+ * @name:	String to store in name field
+ *
+ * Return value:
+ * 	Pointer to a new Scsi_Host_Name
+ **/
+static int scsi_alloc_host_num(const char *name)
+{
+        int hostnum = 0;
+        if (name != NULL && scsihosts != NULL && scsihosts[0] != '\0') {
 
-	return shost_name;
+                const int namelen = strlen(name);
+                const char *start = scsihosts;
+                while (start) {
+                        const char *end = strpbrk(start, ",:");
+                        int hostlen = end ? (end - start) : strlen(start);
+
+                        if (hostlen == namelen &&
+                            strncmp(name, start, hostlen) == 0 &&
+                            scsi_find_host_by_num(hostnum) == NULL)
+                                return hostnum;
+
+                        start = end;
+                        hostnum++;
+                }
+        }
+        return scsi_host_next_hn++;
 }
 
 /**
@@ -320,10 +326,6 @@
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
@@ -340,33 +342,7 @@
 
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
@@ -657,20 +633,15 @@
  **/
 struct Scsi_Host *scsi_host_hn_get(unsigned short host_no)
 {
-	struct list_head *lh;
 	struct Scsi_Host *shost;
 
 	spin_lock(&scsi_host_list_lock);
-	list_for_each(lh, &scsi_host_list) {
-		shost = list_entry(lh, struct Scsi_Host, sh_list);
-		if (shost->host_no == host_no) {
-			/* XXX Inc ref count */
-			goto done;
-		}
-	}
+        shost = scsi_find_host_by_num(host_no);
+
+        if (shost) {
+                /* XXX Inc ref count */
+        }
 
-	shost = (struct Scsi_Host *)NULL;
-done:
 	spin_unlock(&scsi_host_list_lock);
 	return shost;
 }
@@ -694,34 +665,11 @@
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
-	}
+        scsihosts = shost_hn;
+        while (shost_hn) {
+                scsi_host_next_hn++;
+                shost_hn = strpbrk(shost_hn, ":,");
+        }
 }
 
 void scsi_host_busy_inc(struct Scsi_Host *shost, Scsi_Device *sdev)

--NzB8fVQJ5HfG6fxh--
