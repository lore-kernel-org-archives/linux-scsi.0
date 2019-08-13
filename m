Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80F0C32753
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9915120578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A31uV9Um"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfHMH0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jZpUDmTOUfjlabnlELyDHxkM2xeqc2FxDEcnqQJbBsM=; b=A31uV9UmE8sqa7Q9RbfDz/j/Me
        YDTBRwbAfPGKKFP7N8JpJELj2sgviIRnoOx559HG45pLDtS2WUJTwJRInH7XACCEKSgUusz3Z68TF
        N3JvSuR7DZ4FlYv9JkFiQw4/u25g7pL52pOnvo+P9fqW5kfJw6aRqtI/vjEMBYDU3kOGzjZge1vkL
        g4wpE1gqMButrZrN/EROO2BsS4xqSWV5DKv6k2QiV+L1tlYSUpHMAReoI+qrtYIWeOpnN+i+kagdP
        nHyouR9wnPyXhLoLnv70/f7Fzi8P8dUZtIqfAblZR3SYaPbHAujIXox6+Q5Vir5ZQv4+Q1lvZ3li1
        Vc0mljuA==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCO-0006oz-As; Tue, 13 Aug 2019 07:26:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/28] ia64: remove the SGI UV simulator support
Date:   Tue, 13 Aug 2019 09:25:07 +0200
Message-Id: <20190813072514.23299-22-hch@lst.de>
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

The simulator support was marked as temporary since the initial commit,
so drop it more than 10 years later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/include/asm/sn/simulator.h | 25 ----------------------
 arch/ia64/include/asm/sn/sn_sal.h    | 10 ---------
 arch/ia64/include/asm/uv/uv.h        |  4 +---
 arch/ia64/uv/kernel/setup.c          | 31 +++++-----------------------
 4 files changed, 6 insertions(+), 64 deletions(-)
 delete mode 100644 arch/ia64/include/asm/sn/simulator.h

diff --git a/arch/ia64/include/asm/sn/simulator.h b/arch/ia64/include/asm/sn/simulator.h
deleted file mode 100644
index 3e4557df3b7c..000000000000
--- a/arch/ia64/include/asm/sn/simulator.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- * Copyright (C) 2000-2004 Silicon Graphics, Inc. All rights reserved.
- */
-
-#ifndef _ASM_IA64_SN_SIMULATOR_H
-#define _ASM_IA64_SN_SIMULATOR_H
-
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_UV)
-#define SNMAGIC 0xaeeeeeee8badbeefL
-#define IS_MEDUSA()			({long sn; asm("mov %0=cpuid[%1]" : "=r"(sn) : "r"(2)); sn == SNMAGIC;})
-
-#define SIMULATOR_SLEEP()		asm("nop.i 0x8beef")
-#define IS_RUNNING_ON_SIMULATOR()	(sn_prom_type)
-#define IS_RUNNING_ON_FAKE_PROM()	(sn_prom_type == 2)
-extern int sn_prom_type;		/* 0=hardware, 1=medusa/realprom, 2=medusa/fakeprom */
-#else
-#define IS_MEDUSA()			0
-#define SIMULATOR_SLEEP()
-#define IS_RUNNING_ON_SIMULATOR()	0
-#endif
-
-#endif /* _ASM_IA64_SN_SIMULATOR_H */
diff --git a/arch/ia64/include/asm/sn/sn_sal.h b/arch/ia64/include/asm/sn/sn_sal.h
index 48b88d0807db..d437aa43343b 100644
--- a/arch/ia64/include/asm/sn/sn_sal.h
+++ b/arch/ia64/include/asm/sn/sn_sal.h
@@ -30,8 +30,6 @@
 #define SALRET_INVALID_ARG	(-2)
 #define SALRET_ERROR		(-3)
 
-#define SN_SAL_FAKE_PROM			   0x02009999
-
 /*
  * Returns the physical address of the partition's reserved page through
  * an iterative number of calls.
@@ -81,14 +79,6 @@ sn_change_memprotect(u64 paddr, u64 len, u64 perms, u64 *nasid_array)
 #define SN_MEMPROT_ACCESS_CLASS_6		0x084080
 #define SN_MEMPROT_ACCESS_CLASS_7		0x021080
 
-static inline int
-ia64_sn_is_fake_prom(void)
-{
-	struct ia64_sal_retval rv;
-	SAL_CALL_NOLOCK(rv, SN_SAL_FAKE_PROM, 0, 0, 0, 0, 0, 0, 0);
-	return (rv.status == 0);
-}
-
 union sn_watchlist_u {
 	u64     val;
 	struct {
diff --git a/arch/ia64/include/asm/uv/uv.h b/arch/ia64/include/asm/uv/uv.h
index 71df93ee3bc0..502cf1c56369 100644
--- a/arch/ia64/include/asm/uv/uv.h
+++ b/arch/ia64/include/asm/uv/uv.h
@@ -2,12 +2,10 @@
 #ifndef _ASM_IA64_UV_UV_H
 #define _ASM_IA64_UV_UV_H
 
-#include <asm/sn/simulator.h>
-
 static inline int is_uv_system(void)
 {
 	/* temporary support for running on hardware simulator */
-	return IS_MEDUSA() || ia64_platform_is("uv");
+	return ia64_platform_is("uv");
 }
 
 #endif	/* _ASM_IA64_UV_UV_H */
diff --git a/arch/ia64/uv/kernel/setup.c b/arch/ia64/uv/kernel/setup.c
index 11478d2d863d..6ac4bd314d92 100644
--- a/arch/ia64/uv/kernel/setup.c
+++ b/arch/ia64/uv/kernel/setup.c
@@ -10,14 +10,12 @@
 
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <asm/sn/simulator.h>
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
 
 DEFINE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 EXPORT_PER_CPU_SYMBOL_GPL(__uv_hub_info);
 
-int sn_prom_type;
 long sn_coherency_id;
 EXPORT_SYMBOL_GPL(sn_coherency_id);
 
@@ -60,30 +58,11 @@ void __init uv_setup(char **cmdline_p)
 	int nid, cpu, m_val, n_val;
 	unsigned long mmr_base, lowmem_redir_base, lowmem_redir_size;
 
-	if (IS_MEDUSA()) {
-		lowmem_redir_base = 0;
-		lowmem_redir_size = 0;
-		node_id.v = 0;
-		m_n_config.s.m_skt = 37;
-		m_n_config.s.n_skt = 0;
-		mmr_base = 0;
-#if 0
-		/* Need BIOS calls - TDB */
-		if (!ia64_sn_is_fake_prom())
-			sn_prom_type = 1;
-		else
-#endif
-			sn_prom_type = 2;
-		printk(KERN_INFO "Running on medusa with %s PROM\n",
-					(sn_prom_type == 1) ? "real" : "fake");
-	} else {
-		get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
-		node_id.v = uv_read_local_mmr(UVH_NODE_ID);
-		m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
-		mmr_base =
-			uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
-				~UV_MMR_ENABLE;
-	}
+	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
+	node_id.v = uv_read_local_mmr(UVH_NODE_ID);
+	m_n_config.v = uv_read_local_mmr(UVH_SI_ADDR_MAP_CONFIG);
+	mmr_base = uv_read_local_mmr(UVH_RH_GAM_MMR_OVERLAY_CONFIG_MMR) &
+			~UV_MMR_ENABLE;
 
 	m_val = m_n_config.s.m_skt;
 	n_val = m_n_config.s.n_skt;
-- 
2.20.1

