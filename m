From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Generalize 32bit emulation support in MPT fusion
Date: Tue, 23 Sep 2003 08:39:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030923063930.GA14135@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:49162 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S263330AbTIWGjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 02:39:48 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Pam.Delaney@lsil.com



The mptctl module has had sparc64 32bit emulation support for some 
time. This patch generalizes it to use the generic compat infrastructure.
This makes it work on x86-64 too.

I also removed one special case for sparc in the locking that didn't
make any sense to me.

Patch for 2.6.0test5

-Andi


diff -burpN -X ../KDIFX linux-vanilla/drivers/message/fusion/mptctl.c linux-2.6.0test5-amd64/drivers/message/fusion/mptctl.c
--- linux-vanilla/drivers/message/fusion/mptctl.c	2003-08-23 01:51:03.000000000 +0200
+++ linux-2.6.0test5-amd64/drivers/message/fusion/mptctl.c	2003-09-01 03:51:07.000000000 +0200
@@ -207,14 +207,6 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, in
 		return -EBUSY;
 	}
 
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-	if (!nonblock) {
-		if (down_interruptible(&mptctl_syscall_sem_ioc[ioc->id]))
-			rc = -ERESTARTSYS;
-	} else {
-		rc = -EPERM;
-	}
-#else
 	if (nonblock) {
 		if (down_trylock(&mptctl_syscall_sem_ioc[ioc->id]))
 			rc = -EAGAIN;
@@ -222,7 +214,6 @@ mptctl_syscall_down(MPT_ADAPTER *ioc, in
 		if (down_interruptible(&mptctl_syscall_sem_ioc[ioc->id]))
 			rc = -ERESTARTSYS;
 	}
-#endif
 	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down return %d\n", rc));
 	return rc;
 }
@@ -2733,28 +2724,19 @@ static struct miscdevice mptctl_miscdev 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
+#ifdef CONFIG_COMPAT
 
-/* The dynamic ioctl32 compat. registry only exists in >2.3.x sparc64 kernels */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)		/*{*/
-extern int register_ioctl32_conversion(unsigned int cmd,
-				       int (*handler)(unsigned int,
-						      unsigned int,
-						      unsigned long,
-						      struct file *));
-int unregister_ioctl32_conversion(unsigned int cmd);
-extern asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd,
-				 unsigned long arg);
+#include <linux/ioctl32.h>
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* sparc32_XXX functions are used to provide a conversion between
+/* compat_XXX functions are used to provide a conversion between
  * pointers and u32's. If the arg does not contain any pointers, then
- * a specialized function (sparc32_XXX) is not needed. If the arg
+ * a specialized function (compat_XXX) is not needed. If the arg
  * does contain pointer(s), then the specialized function is used
  * to ensure the structure contents is properly processed by mptctl.
  */
 static int
