Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCF2C32753
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D7720578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="graF1H2T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfHMHZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:25:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMHZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fjDMvWGOTi64mhpCCyBd+3TlZqcORHDnE5CYKl4nvzo=; b=graF1H2T95oAo5KVf0A7Rqcimg
        iLpZbH2lq8xF3XtDXSq8xHhlfYFaXqQAP5nWF5zygsq1xVmEyScDXp/gEkXlwHOFdpxwRzziM2rbd
        801vKRt9Ft91+25PFZXayTnoZDInV5lrR0QjlkmBpT0MrV7P/uQhyS9WRhjxzjyFLFDSpb0um13wg
        jsvHWhZPuf4SNOrCx79uSOb0Ta5M9pEVMLl1sFWuudfAhFJFd2UDFinws0tHqrfW4UCKi/nXEblLU
        pzSGLJmAhk6ji4MxjtbuN2flwAHKtoUk73t660N6Y2jVuABk874cIROZzL+AC4kU8iP6Yt/O1mKMi
        O4FXPCEg==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRBk-0006AX-8C; Tue, 13 Aug 2019 07:25:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/28] misc/sgi-xp: remove SGI SN2 support
Date:   Tue, 13 Aug 2019 09:24:56 +0200
Message-Id: <20190813072514.23299-11-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Note this also marks xp broken on ia64 now, as the UV support, which
was disable in generic kernels before actually never compiled due to
undefined uv_gpa_to_soc_phys_ram and uv_gpa_in_mmr_space symbols since
at least commit c2c9f1157414 ("x86: uv: update XPC to handle updated
BIOS interface").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/uv/kernel/setup.c         |    4 -
 drivers/misc/Kconfig                |    5 +-
 drivers/misc/sgi-xp/Makefile        |   13 +-
 drivers/misc/sgi-xp/xp.h            |   19 -
 drivers/misc/sgi-xp/xp_main.c       |    8 +-
 drivers/misc/sgi-xp/xp_nofault.S    |   35 -
 drivers/misc/sgi-xp/xp_sn2.c        |  190 ---
 drivers/misc/sgi-xp/xp_uv.c         |    3 +-
 drivers/misc/sgi-xp/xpc.h           |  273 ---
 drivers/misc/sgi-xp/xpc_main.c      |   31 +-
 drivers/misc/sgi-xp/xpc_partition.c |    5 -
 drivers/misc/sgi-xp/xpc_sn2.c       | 2459 ---------------------------
 drivers/misc/sgi-xp/xpc_uv.c        |    2 +
 drivers/misc/sgi-xp/xpnet.c         |    2 +-
 14 files changed, 15 insertions(+), 3034 deletions(-)
 delete mode 100644 drivers/misc/sgi-xp/xp_nofault.S
 delete mode 100644 drivers/misc/sgi-xp/xp_sn2.c
 delete mode 100644 drivers/misc/sgi-xp/xpc_sn2.c

diff --git a/arch/ia64/uv/kernel/setup.c b/arch/ia64/uv/kernel/setup.c
index f1490657bafc..32d6ea2e89f8 100644
--- a/arch/ia64/uv/kernel/setup.c
+++ b/arch/ia64/uv/kernel/setup.c
@@ -19,12 +19,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
 
 #ifdef CONFIG_IA64_SGI_UV
 int sn_prom_type;
-long sn_partition_id;
-EXPORT_SYMBOL(sn_partition_id);
 long sn_coherency_id;
 EXPORT_SYMBOL_GPL(sn_coherency_id);
-long sn_region_size;
-EXPORT_SYMBOL(sn_region_size);
 #endif
 
 struct redir_addr {
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 6abfc8e92fcc..299032693934 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -200,9 +200,8 @@ config ENCLOSURE_SERVICES
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
 	depends on NET
-	depends on (IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || X86_UV) && SMP
-	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
-	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
+	depends on (IA64_GENERIC || IA64_SGI_UV || X86_UV) && SMP
+	depends on X86_64 || BROKEN
 	select SGI_GRU if X86_64 && SMP
 	---help---
 	  An SGI machine can be divided into multiple Single System
diff --git a/drivers/misc/sgi-xp/Makefile b/drivers/misc/sgi-xp/Makefile
index bbb622c19c06..34c55a4045af 100644
--- a/drivers/misc/sgi-xp/Makefile
+++ b/drivers/misc/sgi-xp/Makefile
@@ -4,17 +4,10 @@
 #
 
 obj-$(CONFIG_SGI_XP)		+= xp.o
-xp-y				:= xp_main.o
-xp-$(CONFIG_IA64_SGI_SN2)	+= xp_sn2.o xp_nofault.o
-xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o
-xp-$(CONFIG_IA64_SGI_UV)	+= xp_uv.o
-xp-$(CONFIG_X86_64)		+= xp_uv.o
+xp-y				:= xp_main.o xp_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
-xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
-xpc-$(CONFIG_IA64_SGI_SN2)	+= xpc_sn2.o
-xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o
-xpc-$(CONFIG_IA64_SGI_UV) 	+= xpc_uv.o
-xpc-$(CONFIG_X86_64)		+= xpc_uv.o
+xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o \
+				   xpc_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpnet.o
diff --git a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
index b8069eec18cb..06469b12aced 100644
--- a/drivers/misc/sgi-xp/xp.h
+++ b/drivers/misc/sgi-xp/xp.h
@@ -24,23 +24,6 @@
 #define is_uv()		0
 #endif
 
-#if defined CONFIG_IA64
-#include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
-#define is_shub()	ia64_platform_is("sn2")
-#endif
-
-#ifndef is_shub1
-#define is_shub1()	0
-#endif
-
-#ifndef is_shub2
-#define is_shub2()	0
-#endif
-
-#ifndef is_shub
-#define is_shub()	0
-#endif
-
 #ifdef USE_DBUG_ON
 #define DBUG_ON(condition)	BUG_ON(condition)
 #else
@@ -360,9 +343,7 @@ extern int xp_nofault_PIOR(void *);
 extern int xp_error_PIOR(void);
 
 extern struct device *xp;
-extern enum xp_retval xp_init_sn2(void);
 extern enum xp_retval xp_init_uv(void);
-extern void xp_exit_sn2(void);
 extern void xp_exit_uv(void);
 
 #endif /* _DRIVERS_MISC_SGIXP_XP_H */
diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
index 6d7f557fd1c1..5fd94d836070 100644
--- a/drivers/misc/sgi-xp/xp_main.c
+++ b/drivers/misc/sgi-xp/xp_main.c
@@ -233,9 +233,7 @@ xp_init(void)
 	for (ch_number = 0; ch_number < XPC_MAX_NCHANNELS; ch_number++)
 		mutex_init(&xpc_registrations[ch_number].mutex);
 
-	if (is_shub())
-		ret = xp_init_sn2();
-	else if (is_uv())
+	if (is_uv())
 		ret = xp_init_uv();
 	else
 		ret = 0;
@@ -251,9 +249,7 @@ module_init(xp_init);
 void __exit
 xp_exit(void)
 {
-	if (is_shub())
-		xp_exit_sn2();
-	else if (is_uv())
+	if (is_uv())
 		xp_exit_uv();
 }
 
diff --git a/drivers/misc/sgi-xp/xp_nofault.S b/drivers/misc/sgi-xp/xp_nofault.S
deleted file mode 100644
index e38d43319429..000000000000
--- a/drivers/misc/sgi-xp/xp_nofault.S
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (c) 2004-2008 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-/*
- * The xp_nofault_PIOR function takes a pointer to a remote PIO register
- * and attempts to load and consume a value from it.  This function
- * will be registered as a nofault code block.  In the event that the
- * PIO read fails, the MCA handler will force the error to look
- * corrected and vector to the xp_error_PIOR which will return an error.
- *
- * The definition of "consumption" and the time it takes for an MCA
- * to surface is processor implementation specific.  This code
- * is sufficient on Itanium through the Montvale processor family.
- * It may need to be adjusted for future processor implementations.
- *
- *	extern int xp_nofault_PIOR(void *remote_register);
- */
-
-	.global xp_nofault_PIOR
-xp_nofault_PIOR:
-	mov	r8=r0			// Stage a success return value
-	ld8.acq	r9=[r32];;		// PIO Read the specified register
-	adds	r9=1,r9;;		// Add to force consumption
-	srlz.i;;			// Allow time for MCA to surface
-	br.ret.sptk.many b0;;		// Return success
-
-	.global xp_error_PIOR
-xp_error_PIOR:
-	mov	r8=1			// Return value of 1
-	br.ret.sptk.many b0;;		// Return failure
diff --git a/drivers/misc/sgi-xp/xp_sn2.c b/drivers/misc/sgi-xp/xp_sn2.c
deleted file mode 100644
index d8e463f87241..000000000000
--- a/drivers/misc/sgi-xp/xp_sn2.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-/*
- * Cross Partition (XP) sn2-based functions.
- *
- *      Architecture specific implementation of common functions.
- */
-
-#include <linux/module.h>
-#include <linux/device.h>
-#include <asm/sn/bte.h>
-#include <asm/sn/sn_sal.h>
-#include "xp.h"
-
-/*
- * The export of xp_nofault_PIOR needs to happen here since it is defined
- * in drivers/misc/sgi-xp/xp_nofault.S. The target of the nofault read is
- * defined here.
- */
-EXPORT_SYMBOL_GPL(xp_nofault_PIOR);
-
-u64 xp_nofault_PIOR_target;
-EXPORT_SYMBOL_GPL(xp_nofault_PIOR_target);
-
-/*
- * Register a nofault code region which performs a cross-partition PIO read.
- * If the PIO read times out, the MCA handler will consume the error and
- * return to a kernel-provided instruction to indicate an error. This PIO read
- * exists because it is guaranteed to timeout if the destination is down
- * (amo operations do not timeout on at least some CPUs on Shubs <= v1.2,
- * which unfortunately we have to work around).
- */
-static enum xp_retval
-xp_register_nofault_code_sn2(void)
-{
-	int ret;
-	u64 func_addr;
-	u64 err_func_addr;
-
-	func_addr = *(u64 *)xp_nofault_PIOR;
-	err_func_addr = *(u64 *)xp_error_PIOR;
-	ret = sn_register_nofault_code(func_addr, err_func_addr, err_func_addr,
-				       1, 1);
-	if (ret != 0) {
-		dev_err(xp, "can't register nofault code, error=%d\n", ret);
-		return xpSalError;
-	}
-	/*
-	 * Setup the nofault PIO read target. (There is no special reason why
-	 * SH_IPI_ACCESS was selected.)
-	 */
-	if (is_shub1())
-		xp_nofault_PIOR_target = SH1_IPI_ACCESS;
-	else if (is_shub2())
-		xp_nofault_PIOR_target = SH2_IPI_ACCESS0;
-
-	return xpSuccess;
-}
-
-static void
-xp_unregister_nofault_code_sn2(void)
-{
-	u64 func_addr = *(u64 *)xp_nofault_PIOR;
-	u64 err_func_addr = *(u64 *)xp_error_PIOR;
-
-	/* unregister the PIO read nofault code region */
-	(void)sn_register_nofault_code(func_addr, err_func_addr,
-				       err_func_addr, 1, 0);
-}
-
-/*
- * Convert a virtual memory address to a physical memory address.
- */
-static unsigned long
-xp_pa_sn2(void *addr)
-{
-	return __pa(addr);
-}
-
-/*
- * Convert a global physical to a socket physical address.
- */
-static unsigned long
-xp_socket_pa_sn2(unsigned long gpa)
-{
-	return gpa;
-}
-
-/*
- * Wrapper for bte_copy().
- *
- *	dst_pa - physical address of the destination of the transfer.
- *	src_pa - physical address of the source of the transfer.
- *	len - number of bytes to transfer from source to destination.
- *
- * Note: xp_remote_memcpy_sn2() should never be called while holding a spinlock.
- */
-static enum xp_retval
-xp_remote_memcpy_sn2(unsigned long dst_pa, const unsigned long src_pa,
-		     size_t len)
-{
-	bte_result_t ret;
-
-	ret = bte_copy(src_pa, dst_pa, len, (BTE_NOTIFY | BTE_WACQUIRE), NULL);
-	if (ret == BTE_SUCCESS)
-		return xpSuccess;
-
-	if (is_shub2()) {
-		dev_err(xp, "bte_copy() on shub2 failed, error=0x%x dst_pa="
-			"0x%016lx src_pa=0x%016lx len=%ld\\n", ret, dst_pa,
-			src_pa, len);
-	} else {
-		dev_err(xp, "bte_copy() failed, error=%d dst_pa=0x%016lx "
-			"src_pa=0x%016lx len=%ld\\n", ret, dst_pa, src_pa, len);
-	}
-
-	return xpBteCopyError;
-}
-
-static int
-xp_cpu_to_nasid_sn2(int cpuid)
-{
-	return cpuid_to_nasid(cpuid);
-}
-
-static enum xp_retval
-xp_expand_memprotect_sn2(unsigned long phys_addr, unsigned long size)
-{
-	u64 nasid_array = 0;
-	int ret;
-
-	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_1,
-				   &nasid_array);
-	if (ret != 0) {
-		dev_err(xp, "sn_change_memprotect(,, "
-			"SN_MEMPROT_ACCESS_CLASS_1,) failed ret=%d\n", ret);
-		return xpSalError;
-	}
-	return xpSuccess;
-}
-
-static enum xp_retval
-xp_restrict_memprotect_sn2(unsigned long phys_addr, unsigned long size)
-{
-	u64 nasid_array = 0;
-	int ret;
-
-	ret = sn_change_memprotect(phys_addr, size, SN_MEMPROT_ACCESS_CLASS_0,
-				   &nasid_array);
-	if (ret != 0) {
-		dev_err(xp, "sn_change_memprotect(,, "
-			"SN_MEMPROT_ACCESS_CLASS_0,) failed ret=%d\n", ret);
-		return xpSalError;
-	}
-	return xpSuccess;
-}
-
-enum xp_retval
-xp_init_sn2(void)
-{
-	BUG_ON(!is_shub());
-
-	xp_max_npartitions = XP_MAX_NPARTITIONS_SN2;
-	xp_partition_id = sn_partition_id;
-	xp_region_size = sn_region_size;
-
-	xp_pa = xp_pa_sn2;
-	xp_socket_pa = xp_socket_pa_sn2;
-	xp_remote_memcpy = xp_remote_memcpy_sn2;
-	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
-	xp_expand_memprotect = xp_expand_memprotect_sn2;
-	xp_restrict_memprotect = xp_restrict_memprotect_sn2;
-
-	return xp_register_nofault_code_sn2();
-}
-
-void
-xp_exit_sn2(void)
-{
-	BUG_ON(!is_shub());
-
-	xp_unregister_nofault_code_sn2();
-}
-
diff --git a/drivers/misc/sgi-xp/xp_uv.c b/drivers/misc/sgi-xp/xp_uv.c
index a0d093274dc0..5e335e93459c 100644
--- a/drivers/misc/sgi-xp/xp_uv.c
+++ b/drivers/misc/sgi-xp/xp_uv.c
@@ -151,9 +151,10 @@ xp_init_uv(void)
 	BUG_ON(!is_uv());
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_UV;
+#ifdef CONFIG_X86
 	xp_partition_id = sn_partition_id;
 	xp_region_size = sn_region_size;
-
+#endif
 	xp_pa = xp_pa_uv;
 	xp_socket_pa = xp_socket_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
diff --git a/drivers/misc/sgi-xp/xpc.h b/drivers/misc/sgi-xp/xpc.h
index b94d5f767703..71db60edff65 100644
--- a/drivers/misc/sgi-xp/xpc.h
+++ b/drivers/misc/sgi-xp/xpc.h
@@ -71,14 +71,10 @@
  *     'SAL_nasids_size'. (Local partition's mask pointers are xpc_part_nasids
  *     and xpc_mach_nasids.)
  *
- *   vars	(ia64-sn2 only)
- *   vars part	(ia64-sn2 only)
- *
  *     Immediately following the mach_nasids mask are the XPC variables
  *     required by other partitions. First are those that are generic to all
  *     partitions (vars), followed on the next available cacheline by those
  *     which are partition specific (vars part). These are setup by XPC.
- *     (Local partition's vars pointers are xpc_vars and xpc_vars_part.)
  *
  * Note: Until 'ts_jiffies' is set non-zero, the partition XPC code has not been
  *       initialized.
@@ -92,9 +88,6 @@ struct xpc_rsvd_page {
 	u8 pad1[3];		/* align to next u64 in 1st 64-byte cacheline */
 	unsigned long ts_jiffies; /* timestamp when rsvd pg was setup by XPC */
 	union {
-		struct {
-			unsigned long vars_pa;	/* phys addr */
-		} sn2;
 		struct {
 			unsigned long heartbeat_gpa; /* phys addr */
 			unsigned long activate_gru_mq_desc_gpa; /* phys addr */
@@ -106,84 +99,14 @@ struct xpc_rsvd_page {
 
 #define XPC_RP_VERSION _XPC_VERSION(3, 0) /* version 3.0 of the reserved page */
 
-/*
- * Define the structures by which XPC variables can be exported to other
- * partitions. (There are two: struct xpc_vars and struct xpc_vars_part)
- */
-
-/*
- * The following structure describes the partition generic variables
- * needed by other partitions in order to properly initialize.
- *
- * struct xpc_vars version number also applies to struct xpc_vars_part.
- * Changes to either structure and/or related functionality should be
- * reflected by incrementing either the major or minor version numbers
- * of struct xpc_vars.
- */
-struct xpc_vars_sn2 {
-	u8 version;
-	u64 heartbeat;
-	DECLARE_BITMAP(heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
-	u64 heartbeat_offline;	/* if 0, heartbeat should be changing */
-	int activate_IRQ_nasid;
-	int activate_IRQ_phys_cpuid;
-	unsigned long vars_part_pa;
-	unsigned long amos_page_pa;/* paddr of page of amos from MSPEC driver */
-	struct amo *amos_page;	/* vaddr of page of amos from MSPEC driver */
-};
-
-#define XPC_V_VERSION _XPC_VERSION(3, 1)    /* version 3.1 of the cross vars */
-
-/*
- * The following structure describes the per partition specific variables.
- *
- * An array of these structures, one per partition, will be defined. As a
- * partition becomes active XPC will copy the array entry corresponding to
- * itself from that partition. It is desirable that the size of this structure
- * evenly divides into a 128-byte cacheline, such that none of the entries in
- * this array crosses a 128-byte cacheline boundary. As it is now, each entry
- * occupies 64-bytes.
- */
-struct xpc_vars_part_sn2 {
-	u64 magic;
-
-	unsigned long openclose_args_pa; /* phys addr of open and close args */
-	unsigned long GPs_pa;	/* physical address of Get/Put values */
-
-	unsigned long chctl_amo_pa; /* physical address of chctl flags' amo */
-
-	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
-	int notify_IRQ_phys_cpuid;	/* CPUID of where to send notify IRQs */
-
-	u8 nchannels;		/* #of defined channels supported */
-
-	u8 reserved[23];	/* pad to a full 64 bytes */
-};
-
-/*
- * The vars_part MAGIC numbers play a part in the first contact protocol.
- *
- * MAGIC1 indicates that the per partition specific variables for a remote
- * partition have been initialized by this partition.
- *
- * MAGIC2 indicates that this partition has pulled the remote partititions
- * per partition variables that pertain to this partition.
- */
-#define XPC_VP_MAGIC1_SN2 0x0053524156435058L /* 'XPCVARS\0'L (little endian) */
-#define XPC_VP_MAGIC2_SN2 0x0073726176435058L /* 'XPCvars\0'L (little endian) */
-
 /* the reserved page sizes and offsets */
 
 #define XPC_RP_HEADER_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_rsvd_page))
-#define XPC_RP_VARS_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_vars_sn2))
 
 #define XPC_RP_PART_NASIDS(_rp) ((unsigned long *)((u8 *)(_rp) + \
 				 XPC_RP_HEADER_SIZE))
 #define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + \
 				 xpc_nasid_mask_nlongs)
-#define XPC_RP_VARS(_rp)	((struct xpc_vars_sn2 *) \
-				 (XPC_RP_MACH_NASIDS(_rp) + \
-				  xpc_nasid_mask_nlongs))
 
 
 /*
@@ -297,17 +220,6 @@ struct xpc_activate_mq_msg_chctl_opencomplete_uv {
 #define XPC_UNPACK_ARG1(_args)	(((u64)_args) & 0xffffffff)
 #define XPC_UNPACK_ARG2(_args)	((((u64)_args) >> 32) & 0xffffffff)
 
-/*
- * Define a Get/Put value pair (pointers) used with a message queue.
- */
-struct xpc_gp_sn2 {
-	s64 get;		/* Get value */
-	s64 put;		/* Put value */
-};
-
-#define XPC_GP_SIZE \
-		L1_CACHE_ALIGN(sizeof(struct xpc_gp_sn2) * XPC_MAX_NCHANNELS)
-
 /*
  * Define a structure that contains arguments associated with opening and
  * closing a channel.
@@ -340,30 +252,6 @@ struct xpc_fifo_head_uv {
 	int n_entries;
 };
 
-/*
- * Define a sn2 styled message.
- *
- * A user-defined message resides in the payload area. The max size of the
- * payload is defined by the user via xpc_connect().
- *
- * The size of a message entry (within a message queue) must be a 128-byte
- * cacheline sized multiple in order to facilitate the BTE transfer of messages
- * from one message queue to another.
- */
-struct xpc_msg_sn2 {
-	u8 flags;		/* FOR XPC INTERNAL USE ONLY */
-	u8 reserved[7];		/* FOR XPC INTERNAL USE ONLY */
-	s64 number;		/* FOR XPC INTERNAL USE ONLY */
-
-	u64 payload;		/* user defined portion of message */
-};
-
-/* struct xpc_msg_sn2 flags */
-
-#define	XPC_M_SN2_DONE		0x01	/* msg has been received/consumed */
-#define	XPC_M_SN2_READY		0x02	/* msg is ready to be sent */
-#define	XPC_M_SN2_INTERRUPT	0x04	/* send interrupt when msg consumed */
-
 /*
  * The format of a uv XPC notify_mq GRU message is as follows:
  *
@@ -390,20 +278,6 @@ struct xpc_notify_mq_msg_uv {
 	unsigned long payload;
 };
 
-/*
- * Define sn2's notify entry.
- *
- * This is used to notify a message's sender that their message was received
- * and consumed by the intended recipient.
- */
-struct xpc_notify_sn2 {
-	u8 type;		/* type of notification */
-
-	/* the following two fields are only used if type == XPC_N_CALL */
-	xpc_notify_func func;	/* user's notify function */
-	void *key;		/* pointer to user's key */
-};
-
 /* struct xpc_notify_sn2 type of notification */
 
 #define	XPC_N_CALL	0x01	/* notify function provided by user */
@@ -431,102 +305,6 @@ struct xpc_send_msg_slot_uv {
  * of these structures for each potential channel connection to that partition.
  */
 
-/*
- * The following is sn2 only.
- *
- * Each channel structure manages two message queues (circular buffers).
- * They are allocated at the time a channel connection is made. One of
- * these message queues (local_msgqueue) holds the locally created messages
- * that are destined for the remote partition. The other of these message
- * queues (remote_msgqueue) is a locally cached copy of the remote partition's
- * own local_msgqueue.
- *
- * The following is a description of the Get/Put pointers used to manage these
- * two message queues. Consider the local_msgqueue to be on one partition
- * and the remote_msgqueue to be its cached copy on another partition. A
- * description of what each of the lettered areas contains is included.
- *
- *
- *                     local_msgqueue      remote_msgqueue
- *
- *                        |/////////|      |/////////|
- *    w_remote_GP.get --> +---------+      |/////////|
- *                        |    F    |      |/////////|
- *     remote_GP.get  --> +---------+      +---------+ <-- local_GP->get
- *                        |         |      |         |
- *                        |         |      |    E    |
- *                        |         |      |         |
- *                        |         |      +---------+ <-- w_local_GP.get
- *                        |    B    |      |/////////|
- *                        |         |      |////D////|
- *                        |         |      |/////////|
- *                        |         |      +---------+ <-- w_remote_GP.put
- *                        |         |      |////C////|
- *      local_GP->put --> +---------+      +---------+ <-- remote_GP.put
- *                        |         |      |/////////|
- *                        |    A    |      |/////////|
- *                        |         |      |/////////|
- *     w_local_GP.put --> +---------+      |/////////|
- *                        |/////////|      |/////////|
- *
- *
- *	    ( remote_GP.[get|put] are cached copies of the remote
- *	      partition's local_GP->[get|put], and thus their values can
- *	      lag behind their counterparts on the remote partition. )
- *
- *
- *  A - Messages that have been allocated, but have not yet been sent to the
- *	remote partition.
- *
- *  B - Messages that have been sent, but have not yet been acknowledged by the
- *      remote partition as having been received.
- *
- *  C - Area that needs to be prepared for the copying of sent messages, by
- *	the clearing of the message flags of any previously received messages.
- *
- *  D - Area into which sent messages are to be copied from the remote
- *	partition's local_msgqueue and then delivered to their intended
- *	recipients. [ To allow for a multi-message copy, another pointer
- *	(next_msg_to_pull) has been added to keep track of the next message
- *	number needing to be copied (pulled). It chases after w_remote_GP.put.
- *	Any messages lying between w_local_GP.get and next_msg_to_pull have
- *	been copied and are ready to be delivered. ]
- *
- *  E - Messages that have been copied and delivered, but have not yet been
- *	acknowledged by the recipient as having been received.
- *
- *  F - Messages that have been acknowledged, but XPC has not yet notified the
- *	sender that the message was received by its intended recipient.
- *	This is also an area that needs to be prepared for the allocating of
- *	new messages, by the clearing of the message flags of the acknowledged
- *	messages.
- */
-
-struct xpc_channel_sn2 {
-	struct xpc_openclose_args *local_openclose_args; /* args passed on */
-					     /* opening or closing of channel */
-
-	void *local_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg_sn2 *local_msgqueue;	/* local message queue */
-	void *remote_msgqueue_base;	/* base address of kmalloc'd space */
-	struct xpc_msg_sn2 *remote_msgqueue; /* cached copy of remote */
-					   /* partition's local message queue */
-	unsigned long remote_msgqueue_pa; /* phys addr of remote partition's */
-					  /* local message queue */
-
-	struct xpc_notify_sn2 *notify_queue;/* notify queue for messages sent */
-
-	/* various flavors of local and remote Get/Put values */
-
-	struct xpc_gp_sn2 *local_GP;	/* local Get/Put values */
-	struct xpc_gp_sn2 remote_GP;	/* remote Get/Put values */
-	struct xpc_gp_sn2 w_local_GP;	/* working local Get/Put values */
-	struct xpc_gp_sn2 w_remote_GP;	/* working remote Get/Put values */
-	s64 next_msg_to_pull;	/* Put value of next msg to pull */
-
-	struct mutex msg_to_pull_mutex;	/* next msg to pull serialization */
-};
-
 struct xpc_channel_uv {
 	void *cached_notify_gru_mq_desc; /* remote partition's notify mq's */
 					 /* gru mq descriptor */
@@ -579,7 +357,6 @@ struct xpc_channel {
 	wait_queue_head_t idle_wq;	/* idle kthread wait queue */
 
 	union {
-		struct xpc_channel_sn2 sn2;
 		struct xpc_channel_uv uv;
 	} sn;
 
@@ -666,43 +443,6 @@ xpc_any_msg_chctl_flags_set(union xpc_channel_ctl_flags *chctl)
 	return 0;
 }
 
-/*
- * Manage channels on a partition basis. There is one of these structures
- * for each partition (a partition will never utilize the structure that
- * represents itself).
- */
-
-struct xpc_partition_sn2 {
-	unsigned long remote_amos_page_pa; /* paddr of partition's amos page */
-	int activate_IRQ_nasid;	/* active partition's act/deact nasid */
-	int activate_IRQ_phys_cpuid;	/* active part's act/deact phys cpuid */
-
-	unsigned long remote_vars_pa;	/* phys addr of partition's vars */
-	unsigned long remote_vars_part_pa; /* paddr of partition's vars part */
-	u8 remote_vars_version;	/* version# of partition's vars */
-
-	void *local_GPs_base;	/* base address of kmalloc'd space */
-	struct xpc_gp_sn2 *local_GPs;	/* local Get/Put values */
-	void *remote_GPs_base;	/* base address of kmalloc'd space */
-	struct xpc_gp_sn2 *remote_GPs;	/* copy of remote partition's local */
-					/* Get/Put values */
-	unsigned long remote_GPs_pa; /* phys addr of remote partition's local */
-				     /* Get/Put values */
-
-	void *local_openclose_args_base;   /* base address of kmalloc'd space */
-	struct xpc_openclose_args *local_openclose_args;      /* local's args */
-	unsigned long remote_openclose_args_pa;	/* phys addr of remote's args */
-
-	int notify_IRQ_nasid;	/* nasid of where to send notify IRQs */
-	int notify_IRQ_phys_cpuid;	/* CPUID of where to send notify IRQs */
-	char notify_IRQ_owner[8];	/* notify IRQ's owner's name */
-
-	struct amo *remote_chctl_amo_va; /* addr of remote chctl flags' amo */
-	struct amo *local_chctl_amo_va;	/* address of chctl flags' amo */
-
-	struct timer_list dropped_notify_IRQ_timer;	/* dropped IRQ timer */
-};
-
 struct xpc_partition_uv {
 	unsigned long heartbeat_gpa; /* phys addr of partition's heartbeat */
 	struct xpc_heartbeat_uv cached_heartbeat; /* cached copy of */
@@ -774,7 +514,6 @@ struct xpc_partition {
 	wait_queue_head_t channel_mgr_wq;	/* channel mgr's wait queue */
 
 	union {
-		struct xpc_partition_sn2 sn2;
 		struct xpc_partition_uv uv;
 	} sn;
 
@@ -854,14 +593,6 @@ struct xpc_arch_operations {
 #define XPC_P_SS_WTEARDOWN	0x02	/* waiting to teardown infrastructure */
 #define XPC_P_SS_TORNDOWN	0x03	/* infrastructure is torndown */
 
-/*
- * struct xpc_partition_sn2's dropped notify IRQ timer is set to wait the
- * following interval #of seconds before checking for dropped notify IRQs.
- * These can occur whenever an IRQ's associated amo write doesn't complete
- * until after the IRQ was received.
- */
-#define XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL	(0.25 * HZ)
-
 /* number of seconds to wait for other partitions to disengage */
 #define XPC_DISENGAGE_DEFAULT_TIMELIMIT		90
 
@@ -888,10 +619,6 @@ extern void xpc_activate_kthreads(struct xpc_channel *, int);
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
 
-/* found in xpc_sn2.c */
-extern int xpc_init_sn2(void);
-extern void xpc_exit_sn2(void);
-
 /* found in xpc_uv.c */
 extern int xpc_init_uv(void);
 extern void xpc_exit_uv(void);
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 83fc748a91a7..79a963105983 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -279,13 +279,6 @@ xpc_hb_checker(void *ignore)
 
 			dev_dbg(xpc_part, "checking remote heartbeats\n");
 			xpc_check_remote_hb();
-
-			/*
-			 * On sn2 we need to periodically recheck to ensure no
-			 * IRQ/amo pairs have been missed.
-			 */
-			if (is_shub())
-				force_IRQ = 1;
 		}
 
 		/* check for outstanding IRQs */
@@ -1050,9 +1043,7 @@ xpc_do_exit(enum xp_retval reason)
 
 	xpc_teardown_partitions();
 
-	if (is_shub())
-		xpc_exit_sn2();
-	else if (is_uv())
+	if (is_uv())
 		xpc_exit_uv();
 }
 
@@ -1235,21 +1226,7 @@ xpc_init(void)
 	dev_set_name(xpc_part, "part");
 	dev_set_name(xpc_chan, "chan");
 
-	if (is_shub()) {
-		/*
-		 * The ia64-sn2 architecture supports at most 64 partitions.
-		 * And the inability to unregister remote amos restricts us
-		 * further to only support exactly 64 partitions on this
-		 * architecture, no less.
-		 */
-		if (xp_max_npartitions != 64) {
-			dev_err(xpc_part, "max #of partitions not set to 64\n");
-			ret = -EINVAL;
-		} else {
-			ret = xpc_init_sn2();
-		}
-
-	} else if (is_uv()) {
+	if (is_uv()) {
 		ret = xpc_init_uv();
 
 	} else {
@@ -1335,9 +1312,7 @@ xpc_init(void)
 
 	xpc_teardown_partitions();
 out_1:
-	if (is_shub())
-		xpc_exit_sn2();
-	else if (is_uv())
+	if (is_uv())
 		xpc_exit_uv();
 	return ret;
 }
diff --git a/drivers/misc/sgi-xp/xpc_partition.c b/drivers/misc/sgi-xp/xpc_partition.c
index 782ce95d3f17..21a04bc97d40 100644
--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
@@ -93,10 +93,6 @@ xpc_get_rsvd_page_pa(int nasid)
 		if (ret != xpNeedMoreInfo)
 			break;
 
-		/* !!! L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
-		if (is_shub())
-			len = L1_CACHE_ALIGN(len);
-
 		if (len > buf_len) {
 			kfree(buf_base);
 			buf_len = L1_CACHE_ALIGN(len);
@@ -452,7 +448,6 @@ xpc_discovery(void)
 		case 32:
 			max_regions *= 2;
 			region_size = 16;
-			DBUG_ON(!is_shub2());
 		}
 	}
 
diff --git a/drivers/misc/sgi-xp/xpc_sn2.c b/drivers/misc/sgi-xp/xpc_sn2.c
deleted file mode 100644
index 0ae69b9390ce..000000000000
--- a/drivers/misc/sgi-xp/xpc_sn2.c
+++ /dev/null
@@ -1,2459 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (c) 2008-2009 Silicon Graphics, Inc.  All Rights Reserved.
- */
-
-/*
- * Cross Partition Communication (XPC) sn2-based functions.
- *
- *     Architecture specific implementation of common functions.
- *
- */
-
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <asm/uncached.h>
-#include <asm/sn/mspec.h>
-#include <asm/sn/sn_sal.h>
-#include "xpc.h"
-
-/*
- * Define the number of u64s required to represent all the C-brick nasids
- * as a bitmap.  The cross-partition kernel modules deal only with
- * C-brick nasids, thus the need for bitmaps which don't account for
- * odd-numbered (non C-brick) nasids.
- */
-#define XPC_MAX_PHYSNODES_SN2	(MAX_NUMALINK_NODES / 2)
-#define XP_NASID_MASK_BYTES_SN2	((XPC_MAX_PHYSNODES_SN2 + 7) / 8)
-#define XP_NASID_MASK_WORDS_SN2	((XPC_MAX_PHYSNODES_SN2 + 63) / 64)
-
-/*
- * Memory for XPC's amo variables is allocated by the MSPEC driver. These
- * pages are located in the lowest granule. The lowest granule uses 4k pages
- * for cached references and an alternate TLB handler to never provide a
- * cacheable mapping for the entire region. This will prevent speculative
- * reading of cached copies of our lines from being issued which will cause
- * a PI FSB Protocol error to be generated by the SHUB. For XPC, we need 64
- * amo variables (based on XP_MAX_NPARTITIONS_SN2) to identify the senders of
- * NOTIFY IRQs, 128 amo variables (based on XP_NASID_MASK_WORDS_SN2) to identify
- * the senders of ACTIVATE IRQs, 1 amo variable to identify which remote
- * partitions (i.e., XPCs) consider themselves currently engaged with the
- * local XPC and 1 amo variable to request partition deactivation.
- */
-#define XPC_NOTIFY_IRQ_AMOS_SN2		0
-#define XPC_ACTIVATE_IRQ_AMOS_SN2	(XPC_NOTIFY_IRQ_AMOS_SN2 + \
-					 XP_MAX_NPARTITIONS_SN2)
-#define XPC_ENGAGED_PARTITIONS_AMO_SN2	(XPC_ACTIVATE_IRQ_AMOS_SN2 + \
-					 XP_NASID_MASK_WORDS_SN2)
-#define XPC_DEACTIVATE_REQUEST_AMO_SN2	(XPC_ENGAGED_PARTITIONS_AMO_SN2 + 1)
-
-/*
- * Buffer used to store a local copy of portions of a remote partition's
- * reserved page (either its header and part_nasids mask, or its vars).
- */
-static void *xpc_remote_copy_buffer_base_sn2;
-static char *xpc_remote_copy_buffer_sn2;
-
-static struct xpc_vars_sn2 *xpc_vars_sn2;
-static struct xpc_vars_part_sn2 *xpc_vars_part_sn2;
-
-static int
-xpc_setup_partitions_sn2(void)
-{
-	/* nothing needs to be done */
-	return 0;
-}
-
-static void
-xpc_teardown_partitions_sn2(void)
-{
-	/* nothing needs to be done */
-}
-
-/* SH_IPI_ACCESS shub register value on startup */
-static u64 xpc_sh1_IPI_access_sn2;
-static u64 xpc_sh2_IPI_access0_sn2;
-static u64 xpc_sh2_IPI_access1_sn2;
-static u64 xpc_sh2_IPI_access2_sn2;
-static u64 xpc_sh2_IPI_access3_sn2;
-
-/*
- * Change protections to allow IPI operations.
- */
-static void
-xpc_allow_IPI_ops_sn2(void)
-{
-	int node;
-	int nasid;
-
-	/* !!! The following should get moved into SAL. */
-	if (is_shub2()) {
-		xpc_sh2_IPI_access0_sn2 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
-		xpc_sh2_IPI_access1_sn2 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
-		xpc_sh2_IPI_access2_sn2 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
-		xpc_sh2_IPI_access3_sn2 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-			      -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-			      -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-			      -1UL);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-			      -1UL);
-		}
-	} else {
-		xpc_sh1_IPI_access_sn2 =
-		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
-
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-			      -1UL);
-		}
-	}
-}
-
-/*
- * Restrict protections to disallow IPI operations.
- */
-static void
-xpc_disallow_IPI_ops_sn2(void)
-{
-	int node;
-	int nasid;
-
-	/* !!! The following should get moved into SAL. */
-	if (is_shub2()) {
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-			      xpc_sh2_IPI_access0_sn2);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-			      xpc_sh2_IPI_access1_sn2);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-			      xpc_sh2_IPI_access2_sn2);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-			      xpc_sh2_IPI_access3_sn2);
-		}
-	} else {
-		for_each_online_node(node) {
-			nasid = cnodeid_to_nasid(node);
-			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-			      xpc_sh1_IPI_access_sn2);
-		}
-	}
-}
-
-/*
- * The following set of functions are used for the sending and receiving of
- * IRQs (also known as IPIs). There are two flavors of IRQs, one that is
- * associated with partition activity (SGI_XPC_ACTIVATE) and the other that
- * is associated with channel activity (SGI_XPC_NOTIFY).
- */
-
-static u64
-xpc_receive_IRQ_amo_sn2(struct amo *amo)
-{
-	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_CLEAR);
-}
-
-static enum xp_retval
-xpc_send_IRQ_sn2(struct amo *amo, u64 flag, int nasid, int phys_cpuid,
-		 int vector)
-{
-	int ret = 0;
-	unsigned long irq_flags;
-
-	local_irq_save(irq_flags);
-
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_OR, flag);
-	sn_send_IPI_phys(nasid, phys_cpuid, vector, 0);
-
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IRQs and amos to it until the heartbeat times out.
-	 */
-	ret = xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->variable),
-						     xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
-
-	return (ret == 0) ? xpSuccess : xpPioReadError;
-}
-
-static struct amo *
-xpc_init_IRQ_amo_sn2(int index)
-{
-	struct amo *amo = xpc_vars_sn2->amos_page + index;
-
-	(void)xpc_receive_IRQ_amo_sn2(amo);	/* clear amo variable */
-	return amo;
-}
-
-/*
- * Functions associated with SGI_XPC_ACTIVATE IRQ.
- */
-
-/*
- * Notify the heartbeat check thread that an activate IRQ has been received.
- */
-static irqreturn_t
-xpc_handle_activate_IRQ_sn2(int irq, void *dev_id)
-{
-	unsigned long irq_flags;
-
-	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
-	xpc_activate_IRQ_rcvd++;
-	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
-
-	wake_up_interruptible(&xpc_activate_IRQ_wq);
-	return IRQ_HANDLED;
-}
-
-/*
- * Flag the appropriate amo variable and send an IRQ to the specified node.
- */
-static void
-xpc_send_activate_IRQ_sn2(unsigned long amos_page_pa, int from_nasid,
-			  int to_nasid, int to_phys_cpuid)
-{
-	struct amo *amos = (struct amo *)__va(amos_page_pa +
-					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
-					      sizeof(struct amo)));
-
-	(void)xpc_send_IRQ_sn2(&amos[BIT_WORD(from_nasid / 2)],
-			       BIT_MASK(from_nasid / 2), to_nasid,
-			       to_phys_cpuid, SGI_XPC_ACTIVATE);
-}
-
-static void
-xpc_send_local_activate_IRQ_sn2(int from_nasid)
-{
-	unsigned long irq_flags;
-	struct amo *amos = (struct amo *)__va(xpc_vars_sn2->amos_page_pa +
-					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
-					      sizeof(struct amo)));
-
-	/* fake the sending and receipt of an activate IRQ from remote nasid */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amos[BIT_WORD(from_nasid / 2)].variable),
-			 FETCHOP_OR, BIT_MASK(from_nasid / 2));
-
-	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
-	xpc_activate_IRQ_rcvd++;
-	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
-
-	wake_up_interruptible(&xpc_activate_IRQ_wq);
-}
-
-/*
- * Functions associated with SGI_XPC_NOTIFY IRQ.
- */
-
-/*
- * Check to see if any chctl flags were sent from the specified partition.
- */
-static void
-xpc_check_for_sent_chctl_flags_sn2(struct xpc_partition *part)
-{
-	union xpc_channel_ctl_flags chctl;
-	unsigned long irq_flags;
-
-	chctl.all_flags = xpc_receive_IRQ_amo_sn2(part->sn.sn2.
-						  local_chctl_amo_va);
-	if (chctl.all_flags == 0)
-		return;
-
-	spin_lock_irqsave(&part->chctl_lock, irq_flags);
-	part->chctl.all_flags |= chctl.all_flags;
-	spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
-
-	dev_dbg(xpc_chan, "received notify IRQ from partid=%d, chctl.all_flags="
-		"0x%llx\n", XPC_PARTID(part), chctl.all_flags);
-
-	xpc_wakeup_channel_mgr(part);
-}
-
-/*
- * Handle the receipt of a SGI_XPC_NOTIFY IRQ by seeing whether the specified
- * partition actually sent it. Since SGI_XPC_NOTIFY IRQs may be shared by more
- * than one partition, we use an amo structure per partition to indicate
- * whether a partition has sent an IRQ or not.  If it has, then wake up the
- * associated kthread to handle it.
- *
- * All SGI_XPC_NOTIFY IRQs received by XPC are the result of IRQs sent by XPC
- * running on other partitions.
- *
- * Noteworthy Arguments:
- *
- *	irq - Interrupt ReQuest number. NOT USED.
- *
- *	dev_id - partid of IRQ's potential sender.
- */
-static irqreturn_t
-xpc_handle_notify_IRQ_sn2(int irq, void *dev_id)
-{
-	short partid = (short)(u64)dev_id;
-	struct xpc_partition *part = &xpc_partitions[partid];
-
-	DBUG_ON(partid < 0 || partid >= XP_MAX_NPARTITIONS_SN2);
-
-	if (xpc_part_ref(part)) {
-		xpc_check_for_sent_chctl_flags_sn2(part);
-
-		xpc_part_deref(part);
-	}
-	return IRQ_HANDLED;
-}
-
-/*
- * Check to see if xpc_handle_notify_IRQ_sn2() dropped any IRQs on the floor
- * because the write to their associated amo variable completed after the IRQ
- * was received.
- */
-static void
-xpc_check_for_dropped_notify_IRQ_sn2(struct timer_list *t)
-{
-	struct xpc_partition *part =
-		from_timer(part, t, sn.sn2.dropped_notify_IRQ_timer);
-
-	if (xpc_part_ref(part)) {
-		xpc_check_for_sent_chctl_flags_sn2(part);
-
-		t->expires = jiffies + XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL;
-		add_timer(t);
-		xpc_part_deref(part);
-	}
-}
-
-/*
- * Send a notify IRQ to the remote partition that is associated with the
- * specified channel.
- */
-static void
-xpc_send_notify_IRQ_sn2(struct xpc_channel *ch, u8 chctl_flag,
-			char *chctl_flag_string, unsigned long *irq_flags)
-{
-	struct xpc_partition *part = &xpc_partitions[ch->partid];
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	union xpc_channel_ctl_flags chctl = { 0 };
-	enum xp_retval ret;
-
-	if (likely(part->act_state != XPC_P_AS_DEACTIVATING)) {
-		chctl.flags[ch->number] = chctl_flag;
-		ret = xpc_send_IRQ_sn2(part_sn2->remote_chctl_amo_va,
-				       chctl.all_flags,
-				       part_sn2->notify_IRQ_nasid,
-				       part_sn2->notify_IRQ_phys_cpuid,
-				       SGI_XPC_NOTIFY);
-		dev_dbg(xpc_chan, "%s sent to partid=%d, channel=%d, ret=%d\n",
-			chctl_flag_string, ch->partid, ch->number, ret);
-		if (unlikely(ret != xpSuccess)) {
-			if (irq_flags != NULL)
-				spin_unlock_irqrestore(&ch->lock, *irq_flags);
-			XPC_DEACTIVATE_PARTITION(part, ret);
-			if (irq_flags != NULL)
-				spin_lock_irqsave(&ch->lock, *irq_flags);
-		}
-	}
-}
-
-#define XPC_SEND_NOTIFY_IRQ_SN2(_ch, _ipi_f, _irq_f) \
-		xpc_send_notify_IRQ_sn2(_ch, _ipi_f, #_ipi_f, _irq_f)
-
-/*
- * Make it look like the remote partition, which is associated with the
- * specified channel, sent us a notify IRQ. This faked IRQ will be handled
- * by xpc_check_for_dropped_notify_IRQ_sn2().
- */
-static void
-xpc_send_local_notify_IRQ_sn2(struct xpc_channel *ch, u8 chctl_flag,
-			      char *chctl_flag_string)
-{
-	struct xpc_partition *part = &xpc_partitions[ch->partid];
-	union xpc_channel_ctl_flags chctl = { 0 };
-
-	chctl.flags[ch->number] = chctl_flag;
-	FETCHOP_STORE_OP(TO_AMO((u64)&part->sn.sn2.local_chctl_amo_va->
-				variable), FETCHOP_OR, chctl.all_flags);
-	dev_dbg(xpc_chan, "%s sent local from partid=%d, channel=%d\n",
-		chctl_flag_string, ch->partid, ch->number);
-}
-
-#define XPC_SEND_LOCAL_NOTIFY_IRQ_SN2(_ch, _ipi_f) \
-		xpc_send_local_notify_IRQ_sn2(_ch, _ipi_f, #_ipi_f)
-
-static void
-xpc_send_chctl_closerequest_sn2(struct xpc_channel *ch,
-				unsigned long *irq_flags)
-{
-	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
-
-	args->reason = ch->reason;
-	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_CLOSEREQUEST, irq_flags);
-}
-
-static void
-xpc_send_chctl_closereply_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
-{
-	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_CLOSEREPLY, irq_flags);
-}
-
-static void
-xpc_send_chctl_openrequest_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
-{
-	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
-
-	args->entry_size = ch->entry_size;
-	args->local_nentries = ch->local_nentries;
-	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREQUEST, irq_flags);
-}
-
-static void
-xpc_send_chctl_openreply_sn2(struct xpc_channel *ch, unsigned long *irq_flags)
-{
-	struct xpc_openclose_args *args = ch->sn.sn2.local_openclose_args;
-
-	args->remote_nentries = ch->remote_nentries;
-	args->local_nentries = ch->local_nentries;
-	args->local_msgqueue_pa = xp_pa(ch->sn.sn2.local_msgqueue);
-	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENREPLY, irq_flags);
-}
-
-static void
-xpc_send_chctl_opencomplete_sn2(struct xpc_channel *ch,
-				unsigned long *irq_flags)
-{
-	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_OPENCOMPLETE, irq_flags);
-}
-
-static void
-xpc_send_chctl_msgrequest_sn2(struct xpc_channel *ch)
-{
-	XPC_SEND_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST, NULL);
-}
-
-static void
-xpc_send_chctl_local_msgrequest_sn2(struct xpc_channel *ch)
-{
-	XPC_SEND_LOCAL_NOTIFY_IRQ_SN2(ch, XPC_CHCTL_MSGREQUEST);
-}
-
-static enum xp_retval
-xpc_save_remote_msgqueue_pa_sn2(struct xpc_channel *ch,
-				unsigned long msgqueue_pa)
-{
-	ch->sn.sn2.remote_msgqueue_pa = msgqueue_pa;
-	return xpSuccess;
-}
-
-/*
- * This next set of functions are used to keep track of when a partition is
- * potentially engaged in accessing memory belonging to another partition.
- */
-
-static void
-xpc_indicate_partition_engaged_sn2(struct xpc_partition *part)
-{
-	unsigned long irq_flags;
-	struct amo *amo = (struct amo *)__va(part->sn.sn2.remote_amos_page_pa +
-					     (XPC_ENGAGED_PARTITIONS_AMO_SN2 *
-					     sizeof(struct amo)));
-
-	local_irq_save(irq_flags);
-
-	/* set bit corresponding to our partid in remote partition's amo */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_OR,
-			 BIT(sn_partition_id));
-
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IRQs and amos to it until the heartbeat times out.
-	 */
-	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
-							       variable),
-						     xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
-}
-
-static void
-xpc_indicate_partition_disengaged_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	unsigned long irq_flags;
-	struct amo *amo = (struct amo *)__va(part_sn2->remote_amos_page_pa +
-					     (XPC_ENGAGED_PARTITIONS_AMO_SN2 *
-					     sizeof(struct amo)));
-
-	local_irq_save(irq_flags);
-
-	/* clear bit corresponding to our partid in remote partition's amo */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~BIT(sn_partition_id));
-
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IRQs and amos to it until the heartbeat times out.
-	 */
-	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
-							       variable),
-						     xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
-
-	/*
-	 * Send activate IRQ to get other side to see that we've cleared our
-	 * bit in their engaged partitions amo.
-	 */
-	xpc_send_activate_IRQ_sn2(part_sn2->remote_amos_page_pa,
-				  cnodeid_to_nasid(0),
-				  part_sn2->activate_IRQ_nasid,
-				  part_sn2->activate_IRQ_phys_cpuid);
-}
-
-static void
-xpc_assume_partition_disengaged_sn2(short partid)
-{
-	struct amo *amo = xpc_vars_sn2->amos_page +
-			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
-
-	/* clear bit(s) based on partid mask in our partition's amo */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~BIT(partid));
-}
-
-static int
-xpc_partition_engaged_sn2(short partid)
-{
-	struct amo *amo = xpc_vars_sn2->amos_page +
-			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
-
-	/* our partition's amo variable ANDed with partid mask */
-	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
-		BIT(partid)) != 0;
-}
-
-static int
-xpc_any_partition_engaged_sn2(void)
-{
-	struct amo *amo = xpc_vars_sn2->amos_page +
-			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
-
-	/* our partition's amo variable */
-	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) != 0;
-}
-
-/* original protection values for each node */
-static u64 xpc_prot_vec_sn2[MAX_NUMNODES];
-
-/*
- * Change protections to allow amo operations on non-Shub 1.1 systems.
- */
-static enum xp_retval
-xpc_allow_amo_ops_sn2(struct amo *amos_page)
-{
-	enum xp_retval ret = xpSuccess;
-
-	/*
-	 * On SHUB 1.1, we cannot call sn_change_memprotect() since the BIST
-	 * collides with memory operations. On those systems we call
-	 * xpc_allow_amo_ops_shub_wars_1_1_sn2() instead.
-	 */
-	if (!enable_shub_wars_1_1())
-		ret = xp_expand_memprotect(ia64_tpa((u64)amos_page), PAGE_SIZE);
-
-	return ret;
-}
-
-/*
- * Change protections to allow amo operations on Shub 1.1 systems.
- */
-static void
-xpc_allow_amo_ops_shub_wars_1_1_sn2(void)
-{
-	int node;
-	int nasid;
-
-	if (!enable_shub_wars_1_1())
-		return;
-
-	for_each_online_node(node) {
-		nasid = cnodeid_to_nasid(node);
-		/* save current protection values */
-		xpc_prot_vec_sn2[node] =
-		    (u64)HUB_L((u64 *)GLOBAL_MMR_ADDR(nasid,
-						  SH1_MD_DQLP_MMR_DIR_PRIVEC0));
-		/* open up everything */
-		HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-					     SH1_MD_DQLP_MMR_DIR_PRIVEC0),
-		      -1UL);
-		HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,
-					     SH1_MD_DQRP_MMR_DIR_PRIVEC0),
-		      -1UL);
-	}
-}
-
-static enum xp_retval
-xpc_get_partition_rsvd_page_pa_sn2(void *buf, u64 *cookie, unsigned long *rp_pa,
-				   size_t *len)
-{
-	s64 status;
-	enum xp_retval ret;
-
-	status = sn_partition_reserved_page_pa((u64)buf, cookie,
-			(u64 *)rp_pa, (u64 *)len);
-	if (status == SALRET_OK)
-		ret = xpSuccess;
-	else if (status == SALRET_MORE_PASSES)
-		ret = xpNeedMoreInfo;
-	else
-		ret = xpSalError;
-
-	return ret;
-}
-
-
-static int
-xpc_setup_rsvd_page_sn2(struct xpc_rsvd_page *rp)
-{
-	struct amo *amos_page;
-	int i;
-	int ret;
-
-	xpc_vars_sn2 = XPC_RP_VARS(rp);
-
-	rp->sn.sn2.vars_pa = xp_pa(xpc_vars_sn2);
-
-	/* vars_part array follows immediately after vars */
-	xpc_vars_part_sn2 = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
-							 XPC_RP_VARS_SIZE);
-
-	/*
-	 * Before clearing xpc_vars_sn2, see if a page of amos had been
-	 * previously allocated. If not we'll need to allocate one and set
-	 * permissions so that cross-partition amos are allowed.
-	 *
-	 * The allocated amo page needs MCA reporting to remain disabled after
-	 * XPC has unloaded.  To make this work, we keep a copy of the pointer
-	 * to this page (i.e., amos_page) in the struct xpc_vars_sn2 structure,
-	 * which is pointed to by the reserved page, and re-use that saved copy
-	 * on subsequent loads of XPC. This amo page is never freed, and its
-	 * memory protections are never restricted.
-	 */
-	amos_page = xpc_vars_sn2->amos_page;
-	if (amos_page == NULL) {
-		amos_page = (struct amo *)TO_AMO(uncached_alloc_page(0, 1));
-		if (amos_page == NULL) {
-			dev_err(xpc_part, "can't allocate page of amos\n");
-			return -ENOMEM;
-		}
-
-		/*
-		 * Open up amo-R/W to cpu.  This is done on Shub 1.1 systems
-		 * when xpc_allow_amo_ops_shub_wars_1_1_sn2() is called.
-		 */
-		ret = xpc_allow_amo_ops_sn2(amos_page);
-		if (ret != xpSuccess) {
-			dev_err(xpc_part, "can't allow amo operations\n");
-			uncached_free_page(__IA64_UNCACHED_OFFSET |
-					   TO_PHYS((u64)amos_page), 1);
-			return -EPERM;
-		}
-	}
-
-	/* clear xpc_vars_sn2 */
-	memset(xpc_vars_sn2, 0, sizeof(struct xpc_vars_sn2));
-
-	xpc_vars_sn2->version = XPC_V_VERSION;
-	xpc_vars_sn2->activate_IRQ_nasid = cpuid_to_nasid(0);
-	xpc_vars_sn2->activate_IRQ_phys_cpuid = cpu_physical_id(0);
-	xpc_vars_sn2->vars_part_pa = xp_pa(xpc_vars_part_sn2);
-	xpc_vars_sn2->amos_page_pa = ia64_tpa((u64)amos_page);
-	xpc_vars_sn2->amos_page = amos_page;	/* save for next load of XPC */
-
-	/* clear xpc_vars_part_sn2 */
-	memset((u64 *)xpc_vars_part_sn2, 0, sizeof(struct xpc_vars_part_sn2) *
-	       XP_MAX_NPARTITIONS_SN2);
-
-	/* initialize the activate IRQ related amo variables */
-	for (i = 0; i < xpc_nasid_mask_nlongs; i++)
-		(void)xpc_init_IRQ_amo_sn2(XPC_ACTIVATE_IRQ_AMOS_SN2 + i);
-
-	/* initialize the engaged remote partitions related amo variables */
-	(void)xpc_init_IRQ_amo_sn2(XPC_ENGAGED_PARTITIONS_AMO_SN2);
-	(void)xpc_init_IRQ_amo_sn2(XPC_DEACTIVATE_REQUEST_AMO_SN2);
-
-	return 0;
-}
-
-static int
-xpc_hb_allowed_sn2(short partid, void *heartbeating_to_mask)
-{
-	return test_bit(partid, heartbeating_to_mask);
-}
-
-static void
-xpc_allow_hb_sn2(short partid)
-{
-	DBUG_ON(xpc_vars_sn2 == NULL);
-	set_bit(partid, xpc_vars_sn2->heartbeating_to_mask);
-}
-
-static void
-xpc_disallow_hb_sn2(short partid)
-{
-	DBUG_ON(xpc_vars_sn2 == NULL);
-	clear_bit(partid, xpc_vars_sn2->heartbeating_to_mask);
-}
-
-static void
-xpc_disallow_all_hbs_sn2(void)
-{
-	DBUG_ON(xpc_vars_sn2 == NULL);
-	bitmap_zero(xpc_vars_sn2->heartbeating_to_mask, xp_max_npartitions);
-}
-
-static void
-xpc_increment_heartbeat_sn2(void)
-{
-	xpc_vars_sn2->heartbeat++;
-}
-
-static void
-xpc_offline_heartbeat_sn2(void)
-{
-	xpc_increment_heartbeat_sn2();
-	xpc_vars_sn2->heartbeat_offline = 1;
-}
-
-static void
-xpc_online_heartbeat_sn2(void)
-{
-	xpc_increment_heartbeat_sn2();
-	xpc_vars_sn2->heartbeat_offline = 0;
-}
-
-static void
-xpc_heartbeat_init_sn2(void)
-{
-	DBUG_ON(xpc_vars_sn2 == NULL);
-
-	bitmap_zero(xpc_vars_sn2->heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
-	xpc_online_heartbeat_sn2();
-}
-
-static void
-xpc_heartbeat_exit_sn2(void)
-{
-	xpc_offline_heartbeat_sn2();
-}
-
-static enum xp_retval
-xpc_get_remote_heartbeat_sn2(struct xpc_partition *part)
-{
-	struct xpc_vars_sn2 *remote_vars;
-	enum xp_retval ret;
-
-	remote_vars = (struct xpc_vars_sn2 *)xpc_remote_copy_buffer_sn2;
-
-	/* pull the remote vars structure that contains the heartbeat */
-	ret = xp_remote_memcpy(xp_pa(remote_vars),
-			       part->sn.sn2.remote_vars_pa,
-			       XPC_RP_VARS_SIZE);
-	if (ret != xpSuccess)
-		return ret;
-
-	dev_dbg(xpc_part, "partid=%d, heartbeat=%lld, last_heartbeat=%lld, "
-		"heartbeat_offline=%lld, HB_mask[0]=0x%lx\n", XPC_PARTID(part),
-		remote_vars->heartbeat, part->last_heartbeat,
-		remote_vars->heartbeat_offline,
-		remote_vars->heartbeating_to_mask[0]);
-
-	if ((remote_vars->heartbeat == part->last_heartbeat &&
-	    !remote_vars->heartbeat_offline) ||
-	    !xpc_hb_allowed_sn2(sn_partition_id,
-				remote_vars->heartbeating_to_mask)) {
-		ret = xpNoHeartbeat;
-	} else {
-		part->last_heartbeat = remote_vars->heartbeat;
-	}
-
-	return ret;
-}
-
-/*
- * Get a copy of the remote partition's XPC variables from the reserved page.
- *
- * remote_vars points to a buffer that is cacheline aligned for BTE copies and
- * assumed to be of size XPC_RP_VARS_SIZE.
- */
-static enum xp_retval
-xpc_get_remote_vars_sn2(unsigned long remote_vars_pa,
-			struct xpc_vars_sn2 *remote_vars)
-{
-	enum xp_retval ret;
-
-	if (remote_vars_pa == 0)
-		return xpVarsNotSet;
-
-	/* pull over the cross partition variables */
-	ret = xp_remote_memcpy(xp_pa(remote_vars), remote_vars_pa,
-			       XPC_RP_VARS_SIZE);
-	if (ret != xpSuccess)
-		return ret;
-
-	if (XPC_VERSION_MAJOR(remote_vars->version) !=
-	    XPC_VERSION_MAJOR(XPC_V_VERSION)) {
-		return xpBadVersion;
-	}
-
-	return xpSuccess;
-}
-
-static void
-xpc_request_partition_activation_sn2(struct xpc_rsvd_page *remote_rp,
-				     unsigned long remote_rp_pa, int nasid)
-{
-	xpc_send_local_activate_IRQ_sn2(nasid);
-}
-
-static void
-xpc_request_partition_reactivation_sn2(struct xpc_partition *part)
-{
-	xpc_send_local_activate_IRQ_sn2(part->sn.sn2.activate_IRQ_nasid);
-}
-
-static void
-xpc_request_partition_deactivation_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	unsigned long irq_flags;
-	struct amo *amo = (struct amo *)__va(part_sn2->remote_amos_page_pa +
-					     (XPC_DEACTIVATE_REQUEST_AMO_SN2 *
-					     sizeof(struct amo)));
-
-	local_irq_save(irq_flags);
-
-	/* set bit corresponding to our partid in remote partition's amo */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_OR,
-			 BIT(sn_partition_id));
-
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IRQs and amos to it until the heartbeat times out.
-	 */
-	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
-							       variable),
-						     xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
-
-	/*
-	 * Send activate IRQ to get other side to see that we've set our
-	 * bit in their deactivate request amo.
-	 */
-	xpc_send_activate_IRQ_sn2(part_sn2->remote_amos_page_pa,
-				  cnodeid_to_nasid(0),
-				  part_sn2->activate_IRQ_nasid,
-				  part_sn2->activate_IRQ_phys_cpuid);
-}
-
-static void
-xpc_cancel_partition_deactivation_request_sn2(struct xpc_partition *part)
-{
-	unsigned long irq_flags;
-	struct amo *amo = (struct amo *)__va(part->sn.sn2.remote_amos_page_pa +
-					     (XPC_DEACTIVATE_REQUEST_AMO_SN2 *
-					     sizeof(struct amo)));
-
-	local_irq_save(irq_flags);
-
-	/* clear bit corresponding to our partid in remote partition's amo */
-	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
-			 ~BIT(sn_partition_id));
-
-	/*
-	 * We must always use the nofault function regardless of whether we
-	 * are on a Shub 1.1 system or a Shub 1.2 slice 0xc processor. If we
-	 * didn't, we'd never know that the other partition is down and would
-	 * keep sending IRQs and amos to it until the heartbeat times out.
-	 */
-	(void)xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(&amo->
-							       variable),
-						     xp_nofault_PIOR_target));
-
-	local_irq_restore(irq_flags);
-}
-
-static int
-xpc_partition_deactivation_requested_sn2(short partid)
-{
-	struct amo *amo = xpc_vars_sn2->amos_page +
-			  XPC_DEACTIVATE_REQUEST_AMO_SN2;
-
-	/* our partition's amo variable ANDed with partid mask */
-	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
-		BIT(partid)) != 0;
-}
-
-/*
- * Update the remote partition's info.
- */
-static void
-xpc_update_partition_info_sn2(struct xpc_partition *part, u8 remote_rp_version,
-			      unsigned long *remote_rp_ts_jiffies,
-			      unsigned long remote_rp_pa,
-			      unsigned long remote_vars_pa,
-			      struct xpc_vars_sn2 *remote_vars)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-
-	part->remote_rp_version = remote_rp_version;
-	dev_dbg(xpc_part, "  remote_rp_version = 0x%016x\n",
-		part->remote_rp_version);
-
-	part->remote_rp_ts_jiffies = *remote_rp_ts_jiffies;
-	dev_dbg(xpc_part, "  remote_rp_ts_jiffies = 0x%016lx\n",
-		part->remote_rp_ts_jiffies);
-
-	part->remote_rp_pa = remote_rp_pa;
-	dev_dbg(xpc_part, "  remote_rp_pa = 0x%016lx\n", part->remote_rp_pa);
-
-	part_sn2->remote_vars_pa = remote_vars_pa;
-	dev_dbg(xpc_part, "  remote_vars_pa = 0x%016lx\n",
-		part_sn2->remote_vars_pa);
-
-	part->last_heartbeat = remote_vars->heartbeat - 1;
-	dev_dbg(xpc_part, "  last_heartbeat = 0x%016llx\n",
-		part->last_heartbeat);
-
-	part_sn2->remote_vars_part_pa = remote_vars->vars_part_pa;
-	dev_dbg(xpc_part, "  remote_vars_part_pa = 0x%016lx\n",
-		part_sn2->remote_vars_part_pa);
-
-	part_sn2->activate_IRQ_nasid = remote_vars->activate_IRQ_nasid;
-	dev_dbg(xpc_part, "  activate_IRQ_nasid = 0x%x\n",
-		part_sn2->activate_IRQ_nasid);
-
-	part_sn2->activate_IRQ_phys_cpuid =
-	    remote_vars->activate_IRQ_phys_cpuid;
-	dev_dbg(xpc_part, "  activate_IRQ_phys_cpuid = 0x%x\n",
-		part_sn2->activate_IRQ_phys_cpuid);
-
-	part_sn2->remote_amos_page_pa = remote_vars->amos_page_pa;
-	dev_dbg(xpc_part, "  remote_amos_page_pa = 0x%lx\n",
-		part_sn2->remote_amos_page_pa);
-
-	part_sn2->remote_vars_version = remote_vars->version;
-	dev_dbg(xpc_part, "  remote_vars_version = 0x%x\n",
-		part_sn2->remote_vars_version);
-}
-
-/*
- * Prior code has determined the nasid which generated a activate IRQ.
- * Inspect that nasid to determine if its partition needs to be activated
- * or deactivated.
- *
- * A partition is considered "awaiting activation" if our partition
- * flags indicate it is not active and it has a heartbeat.  A
- * partition is considered "awaiting deactivation" if our partition
- * flags indicate it is active but it has no heartbeat or it is not
- * sending its heartbeat to us.
- *
- * To determine the heartbeat, the remote nasid must have a properly
- * initialized reserved page.
- */
-static void
-xpc_identify_activate_IRQ_req_sn2(int nasid)
-{
-	struct xpc_rsvd_page *remote_rp;
-	struct xpc_vars_sn2 *remote_vars;
-	unsigned long remote_rp_pa;
-	unsigned long remote_vars_pa;
-	int remote_rp_version;
-	int reactivate = 0;
-	unsigned long remote_rp_ts_jiffies = 0;
-	short partid;
-	struct xpc_partition *part;
-	struct xpc_partition_sn2 *part_sn2;
-	enum xp_retval ret;
-
-	/* pull over the reserved page structure */
-
-	remote_rp = (struct xpc_rsvd_page *)xpc_remote_copy_buffer_sn2;
-
-	ret = xpc_get_remote_rp(nasid, NULL, remote_rp, &remote_rp_pa);
-	if (ret != xpSuccess) {
-		dev_warn(xpc_part, "unable to get reserved page from nasid %d, "
-			 "which sent interrupt, reason=%d\n", nasid, ret);
-		return;
-	}
-
-	remote_vars_pa = remote_rp->sn.sn2.vars_pa;
-	remote_rp_version = remote_rp->version;
-	remote_rp_ts_jiffies = remote_rp->ts_jiffies;
-
-	partid = remote_rp->SAL_partid;
-	part = &xpc_partitions[partid];
-	part_sn2 = &part->sn.sn2;
-
-	/* pull over the cross partition variables */
-
-	remote_vars = (struct xpc_vars_sn2 *)xpc_remote_copy_buffer_sn2;
-
-	ret = xpc_get_remote_vars_sn2(remote_vars_pa, remote_vars);
-	if (ret != xpSuccess) {
-		dev_warn(xpc_part, "unable to get XPC variables from nasid %d, "
-			 "which sent interrupt, reason=%d\n", nasid, ret);
-
-		XPC_DEACTIVATE_PARTITION(part, ret);
-		return;
-	}
-
-	part->activate_IRQ_rcvd++;
-
-	dev_dbg(xpc_part, "partid for nasid %d is %d; IRQs = %d; HB = "
-		"%lld:0x%lx\n", (int)nasid, (int)partid,
-		part->activate_IRQ_rcvd,
-		remote_vars->heartbeat, remote_vars->heartbeating_to_mask[0]);
-
-	if (xpc_partition_disengaged(part) &&
-	    part->act_state == XPC_P_AS_INACTIVE) {
-
-		xpc_update_partition_info_sn2(part, remote_rp_version,
-					      &remote_rp_ts_jiffies,
-					      remote_rp_pa, remote_vars_pa,
-					      remote_vars);
-
-		if (xpc_partition_deactivation_requested_sn2(partid)) {
-			/*
-			 * Other side is waiting on us to deactivate even though
-			 * we already have.
-			 */
-			return;
-		}
-
-		xpc_activate_partition(part);
-		return;
-	}
-
-	DBUG_ON(part->remote_rp_version == 0);
-	DBUG_ON(part_sn2->remote_vars_version == 0);
-
-	if (remote_rp_ts_jiffies != part->remote_rp_ts_jiffies) {
-
-		/* the other side rebooted */
-
-		DBUG_ON(xpc_partition_engaged_sn2(partid));
-		DBUG_ON(xpc_partition_deactivation_requested_sn2(partid));
-
-		xpc_update_partition_info_sn2(part, remote_rp_version,
-					      &remote_rp_ts_jiffies,
-					      remote_rp_pa, remote_vars_pa,
-					      remote_vars);
-		reactivate = 1;
-	}
-
-	if (part->disengage_timeout > 0 && !xpc_partition_disengaged(part)) {
-		/* still waiting on other side to disengage from us */
-		return;
-	}
-
-	if (reactivate)
-		XPC_DEACTIVATE_PARTITION(part, xpReactivating);
-	else if (xpc_partition_deactivation_requested_sn2(partid))
-		XPC_DEACTIVATE_PARTITION(part, xpOtherGoingDown);
-}
-
-/*
- * Loop through the activation amo variables and process any bits
- * which are set.  Each bit indicates a nasid sending a partition
- * activation or deactivation request.
- *
- * Return #of IRQs detected.
- */
-int
-xpc_identify_activate_IRQ_sender_sn2(void)
-{
-	int l;
-	int b;
-	unsigned long nasid_mask_long;
-	u64 nasid;		/* remote nasid */
-	int n_IRQs_detected = 0;
-	struct amo *act_amos;
-
-	act_amos = xpc_vars_sn2->amos_page + XPC_ACTIVATE_IRQ_AMOS_SN2;
-
-	/* scan through activate amo variables looking for non-zero entries */
-	for (l = 0; l < xpc_nasid_mask_nlongs; l++) {
-
-		if (xpc_exiting)
-			break;
-
-		nasid_mask_long = xpc_receive_IRQ_amo_sn2(&act_amos[l]);
-
-		b = find_first_bit(&nasid_mask_long, BITS_PER_LONG);
-		if (b >= BITS_PER_LONG) {
-			/* no IRQs from nasids in this amo variable */
-			continue;
-		}
-
-		dev_dbg(xpc_part, "amo[%d] gave back 0x%lx\n", l,
-			nasid_mask_long);
-
-		/*
-		 * If this nasid has been added to the machine since
-		 * our partition was reset, this will retain the
-		 * remote nasid in our reserved pages machine mask.
-		 * This is used in the event of module reload.
-		 */
-		xpc_mach_nasids[l] |= nasid_mask_long;
-
-		/* locate the nasid(s) which sent interrupts */
-
-		do {
-			n_IRQs_detected++;
-			nasid = (l * BITS_PER_LONG + b) * 2;
-			dev_dbg(xpc_part, "interrupt from nasid %lld\n", nasid);
-			xpc_identify_activate_IRQ_req_sn2(nasid);
-
-			b = find_next_bit(&nasid_mask_long, BITS_PER_LONG,
-					  b + 1);
-		} while (b < BITS_PER_LONG);
-	}
-	return n_IRQs_detected;
-}
-
-static void
-xpc_process_activate_IRQ_rcvd_sn2(void)
-{
-	unsigned long irq_flags;
-	int n_IRQs_expected;
-	int n_IRQs_detected;
-
-	spin_lock_irqsave(&xpc_activate_IRQ_rcvd_lock, irq_flags);
-	n_IRQs_expected = xpc_activate_IRQ_rcvd;
-	xpc_activate_IRQ_rcvd = 0;
-	spin_unlock_irqrestore(&xpc_activate_IRQ_rcvd_lock, irq_flags);
-
-	n_IRQs_detected = xpc_identify_activate_IRQ_sender_sn2();
-	if (n_IRQs_detected < n_IRQs_expected) {
-		/* retry once to help avoid missing amo */
-		(void)xpc_identify_activate_IRQ_sender_sn2();
-	}
-}
-
-/*
- * Setup the channel structures that are sn2 specific.
- */
-static enum xp_retval
-xpc_setup_ch_structures_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	struct xpc_channel_sn2 *ch_sn2;
-	enum xp_retval retval;
-	int ret;
-	int cpuid;
-	int ch_number;
-	struct timer_list *timer;
-	short partid = XPC_PARTID(part);
-
-	/* allocate all the required GET/PUT values */
-
-	part_sn2->local_GPs =
-	    xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE, GFP_KERNEL,
-					  &part_sn2->local_GPs_base);
-	if (part_sn2->local_GPs == NULL) {
-		dev_err(xpc_chan, "can't get memory for local get/put "
-			"values\n");
-		return xpNoMemory;
-	}
-
-	part_sn2->remote_GPs =
-	    xpc_kzalloc_cacheline_aligned(XPC_GP_SIZE, GFP_KERNEL,
-					  &part_sn2->remote_GPs_base);
-	if (part_sn2->remote_GPs == NULL) {
-		dev_err(xpc_chan, "can't get memory for remote get/put "
-			"values\n");
-		retval = xpNoMemory;
-		goto out_1;
-	}
-
-	part_sn2->remote_GPs_pa = 0;
-
-	/* allocate all the required open and close args */
-
-	part_sn2->local_openclose_args =
-	    xpc_kzalloc_cacheline_aligned(XPC_OPENCLOSE_ARGS_SIZE,
-					  GFP_KERNEL, &part_sn2->
-					  local_openclose_args_base);
-	if (part_sn2->local_openclose_args == NULL) {
-		dev_err(xpc_chan, "can't get memory for local connect args\n");
-		retval = xpNoMemory;
-		goto out_2;
-	}
-
-	part_sn2->remote_openclose_args_pa = 0;
-
-	part_sn2->local_chctl_amo_va = xpc_init_IRQ_amo_sn2(partid);
-
-	part_sn2->notify_IRQ_nasid = 0;
-	part_sn2->notify_IRQ_phys_cpuid = 0;
-	part_sn2->remote_chctl_amo_va = NULL;
-
-	sprintf(part_sn2->notify_IRQ_owner, "xpc%02d", partid);
-	ret = request_irq(SGI_XPC_NOTIFY, xpc_handle_notify_IRQ_sn2,
-			  IRQF_SHARED, part_sn2->notify_IRQ_owner,
-			  (void *)(u64)partid);
-	if (ret != 0) {
-		dev_err(xpc_chan, "can't register NOTIFY IRQ handler, "
-			"errno=%d\n", -ret);
-		retval = xpLackOfResources;
-		goto out_3;
-	}
-
-	/* Setup a timer to check for dropped notify IRQs */
-	timer = &part_sn2->dropped_notify_IRQ_timer;
-	timer_setup(timer, xpc_check_for_dropped_notify_IRQ_sn2, 0);
-	timer->expires = jiffies + XPC_DROPPED_NOTIFY_IRQ_WAIT_INTERVAL;
-	add_timer(timer);
-
-	for (ch_number = 0; ch_number < part->nchannels; ch_number++) {
-		ch_sn2 = &part->channels[ch_number].sn.sn2;
-
-		ch_sn2->local_GP = &part_sn2->local_GPs[ch_number];
-		ch_sn2->local_openclose_args =
-		    &part_sn2->local_openclose_args[ch_number];
-
-		mutex_init(&ch_sn2->msg_to_pull_mutex);
-	}
-
-	/*
-	 * Setup the per partition specific variables required by the
-	 * remote partition to establish channel connections with us.
-	 *
-	 * The setting of the magic # indicates that these per partition
-	 * specific variables are ready to be used.
-	 */
-	xpc_vars_part_sn2[partid].GPs_pa = xp_pa(part_sn2->local_GPs);
-	xpc_vars_part_sn2[partid].openclose_args_pa =
-	    xp_pa(part_sn2->local_openclose_args);
-	xpc_vars_part_sn2[partid].chctl_amo_pa =
-	    xp_pa(part_sn2->local_chctl_amo_va);
-	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
-	xpc_vars_part_sn2[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
-	xpc_vars_part_sn2[partid].notify_IRQ_phys_cpuid =
-	    cpu_physical_id(cpuid);
-	xpc_vars_part_sn2[partid].nchannels = part->nchannels;
-	xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC1_SN2;
-
-	return xpSuccess;
-
-	/* setup of ch structures failed */
-out_3:
-	kfree(part_sn2->local_openclose_args_base);
-	part_sn2->local_openclose_args = NULL;
-out_2:
-	kfree(part_sn2->remote_GPs_base);
-	part_sn2->remote_GPs = NULL;
-out_1:
-	kfree(part_sn2->local_GPs_base);
-	part_sn2->local_GPs = NULL;
-	return retval;
-}
-
-/*
- * Teardown the channel structures that are sn2 specific.
- */
-static void
-xpc_teardown_ch_structures_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	short partid = XPC_PARTID(part);
-
-	/*
-	 * Indicate that the variables specific to the remote partition are no
-	 * longer available for its use.
-	 */
-	xpc_vars_part_sn2[partid].magic = 0;
-
-	/* in case we've still got outstanding timers registered... */
-	del_timer_sync(&part_sn2->dropped_notify_IRQ_timer);
-	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
-
-	kfree(part_sn2->local_openclose_args_base);
-	part_sn2->local_openclose_args = NULL;
-	kfree(part_sn2->remote_GPs_base);
-	part_sn2->remote_GPs = NULL;
-	kfree(part_sn2->local_GPs_base);
-	part_sn2->local_GPs = NULL;
-	part_sn2->local_chctl_amo_va = NULL;
-}
-
-/*
- * Create a wrapper that hides the underlying mechanism for pulling a cacheline
- * (or multiple cachelines) from a remote partition.
- *
- * src_pa must be a cacheline aligned physical address on the remote partition.
- * dst must be a cacheline aligned virtual address on this partition.
- * cnt must be cacheline sized
- */
-/* ??? Replace this function by call to xp_remote_memcpy() or bte_copy()? */
-static enum xp_retval
-xpc_pull_remote_cachelines_sn2(struct xpc_partition *part, void *dst,
-			       const unsigned long src_pa, size_t cnt)
-{
-	enum xp_retval ret;
-
-	DBUG_ON(src_pa != L1_CACHE_ALIGN(src_pa));
-	DBUG_ON((unsigned long)dst != L1_CACHE_ALIGN((unsigned long)dst));
-	DBUG_ON(cnt != L1_CACHE_ALIGN(cnt));
-
-	if (part->act_state == XPC_P_AS_DEACTIVATING)
-		return part->reason;
-
-	ret = xp_remote_memcpy(xp_pa(dst), src_pa, cnt);
-	if (ret != xpSuccess) {
-		dev_dbg(xpc_chan, "xp_remote_memcpy() from partition %d failed,"
-			" ret=%d\n", XPC_PARTID(part), ret);
-	}
-	return ret;
-}
-
-/*
- * Pull the remote per partition specific variables from the specified
- * partition.
- */
-static enum xp_retval
-xpc_pull_remote_vars_part_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	u8 buffer[L1_CACHE_BYTES * 2];
-	struct xpc_vars_part_sn2 *pulled_entry_cacheline =
-	    (struct xpc_vars_part_sn2 *)L1_CACHE_ALIGN((u64)buffer);
-	struct xpc_vars_part_sn2 *pulled_entry;
-	unsigned long remote_entry_cacheline_pa;
-	unsigned long remote_entry_pa;
-	short partid = XPC_PARTID(part);
-	enum xp_retval ret;
-
-	/* pull the cacheline that contains the variables we're interested in */
-
-	DBUG_ON(part_sn2->remote_vars_part_pa !=
-		L1_CACHE_ALIGN(part_sn2->remote_vars_part_pa));
-	DBUG_ON(sizeof(struct xpc_vars_part_sn2) != L1_CACHE_BYTES / 2);
-
-	remote_entry_pa = part_sn2->remote_vars_part_pa +
-	    sn_partition_id * sizeof(struct xpc_vars_part_sn2);
-
-	remote_entry_cacheline_pa = (remote_entry_pa & ~(L1_CACHE_BYTES - 1));
-
-	pulled_entry = (struct xpc_vars_part_sn2 *)((u64)pulled_entry_cacheline
-						    + (remote_entry_pa &
-						    (L1_CACHE_BYTES - 1)));
-
-	ret = xpc_pull_remote_cachelines_sn2(part, pulled_entry_cacheline,
-					     remote_entry_cacheline_pa,
-					     L1_CACHE_BYTES);
-	if (ret != xpSuccess) {
-		dev_dbg(xpc_chan, "failed to pull XPC vars_part from "
-			"partition %d, ret=%d\n", partid, ret);
-		return ret;
-	}
-
-	/* see if they've been set up yet */
-
-	if (pulled_entry->magic != XPC_VP_MAGIC1_SN2 &&
-	    pulled_entry->magic != XPC_VP_MAGIC2_SN2) {
-
-		if (pulled_entry->magic != 0) {
-			dev_dbg(xpc_chan, "partition %d's XPC vars_part for "
-				"partition %d has bad magic value (=0x%llx)\n",
-				partid, sn_partition_id, pulled_entry->magic);
-			return xpBadMagic;
-		}
-
-		/* they've not been initialized yet */
-		return xpRetry;
-	}
-
-	if (xpc_vars_part_sn2[partid].magic == XPC_VP_MAGIC1_SN2) {
-
-		/* validate the variables */
-
-		if (pulled_entry->GPs_pa == 0 ||
-		    pulled_entry->openclose_args_pa == 0 ||
-		    pulled_entry->chctl_amo_pa == 0) {
-
-			dev_err(xpc_chan, "partition %d's XPC vars_part for "
-				"partition %d are not valid\n", partid,
-				sn_partition_id);
-			return xpInvalidAddress;
-		}
-
-		/* the variables we imported look to be valid */
-
-		part_sn2->remote_GPs_pa = pulled_entry->GPs_pa;
-		part_sn2->remote_openclose_args_pa =
-		    pulled_entry->openclose_args_pa;
-		part_sn2->remote_chctl_amo_va =
-		    (struct amo *)__va(pulled_entry->chctl_amo_pa);
-		part_sn2->notify_IRQ_nasid = pulled_entry->notify_IRQ_nasid;
-		part_sn2->notify_IRQ_phys_cpuid =
-		    pulled_entry->notify_IRQ_phys_cpuid;
-
-		if (part->nchannels > pulled_entry->nchannels)
-			part->nchannels = pulled_entry->nchannels;
-
-		/* let the other side know that we've pulled their variables */
-
-		xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC2_SN2;
-	}
-
-	if (pulled_entry->magic == XPC_VP_MAGIC1_SN2)
-		return xpRetry;
-
-	return xpSuccess;
-}
-
-/*
- * Establish first contact with the remote partititon. This involves pulling
- * the XPC per partition variables from the remote partition and waiting for
- * the remote partition to pull ours.
- */
-static enum xp_retval
-xpc_make_first_contact_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	enum xp_retval ret;
-
-	/*
-	 * Register the remote partition's amos with SAL so it can handle
-	 * and cleanup errors within that address range should the remote
-	 * partition go down. We don't unregister this range because it is
-	 * difficult to tell when outstanding writes to the remote partition
-	 * are finished and thus when it is safe to unregister. This should
-	 * not result in wasted space in the SAL xp_addr_region table because
-	 * we should get the same page for remote_amos_page_pa after module
-	 * reloads and system reboots.
-	 */
-	if (sn_register_xp_addr_region(part_sn2->remote_amos_page_pa,
-				       PAGE_SIZE, 1) < 0) {
-		dev_warn(xpc_part, "xpc_activating(%d) failed to register "
-			 "xp_addr region\n", XPC_PARTID(part));
-
-		ret = xpPhysAddrRegFailed;
-		XPC_DEACTIVATE_PARTITION(part, ret);
-		return ret;
-	}
-
-	/*
-	 * Send activate IRQ to get other side to activate if they've not
-	 * already begun to do so.
-	 */
-	xpc_send_activate_IRQ_sn2(part_sn2->remote_amos_page_pa,
-				  cnodeid_to_nasid(0),
-				  part_sn2->activate_IRQ_nasid,
-				  part_sn2->activate_IRQ_phys_cpuid);
-
-	while ((ret = xpc_pull_remote_vars_part_sn2(part)) != xpSuccess) {
-		if (ret != xpRetry) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-			return ret;
-		}
-
-		dev_dbg(xpc_part, "waiting to make first contact with "
-			"partition %d\n", XPC_PARTID(part));
-
-		/* wait a 1/4 of a second or so */
-		(void)msleep_interruptible(250);
-
-		if (part->act_state == XPC_P_AS_DEACTIVATING)
-			return part->reason;
-	}
-
-	return xpSuccess;
-}
-
-/*
- * Get the chctl flags and pull the openclose args and/or remote GPs as needed.
- */
-static u64
-xpc_get_chctl_all_flags_sn2(struct xpc_partition *part)
-{
-	struct xpc_partition_sn2 *part_sn2 = &part->sn.sn2;
-	unsigned long irq_flags;
-	union xpc_channel_ctl_flags chctl;
-	enum xp_retval ret;
-
-	/*
-	 * See if there are any chctl flags to be handled.
-	 */
-
-	spin_lock_irqsave(&part->chctl_lock, irq_flags);
-	chctl = part->chctl;
-	if (chctl.all_flags != 0)
-		part->chctl.all_flags = 0;
-
-	spin_unlock_irqrestore(&part->chctl_lock, irq_flags);
-
-	if (xpc_any_openclose_chctl_flags_set(&chctl)) {
-		ret = xpc_pull_remote_cachelines_sn2(part, part->
-						     remote_openclose_args,
-						     part_sn2->
-						     remote_openclose_args_pa,
-						     XPC_OPENCLOSE_ARGS_SIZE);
-		if (ret != xpSuccess) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-
-			dev_dbg(xpc_chan, "failed to pull openclose args from "
-				"partition %d, ret=%d\n", XPC_PARTID(part),
-				ret);
-
-			/* don't bother processing chctl flags anymore */
-			chctl.all_flags = 0;
-		}
-	}
-
-	if (xpc_any_msg_chctl_flags_set(&chctl)) {
-		ret = xpc_pull_remote_cachelines_sn2(part, part_sn2->remote_GPs,
-						     part_sn2->remote_GPs_pa,
-						     XPC_GP_SIZE);
-		if (ret != xpSuccess) {
-			XPC_DEACTIVATE_PARTITION(part, ret);
-
-			dev_dbg(xpc_chan, "failed to pull GPs from partition "
-				"%d, ret=%d\n", XPC_PARTID(part), ret);
-
-			/* don't bother processing chctl flags anymore */
-			chctl.all_flags = 0;
-		}
-	}
-
-	return chctl.all_flags;
-}
-
-/*
- * Allocate the local message queue and the notify queue.
- */
-static enum xp_retval
-xpc_allocate_local_msgqueue_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	unsigned long irq_flags;
-	int nentries;
-	size_t nbytes;
-
-	for (nentries = ch->local_nentries; nentries > 0; nentries--) {
-
-		nbytes = nentries * ch->entry_size;
-		ch_sn2->local_msgqueue =
-		    xpc_kzalloc_cacheline_aligned(nbytes, GFP_KERNEL,
-						  &ch_sn2->local_msgqueue_base);
-		if (ch_sn2->local_msgqueue == NULL)
-			continue;
-
-		nbytes = nentries * sizeof(struct xpc_notify_sn2);
-		ch_sn2->notify_queue = kzalloc(nbytes, GFP_KERNEL);
-		if (ch_sn2->notify_queue == NULL) {
-			kfree(ch_sn2->local_msgqueue_base);
-			ch_sn2->local_msgqueue = NULL;
-			continue;
-		}
-
-		spin_lock_irqsave(&ch->lock, irq_flags);
-		if (nentries < ch->local_nentries) {
-			dev_dbg(xpc_chan, "nentries=%d local_nentries=%d, "
-				"partid=%d, channel=%d\n", nentries,
-				ch->local_nentries, ch->partid, ch->number);
-
-			ch->local_nentries = nentries;
-		}
-		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpSuccess;
-	}
-
-	dev_dbg(xpc_chan, "can't get memory for local message queue and notify "
-		"queue, partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpNoMemory;
-}
-
-/*
- * Allocate the cached remote message queue.
- */
-static enum xp_retval
-xpc_allocate_remote_msgqueue_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	unsigned long irq_flags;
-	int nentries;
-	size_t nbytes;
-
-	DBUG_ON(ch->remote_nentries <= 0);
-
-	for (nentries = ch->remote_nentries; nentries > 0; nentries--) {
-
-		nbytes = nentries * ch->entry_size;
-		ch_sn2->remote_msgqueue =
-		    xpc_kzalloc_cacheline_aligned(nbytes, GFP_KERNEL, &ch_sn2->
-						  remote_msgqueue_base);
-		if (ch_sn2->remote_msgqueue == NULL)
-			continue;
-
-		spin_lock_irqsave(&ch->lock, irq_flags);
-		if (nentries < ch->remote_nentries) {
-			dev_dbg(xpc_chan, "nentries=%d remote_nentries=%d, "
-				"partid=%d, channel=%d\n", nentries,
-				ch->remote_nentries, ch->partid, ch->number);
-
-			ch->remote_nentries = nentries;
-		}
-		spin_unlock_irqrestore(&ch->lock, irq_flags);
-		return xpSuccess;
-	}
-
-	dev_dbg(xpc_chan, "can't get memory for cached remote message queue, "
-		"partid=%d, channel=%d\n", ch->partid, ch->number);
-	return xpNoMemory;
-}
-
-/*
- * Allocate message queues and other stuff associated with a channel.
- *
- * Note: Assumes all of the channel sizes are filled in.
- */
-static enum xp_retval
-xpc_setup_msg_structures_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	enum xp_retval ret;
-
-	DBUG_ON(ch->flags & XPC_C_SETUP);
-
-	ret = xpc_allocate_local_msgqueue_sn2(ch);
-	if (ret == xpSuccess) {
-
-		ret = xpc_allocate_remote_msgqueue_sn2(ch);
-		if (ret != xpSuccess) {
-			kfree(ch_sn2->local_msgqueue_base);
-			ch_sn2->local_msgqueue = NULL;
-			kfree(ch_sn2->notify_queue);
-			ch_sn2->notify_queue = NULL;
-		}
-	}
-	return ret;
-}
-
-/*
- * Free up message queues and other stuff that were allocated for the specified
- * channel.
- */
-static void
-xpc_teardown_msg_structures_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-
-	lockdep_assert_held(&ch->lock);
-
-	ch_sn2->remote_msgqueue_pa = 0;
-
-	ch_sn2->local_GP->get = 0;
-	ch_sn2->local_GP->put = 0;
-	ch_sn2->remote_GP.get = 0;
-	ch_sn2->remote_GP.put = 0;
-	ch_sn2->w_local_GP.get = 0;
-	ch_sn2->w_local_GP.put = 0;
-	ch_sn2->w_remote_GP.get = 0;
-	ch_sn2->w_remote_GP.put = 0;
-	ch_sn2->next_msg_to_pull = 0;
-
-	if (ch->flags & XPC_C_SETUP) {
-		dev_dbg(xpc_chan, "ch->flags=0x%x, partid=%d, channel=%d\n",
-			ch->flags, ch->partid, ch->number);
-
-		kfree(ch_sn2->local_msgqueue_base);
-		ch_sn2->local_msgqueue = NULL;
-		kfree(ch_sn2->remote_msgqueue_base);
-		ch_sn2->remote_msgqueue = NULL;
-		kfree(ch_sn2->notify_queue);
-		ch_sn2->notify_queue = NULL;
-	}
-}
-
-/*
- * Notify those who wanted to be notified upon delivery of their message.
- */
-static void
-xpc_notify_senders_sn2(struct xpc_channel *ch, enum xp_retval reason, s64 put)
-{
-	struct xpc_notify_sn2 *notify;
-	u8 notify_type;
-	s64 get = ch->sn.sn2.w_remote_GP.get - 1;
-
-	while (++get < put && atomic_read(&ch->n_to_notify) > 0) {
-
-		notify = &ch->sn.sn2.notify_queue[get % ch->local_nentries];
-
-		/*
-		 * See if the notify entry indicates it was associated with
-		 * a message who's sender wants to be notified. It is possible
-		 * that it is, but someone else is doing or has done the
-		 * notification.
-		 */
-		notify_type = notify->type;
-		if (notify_type == 0 ||
-		    cmpxchg(&notify->type, notify_type, 0) != notify_type) {
-			continue;
-		}
-
-		DBUG_ON(notify_type != XPC_N_CALL);
-
-		atomic_dec(&ch->n_to_notify);
-
-		if (notify->func != NULL) {
-			dev_dbg(xpc_chan, "notify->func() called, notify=0x%p "
-				"msg_number=%lld partid=%d channel=%d\n",
-				(void *)notify, get, ch->partid, ch->number);
-
-			notify->func(reason, ch->partid, ch->number,
-				     notify->key);
-
-			dev_dbg(xpc_chan, "notify->func() returned, notify=0x%p"
-				" msg_number=%lld partid=%d channel=%d\n",
-				(void *)notify, get, ch->partid, ch->number);
-		}
-	}
-}
-
-static void
-xpc_notify_senders_of_disconnect_sn2(struct xpc_channel *ch)
-{
-	xpc_notify_senders_sn2(ch, ch->reason, ch->sn.sn2.w_local_GP.put);
-}
-
-/*
- * Clear some of the msg flags in the local message queue.
- */
-static inline void
-xpc_clear_local_msgqueue_flags_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg;
-	s64 get;
-
-	get = ch_sn2->w_remote_GP.get;
-	do {
-		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->local_msgqueue +
-					     (get % ch->local_nentries) *
-					     ch->entry_size);
-		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
-		msg->flags = 0;
-	} while (++get < ch_sn2->remote_GP.get);
-}
-
-/*
- * Clear some of the msg flags in the remote message queue.
- */
-static inline void
-xpc_clear_remote_msgqueue_flags_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg;
-	s64 put, remote_nentries = ch->remote_nentries;
-
-	/* flags are zeroed when the buffer is allocated */
-	if (ch_sn2->remote_GP.put < remote_nentries)
-		return;
-
-	put = max(ch_sn2->w_remote_GP.put, remote_nentries);
-	do {
-		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
-					     (put % remote_nentries) *
-					     ch->entry_size);
-		DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
-		DBUG_ON(!(msg->flags & XPC_M_SN2_DONE));
-		DBUG_ON(msg->number != put - remote_nentries);
-		msg->flags = 0;
-	} while (++put < ch_sn2->remote_GP.put);
-}
-
-static int
-xpc_n_of_deliverable_payloads_sn2(struct xpc_channel *ch)
-{
-	return ch->sn.sn2.w_remote_GP.put - ch->sn.sn2.w_local_GP.get;
-}
-
-static void
-xpc_process_msg_chctl_flags_sn2(struct xpc_partition *part, int ch_number)
-{
-	struct xpc_channel *ch = &part->channels[ch_number];
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	int npayloads_sent;
-
-	ch_sn2->remote_GP = part->sn.sn2.remote_GPs[ch_number];
-
-	/* See what, if anything, has changed for each connected channel */
-
-	xpc_msgqueue_ref(ch);
-
-	if (ch_sn2->w_remote_GP.get == ch_sn2->remote_GP.get &&
-	    ch_sn2->w_remote_GP.put == ch_sn2->remote_GP.put) {
-		/* nothing changed since GPs were last pulled */
-		xpc_msgqueue_deref(ch);
-		return;
-	}
-
-	if (!(ch->flags & XPC_C_CONNECTED)) {
-		xpc_msgqueue_deref(ch);
-		return;
-	}
-
-	/*
-	 * First check to see if messages recently sent by us have been
-	 * received by the other side. (The remote GET value will have
-	 * changed since we last looked at it.)
-	 */
-
-	if (ch_sn2->w_remote_GP.get != ch_sn2->remote_GP.get) {
-
-		/*
-		 * We need to notify any senders that want to be notified
-		 * that their sent messages have been received by their
-		 * intended recipients. We need to do this before updating
-		 * w_remote_GP.get so that we don't allocate the same message
-		 * queue entries prematurely (see xpc_allocate_msg()).
-		 */
-		if (atomic_read(&ch->n_to_notify) > 0) {
-			/*
-			 * Notify senders that messages sent have been
-			 * received and delivered by the other side.
-			 */
-			xpc_notify_senders_sn2(ch, xpMsgDelivered,
-					       ch_sn2->remote_GP.get);
-		}
-
-		/*
-		 * Clear msg->flags in previously sent messages, so that
-		 * they're ready for xpc_allocate_msg().
-		 */
-		xpc_clear_local_msgqueue_flags_sn2(ch);
-
-		ch_sn2->w_remote_GP.get = ch_sn2->remote_GP.get;
-
-		dev_dbg(xpc_chan, "w_remote_GP.get changed to %lld, partid=%d, "
-			"channel=%d\n", ch_sn2->w_remote_GP.get, ch->partid,
-			ch->number);
-
-		/*
-		 * If anyone was waiting for message queue entries to become
-		 * available, wake them up.
-		 */
-		if (atomic_read(&ch->n_on_msg_allocate_wq) > 0)
-			wake_up(&ch->msg_allocate_wq);
-	}
-
-	/*
-	 * Now check for newly sent messages by the other side. (The remote
-	 * PUT value will have changed since we last looked at it.)
-	 */
-
-	if (ch_sn2->w_remote_GP.put != ch_sn2->remote_GP.put) {
-		/*
-		 * Clear msg->flags in previously received messages, so that
-		 * they're ready for xpc_get_deliverable_payload_sn2().
-		 */
-		xpc_clear_remote_msgqueue_flags_sn2(ch);
-
-		smp_wmb(); /* ensure flags have been cleared before bte_copy */
-		ch_sn2->w_remote_GP.put = ch_sn2->remote_GP.put;
-
-		dev_dbg(xpc_chan, "w_remote_GP.put changed to %lld, partid=%d, "
-			"channel=%d\n", ch_sn2->w_remote_GP.put, ch->partid,
-			ch->number);
-
-		npayloads_sent = xpc_n_of_deliverable_payloads_sn2(ch);
-		if (npayloads_sent > 0) {
-			dev_dbg(xpc_chan, "msgs waiting to be copied and "
-				"delivered=%d, partid=%d, channel=%d\n",
-				npayloads_sent, ch->partid, ch->number);
-
-			if (ch->flags & XPC_C_CONNECTEDCALLOUT_MADE)
-				xpc_activate_kthreads(ch, npayloads_sent);
-		}
-	}
-
-	xpc_msgqueue_deref(ch);
-}
-
-static struct xpc_msg_sn2 *
-xpc_pull_remote_msg_sn2(struct xpc_channel *ch, s64 get)
-{
-	struct xpc_partition *part = &xpc_partitions[ch->partid];
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	unsigned long remote_msg_pa;
-	struct xpc_msg_sn2 *msg;
-	u32 msg_index;
-	u32 nmsgs;
-	u64 msg_offset;
-	enum xp_retval ret;
-
-	if (mutex_lock_interruptible(&ch_sn2->msg_to_pull_mutex) != 0) {
-		/* we were interrupted by a signal */
-		return NULL;
-	}
-
-	while (get >= ch_sn2->next_msg_to_pull) {
-
-		/* pull as many messages as are ready and able to be pulled */
-
-		msg_index = ch_sn2->next_msg_to_pull % ch->remote_nentries;
-
-		DBUG_ON(ch_sn2->next_msg_to_pull >= ch_sn2->w_remote_GP.put);
-		nmsgs = ch_sn2->w_remote_GP.put - ch_sn2->next_msg_to_pull;
-		if (msg_index + nmsgs > ch->remote_nentries) {
-			/* ignore the ones that wrap the msg queue for now */
-			nmsgs = ch->remote_nentries - msg_index;
-		}
-
-		msg_offset = msg_index * ch->entry_size;
-		msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue +
-		    msg_offset);
-		remote_msg_pa = ch_sn2->remote_msgqueue_pa + msg_offset;
-
-		ret = xpc_pull_remote_cachelines_sn2(part, msg, remote_msg_pa,
-						     nmsgs * ch->entry_size);
-		if (ret != xpSuccess) {
-
-			dev_dbg(xpc_chan, "failed to pull %d msgs starting with"
-				" msg %lld from partition %d, channel=%d, "
-				"ret=%d\n", nmsgs, ch_sn2->next_msg_to_pull,
-				ch->partid, ch->number, ret);
-
-			XPC_DEACTIVATE_PARTITION(part, ret);
-
-			mutex_unlock(&ch_sn2->msg_to_pull_mutex);
-			return NULL;
-		}
-
-		ch_sn2->next_msg_to_pull += nmsgs;
-	}
-
-	mutex_unlock(&ch_sn2->msg_to_pull_mutex);
-
-	/* return the message we were looking for */
-	msg_offset = (get % ch->remote_nentries) * ch->entry_size;
-	msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->remote_msgqueue + msg_offset);
-
-	return msg;
-}
-
-/*
- * Get the next deliverable message's payload.
- */
-static void *
-xpc_get_deliverable_payload_sn2(struct xpc_channel *ch)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg;
-	void *payload = NULL;
-	s64 get;
-
-	do {
-		if (ch->flags & XPC_C_DISCONNECTING)
-			break;
-
-		get = ch_sn2->w_local_GP.get;
-		smp_rmb();	/* guarantee that .get loads before .put */
-		if (get == ch_sn2->w_remote_GP.put)
-			break;
-
-		/* There are messages waiting to be pulled and delivered.
-		 * We need to try to secure one for ourselves. We'll do this
-		 * by trying to increment w_local_GP.get and hope that no one
-		 * else beats us to it. If they do, we'll we'll simply have
-		 * to try again for the next one.
-		 */
-
-		if (cmpxchg(&ch_sn2->w_local_GP.get, get, get + 1) == get) {
-			/* we got the entry referenced by get */
-
-			dev_dbg(xpc_chan, "w_local_GP.get changed to %lld, "
-				"partid=%d, channel=%d\n", get + 1,
-				ch->partid, ch->number);
-
-			/* pull the message from the remote partition */
-
-			msg = xpc_pull_remote_msg_sn2(ch, get);
-
-			if (msg != NULL) {
-				DBUG_ON(msg->number != get);
-				DBUG_ON(msg->flags & XPC_M_SN2_DONE);
-				DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
-
-				payload = &msg->payload;
-			}
-			break;
-		}
-
-	} while (1);
-
-	return payload;
-}
-
-/*
- * Now we actually send the messages that are ready to be sent by advancing
- * the local message queue's Put value and then send a chctl msgrequest to the
- * recipient partition.
- */
-static void
-xpc_send_msgs_sn2(struct xpc_channel *ch, s64 initial_put)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg;
-	s64 put = initial_put + 1;
-	int send_msgrequest = 0;
-
-	while (1) {
-
-		while (1) {
-			if (put == ch_sn2->w_local_GP.put)
-				break;
-
-			msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->
-						     local_msgqueue + (put %
-						     ch->local_nentries) *
-						     ch->entry_size);
-
-			if (!(msg->flags & XPC_M_SN2_READY))
-				break;
-
-			put++;
-		}
-
-		if (put == initial_put) {
-			/* nothing's changed */
-			break;
-		}
-
-		if (cmpxchg_rel(&ch_sn2->local_GP->put, initial_put, put) !=
-		    initial_put) {
-			/* someone else beat us to it */
-			DBUG_ON(ch_sn2->local_GP->put < initial_put);
-			break;
-		}
-
-		/* we just set the new value of local_GP->put */
-
-		dev_dbg(xpc_chan, "local_GP->put changed to %lld, partid=%d, "
-			"channel=%d\n", put, ch->partid, ch->number);
-
-		send_msgrequest = 1;
-
-		/*
-		 * We need to ensure that the message referenced by
-		 * local_GP->put is not XPC_M_SN2_READY or that local_GP->put
-		 * equals w_local_GP.put, so we'll go have a look.
-		 */
-		initial_put = put;
-	}
-
-	if (send_msgrequest)
-		xpc_send_chctl_msgrequest_sn2(ch);
-}
-
-/*
- * Allocate an entry for a message from the message queue associated with the
- * specified channel.
- */
-static enum xp_retval
-xpc_allocate_msg_sn2(struct xpc_channel *ch, u32 flags,
-		     struct xpc_msg_sn2 **address_of_msg)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg;
-	enum xp_retval ret;
-	s64 put;
-
-	/*
-	 * Get the next available message entry from the local message queue.
-	 * If none are available, we'll make sure that we grab the latest
-	 * GP values.
-	 */
-	ret = xpTimeout;
-
-	while (1) {
-
-		put = ch_sn2->w_local_GP.put;
-		smp_rmb();	/* guarantee that .put loads before .get */
-		if (put - ch_sn2->w_remote_GP.get < ch->local_nentries) {
-
-			/* There are available message entries. We need to try
-			 * to secure one for ourselves. We'll do this by trying
-			 * to increment w_local_GP.put as long as someone else
-			 * doesn't beat us to it. If they do, we'll have to
-			 * try again.
-			 */
-			if (cmpxchg(&ch_sn2->w_local_GP.put, put, put + 1) ==
-			    put) {
-				/* we got the entry referenced by put */
-				break;
-			}
-			continue;	/* try again */
-		}
-
-		/*
-		 * There aren't any available msg entries at this time.
-		 *
-		 * In waiting for a message entry to become available,
-		 * we set a timeout in case the other side is not sending
-		 * completion interrupts. This lets us fake a notify IRQ
-		 * that will cause the notify IRQ handler to fetch the latest
-		 * GP values as if an interrupt was sent by the other side.
-		 */
-		if (ret == xpTimeout)
-			xpc_send_chctl_local_msgrequest_sn2(ch);
-
-		if (flags & XPC_NOWAIT)
-			return xpNoWait;
-
-		ret = xpc_allocate_msg_wait(ch);
-		if (ret != xpInterrupted && ret != xpTimeout)
-			return ret;
-	}
-
-	/* get the message's address and initialize it */
-	msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->local_msgqueue +
-				     (put % ch->local_nentries) *
-				     ch->entry_size);
-
-	DBUG_ON(msg->flags != 0);
-	msg->number = put;
-
-	dev_dbg(xpc_chan, "w_local_GP.put changed to %lld; msg=0x%p, "
-		"msg_number=%lld, partid=%d, channel=%d\n", put + 1,
-		(void *)msg, msg->number, ch->partid, ch->number);
-
-	*address_of_msg = msg;
-	return xpSuccess;
-}
-
-/*
- * Common code that does the actual sending of the message by advancing the
- * local message queue's Put value and sends a chctl msgrequest to the
- * partition the message is being sent to.
- */
-static enum xp_retval
-xpc_send_payload_sn2(struct xpc_channel *ch, u32 flags, void *payload,
-		     u16 payload_size, u8 notify_type, xpc_notify_func func,
-		     void *key)
-{
-	enum xp_retval ret = xpSuccess;
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg = msg;
-	struct xpc_notify_sn2 *notify = notify;
-	s64 msg_number;
-	s64 put;
-
-	DBUG_ON(notify_type == XPC_N_CALL && func == NULL);
-
-	if (XPC_MSG_SIZE(payload_size) > ch->entry_size)
-		return xpPayloadTooBig;
-
-	xpc_msgqueue_ref(ch);
-
-	if (ch->flags & XPC_C_DISCONNECTING) {
-		ret = ch->reason;
-		goto out_1;
-	}
-	if (!(ch->flags & XPC_C_CONNECTED)) {
-		ret = xpNotConnected;
-		goto out_1;
-	}
-
-	ret = xpc_allocate_msg_sn2(ch, flags, &msg);
-	if (ret != xpSuccess)
-		goto out_1;
-
-	msg_number = msg->number;
-
-	if (notify_type != 0) {
-		/*
-		 * Tell the remote side to send an ACK interrupt when the
-		 * message has been delivered.
-		 */
-		msg->flags |= XPC_M_SN2_INTERRUPT;
-
-		atomic_inc(&ch->n_to_notify);
-
-		notify = &ch_sn2->notify_queue[msg_number % ch->local_nentries];
-		notify->func = func;
-		notify->key = key;
-		notify->type = notify_type;
-
-		/* ??? Is a mb() needed here? */
-
-		if (ch->flags & XPC_C_DISCONNECTING) {
-			/*
-			 * An error occurred between our last error check and
-			 * this one. We will try to clear the type field from
-			 * the notify entry. If we succeed then
-			 * xpc_disconnect_channel() didn't already process
-			 * the notify entry.
-			 */
-			if (cmpxchg(&notify->type, notify_type, 0) ==
-			    notify_type) {
-				atomic_dec(&ch->n_to_notify);
-				ret = ch->reason;
-			}
-			goto out_1;
-		}
-	}
-
-	memcpy(&msg->payload, payload, payload_size);
-
-	msg->flags |= XPC_M_SN2_READY;
-
-	/*
-	 * The preceding store of msg->flags must occur before the following
-	 * load of local_GP->put.
-	 */
-	smp_mb();
-
-	/* see if the message is next in line to be sent, if so send it */
-
-	put = ch_sn2->local_GP->put;
-	if (put == msg_number)
-		xpc_send_msgs_sn2(ch, put);
-
-out_1:
-	xpc_msgqueue_deref(ch);
-	return ret;
-}
-
-/*
- * Now we actually acknowledge the messages that have been delivered and ack'd
- * by advancing the cached remote message queue's Get value and if requested
- * send a chctl msgrequest to the message sender's partition.
- *
- * If a message has XPC_M_SN2_INTERRUPT set, send an interrupt to the partition
- * that sent the message.
- */
-static void
-xpc_acknowledge_msgs_sn2(struct xpc_channel *ch, s64 initial_get, u8 msg_flags)
-{
-	struct xpc_channel_sn2 *ch_sn2 = &ch->sn.sn2;
-	struct xpc_msg_sn2 *msg;
-	s64 get = initial_get + 1;
-	int send_msgrequest = 0;
-
-	while (1) {
-
-		while (1) {
-			if (get == ch_sn2->w_local_GP.get)
-				break;
-
-			msg = (struct xpc_msg_sn2 *)((u64)ch_sn2->
-						     remote_msgqueue + (get %
-						     ch->remote_nentries) *
-						     ch->entry_size);
-
-			if (!(msg->flags & XPC_M_SN2_DONE))
-				break;
-
-			msg_flags |= msg->flags;
-			get++;
-		}
-
-		if (get == initial_get) {
-			/* nothing's changed */
-			break;
-		}
-
-		if (cmpxchg_rel(&ch_sn2->local_GP->get, initial_get, get) !=
-		    initial_get) {
-			/* someone else beat us to it */
-			DBUG_ON(ch_sn2->local_GP->get <= initial_get);
-			break;
-		}
-
-		/* we just set the new value of local_GP->get */
-
-		dev_dbg(xpc_chan, "local_GP->get changed to %lld, partid=%d, "
-			"channel=%d\n", get, ch->partid, ch->number);
-
-		send_msgrequest = (msg_flags & XPC_M_SN2_INTERRUPT);
-
-		/*
-		 * We need to ensure that the message referenced by
-		 * local_GP->get is not XPC_M_SN2_DONE or that local_GP->get
-		 * equals w_local_GP.get, so we'll go have a look.
-		 */
-		initial_get = get;
-	}
-
-	if (send_msgrequest)
-		xpc_send_chctl_msgrequest_sn2(ch);
-}
-
-static void
-xpc_received_payload_sn2(struct xpc_channel *ch, void *payload)
-{
-	struct xpc_msg_sn2 *msg;
-	s64 msg_number;
-	s64 get;
-
-	msg = container_of(payload, struct xpc_msg_sn2, payload);
-	msg_number = msg->number;
-
-	dev_dbg(xpc_chan, "msg=0x%p, msg_number=%lld, partid=%d, channel=%d\n",
-		(void *)msg, msg_number, ch->partid, ch->number);
-
-	DBUG_ON((((u64)msg - (u64)ch->sn.sn2.remote_msgqueue) / ch->entry_size) !=
-		msg_number % ch->remote_nentries);
-	DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
-	DBUG_ON(msg->flags & XPC_M_SN2_DONE);
-
-	msg->flags |= XPC_M_SN2_DONE;
-
-	/*
-	 * The preceding store of msg->flags must occur before the following
-	 * load of local_GP->get.
-	 */
-	smp_mb();
-
-	/*
-	 * See if this message is next in line to be acknowledged as having
-	 * been delivered.
-	 */
-	get = ch->sn.sn2.local_GP->get;
-	if (get == msg_number)
-		xpc_acknowledge_msgs_sn2(ch, get, msg->flags);
-}
-
-static struct xpc_arch_operations xpc_arch_ops_sn2 = {
-	.setup_partitions = xpc_setup_partitions_sn2,
-	.teardown_partitions = xpc_teardown_partitions_sn2,
-	.process_activate_IRQ_rcvd = xpc_process_activate_IRQ_rcvd_sn2,
-	.get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2,
-	.setup_rsvd_page = xpc_setup_rsvd_page_sn2,
-
-	.allow_hb = xpc_allow_hb_sn2,
-	.disallow_hb = xpc_disallow_hb_sn2,
-	.disallow_all_hbs = xpc_disallow_all_hbs_sn2,
-	.increment_heartbeat = xpc_increment_heartbeat_sn2,
-	.offline_heartbeat = xpc_offline_heartbeat_sn2,
-	.online_heartbeat = xpc_online_heartbeat_sn2,
-	.heartbeat_init = xpc_heartbeat_init_sn2,
-	.heartbeat_exit = xpc_heartbeat_exit_sn2,
-	.get_remote_heartbeat = xpc_get_remote_heartbeat_sn2,
-
-	.request_partition_activation =
-		xpc_request_partition_activation_sn2,
-	.request_partition_reactivation =
-		xpc_request_partition_reactivation_sn2,
-	.request_partition_deactivation =
-		xpc_request_partition_deactivation_sn2,
-	.cancel_partition_deactivation_request =
-		xpc_cancel_partition_deactivation_request_sn2,
-
-	.setup_ch_structures = xpc_setup_ch_structures_sn2,
-	.teardown_ch_structures = xpc_teardown_ch_structures_sn2,
-
-	.make_first_contact = xpc_make_first_contact_sn2,
-
-	.get_chctl_all_flags = xpc_get_chctl_all_flags_sn2,
-	.send_chctl_closerequest = xpc_send_chctl_closerequest_sn2,
-	.send_chctl_closereply = xpc_send_chctl_closereply_sn2,
-	.send_chctl_openrequest = xpc_send_chctl_openrequest_sn2,
-	.send_chctl_openreply = xpc_send_chctl_openreply_sn2,
-	.send_chctl_opencomplete = xpc_send_chctl_opencomplete_sn2,
-	.process_msg_chctl_flags = xpc_process_msg_chctl_flags_sn2,
-
-	.save_remote_msgqueue_pa = xpc_save_remote_msgqueue_pa_sn2,
-
-	.setup_msg_structures = xpc_setup_msg_structures_sn2,
-	.teardown_msg_structures = xpc_teardown_msg_structures_sn2,
-
-	.indicate_partition_engaged = xpc_indicate_partition_engaged_sn2,
-	.indicate_partition_disengaged = xpc_indicate_partition_disengaged_sn2,
-	.partition_engaged = xpc_partition_engaged_sn2,
-	.any_partition_engaged = xpc_any_partition_engaged_sn2,
-	.assume_partition_disengaged = xpc_assume_partition_disengaged_sn2,
-
-	.n_of_deliverable_payloads = xpc_n_of_deliverable_payloads_sn2,
-	.send_payload = xpc_send_payload_sn2,
-	.get_deliverable_payload = xpc_get_deliverable_payload_sn2,
-	.received_payload = xpc_received_payload_sn2,
-	.notify_senders_of_disconnect = xpc_notify_senders_of_disconnect_sn2,
-};
-
-int
-xpc_init_sn2(void)
-{
-	int ret;
-	size_t buf_size;
-
-	xpc_arch_ops = xpc_arch_ops_sn2;
-
-	if (offsetof(struct xpc_msg_sn2, payload) > XPC_MSG_HDR_MAX_SIZE) {
-		dev_err(xpc_part, "header portion of struct xpc_msg_sn2 is "
-			"larger than %d\n", XPC_MSG_HDR_MAX_SIZE);
-		return -E2BIG;
-	}
-
-	buf_size = max(XPC_RP_VARS_SIZE,
-		       XPC_RP_HEADER_SIZE + XP_NASID_MASK_BYTES_SN2);
-	xpc_remote_copy_buffer_sn2 = xpc_kmalloc_cacheline_aligned(buf_size,
-								   GFP_KERNEL,
-					      &xpc_remote_copy_buffer_base_sn2);
-	if (xpc_remote_copy_buffer_sn2 == NULL) {
-		dev_err(xpc_part, "can't get memory for remote copy buffer\n");
-		return -ENOMEM;
-	}
-
-	/* open up protections for IPI and [potentially] amo operations */
-	xpc_allow_IPI_ops_sn2();
-	xpc_allow_amo_ops_shub_wars_1_1_sn2();
-
-	/*
-	 * This is safe to do before the xpc_hb_checker thread has started
-	 * because the handler releases a wait queue.  If an interrupt is
-	 * received before the thread is waiting, it will not go to sleep,
-	 * but rather immediately process the interrupt.
-	 */
-	ret = request_irq(SGI_XPC_ACTIVATE, xpc_handle_activate_IRQ_sn2, 0,
-			  "xpc hb", NULL);
-	if (ret != 0) {
-		dev_err(xpc_part, "can't register ACTIVATE IRQ handler, "
-			"errno=%d\n", -ret);
-		xpc_disallow_IPI_ops_sn2();
-		kfree(xpc_remote_copy_buffer_base_sn2);
-	}
-	return ret;
-}
-
-void
-xpc_exit_sn2(void)
-{
-	free_irq(SGI_XPC_ACTIVATE, NULL);
-	xpc_disallow_IPI_ops_sn2();
-	kfree(xpc_remote_copy_buffer_base_sn2);
-}
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 0c6de97dd347..d8a6fe16e4f5 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -48,6 +48,8 @@ struct uv_IO_APIC_route_entry {
 		__reserved_2	: 15,
 		dest		: 32;
 };
+
+#define sn_partition_id 0
 #endif
 
 static struct xpc_heartbeat_uv *xpc_heartbeat_uv;
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 44d750d98bc8..f7d610a22347 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -515,7 +515,7 @@ xpnet_init(void)
 {
 	int result;
 
-	if (!is_shub() && !is_uv())
+	if (!is_uv())
 		return -ENODEV;
 
 	dev_info(xpnet, "registering network device %s\n", XPNET_DEVICE_NAME);
-- 
2.20.1

