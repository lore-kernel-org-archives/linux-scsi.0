From: Andi Kleen <ak@muc.de>
Subject: Re: [PATCH] Add compat_ioctl to mptctl
Date: 21 Jan 2005 04:44:22 +0100
Message-ID: <20050121034422.GA32331@muc.de>
References: <91888D455306F94EBD4D168954A9457CEAAE15@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colin2.muc.de ([193.149.48.15]:8719 "HELO colin2.muc.de")
	by vger.kernel.org with SMTP id S262255AbVAUDoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 22:44:24 -0500
Date: Fri, 21 Jan 2005 04:44:22 +0100
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457CEAAE15@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, Jan 20, 2005 at 06:24:25PM -0700, Moore, Eric Dean wrote:
> On Thursday, January 20, 2005 2:38 AM, Andi Kleen wrote:
> > 
> > Sorry. I swear it compiled at one point, but some last minute
> > changes must have broken it. Please try this version.
> > 
> > 
> > Convert mptctl to compat_ioctl. I also changed it to unlocked_ioctl
> > while I was on it.
> > 
> > Signed-off-by: Andi Kleen <ak@muc.de>
> > 
> 
> This test compilies, and I have tested it today with both 32bit and 64bit
> apps on x86_64.  Works fine.

Thanks.

> 
> One request is in compat_mptctl_ioctl:
> 
> Can you add MPTTEST added back in the switch/case?  It was there before in
> the register_ioctl32_conversion/unregister_ioctl32_conversion 's.

New patch with this changed. 

Convert mptctl to compat_ioctl. I also changed it to unlocked_ioctl
while I was on it.

Signed-off-by: Andi Kleen <ak@muc.de>


diff -u linux-2.6.11-rc1-bk4/drivers/message/fusion/mptctl.c-o linux-2.6.11-rc1-bk4/drivers/message/fusion/mptctl.c
--- linux-2.6.11-rc1-bk4/drivers/message/fusion/mptctl.c-o	2005-01-04 12:12:51.000000000 +0100
+++ linux-2.6.11-rc1-bk4/drivers/message/fusion/mptctl.c	2005-01-18 12:11:30.000000000 +0100
@@ -142,6 +142,10 @@
 static int  mptctl_probe(struct pci_dev *, const struct pci_device_id *);
 static void mptctl_remove(struct pci_dev *);
 
+#ifdef CONFIG_COMPAT
+static long compat_mpctl_ioctl(struct file *f, unsigned cmd, unsigned long arg);
+#endif
+
 /*
  * Private function calls.
  */
@@ -552,8 +556,8 @@
  *  cmd - specify the particular IOCTL command to be issued
  *  arg - data specific to the command. Must not be null.
  */
-static int
-mptctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long
+__mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	mpt_ioctl_header __user *uhdr = (void __user *) arg;
 	mpt_ioctl_header	 khdr;
@@ -637,6 +641,16 @@
 	return ret;
 }
 
+static long
+mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = __mptctl_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static int mptctl_do_reset(unsigned long arg)
 {
 	struct mpt_ioctl_diag_reset __user *urinfo = (void __user *) arg;
@@ -2669,7 +2683,10 @@
 static struct file_operations mptctl_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.ioctl =	mptctl_ioctl,
+	.unlocked_ioctl = mptctl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = compat_mpctl_ioctl,
+#endif
 };
 
 static struct miscdevice mptctl_miscdev = {
@@ -2691,22 +2708,10 @@
  * does contain pointer(s), then the specialized function is used
  * to ensure the structure contents is properly processed by mptctl.
  */
-static int
-compat_mptctl_ioctl(unsigned int fd, unsigned int cmd,
-			unsigned long arg, struct file *filp)
-{
-	int ret;
-
-	lock_kernel();
-	dctlprintk((KERN_INFO MYNAM "::compat_mptctl_ioctl() called\n"));
-	ret = mptctl_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
-	unlock_kernel();
-	return ret;
-}
  
 static int
-compat_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,
-			unsigned long arg, struct file *filp)
+compat_mptfwxfer_ioctl(struct file *filp, unsigned int cmd,
+			unsigned long arg)
 {
 	struct mpt_fw_xfer32 kfw32;
 	struct mpt_fw_xfer kfw;
@@ -2744,8 +2749,8 @@
 }
 
 static int
