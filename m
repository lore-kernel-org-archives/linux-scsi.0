From: viro@www.linux.org.uk
Subject: [PATCH] megaraid annotation
Date: Wed, 01 Sep 2004 00:12:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2HnS-0004Ay-VT@www.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:37317 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269301AbUHaXMP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 19:12:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-scsi@vger.kernel.org

[Sorry about duplicate - forgot to Cc it to linux-scsi first time]
Signed-off-by: Al Viro <viro@parcelfarce.linux.org.uk
----
diff -urN RC9-rc1-bk7-eicon/drivers/scsi/megaraid/megaraid_ioctl.h RC9-rc1-bk7-megaraid/drivers/scsi/megaraid/megaraid_ioctl.h
--- RC9-rc1-bk7-eicon/drivers/scsi/megaraid/megaraid_ioctl.h	Tue Aug 31 14:57:33 2004
+++ RC9-rc1-bk7-megaraid/drivers/scsi/megaraid/megaraid_ioctl.h	Tue Aug 31 18:54:08 2004
@@ -130,9 +130,9 @@
 	uint8_t			reserved[128];
 
 /* Driver Data: */
-	caddr_t			user_data;
+	void __user *		user_data;
 	uint32_t		user_data_len;
-	mraid_passthru_t	*user_pthru;
+	mraid_passthru_t	__user *user_pthru;
 
 	mraid_passthru_t	*pthru32;
 	dma_addr_t		pthru32_h;
diff -urN RC9-rc1-bk7-eicon/drivers/scsi/megaraid/megaraid_mm.c RC9-rc1-bk7-megaraid/drivers/scsi/megaraid/megaraid_mm.c
--- RC9-rc1-bk7-eicon/drivers/scsi/megaraid/megaraid_mm.c	Tue Aug 31 18:53:12 2004
+++ RC9-rc1-bk7-megaraid/drivers/scsi/megaraid/megaraid_mm.c	Tue Aug 31 18:54:25 2004
@@ -24,17 +24,17 @@
 
 
 // routines to convert to and from the old the format
-static int mimd_to_kioc(mimd_t *, mraid_mmadp_t *, uioc_t *);
-static int kioc_to_mimd(uioc_t *, mimd_t *);
+static int mimd_to_kioc(mimd_t __user *, mraid_mmadp_t *, uioc_t *);
+static int kioc_to_mimd(uioc_t *, mimd_t __user *);
 
 
 // Helper functions
-static int handle_drvrcmd(unsigned long, uint8_t, int *);
+static int handle_drvrcmd(void __user *, uint8_t, int *);
 static int lld_ioctl(mraid_mmadp_t *, uioc_t *);
 static void ioctl_done(uioc_t *);
 static void lld_timedout(unsigned long);
 static void hinfo_to_cinfo(mraid_hba_info_t *, mcontroller_t *);
-static mraid_mmadp_t *mraid_mm_get_adapter(mimd_t *, int *);
+static mraid_mmadp_t *mraid_mm_get_adapter(mimd_t __user *, int *);
 static uioc_t *mraid_mm_alloc_kioc(mraid_mmadp_t *);
 static void mraid_mm_dealloc_kioc(mraid_mmadp_t *, uioc_t *);
 static int mraid_mm_attach_buf(mraid_mmadp_t *, uioc_t *, int);
@@ -108,6 +108,7 @@
 	mraid_mmadp_t	*adp;
 	uint8_t		old_ioctl;
 	int		drvrcmd_rval;
+	void __user *argp = (void __user *)arg;
 
 	/*
 	 * Make sure only USCSICMD are issued through this interface.
@@ -121,7 +122,7 @@
 	/*
 	 * Look for signature to see if this is the new or old ioctl format.
 	 */
