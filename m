From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: merge megaraid 2.20.x in kernel 2.6?
Date: 17 Aug 2004 12:58:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092761934.1775.326.camel@mulgrave>
References: <20040817160128.GA7127@lists.us.dell.com>
	<1092760835.1775.303.camel@mulgrave> <20040817174755.A23872@infradead.org>
	<20040817165116.GD7127@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3780 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268348AbUHQQ7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:59:04 -0400
In-Reply-To: <20040817165116.GD7127@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: Christoph Hellwig <hch@infradead.org>, atulm@lsil.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-08-17 at 12:51, Matt Domsch wrote:
> Not yet, that was one of the changes Atul requested he be allowed to
> make post-merge.

OK, this seems to be what fixes the COMPAT_IOCTL problem.

James

===== drivers/scsi/megaraid/megaraid_mm.c 1.1 vs edited =====
--- 1.1/drivers/scsi/megaraid/megaraid_mm.c	2004-06-23 14:36:31 -05:00
+++ edited/drivers/scsi/megaraid/megaraid_mm.c	2004-08-17 11:56:03 -05:00
@@ -1075,7 +1075,7 @@
 /**
  * mraid_mm_compat_ioctl	: 32bit to 64bit ioctl conversion routine
  */
-#ifdef LSI_CONFIG_COMPAT
+#ifdef CONFIG_COMPAT
 static int
 mraid_mm_compat_ioctl(unsigned int fd, unsigned int cmd,
 			unsigned long arg, struct file *filep)
===== drivers/scsi/megaraid/megaraid_mm.h 1.1 vs edited =====
--- 1.1/drivers/scsi/megaraid/megaraid_mm.h	2004-06-23 10:53:53 -05:00
+++ edited/drivers/scsi/megaraid/megaraid_mm.h	2004-08-17 11:54:14 -05:00
@@ -41,18 +41,7 @@
 /*
  * Localizing ioctl32 differences
  */
-#if defined (CONFIG_COMPAT) || defined(__x86_64__) || defined(IA32_EMULATION)
-#if !defined(CONFIG_IA64)
-#define LSI_CONFIG_COMPAT
-#endif
-#endif
-
-#ifdef LSI_CONFIG_COMPAT
-#include <asm/ioctl32.h>
-#else
-#define register_ioctl32_conversion(a,b)	do{}while(0)
-#define unregister_ioctl32_conversion(a)	do{}while(0)
-#endif /* LSI_CONFIG_COMPAT */
+#include <linux/ioctl32.h>
 
 /**
  * mimd_t	: Old style ioctl packet structure (deprecated)
@@ -137,7 +126,7 @@
 static void mraid_mm_free_adp_resources(mraid_mmadp_t *);
 static void mraid_mm_teardown_dma_pools(mraid_mmadp_t *);
 
-#ifdef LSI_CONFIG_COMPAT
+#ifdef CONFIG_COMPAT
 static int mraid_mm_compat_ioctl(unsigned int, unsigned int, unsigned long,
 		struct file *);
 #endif

