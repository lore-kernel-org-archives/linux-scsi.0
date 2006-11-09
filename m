From: akpm@osdl.org
Subject: [patch 16/26] SCSI: minor bug fixes and cleanups
Date: Wed, 08 Nov 2006 19:56:20 -0800
Message-ID: <200611090356.kA93uK2N003967@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:27570 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424010AbWKID5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:57:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jeff@garzik.org

From: Jeff Garzik <jeff@garzik.org>

BusLogic: use kzalloc(), remove cast to/from void*

aic7xxx_old: fix typo in cast

NCR53c406a: ifdef out static built code

fd_mcs: ifdef out static built code

ncr53c8xx: ifdef out static built code

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/BusLogic.c   |   12 ++++++------
 drivers/scsi/NCR53c406a.c |    5 +++++
 drivers/scsi/fd_mcs.c     |    2 ++
 drivers/scsi/ncr53c8xx.c  |   19 +++++++++++--------
 4 files changed, 24 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/BusLogic.c~scsi-minor-bug-fixes-and-cleanups drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c~scsi-minor-bug-fixes-and-cleanups
+++ a/drivers/scsi/BusLogic.c
@@ -2186,21 +2186,21 @@ static int __init BusLogic_init(void)
 
 	if (BusLogic_ProbeOptions.NoProbe)
 		return -ENODEV;
-	BusLogic_ProbeInfoList = (struct BusLogic_ProbeInfo *)
-	    kmalloc(BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo), GFP_ATOMIC);
+	BusLogic_ProbeInfoList =
+	    kzalloc(BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo), GFP_KERNEL);
 	if (BusLogic_ProbeInfoList == NULL) {
 		BusLogic_Error("BusLogic: Unable to allocate Probe Info List\n", NULL);
 		return -ENOMEM;
 	}
-	memset(BusLogic_ProbeInfoList, 0, BusLogic_MaxHostAdapters * sizeof(struct BusLogic_ProbeInfo));
-	PrototypeHostAdapter = (struct BusLogic_HostAdapter *)
-	    kmalloc(sizeof(struct BusLogic_HostAdapter), GFP_ATOMIC);
+
+	PrototypeHostAdapter =
+	    kzalloc(sizeof(struct BusLogic_HostAdapter), GFP_KERNEL);
 	if (PrototypeHostAdapter == NULL) {
 		kfree(BusLogic_ProbeInfoList);
 		BusLogic_Error("BusLogic: Unable to allocate Prototype " "Host Adapter\n", NULL);
 		return -ENOMEM;
 	}
-	memset(PrototypeHostAdapter, 0, sizeof(struct BusLogic_HostAdapter));
+
 #ifdef MODULE
 	if (BusLogic != NULL)
 		BusLogic_Setup(BusLogic);
diff -puN drivers/scsi/NCR53c406a.c~scsi-minor-bug-fixes-and-cleanups drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c~scsi-minor-bug-fixes-and-cleanups
+++ a/drivers/scsi/NCR53c406a.c
@@ -220,9 +220,11 @@ static void *addresses[] = {
 static unsigned short ports[] = { 0x230, 0x330, 0x280, 0x290, 0x330, 0x340, 0x300, 0x310, 0x348, 0x350 };
 #define PORT_COUNT ARRAY_SIZE(ports)
 
+#ifndef MODULE
 /* possible interrupt channels */
 static unsigned short intrs[] = { 10, 11, 12, 15 };
 #define INTR_COUNT ARRAY_SIZE(intrs)
+#endif /* !MODULE */
 
 /* signatures for NCR 53c406a based controllers */
 #if USE_BIOS
@@ -605,6 +607,7 @@ static int NCR53c406a_release(struct Scs
 	return 0;
 }
 
+#ifndef MODULE
 /* called from init/main.c */
 static int __init NCR53c406a_setup(char *str)
 {
@@ -661,6 +664,8 @@ static int __init NCR53c406a_setup(char 
 
 __setup("ncr53c406a=", NCR53c406a_setup);
 
+#endif /* !MODULE */
+
 static const char *NCR53c406a_info(struct Scsi_Host *SChost)
 {
 	DEB(printk("NCR53c406a_info called\n"));
diff -puN drivers/scsi/fd_mcs.c~scsi-minor-bug-fixes-and-cleanups drivers/scsi/fd_mcs.c
--- a/drivers/scsi/fd_mcs.c~scsi-minor-bug-fixes-and-cleanups
+++ a/drivers/scsi/fd_mcs.c
@@ -294,6 +294,7 @@ static struct Scsi_Host *hosts[FD_MAX_HO
 static int user_fifo_count = 0;
 static int user_fifo_size = 0;
 
+#ifndef MODULE
 static int __init fd_mcs_setup(char *str)
 {
 	static int done_setup = 0;
@@ -311,6 +312,7 @@ static int __init fd_mcs_setup(char *str
 }
 
 __setup("fd_mcs=", fd_mcs_setup);
+#endif /* !MODULE */
 
 static void print_banner(struct Scsi_Host *shpnt)
 {
diff -puN drivers/scsi/ncr53c8xx.c~scsi-minor-bug-fixes-and-cleanups drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~scsi-minor-bug-fixes-and-cleanups
+++ a/drivers/scsi/ncr53c8xx.c
@@ -589,10 +589,12 @@ static int __map_scsi_sg_data(struct dev
 static struct ncr_driver_setup
 	driver_setup			= SCSI_NCR_DRIVER_SETUP;
 
+#ifndef MODULE
 #ifdef	SCSI_NCR_BOOT_COMMAND_LINE_SUPPORT
 static struct ncr_driver_setup
 	driver_safe_setup __initdata	= SCSI_NCR_DRIVER_SAFE_SETUP;
 #endif
+#endif /* !MODULE */
 
 #define initverbose (driver_setup.verbose)
 #define bootverbose (np->verbose)
@@ -641,6 +643,13 @@ static struct ncr_driver_setup
 #define OPT_IARB		26
 #endif
 
+#ifdef MODULE
+#define	ARG_SEP	' '
+#else
+#define	ARG_SEP	','
+#endif
+
+#ifndef MODULE
 static char setup_token[] __initdata = 
 	"tags:"   "mpar:"
 	"spar:"   "disc:"
@@ -660,12 +669,6 @@ static char setup_token[] __initdata = 
 #endif
 	;	/* DONNOT REMOVE THIS ';' */
 
-#ifdef MODULE
-#define	ARG_SEP	' '
-#else
-#define	ARG_SEP	','
-#endif
-
 static int __init get_setup_token(char *p)
 {
 	char *cur = setup_token;
@@ -682,7 +685,6 @@ static int __init get_setup_token(char *
 	return 0;
 }
 
-
 static int __init sym53c8xx__setup(char *str)
 {
 #ifdef SCSI_NCR_BOOT_COMMAND_LINE_SUPPORT
@@ -804,6 +806,7 @@ static int __init sym53c8xx__setup(char 
 #endif /* SCSI_NCR_BOOT_COMMAND_LINE_SUPPORT */
 	return 1;
 }
+#endif /* !MODULE */
 
 /*===================================================================
 **
@@ -8321,12 +8324,12 @@ char *ncr53c8xx;	/* command line passed 
 module_param(ncr53c8xx, charp, 0);
 #endif
 
+#ifndef MODULE
 static int __init ncr53c8xx_setup(char *str)
 {
 	return sym53c8xx__setup(str);
 }
 
-#ifndef MODULE
 __setup("ncr53c8xx=", ncr53c8xx_setup);
 #endif
 
_