-	if (copy_from_user(signature, (char *)arg, EXT_IOCTL_SIGN_SZ)) {
+	if (copy_from_user(signature, argp, EXT_IOCTL_SIGN_SZ)) {
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid cmm: copy from usr addr failed\n"));
 		return (-EFAULT);
@@ -142,7 +143,7 @@
 	 * If it is a driver ioctl (as opposed to fw ioctls), then we can
 	 * handle the command locally. rval > 0 means it is not a drvr cmd
 	 */
-	rval = handle_drvrcmd(arg, old_ioctl, &drvrcmd_rval);
+	rval = handle_drvrcmd(argp, old_ioctl, &drvrcmd_rval);
 
 	if (rval < 0)
 		return rval;
@@ -150,7 +151,7 @@
 		return drvrcmd_rval;
 
 	rval = 0;
-	if ((adp = mraid_mm_get_adapter((mimd_t*)arg, &rval)) == NULL) {
+	if ((adp = mraid_mm_get_adapter(argp, &rval)) == NULL) {
 		return rval;
 	}
 
@@ -162,7 +163,7 @@
 	/*
 	 * User sent the old mimd_t ioctl packet. Convert it to uioc_t.
 	 */
-	if ((rval = mimd_to_kioc((mimd_t*)arg, adp, kioc))) {
+	if ((rval = mimd_to_kioc(argp, adp, kioc))) {
 		mraid_mm_dealloc_kioc(adp, kioc);
 		return rval;
 	}
@@ -180,7 +181,7 @@
 	/*
 	 * Convert the kioc back to user space
 	 */
-	rval = kioc_to_mimd(kioc, (mimd_t *)arg);
+	rval = kioc_to_mimd(kioc, argp);
 
 	/*
 	 * Return the kioc to free pool
@@ -197,7 +198,7 @@
  * @adapter	: pointer to the adapter (OUT)
  */
 static mraid_mmadp_t *
-mraid_mm_get_adapter(mimd_t *umimd, int *rval)
+mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 {
 	mraid_mmadp_t	*adapter;
 	mimd_t		mimd;
@@ -239,9 +240,9 @@
  * @old_ioctl	: mimd if 1; uioc otherwise
  */
 static int
-handle_drvrcmd(unsigned long arg, uint8_t old_ioctl, int *rval)
+handle_drvrcmd(void __user *arg, uint8_t old_ioctl, int *rval)
 {
-	mimd_t		*umimd;
+	mimd_t		__user *umimd;
 	mimd_t		kmimd;
 	uint8_t		opcode;
 	uint8_t		subopcode;
@@ -256,7 +257,7 @@
 
 old_packet:
 	*rval = 0;
-	umimd = (mimd_t*) arg;
+	umimd = arg;
 
 	if (copy_from_user(&kmimd, umimd, sizeof(mimd_t)))
 		return (-EFAULT);
@@ -312,7 +313,7 @@
  */
 
 static int
-mimd_to_kioc(mimd_t *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
+mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *adp, uioc_t *kioc)
 {
 	mbox64_t		*mbox64;
 	mbox_t			*mbox;
@@ -436,7 +437,7 @@
 	kioc->user_pthru	= &umimd->pthru;
 	mbox->xferaddr		= (uint32_t)kioc->pthru32_h;
 
-	if (copy_from_user(pthru32, (caddr_t)kioc->user_pthru,
+	if (copy_from_user(pthru32, kioc->user_pthru,
 			sizeof(mraid_passthru_t))) {
 		return (-EFAULT);
 	}
@@ -719,14 +720,14 @@
  * @mimd	: User space MIMD packet
  */
 static int
-kioc_to_mimd(uioc_t *kioc, mimd_t *mimd)
+kioc_to_mimd(uioc_t *kioc, mimd_t __user *mimd)
 {
 	mimd_t			kmimd;
 	uint8_t			opcode;
 	uint8_t			subopcode;
 
 	mbox64_t		*mbox64;
-	mraid_passthru_t	*upthru32;
+	mraid_passthru_t	__user *upthru32;
 	mraid_passthru_t	*kpthru32;
 	mcontroller_t		cinfo;
 	mraid_hba_info_t	*hinfo;
@@ -767,8 +768,8 @@
 		upthru32 = kioc->user_pthru;
 		kpthru32 = kioc->pthru32;
 
-		if (copy_to_user((void *)&upthru32->scsistatus,
-					(void *)&kpthru32->scsistatus,
+		if (copy_to_user(&upthru32->scsistatus,
+					&kpthru32->scsistatus,
 					sizeof(uint8_t))) {
 			return (-EFAULT);
 		}
@@ -781,8 +782,8 @@
 		}
 	}
 
-	if (copy_to_user((void *)&mimd->mbox[17],
-			(void *)&mbox64->mbox32.status, sizeof(uint8_t))) {
+	if (copy_to_user(&mimd->mbox[17],
+			&mbox64->mbox32.status, sizeof(uint8_t))) {
 		return (-EFAULT);
 	}
 
diff -urN RC9-rc1-bk7-eicon/drivers/scsi/megaraid/megaraid_mm.h RC9-rc1-bk7-megaraid/drivers/scsi/megaraid/megaraid_mm.h
--- RC9-rc1-bk7-eicon/drivers/scsi/megaraid/megaraid_mm.h	Tue Aug 31 14:57:33 2004
+++ RC9-rc1-bk7-megaraid/drivers/scsi/megaraid/megaraid_mm.h	Tue Aug 31 18:54:15 2004
@@ -74,11 +74,11 @@
 			uint8_t subopcode;
 			uint16_t adapno;
 #if BITS_PER_LONG == 32
-			uint8_t *buffer;
+			uint8_t __user *buffer;
 			uint8_t pad[4];
 #endif
 #if BITS_PER_LONG == 64
-			uint8_t *buffer;
+			uint8_t __user *buffer;
 #endif
 			uint32_t length;
 		} __attribute__ ((packed)) fcs;
@@ -88,11 +88,11 @@
 	mraid_passthru_t pthru;
 
 #if BITS_PER_LONG == 32
-	char *data;		/* buffer <= 4096 for 0x80 commands */
+	char __user *data;		/* buffer <= 4096 for 0x80 commands */
 	char pad[4];
 #endif
 #if BITS_PER_LONG == 64
-	char *data;
+	char __user *data;
 #endif
 
 } __attribute__ ((packed))mimd_t;