-compat_mpt_command(unsigned int fd, unsigned int cmd,
-			unsigned long arg, struct file *filp)
+compat_mpt_command(struct file *filp, unsigned int cmd,
+			unsigned long arg)
 {
 	struct mpt_ioctl_command32 karg32;
 	struct mpt_ioctl_command32 __user *uarg = (struct mpt_ioctl_command32 __user *) arg;
@@ -2797,6 +2802,38 @@
 	return ret;
 }
 
+static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	switch (cmd) { 
+	case MPTIOCINFO:
+	case MPTIOCINFO1:
+	case MPTIOCINFO2:
+	case MPTTARGETINFO:
+	case MPTEVENTQUERY:
+	case MPTEVENTENABLE:
+	case MPTEVENTREPORT:
+	case MPTHARDRESET:
+	case HP_GETHOSTINFO:
+	case HP_GETTARGETINFO:
+	case MPTTEST:
+		ret = __mptctl_ioctl(f, cmd, arg);
+		break;
+	case MPTCOMMAND32:
+		ret = compat_mpt_command(f, cmd, arg);
+		break;
+	case MPTFWDOWNLOAD32:
+		ret = compat_mptfwxfer_ioctl(f, cmd, arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+	unlock_kernel();
+	return ret;
+}
+
 #endif
 
 
@@ -2879,35 +2916,6 @@
 		": failed to register dd callbacks\n"));
 	}
 
-#ifdef CONFIG_COMPAT
-	err = register_ioctl32_conversion(MPTIOCINFO, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTIOCINFO1, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTIOCINFO2, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTTARGETINFO, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTTEST, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTEVENTQUERY, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTEVENTENABLE, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTEVENTREPORT, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTHARDRESET, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTCOMMAND32, compat_mpt_command);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTFWDOWNLOAD32,
-					  compat_mptfwxfer_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(HP_GETHOSTINFO, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(HP_GETTARGETINFO, compat_mptctl_ioctl);
-	if (++where && err) goto out_fail;
-#endif
 
 	/* Register this device */
 	err = misc_register(&mptctl_miscdev);
@@ -2940,23 +2948,6 @@
 
 out_fail:
 
-#ifdef CONFIG_COMPAT
-	printk(KERN_ERR MYNAM ": ERROR: Failed to register ioctl32_conversion!"
-			" (%d:err=%d)\n", where, err);
-	unregister_ioctl32_conversion(MPTIOCINFO);
-	unregister_ioctl32_conversion(MPTIOCINFO1);
-	unregister_ioctl32_conversion(MPTIOCINFO2);
-	unregister_ioctl32_conversion(MPTTARGETINFO);
-	unregister_ioctl32_conversion(MPTTEST);
-	unregister_ioctl32_conversion(MPTEVENTQUERY);
-	unregister_ioctl32_conversion(MPTEVENTENABLE);
-	unregister_ioctl32_conversion(MPTEVENTREPORT);
-	unregister_ioctl32_conversion(MPTHARDRESET);
-	unregister_ioctl32_conversion(MPTCOMMAND32);
-	unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
-	unregister_ioctl32_conversion(HP_GETHOSTINFO);
-	unregister_ioctl32_conversion(HP_GETTARGETINFO);
-#endif
 
 	mpt_device_driver_deregister(MPTCTL_DRIVER);
 
@@ -2980,22 +2971,6 @@
 
         mpt_device_driver_deregister(MPTCTL_DRIVER);
 
-#ifdef CONFIG_COMPAT
-	unregister_ioctl32_conversion(MPTIOCINFO);
-	unregister_ioctl32_conversion(MPTIOCINFO1);
-	unregister_ioctl32_conversion(MPTIOCINFO2);
-	unregister_ioctl32_conversion(MPTTARGETINFO);
-	unregister_ioctl32_conversion(MPTTEST);
-	unregister_ioctl32_conversion(MPTEVENTQUERY);
-	unregister_ioctl32_conversion(MPTEVENTENABLE);
-	unregister_ioctl32_conversion(MPTEVENTREPORT);
-	unregister_ioctl32_conversion(MPTHARDRESET);
-	unregister_ioctl32_conversion(MPTCOMMAND32);
-	unregister_ioctl32_conversion(MPTFWDOWNLOAD32);
-	unregister_ioctl32_conversion(HP_GETHOSTINFO);
-	unregister_ioctl32_conversion(HP_GETTARGETINFO);
-#endif
-
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
