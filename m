From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: [PATCH] ATA convert GSI to irq on ia64
Date: Thu, 08 Feb 2007 15:40:22 +0800
Message-ID: <1170920422.15989.354.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:48160 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422950AbXBHHkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 02:40:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
fixed irq number. On ia64 platform, such numbers are GSI and should be converted
to irq vector.

Below patch against kernel 2.6.20 fixes it.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

diff -Nraup linux-2.6.20/include/asm-generic/libata-portmap.h linux-2.6.20_fix/include/asm-generic/libata-portmap.h
--- linux-2.6.20/include/asm-generic/libata-portmap.h	2007-02-08 15:13:44.000000000 +0800
+++ linux-2.6.20_fix/include/asm-generic/libata-portmap.h	2007-02-08 15:20:13.000000000 +0800
@@ -3,10 +3,20 @@
 
 #define ATA_PRIMARY_CMD		0x1F0
 #define ATA_PRIMARY_CTL		0x3F6
+#if defined(__ia64__)
+#define ATA_PRIMARY_IRQ(dev)	isa_irq_to_vector(14)
+#else
 #define ATA_PRIMARY_IRQ(dev)	14
+#endif
+
 
 #define ATA_SECONDARY_CMD	0x170
 #define ATA_SECONDARY_CTL	0x376
+#if defined(__ia64__)
+#define ATA_SECONDARY_IRQ(dev)	isa_irq_to_vector(15)
+#else
 #define ATA_SECONDARY_IRQ(dev)	15
+#endif
+
 
 #endif
