From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] dpt_i2o: 64 bit support (take 5)
Date: Tue, 6 May 2008 20:10:55 -0700
Message-ID: <20080506201055.12bf16c4.akpm@linux-foundation.org>
References: <20080501230211.GA19796@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583AbYEGDLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 23:11:21 -0400
In-Reply-To: <20080501230211.GA19796@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: linux-scsi@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>, miquels@cistron.nl, Rolf Eike Beer <eike-kernel@sf-tec.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Fri, 2 May 2008 01:02:15 +0200 Miquel van Smoorenburg <mikevs@xs4all.net> wrote:

> These patches update the dpt_i2o driver to work on 64-bit platforms
> like x86_64.

wheeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee!  Mailing list to mainline (while
avoiding checkpatch by 100 miles) in what?  Six hours?  Hooray for the
merge window!

I'll fix alpha.  I'll let someone else ponder ia64:

drivers/scsi/dpt_i2o.c:83: error: `PROC_IA64' undeclared here (not in a function)
drivers/scsi/dpt_i2o.c:83: error: initializer element is not constant
drivers/scsi/dpt_i2o.c:83: error: (near initialization for `DPTI_sig.dsProcessor')




From: Andrew Morton <akpm@linux-foundation.org>

alpha:

drivers/scsi/dpt_i2o.c:1997: error: implicit declaration of function 'adpt_alpha_info'
drivers/scsi/dpt_i2o.c: At top level:
drivers/scsi/dpt_i2o.c:2032: warning: conflicting types for 'adpt_alpha_info'
drivers/scsi/dpt_i2o.c:2032: error: static declaration of 'adpt_alpha_info' follows non-static declaration
drivers/scsi/dpt_i2o.c:1997: error: previous implicit declaration of 'adpt_alpha_info' was here

Due to a copy-n-paste error in drivers/scsi/dpti.h.

Fix that up and remove some of the many daft static-declarations-in-a-header
which this driver enjoys.

Cc: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |   78 ++++++++++++++++++---------------------
 drivers/scsi/dpti.h    |   13 ------
 2 files changed, 36 insertions(+), 55 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-fix-build-on-alpha drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-fix-build-on-alpha
+++ a/drivers/scsi/dpt_i2o.c
@@ -1967,45 +1967,6 @@ cleanup:
 	return rcode;
 }
 
-
-/*
- * This routine returns information about the system.  This does not effect
- * any logic and if the info is wrong - it doesn't matter.
- */
-
-/* Get all the info we can not get from kernel services */
-static int adpt_system_info(void __user *buffer)
-{
-	sysInfo_S si;
-
-	memset(&si, 0, sizeof(si));
-
-	si.osType = OS_LINUX;
-	si.osMajorVersion = 0;
-	si.osMinorVersion = 0;
-	si.osRevision = 0;
-	si.busType = SI_PCI_BUS;
-	si.processorFamily = DPTI_sig.dsProcessorFamily;
-
-#if defined __i386__ 
-	adpt_i386_info(&si);
-#elif defined (__ia64__)
-	adpt_ia64_info(&si);
-#elif defined(__sparc__)
-	adpt_sparc_info(&si);
-#elif defined (__alpha__)
-	adpt_alpha_info(&si);
-#else
-	si.processorType = 0xff ;
-#endif
-	if(copy_to_user(buffer, &si, sizeof(si))){
-		printk(KERN_WARNING"dpti: Could not copy buffer TO user\n");
-		return -EFAULT;
-	}
-
-	return 0;
-}
-
 #if defined __ia64__ 
 static void adpt_ia64_info(sysInfo_S* si)
 {
@@ -2016,7 +1977,6 @@ static void adpt_ia64_info(sysInfo_S* si
 }
 #endif
 
-
 #if defined __sparc__ 
 static void adpt_sparc_info(sysInfo_S* si)
 {
@@ -2026,7 +1986,6 @@ static void adpt_sparc_info(sysInfo_S* s
 	si->processorType = PROC_ULTRASPARC;
 }
 #endif
-
 #if defined __alpha__ 
 static void adpt_alpha_info(sysInfo_S* si)
 {
@@ -2038,7 +1997,6 @@ static void adpt_alpha_info(sysInfo_S* s
 #endif
 
 #if defined __i386__
-
 static void adpt_i386_info(sysInfo_S* si)
 {
 	// This is all the info we need for now
@@ -2059,9 +2017,45 @@ static void adpt_i386_info(sysInfo_S* si
 		break;
 	}
 }
+#endif
+
+/*
+ * This routine returns information about the system.  This does not effect
+ * any logic and if the info is wrong - it doesn't matter.
+ */
+
+/* Get all the info we can not get from kernel services */
+static int adpt_system_info(void __user *buffer)
+{
+	sysInfo_S si;
+
+	memset(&si, 0, sizeof(si));
+
+	si.osType = OS_LINUX;
+	si.osMajorVersion = 0;
+	si.osMinorVersion = 0;
+	si.osRevision = 0;
+	si.busType = SI_PCI_BUS;
+	si.processorFamily = DPTI_sig.dsProcessorFamily;
 
+#if defined __i386__
+	adpt_i386_info(&si);
+#elif defined (__ia64__)
+	adpt_ia64_info(&si);
+#elif defined(__sparc__)
+	adpt_sparc_info(&si);
+#elif defined (__alpha__)
+	adpt_alpha_info(&si);
+#else
+	si.processorType = 0xff ;
 #endif
+	if(copy_to_user(buffer, &si, sizeof(si))){
+		printk(KERN_WARNING"dpti: Could not copy buffer TO user\n");
+		return -EFAULT;
+	}
 
+	return 0;
+}
 
 static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 	      ulong arg)
diff -puN drivers/scsi/dpti.h~drivers-scsi-dpt_i2oc-fix-build-on-alpha drivers/scsi/dpti.h
--- a/drivers/scsi/dpti.h~drivers-scsi-dpt_i2oc-fix-build-on-alpha
+++ a/drivers/scsi/dpti.h
@@ -316,19 +316,6 @@ static int adpt_close(struct inode *inod
 static void adpt_delay(int millisec);
 #endif
 
-#if defined __ia64__ 
-static void adpt_ia64_info(sysInfo_S* si);
-#endif
-#if defined __sparc__ 
-static void adpt_sparc_info(sysInfo_S* si);
-#endif
-#if defined __alpha__ 
-static void adpt_sparc_info(sysInfo_S* si);
-#endif
-#if defined __i386__
-static void adpt_i386_info(sysInfo_S* si);
-#endif
-
 #define PRINT_BUFFER_SIZE     512
 
 #define HBA_FLAGS_DBG_FLAGS_MASK         0xffff0000	// Mask for debug flags
_