-sparc32_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,
+compat_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,
 			unsigned long arg, struct file *filp)
 {
 	struct mpt_fw_xfer32 kfw32;
@@ -2764,7 +2746,7 @@ sparc32_mptfwxfer_ioctl(unsigned int fd,
 	int nonblock = (filp->f_flags & O_NONBLOCK);
 	int ret;
 
-	dctlprintk((KERN_INFO MYNAM "::sparc32_mptfwxfer_ioctl() called\n"));
+	dctlprintk((KERN_INFO MYNAM "::compat_mptfwxfer_ioctl() called\n"));
 
 	if (copy_from_user(&kfw32, (char *)arg, sizeof(kfw32)))
 		return -EFAULT;
@@ -2773,7 +2755,7 @@ sparc32_mptfwxfer_ioctl(unsigned int fd,
 	iocnumX = kfw32.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
-		dctlprintk((KERN_ERR MYNAM "::sparc32_mptfwxfer_ioctl @%d - ioc%d not found!\n",
+		dctlprintk((KERN_ERR MYNAM "::compat_mptfwxfer_ioctl @%d - ioc%d not found!\n",
 				__LINE__, iocnumX));
 		return -ENODEV;
 	}
@@ -2793,7 +2775,7 @@ sparc32_mptfwxfer_ioctl(unsigned int fd,
 }
 
 static int
-sparc32_mpt_command(unsigned int fd, unsigned int cmd,
+compat_mpt_command(unsigned int fd, unsigned int cmd,
 			unsigned long arg, struct file *filp)
 {
 	struct mpt_ioctl_command32 karg32;
@@ -2804,7 +2786,7 @@ sparc32_mpt_command(unsigned int fd, uns
 	int nonblock = (filp->f_flags & O_NONBLOCK);
 	int ret;
 
-	dctlprintk((KERN_INFO MYNAM "::sparc32_mpt_command() called\n"));
+	dctlprintk((KERN_INFO MYNAM "::compat_mpt_command() called\n"));
 
 	if (copy_from_user(&karg32, (char *)arg, sizeof(karg32)))
 		return -EFAULT;
@@ -2813,7 +2795,7 @@ sparc32_mpt_command(unsigned int fd, uns
 	iocnumX = karg32.hdr.iocnum & 0xFF;
 	if (((iocnum = mpt_verify_adapter(iocnumX, &iocp)) < 0) ||
 	    (iocp == NULL)) {
-		dctlprintk((KERN_ERR MYNAM "::sparc32_mpt_command @%d - ioc%d not found!\n",
+		dctlprintk((KERN_ERR MYNAM "::compat_mpt_command @%d - ioc%d not found!\n",
 				__LINE__, iocnumX));
 		return -ENODEV;
 	}
@@ -2846,8 +2828,7 @@ sparc32_mpt_command(unsigned int fd, uns
 	return ret;
 }
 
-#endif		/*} linux >= 2.3.x */
-#endif		/*} sparc */
+#endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 int __init mptctl_init(void)
@@ -2893,8 +2874,7 @@ int __init mptctl_init(void)
 		}
 	}
 
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)		/*{*/
+#ifdef CONFIG_COMPAT
 	err = register_ioctl32_conversion(MPTIOCINFO, NULL);
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(MPTIOCINFO1, NULL);
@@ -2911,17 +2891,16 @@ int __init mptctl_init(void)
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(MPTHARDRESET, NULL);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTCOMMAND32, sparc32_mpt_command);
+	err = register_ioctl32_conversion(MPTCOMMAND32, compat_mpt_command);
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(MPTFWDOWNLOAD32,
-					  sparc32_mptfwxfer_ioctl);
+					  compat_mptfwxfer_ioctl);
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(HP_GETHOSTINFO, NULL);
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(HP_GETTARGETINFO, NULL);
 	if (++where && err) goto out_fail;
-#endif		/*} linux >= 2.3.x */
-#endif		/*} sparc */
+#endif
 
 	/* Register this device */
 	err = misc_register(&mptctl_miscdev);
@@ -2954,8 +2933,7 @@ int __init mptctl_init(void)
 
 out_fail:
 
-#if defined(__sparc__) && defined(__sparc_v9__)		/*{*/
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)		/*{*/
+#ifdef CONFIG_COMPAT
 	printk(KERN_ERR MYNAM ": ERROR: Failed to register ioctl32_conversion!"
 			" (%d:err=%d)\n", where, err);
 	unregister_ioctl32_conversion(MPTIOCINFO);
@@ -2970,8 +2948,7 @@ out_fail:
 	unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
 	unregister_ioctl32_conversion(HP_GETHOSTINFO);
 	unregister_ioctl32_conversion(HP_GETTARGETINFO);
-#endif		/*} linux >= 2.3.x */
-#endif		/*} sparc */
+#endif
 
 	for (i=0; i<MPT_MAX_ADAPTERS; i++) {
 		ioc = NULL;
diff -burpN -X ../KDIFX linux-vanilla/drivers/message/fusion/mptctl.h linux-2.6.0test5-amd64/drivers/message/fusion/mptctl.h
--- linux-vanilla/drivers/message/fusion/mptctl.h	2003-08-23 01:56:13.000000000 +0200
+++ linux-2.6.0test5-amd64/drivers/message/fusion/mptctl.h	2003-09-01 04:03:04.000000000 +0200
@@ -84,10 +84,10 @@
 #define MPTFWDOWNLOAD		_IOWR(MPT_MAGIC_NUMBER,15,struct mpt_fw_xfer)
 #define MPTCOMMAND		_IOWR(MPT_MAGIC_NUMBER,20,struct mpt_ioctl_command)
 
-#if defined(__KERNEL__) && defined(__sparc__) && defined(__sparc_v9__)		/*{*/
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 #define MPTFWDOWNLOAD32		_IOWR(MPT_MAGIC_NUMBER,15,struct mpt_fw_xfer32)
 #define MPTCOMMAND32		_IOWR(MPT_MAGIC_NUMBER,20,struct mpt_ioctl_command32)
-#endif	/*}*/
+#endif
 
 #define MPTIOCINFO		_IOWR(MPT_MAGIC_NUMBER,17,struct mpt_ioctl_iocinfo)
 #define MPTIOCINFO1		_IOWR(MPT_MAGIC_NUMBER,17,struct mpt_ioctl_iocinfo_rev0)
@@ -117,7 +117,7 @@ struct mpt_fw_xfer {
 	void		*bufp;		/* Pointer to firmware buffer */
 };
 
-#if defined(__KERNEL__) && defined(__sparc__) && defined(__sparc_v9__)		/*{*/
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 struct mpt_fw_xfer32 {
 	unsigned int iocnum;
 	unsigned int fwlen;
@@ -316,7 +316,7 @@ struct mpt_ioctl_command {
 /*
  * SPARC PLATFORM: See earlier remark.
  */
-#if defined(__KERNEL__) && defined(__sparc__) && defined(__sparc_v9__)		/*{*/
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 struct mpt_ioctl_command32 {
 	mpt_ioctl_header hdr;
 	int	timeout;
 
