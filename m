From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid 32/64 ioctl support (update)
Date: Wed, 16 Jun 2004 08:52:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087401137.13488.61.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:52912 "EHLO fire-2.osdl.org")
	by vger.kernel.org with ESMTP id S264067AbUFPPwV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 11:52:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Here is an updated patch from Adaptec that adds support for 32 bit apps
access to ioctl with 64 bit kernel.  Built against 2.6.7

This patch fixes a problem that existed in my previous submission.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aacraid.h 1.14 vs edited =====
--- 1.14/drivers/scsi/aacraid/aacraid.h	2004-05-10 13:02:37 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-06-04 13:44:08 -07:00
@@ -650,6 +650,7 @@
 struct aac_fib_context {
 	s16	 		type;		// used for verification of structure	
 	s16	 		size;
+	u32			unique;		// unique value representing this context
 	ulong			jiffies;	// used for cleanup - dmb changed to ulong
 	struct list_head	next;		// used to link context's into a linked list
 	struct semaphore 	wait_sem;	// this is used to wait for the next fib to arrive.
@@ -1226,11 +1227,11 @@
 	u32	disknum;
 	u32	cnum;
 };
-
+ 
 struct fib_ioctl
 {
-	char	*fibctx;
-	int	wait;
+	u32	fibctx;
+	s32	wait;
 	char	*fib;
 };
 
