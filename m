From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Convert aacraid to compat_ioctl
Date: 18 Jan 2005 12:15:10 +0100
Message-ID: <20050118111510.GH43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:22282 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S261206AbVARLPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 06:15:11 -0500
Date: Tue, 18 Jan 2005 12:15:10 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Convert aacraid driver to the compat_ioctl entry points.

I don't have hardware, so this is only compile tested, but I just
did some transformations on the existing code.

Signed-off-by: Andi Kleen <ak@muc.de>

diff -u linux-2.6.11-rc1-bk4/drivers/scsi/aacraid/linit.c-o linux-2.6.11-rc1-bk4/drivers/scsi/aacraid/linit.c
--- linux-2.6.11-rc1-bk4/drivers/scsi/aacraid/linit.c-o	2005-01-14 10:12:20.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/scsi/aacraid/linit.c	2005-01-18 07:58:31.000000000 +0100
@@ -45,6 +45,7 @@
 #include <linux/syscalls.h>
 #include <linux/ioctl32.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -191,28 +192,6 @@
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec Rocket Catch All */
 };
 
-#ifdef CONFIG_COMPAT
-/* 
- * Promote 32 bit apps that call get_next_adapter_fib_ioctl to 64 bit version 
- */
-static int aac_get_next_adapter_fib_ioctl(unsigned int fd, unsigned int cmd, 
-		unsigned long arg, struct file *file)
-{
-	struct fib_ioctl __user *f;
-
-	f = compat_alloc_user_space(sizeof(*f));
-	if (!access_ok(VERIFY_WRITE, f, sizeof(*f)))
-		return -EFAULT;
-
-	clear_user(f, sizeof(*f));
-	if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
-		return -EFAULT;
-
-	return sys_ioctl(fd, cmd, (unsigned long)f);
-}
-#endif
-
-
 /**
  *	aac_queuecommand	-	queue a SCSI command
  *	@cmd:		SCSI command to queue
@@ -494,9 +473,65 @@
 	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
 }
 
+#ifdef CONFIG_COMPAT
+static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	switch (cmd) { 
+	case FSACTL_MINIPORT_REV_CHECK:
+	case FSACTL_SENDFIB:
+	case FSACTL_OPEN_GET_ADAPTER_FIB:
+	case FSACTL_CLOSE_GET_ADAPTER_FIB:
+	case FSACTL_SEND_RAW_SRB:
+	case FSACTL_GET_PCI_INFO:
+	case FSACTL_QUERY_DISK:
+	case FSACTL_DELETE_DISK:
+	case FSACTL_FORCE_DELETE_DISK:
+	case FSACTL_GET_CONTAINERS: 
+		ret = aac_do_ioctl(dev, cmd, (void __user *)arg);
+		break;
+
+	case FSACTL_GET_NEXT_ADAPTER_FIB: {
+		struct fib_ioctl __user *f;
+		
+		f = compat_alloc_user_space(sizeof(*f));
+		ret = 0;
+		if (clear_user(f, sizeof(*f) != sizeof(*f)))
+			ret = -EFAULT;
+		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
+			ret = -EFAULT;
+		if (!ret)
+			ret = aac_do_ioctl(dev, cmd, (void __user *)arg);
+		break;
+	}
+
+	default:
+		ret = -ENOIOCTLCMD; 
+		break;
+	} 
+	unlock_kernel();
+	return ret;
+}
+
+static long aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
+{
+	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
+	return aac_compat_do_ioctl(dev, cmd, arg);
+}
+
+static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+{
+	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
+}
+#endif
+
 static struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= aac_cfg_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = aac_compat_cfg_ioctl,
+#endif
 	.open		= aac_cfg_open,
 };
 
@@ -506,6 +541,9 @@
 	.proc_name			= "aacraid",
 	.info           		= aac_info,
 	.ioctl          		= aac_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl			= aac_compat_ioctl,
+#endif
 	.queuecommand   		= aac_queuecommand,
 	.bios_param     		= aac_biosparm,	
 	.slave_configure		= aac_slave_configure,
@@ -699,39 +737,11 @@
 		printk(KERN_WARNING
 		       "aacraid: unable to register \"aac\" device.\n");
 	}
-#ifdef CONFIG_COMPAT
-	register_ioctl32_conversion(FSACTL_MINIPORT_REV_CHECK, NULL);
-	register_ioctl32_conversion(FSACTL_SENDFIB, NULL);
-	register_ioctl32_conversion(FSACTL_OPEN_GET_ADAPTER_FIB, NULL);
-	register_ioctl32_conversion(FSACTL_GET_NEXT_ADAPTER_FIB, 
-		aac_get_next_adapter_fib_ioctl);
-	register_ioctl32_conversion(FSACTL_CLOSE_GET_ADAPTER_FIB, NULL);
-	register_ioctl32_conversion(FSACTL_SEND_RAW_SRB, NULL);
-	register_ioctl32_conversion(FSACTL_GET_PCI_INFO, NULL);
-	register_ioctl32_conversion(FSACTL_QUERY_DISK, NULL);
-	register_ioctl32_conversion(FSACTL_DELETE_DISK, NULL);
-	register_ioctl32_conversion(FSACTL_FORCE_DELETE_DISK, NULL);
-	register_ioctl32_conversion(FSACTL_GET_CONTAINERS, NULL);
-#endif
-
 	return 0;
 }
 
 static void __exit aac_exit(void)
 {
-#ifdef CONFIG_COMPAT
-	unregister_ioctl32_conversion(FSACTL_MINIPORT_REV_CHECK);
-	unregister_ioctl32_conversion(FSACTL_SENDFIB);
-	unregister_ioctl32_conversion(FSACTL_OPEN_GET_ADAPTER_FIB);
-	unregister_ioctl32_conversion(FSACTL_GET_NEXT_ADAPTER_FIB);
-	unregister_ioctl32_conversion(FSACTL_CLOSE_GET_ADAPTER_FIB);
-	unregister_ioctl32_conversion(FSACTL_SEND_RAW_SRB);
-	unregister_ioctl32_conversion(FSACTL_GET_PCI_INFO);
-	unregister_ioctl32_conversion(FSACTL_QUERY_DISK);
-	unregister_ioctl32_conversion(FSACTL_DELETE_DISK);
-	unregister_ioctl32_conversion(FSACTL_FORCE_DELETE_DISK);
-	unregister_ioctl32_conversion(FSACTL_GET_CONTAINERS);
-#endif
 	unregister_chrdev(aac_cfg_major, "aac");
 	pci_unregister_driver(&aac_pci_driver);
 }
