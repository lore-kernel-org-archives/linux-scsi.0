Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D54EC32753
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 249DD20578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nzLOAjHE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfHMH0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+VDeQ25tgP8Lmr5cr3R/SYIemYERT1zBq6ZiCKZF+5Y=; b=nzLOAjHEZTWY0LOay3myIQu7kd
        3km6E9YUfqwSgQd8ly2qKJg+QZPE2+X5Vkrk0ZBMKRfGJcEOldD/q4Y4RtsYSO5Wk4aZmoMiR25G6
        Wj4O6TcEMZ23EG9XwXzT65HNesqXFjEXqBPWqpim98TokAQgQ9yz5XFRtcI4emynQY9xbtoHArV6h
        SMtaLXS4U+P+w3pv9i9r0q6z6uIOnkel6Tu4IH+aGNib0SVnpis+xkHrbQwJiOhJSWAHT17Yk2zRO
        IDPz/LJda0N0Rjb78lQMGIC5SvehfVGw6D8u3XRMWAzhk2j/olCkILrpigButiIHkfGq/moXFnwNc
        AqIVezYg==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCH-0006h3-Sb; Tue, 13 Aug 2019 07:26:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/28] ia64: remove CONFIG_ACPI ifdefs
Date:   Tue, 13 Aug 2019 09:25:05 +0200
Message-Id: <20190813072514.23299-20-hch@lst.de>
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

Now that hpsim support is gone, CONFIG_ACPI is forced on for ia64, and
we can remove a few ifdefs for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/include/asm/acpi.h |  4 ++--
 arch/ia64/kernel/Makefile    |  4 ++--
 arch/ia64/kernel/iosapic.c   |  2 --
 arch/ia64/kernel/irq_ia64.c  |  2 --
 arch/ia64/kernel/mca.c       | 18 ------------------
 arch/ia64/kernel/setup.c     | 10 ++++------
 arch/ia64/kernel/topology.c  |  4 ----
 7 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index 0afb3bc4b4a1..01c1c269aa13 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -17,7 +17,7 @@
 #include <linux/numa.h>
 #include <asm/numa.h>
 
-#ifdef	CONFIG_ACPI
+
 extern int acpi_lapic;
 #define acpi_disabled 0	/* ACPI always enabled on IA64 */
 #define acpi_noirq 0	/* ACPI always enabled on IA64 */
@@ -28,7 +28,7 @@ static inline bool acpi_has_cpu_in_madt(void)
 {
 	return !!acpi_lapic;
 }
-#endif
+
 #define acpi_processor_cstate_check(x) (x) /* no idle limits on IA64 :) */
 static inline void disable_acpi(void) { }
 
diff --git a/arch/ia64/kernel/Makefile b/arch/ia64/kernel/Makefile
index 3ada440ff893..dbde36702cf2 100644
--- a/arch/ia64/kernel/Makefile
+++ b/arch/ia64/kernel/Makefile
@@ -12,9 +12,9 @@ extra-y	:= head.o vmlinux.lds
 obj-y := entry.o efi.o efi_stub.o gate-data.o fsys.o ia64_ksyms.o irq.o irq_ia64.o	\
 	 irq_lsapic.o ivt.o machvec.o pal.o patch.o process.o perfmon.o ptrace.o sal.o		\
 	 salinfo.o setup.o signal.o sys_ia64.o time.o traps.o unaligned.o \
-	 unwind.o mca.o mca_asm.o topology.o dma-mapping.o iosapic.o
+	 unwind.o mca.o mca_asm.o topology.o dma-mapping.o iosapic.o acpi.o \
+	 acpi-ext.o
 
-obj-$(CONFIG_ACPI)		+= acpi.o acpi-ext.o
 obj-$(CONFIG_IA64_BRL_EMU)	+= brl_emu.o
 
 obj-$(CONFIG_IA64_PALINFO)	+= palinfo.o
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 9e49fd006859..2d25958a7ed7 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -643,10 +643,8 @@ get_target_cpu (unsigned int gsi, int irq)
 	if (!cpu_online(smp_processor_id()))
 		return cpu_physical_id(smp_processor_id());
 
-#ifdef CONFIG_ACPI
 	if (cpe_vector > 0 && irq_to_vector(irq) == IA64_CPEP_VECTOR)
 		return get_cpei_target_cpu();
