From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: 2.4.25-rc1: Inconsistent ioctl symbol usage in drivers/messag
	 e/fusion/mptctl.c
Date: Tue, 10 Feb 2004 18:53:26 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D1A97A@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Mikael Pettersson <mikpe@csd.uu.se>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Keith Owens <kaos@ocs.com.au>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday, February 10, 2004 9:25 AM, Mikael Pettersson  wrote:
> Moore, Eric Dean writes:
>  > If we pass NULL as the 2nd parameter for 
> register_ioctl32_conversion(),
>  > the mpt_ioctl() entry point is *not* called when running a 32 bit
>  > application in x86_64 mode.
> 
> Ok, but you still don't need sys_ioctl() since the one-liner
> 
>  > > filp->f_op->ioctl(filp->f_dentry->d_inode, filp, cmd, arg)
> 
> (or a hardcoded call to your ioctl() method) suffices.
> 
> sys_ioctl() mostly just checks for special case ioctls before
> doing the line above, but those special cases can't occur
> since the kernel has already matched your particular ioctl.
> 
> /Mikael
> 


Ok - I have modified the mpt fusion driver per your suggestions.
Please advise if this would work.
This is 2.05.11.03 version.

You can download full source and 2.05.11.03 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.05.11.03



diff -uarN linux-2.4.25-rc1-ref/drivers/message/fusion/linux_compat.h
linux-2.4.25-rc1/drivers/message/fusion/linux_compat.h
--- linux-2.4.25-rc1-ref/drivers/message/fusion/linux_compat.h	2004-02-10
16:54:38.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/linux_compat.h	2004-02-10
15:05:32.000000000 -0700
@@ -12,7 +12,7 @@
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 
 
-#if (defined(__sparc__) && defined(__sparc_v9__)) || defined(__x86_64__) ||
defined(__ia64__)
+#if (defined(__sparc__) && defined(__sparc_v9__)) || defined(__x86_64__)
 #define MPT_CONFIG_COMPAT
 #endif
 
diff -uarN linux-2.4.25-rc1-ref/drivers/message/fusion/mptbase.h
linux-2.4.25-rc1/drivers/message/fusion/mptbase.h
--- linux-2.4.25-rc1-ref/drivers/message/fusion/mptbase.h	2004-02-10
16:54:38.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/mptbase.h	2004-02-10
15:45:03.000000000 -0700
@@ -80,8 +80,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"2.05.11.01"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11.01"
+#define MPT_LINUX_VERSION_COMMON	"2.05.11.03"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11.03"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarN linux-2.4.25-rc1-ref/drivers/message/fusion/mptctl.c
linux-2.4.25-rc1/drivers/message/fusion/mptctl.c
--- linux-2.4.25-rc1-ref/drivers/message/fusion/mptctl.c	2004-02-10
16:54:38.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/mptctl.c	2004-02-10
16:39:55.000000000 -0700
@@ -2715,7 +2715,6 @@
 						      unsigned long,
 						      struct file *));
 int unregister_ioctl32_conversion(unsigned int cmd);
-extern asmlinkage int sys_ioctl(unsigned int fd, unsigned int cmd, unsigned
long arg);
 
 
/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
=*/
 /* compat_XXX functions are used to provide a conversion between
@@ -2725,6 +2724,15 @@
  * to ensure the structure contents is properly processed by mptctl.
  */
 static int
+compat_mptctl_ioctl(unsigned int fd, unsigned int cmd,
+			unsigned long arg, struct file *filp)
+{
+	dctlprintk((KERN_INFO MYNAM "::compat_mptctl_ioctl() called\n"));
+
+	return mptctl_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+}
+
+static int
 compat_mptfwxfer_ioctl(unsigned int fd, unsigned int cmd,
 			unsigned long arg, struct file *filp)
 {
@@ -2864,30 +2872,31 @@
 	}
 
 #ifdef MPT_CONFIG_COMPAT
-	err = register_ioctl32_conversion(MPTIOCINFO, sys_ioctl);
+	err = register_ioctl32_conversion(MPTIOCINFO, compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTIOCINFO1, sys_ioctl);
+	err = register_ioctl32_conversion(MPTIOCINFO1, compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTTARGETINFO, sys_ioctl);
+	err = register_ioctl32_conversion(MPTTARGETINFO,
compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTTEST, sys_ioctl);
+	err = register_ioctl32_conversion(MPTTEST, compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTEVENTQUERY, sys_ioctl);
+	err = register_ioctl32_conversion(MPTEVENTQUERY,
compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTEVENTENABLE, sys_ioctl);
+	err = register_ioctl32_conversion(MPTEVENTENABLE,
compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTEVENTREPORT, sys_ioctl);
+	err = register_ioctl32_conversion(MPTEVENTREPORT,
compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(MPTHARDRESET, sys_ioctl);
+	err = register_ioctl32_conversion(MPTHARDRESET,
compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(MPTCOMMAND32, compat_mpt_command);
 	if (++where && err) goto out_fail;
 	err = register_ioctl32_conversion(MPTFWDOWNLOAD32,
 					  compat_mptfwxfer_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(HP_GETHOSTINFO, sys_ioctl);
+	err = register_ioctl32_conversion(HP_GETHOSTINFO,
compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
-	err = register_ioctl32_conversion(HP_GETTARGETINFO, sys_ioctl);
+	err = register_ioctl32_conversion(HP_GETTARGETINFO,
+	    				compat_mptctl_ioctl);
 	if (++where && err) goto out_fail;
 #endif
 
diff -uarN linux-2.4.25-rc1-ref/drivers/message/fusion/mptscsih.c
linux-2.4.25-rc1/drivers/message/fusion/mptscsih.c
--- linux-2.4.25-rc1-ref/drivers/message/fusion/mptscsih.c	2004-02-10
16:54:38.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/mptscsih.c	2004-02-10
11:33:39.000000000 -0700
@@ -914,8 +914,8 @@
 			sc->resid = sc->request_bufflen - xfer_cnt;
 			dprintk((KERN_NOTICE "  SET sc->resid=%02xh\n",
sc->resid));
 #endif
-			if (sc->underflow > xfer_cnt) {
-				sc->result = DID_SOFT_ERROR;
+			if((xfer_cnt == 0 ) || (sc->underflow > xfer_cnt)) {
+				sc->result = DID_SOFT_ERROR << 16;
 			}
 
 			/* Report Queue Full
