From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: [PATCH] 2.4.25-rc1 - MPT Fusion driver 2.05.11.02 update
Date: Mon, 9 Feb 2004 20:03:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703D1A874@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6073 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S265533AbUBJBDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 20:03:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: marcelo.tosatti@cyclades.com

Here's a patch for 2.4 kernel MPT Fusion drivers.

I have removed _ia64_ from MPT_CONFIG_COMPAT, as the register 32 bit
conversion
functions are not defined there.

There is also a bugfix for UNDERRUN case in mptscsih.

You can download full source and 2.05.11.02 patches here:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.05.11.02

Eric Moore



diff -uarN linux-2.4.25-rc1-ref/drivers/message/fusion/linux_compat.h
linux-2.4.25-rc1/drivers/message/fusion/linux_compat.h
--- linux-2.4.25-rc1-ref/drivers/message/fusion/linux_compat.h	2004-02-09
17:38:45.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/linux_compat.h	2004-02-09
17:39:29.000000000 -0700
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
--- linux-2.4.25-rc1-ref/drivers/message/fusion/mptbase.h	2004-02-09
17:38:46.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/mptbase.h	2004-02-09
17:39:52.000000000 -0700
@@ -80,8 +80,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2003 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"2.05.11.01"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11.01"
+#define MPT_LINUX_VERSION_COMMON	"2.05.11.02"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-2.05.11.02"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
diff -uarN linux-2.4.25-rc1-ref/drivers/message/fusion/mptscsih.c
linux-2.4.25-rc1/drivers/message/fusion/mptscsih.c
--- linux-2.4.25-rc1-ref/drivers/message/fusion/mptscsih.c	2004-02-09
17:38:44.000000000 -0700
+++ linux-2.4.25-rc1/drivers/message/fusion/mptscsih.c	2004-02-09
17:41:15.000000000 -0700
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
