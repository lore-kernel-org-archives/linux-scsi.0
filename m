From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill scsi_host_get_next
Date: Tue, 27 May 2003 14:03:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527120339.GA14177@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:4273 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263407AbTE0Lu2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 07:50:28 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

The only reamining user was a horrible hack with a big XXX:
in scsi_pc98.c.  Remove it and add an even bigger XXX there,
we don't want to keep this function (and the scsi hostlist)
around just for this.


--- 1.68/drivers/scsi/hosts.c	Mon May 26 15:38:16 2003
+++ edited/drivers/scsi/hosts.c	Mon May 26 16:10:33 2003
@@ -490,38 +490,6 @@
 }
 
 /**
- * *scsi_host_get_next - get scsi host and inc ref count
- * @shost:	pointer to a Scsi_Host or NULL to start.
- *
- * Return value:
- * 	A pointer to next Scsi_Host in list or NULL.
- **/
-struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *shost)
-{
-	struct list_head *lh = NULL;
-
-	spin_lock(&scsi_host_list_lock);
-	if (shost) {
-		/* XXX Dec ref on cur shost */
-		lh = shost->sh_list.next;
-	} else {
-		lh = scsi_host_list.next;
-	}
-
-	if (lh == &scsi_host_list) {
-		shost = (struct Scsi_Host *)NULL;
-		goto done;
-	}
-
-	shost = list_entry(lh, struct Scsi_Host, sh_list);
-	/* XXX Inc ref count */
-
-done:
-	spin_unlock(&scsi_host_list_lock);
-	return shost;
-}
-
-/**
  * scsi_host_lookup - get a reference to a Scsi_Host by host no
  *
  * @hostnum:	host number to locate
===== drivers/scsi/scsi_pc98.c 1.2 vs edited =====
--- 1.2/drivers/scsi/scsi_pc98.c	Wed Mar  5 05:49:21 2003
+++ edited/drivers/scsi/scsi_pc98.c	Mon May 26 16:09:10 2003
@@ -15,21 +15,6 @@
 #include "hosts.h"
 
 
-/* XXX - For now, we assume the first (i.e. having the least host_no)
-   real (i.e. non-emulated) host adapter shall be BIOS-controlled one.
-   We *SHOULD* invent another way.  */
-static inline struct Scsi_Host *first_real_host(void)
-{
-	struct Scsi_Host *shost = NULL;
-
-	while ((shost = scsi_host_get_next(shost))) {
-		if (!shost->hostt->emulated)
-			break;
-	}
-
-	return shost;
-}
-
 static int pc98_first_bios_param(struct scsi_device *sdev, int *ip)
 {
 	const u8 *p = (&__PC9800SCA(u8, PC9800SCA_SCSI_PARAMS) + sdev->id * 4);
@@ -50,7 +35,16 @@
 {
 	struct Scsi_Host *first_real = first_real_host();
 
-	if (sdev->host == first_real && sdev->id < 7 &&
+	/*
+	 * XXX
+	 * XXX This needs to become a sysfs attribute that's set
+	 * XXX by code that knows which host is the first one.
+	 * XXX
+	 * XXX Currently we support only one host on with a
+	 * XXX PC98ish HBA.
+	 * XXX
+	 */
+	if (1 || sdev->host == first_real && sdev->id < 7 &&
 	    __PC9800SCA_TEST_BIT(PC9800SCA_DISK_EQUIPS, sdev->id))
 	    	return pc98_first_bios_param(sdev, ip);
 
===== drivers/scsi/scsi_priv.h 1.11 vs edited =====
--- 1.11/drivers/scsi/scsi_priv.h	Mon May 26 16:07:04 2003
+++ edited/drivers/scsi/scsi_priv.h	Mon May 26 16:09:20 2003
@@ -55,7 +55,6 @@
 /* hosts.c */
 extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
 extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
-extern struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern void scsi_host_put(struct Scsi_Host *);
 extern void scsi_host_init(void);