-#endif
 
 #ifdef CONFIG_NUMA
 	{
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index e3874734b149..b989731bbeac 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -633,9 +633,7 @@ ia64_native_register_ipi(void)
 void __init
 init_IRQ (void)
 {
-#ifdef CONFIG_ACPI
 	acpi_boot_init();
-#endif
 	ia64_register_ipi();
 	register_percpu_irq(IA64_SPURIOUS_INT_VECTOR, NULL);
 #ifdef CONFIG_SMP
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index f72b05fe918b..a7f05883935b 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -149,9 +149,7 @@ static ia64_mc_info_t		ia64_mc_info;
 #define CPE_HISTORY_LENGTH    5
 #define CMC_HISTORY_LENGTH    5
 
-#ifdef CONFIG_ACPI
 static struct timer_list cpe_poll_timer;
-#endif
 static struct timer_list cmc_poll_timer;
 /*
  * This variable tells whether we are currently in polling mode.
@@ -532,8 +530,6 @@ int mca_recover_range(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(mca_recover_range);
 
-#ifdef CONFIG_ACPI
-
 int cpe_vector = -1;
 int ia64_cpe_irq = -1;
 
@@ -595,9 +591,6 @@ ia64_mca_cpe_int_handler (int cpe_irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-#endif /* CONFIG_ACPI */
-
-#ifdef CONFIG_ACPI
 /*
  * ia64_mca_register_cpev
  *
@@ -625,7 +618,6 @@ ia64_mca_register_cpev (int cpev)
 	IA64_MCA_DEBUG("%s: corrected platform error "
 		       "vector %#x registered\n", __func__, cpev);
 }
-#endif /* CONFIG_ACPI */
 
 /*
  * ia64_mca_cmc_vector_setup
@@ -1540,8 +1532,6 @@ ia64_mca_cmc_poll (struct timer_list *unused)
  * Outputs
  * 	handled
  */
-#ifdef CONFIG_ACPI
-
 static irqreturn_t
 ia64_mca_cpe_int_caller(int cpe_irq, void *arg)
 {
@@ -1604,8 +1594,6 @@ ia64_mca_cpe_poll (struct timer_list *unused)
 							IA64_IPI_DM_INT, 0);
 }
 
-#endif /* CONFIG_ACPI */
-
 static int
 default_monarch_init_process(struct notifier_block *self, unsigned long val, void *data)
 {
@@ -1799,7 +1787,6 @@ static struct irqaction mca_wkup_irqaction = {
 	.name =		"mca_wkup"
 };
 
-#ifdef CONFIG_ACPI
 static struct irqaction mca_cpe_irqaction = {
 	.handler =	ia64_mca_cpe_int_handler,
 	.name =		"cpe_hndlr"
@@ -1809,7 +1796,6 @@ static struct irqaction mca_cpep_irqaction = {
 	.handler =	ia64_mca_cpe_int_caller,
 	.name =		"cpe_poll"
 };
-#endif /* CONFIG_ACPI */
 
 /* Minimal format of the MCA/INIT stacks.  The pseudo processes that run on
  * these stacks can never sleep, they cannot return from the kernel to user
@@ -2081,10 +2067,8 @@ void __init ia64_mca_irq_init(void)
 	/* Setup the MCA wakeup interrupt vector */
 	register_percpu_irq(IA64_MCA_WAKEUP_VECTOR, &mca_wkup_irqaction);
 
-#ifdef CONFIG_ACPI
 	/* Setup the CPEI/P handler */
 	register_percpu_irq(IA64_CPEP_VECTOR, &mca_cpep_irqaction);
-#endif
 }
 
 /*
@@ -2112,7 +2096,6 @@ ia64_mca_late_init(void)
 			  ia64_mca_cpu_online, NULL);
 	IA64_MCA_DEBUG("%s: CMCI/P setup and enabled.\n", __func__);
 
-#ifdef CONFIG_ACPI
 	/* Setup the CPEI/P vector and handler */
 	cpe_vector = acpi_request_vector(ACPI_INTERRUPT_CPEI);
 	timer_setup(&cpe_poll_timer, ia64_mca_cpe_poll, 0);
@@ -2143,7 +2126,6 @@ ia64_mca_late_init(void)
 			IA64_MCA_DEBUG("%s: CPEP setup and enabled.\n", __func__);
 		}
 	}
-#endif
 
 	return 0;
 }
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 42ef03ce2fd4..8d47836d932c 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -537,21 +537,19 @@ setup_arch (char **cmdline_p)
 	if (early_console_setup(*cmdline_p) == 0)
 		mark_bsp_online();
 
-#ifdef CONFIG_ACPI
 	/* Initialize the ACPI boot-time table parser */
 	acpi_table_init();
 	early_acpi_boot_init();
-# ifdef CONFIG_ACPI_NUMA
+#ifdef CONFIG_ACPI_NUMA
 	acpi_numa_init();
 	acpi_numa_fixup();
-#  ifdef CONFIG_ACPI_HOTPLUG_CPU
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
 	prefill_possible_map();
-#  endif
+#endif
 	per_cpu_scan_finalize((cpumask_weight(&early_cpu_possible_map) == 0 ?
 		32 : cpumask_weight(&early_cpu_possible_map)),
 		additional_cpus > 0 ? additional_cpus : 0);
-# endif
-#endif /* CONFIG_APCI_BOOT */
+#endif /* CONFIG_ACPI_NUMA */
 
 #ifdef CONFIG_SMP
 	smp_build_cpu_map();
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index e311ee13e61d..09fc385c2acd 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -42,7 +42,6 @@ EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);
 #ifdef CONFIG_HOTPLUG_CPU
 int __ref arch_register_cpu(int num)
 {
-#ifdef CONFIG_ACPI
 	/*
 	 * If CPEI can be re-targeted or if this is not
 	 * CPEI target, then it is hotpluggable
@@ -50,7 +49,6 @@ int __ref arch_register_cpu(int num)
 	if (can_cpei_retarget() || !is_cpu_cpei_target(num))
 		sysfs_cpus[num].cpu.hotpluggable = 1;
 	map_cpu_to_node(num, node_cpuid[num].nid);
-#endif
 	return register_cpu(&sysfs_cpus[num].cpu, num);
 }
 EXPORT_SYMBOL(arch_register_cpu);
@@ -58,9 +56,7 @@ EXPORT_SYMBOL(arch_register_cpu);
 void __ref arch_unregister_cpu(int num)
 {
 	unregister_cpu(&sysfs_cpus[num].cpu);
-#ifdef CONFIG_ACPI
 	unmap_cpu_from_node(num, cpu_to_node(num));
-#endif
 }
 EXPORT_SYMBOL(arch_unregister_cpu);
 #else
-- 
2.20.1