===== drivers/scsi/aacraid/commctrl.c 1.5 vs edited =====
--- 1.5/drivers/scsi/aacraid/commctrl.c	2004-05-10 13:22:40 -07:00
+++ edited/drivers/scsi/aacraid/commctrl.c	2004-06-15 14:59:29 -07:00
@@ -92,11 +92,12 @@
 		 */
 		kfib->header.XferState = 0;
 	} else {
-		if (fib_send(kfib->header.Command, fibptr, le32_to_cpu(kfib->header.Size) , FsaNormal,
-			1, 1, NULL, NULL) != 0) 
-		{
+		int retval = fib_send(kfib->header.Command, fibptr,
+				le32_to_cpu(kfib->header.Size) , FsaNormal,
+				1, 1, NULL, NULL);
+		if (retval != 0) {
 			fib_free(fibptr);
-			return -EINVAL;
+			return retval;
 		}
 		if (fib_complete(fibptr) != 0) {
 			fib_free(fibptr);
@@ -130,14 +131,24 @@
 {
 	struct aac_fib_context * fibctx;
 	int status;
-	unsigned long flags;
 
 	fibctx = kmalloc(sizeof(struct aac_fib_context), GFP_KERNEL);
 	if (fibctx == NULL) {
 		status = -ENOMEM;
 	} else {
+		unsigned long flags;
+		struct list_head * entry;
+		struct aac_fib_context * context;
+
 		fibctx->type = FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT;
 		fibctx->size = sizeof(struct aac_fib_context);
+ 		/*
+		 *	Yes yes, I know this could be an index, but we have a
+		 * better guarantee of uniqueness for the locked loop below.
+		 * Without the aid of a persistent history, this also helps
+		 * reduce the chance that the opaque context would be reused.
+		 */
+		fibctx->unique = (u32)((ulong)fibctx & 0xFFFFFFFF);
 		/*
 		 *	Initialize the mutex used to wait for the next AIF.
 		 */
@@ -155,9 +166,22 @@
 		 *	AdapterFibContext list.
 		 */
 		spin_lock_irqsave(&dev->fib_lock, flags);
+		/* Ensure that we have a unique identifier */
+		entry = dev->fib_list.next;
+		while(entry != &dev->fib_list) {
+			context = list_entry(entry, struct aac_fib_context, next);
+			if (context->unique == fibctx->unique) {
+				/* Not unique (32 bits) */
+				fibctx->unique++;
+				entry = dev->fib_list.next;
+			} else {
+				entry = entry->next;
+			}
+		}
 		list_add_tail(&fibctx->next, &dev->fib_list);
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
-		if (copy_to_user(arg,  &fibctx, sizeof(struct aac_fib_context *))) {
+		if (copy_to_user(arg,  &fibctx->unique, 
+						sizeof(fibctx->unique))) {
 			status = -EFAULT;
 		} else {
 			status = 0;
@@ -178,43 +202,44 @@
 static int next_getadapter_fib(struct aac_dev * dev, void *arg)
 {
 	struct fib_ioctl f;
-	struct aac_fib_context *fibctx, *aifcp;
 	struct fib *fib;
+	struct aac_fib_context *fibctx;
 	int status;
 	struct list_head * entry;
-	int found;
 	unsigned long flags;
 	
 	if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
 		return -EFAULT;
 	/*
-	 *	Extract the AdapterFibContext from the Input parameters.
-	 */
-	fibctx = (struct aac_fib_context *) f.fibctx;
-
-	/*
 	 *	Verify that the HANDLE passed in was a valid AdapterFibContext
 	 *
 	 *	Search the list of AdapterFibContext addresses on the adapter
 	 *	to be sure this is a valid address
 	 */
-	found = 0;
 	entry = dev->fib_list.next;
+	fibctx = NULL;
 
 	while(entry != &dev->fib_list) {
-		aifcp = list_entry(entry, struct aac_fib_context, next);
-		if(fibctx == aifcp) {   /* We found a winner */
-			found = 1;
+		fibctx = list_entry(entry, struct aac_fib_context, next);
+		/*
+		 *	Extract the AdapterFibContext from the Input parameters.
+		 */
+		if(fibctx->unique == f.fibctx) {   /* We found a winner */
 			break;
 		}
 		entry = entry->next;
+		fibctx = NULL;
 	}
-	if (found == 0)
+	if (!fibctx) {
+		dprintk ((KERN_INFO "Fib Context not found\n"));
 		return -EINVAL;
+	}
 
 	if((fibctx->type != FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
-		 (fibctx->size != sizeof(struct aac_fib_context)))
+		 (fibctx->size != sizeof(struct aac_fib_context))) {
+		dprintk ((KERN_INFO "Fib Context corrupt?\n"));
 		return -EINVAL;
+	}
 	status = 0;
 	spin_lock_irqsave(&dev->fib_lock, flags);
 	/*
@@ -309,16 +334,10 @@
  
 static int close_getadapter_fib(struct aac_dev * dev, void *arg)
 {
-	struct aac_fib_context *fibctx, *aifcp;
+	struct aac_fib_context *fibctx;
 	int status;
 	unsigned long flags;
 	struct list_head * entry;
-	int found;
-
-	/*
-	 *	Extract the fibctx from the input parameters
-	 */
-	fibctx = arg;
 
 	/*
 	 *	Verify that the HANDLE passed in was a valid AdapterFibContext
@@ -327,19 +346,23 @@
 	 *	to be sure this is a valid address
 	 */
 
-	found = 0;
 	entry = dev->fib_list.next;
+	fibctx = NULL;
 
 	while(entry != &dev->fib_list) {
-		aifcp = list_entry(entry, struct aac_fib_context, next);
-		if(fibctx == aifcp) {   /* We found a winner */
-			found = 1;
+		fibctx = list_entry(entry, struct aac_fib_context, next);
+		/*
+		 *	Extract the fibctx from the input parameters
+		 */
+		if(fibctx->unique == (u32)(unsigned long)arg) {   
+			/* We found a winner */
 			break;
 		}
 		entry = entry->next;
+		fibctx = NULL;
 	}
 
-	if(found == 0)
+	if (!fibctx)
 		return 0; /* Already gone */
 
 	if((fibctx->type != FSAFS_NTC_GET_ADAPTER_FIB_CONTEXT) ||
@@ -356,8 +379,9 @@
  *	@dev: adapter
  *	@arg: ioctl arguments
  *
- *	This routine returns the firmware version.
- *      Under Linux, there have been no version incompatibilities, so this is simple!
+ *	This routine returns the driver version.
+ *      Under Linux, there have been no version incompatibilities, so this is 
+ *      simple!
  */
 
 static int check_revision(struct aac_dev *dev, void *arg)
@@ -419,6 +443,11 @@
 		goto cleanup;
 	}
 
+	if (fibsize > FIB_DATA_SIZE_IN_BYTES) {
+		rcode = -EINVAL;
+		goto cleanup;
+	}
+
 	if(copy_from_user(srbcmd, user_srb,fibsize)){
 		printk(KERN_DEBUG"aacraid: Could not copy srb from user\n"); 
 		rcode = -EFAULT;
@@ -438,7 +467,7 @@
 	srbcmd->retry_limit =cpu_to_le32(0); // Obsolete parameter
 	srbcmd->cdb_size = cpu_to_le32(srbcmd->cdb_size);
 	
-	switch(srbcmd->flags){
+	switch (srbcmd->flags & (SRB_DataIn | SRB_DataOut)) {
 	case SRB_DataOut:
 		data_dir = DMA_TO_DEVICE;
 		break;
@@ -451,17 +480,26 @@
 	default:
 		data_dir = DMA_NONE;
 	}
-	if( dev->pae_support ==1 ) {
+	if(dev->pae_support == 1) {
 		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
 		byte_count = 0;
 
-		// This should also catch if user used the 32 bit sgmap
-		actual_fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry64));
+		/*
+		 * This should also catch if user used the 32 bit sgmap
+		 */
+		actual_fibsize = sizeof (struct aac_srb) - 
+			sizeof(struct sgentry) + ((srbcmd->sg.count & 0xff) * 
+			 	sizeof (struct sgentry64));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
 			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
 			rcode = -EINVAL;
 			goto cleanup;
 		}
+		if ((data_dir == DMA_NONE) && psg->count) { 
+			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
+			rcode = -EINVAL;
+			goto cleanup;
+		}
 
 		for (i = 0; i < psg->count; i++) {
 			dma_addr_t addr; 
@@ -503,6 +541,11 @@
 		actual_fibsize = sizeof (struct aac_srb) + (((srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
 			printk(KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n");
+			rcode = -EINVAL;
+			goto cleanup;
+		}
+		if ((data_dir == DMA_NONE) && psg->count) {
+			printk(KERN_DEBUG"aacraid: SG with no direction specified in Raw SRB command\n");
 			rcode = -EINVAL;
 			goto cleanup;
 		}
===== drivers/scsi/aacraid/linit.c 1.29 vs edited =====
--- 1.29/drivers/scsi/aacraid/linit.c	2004-05-10 04:42:31 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-06-15 15:39:05 -07:00
@@ -42,6 +42,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <asm/semaphore.h>
+#include <linux/syscalls.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -50,6 +51,9 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_eh.h>
+#if (defined(CONFIG_COMPAT))
+# include <linux/ioctl32.h>
+#endif
 
 #include "aacraid.h"
 
@@ -168,6 +172,30 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA      ", 1 }, /* ASR-2025SA      (ZCR DIMM SATA) */
 };
 
+#if (defined(CONFIG_COMPAT))
+/* 
+ * Promote 32 bit apps that call get_next_adapter_fib_ioctl to 64 bit version 
+ */
+int aac_get_next_adapter_fib_ioctl(unsigned int fd, unsigned int cmd, 
+		unsigned long arg, struct file *file)
+{
+	struct fib_ioctl f;
+	mm_segment_t fs;
+	int retval;
+
+	memset (&f, 0, sizeof(f));
+	if(copy_from_user((void *)&f, (void *)arg, 
+				sizeof(struct fib_ioctl) - sizeof(u32)))
+		return -EFAULT;
+	fs = get_fs();
+	set_fs(get_ds());
+	retval = sys_ioctl(fd, cmd, (unsigned long)&f);
+	set_fs(fs);
+	return retval;
+}
+#endif
+
+
 /**
  *	aac_queuecommand	-	queue a SCSI command
  *	@cmd:		SCSI command to queue
@@ -643,12 +671,39 @@
 		printk(KERN_WARNING
 		       "aacraid: unable to register \"aac\" device.\n");
 	}
+#	if (defined(CONFIG_COMPAT))
+		register_ioctl32_conversion(FSACTL_MINIPORT_REV_CHECK, NULL);
+		register_ioctl32_conversion(FSACTL_SENDFIB, NULL);
+		register_ioctl32_conversion(FSACTL_OPEN_GET_ADAPTER_FIB, NULL);
+		register_ioctl32_conversion(FSACTL_GET_NEXT_ADAPTER_FIB, 
+			aac_get_next_adapter_fib_ioctl);
+		register_ioctl32_conversion(FSACTL_CLOSE_GET_ADAPTER_FIB, NULL);
+		register_ioctl32_conversion(FSACTL_SEND_RAW_SRB, NULL);
+		register_ioctl32_conversion(FSACTL_GET_PCI_INFO, NULL);
+		register_ioctl32_conversion(FSACTL_QUERY_DISK, NULL);
+		register_ioctl32_conversion(FSACTL_DELETE_DISK, NULL);
+		register_ioctl32_conversion(FSACTL_FORCE_DELETE_DISK, NULL);
+		register_ioctl32_conversion(2131, NULL);
+#	endif
 
 	return 0;
 }
 
 static void __exit aac_exit(void)
 {
+#	if (defined(CONFIG_COMPAT))
+		unregister_ioctl32_conversion(FSACTL_MINIPORT_REV_CHECK);
+		unregister_ioctl32_conversion(FSACTL_SENDFIB);
+		unregister_ioctl32_conversion(FSACTL_OPEN_GET_ADAPTER_FIB);
+		unregister_ioctl32_conversion(FSACTL_GET_NEXT_ADAPTER_FIB);
+		unregister_ioctl32_conversion(FSACTL_CLOSE_GET_ADAPTER_FIB);
+		unregister_ioctl32_conversion(FSACTL_SEND_RAW_SRB);
+		unregister_ioctl32_conversion(FSACTL_GET_PCI_INFO);
+		unregister_ioctl32_conversion(FSACTL_QUERY_DISK);
+		unregister_ioctl32_conversion(FSACTL_DELETE_DISK);
+		unregister_ioctl32_conversion(FSACTL_FORCE_DELETE_DISK);
+		unregister_ioctl32_conversion(2131);
+#	endif
 	unregister_chrdev(aac_cfg_major, "aac");
 	pci_unregister_driver(&aac_pci_driver);
 }


-- 
Mark Haverkamp <markh@osdl.org>

