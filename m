From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 06/17] bfa: Fix 1860 port initialize when ATC is enabled
Date: Mon, 13 May 2013 02:33:24 -0700
Message-ID: <1368437615-9867-7-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50359 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab3EMJv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:51:59 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>, Anil Gurumurthy <agurumur@Brocade.COM>

On Xen kernels, if ATC (address translation cache) is enabled, the
first PCIe DMA read from the adapter fails with an error. This is due to
a bug ASIC, which leads to a failure of 1860 ports to be initialised.

This patch includes the fix to disable Invalidated Tag Match Enable
capability by setting the bit 26 of CHIP_MISC_PRG to 0, by default it is
set to 1.

Signed-off-by: Anil Gurumurthy <agurumur@brocade.com>
Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc_ct.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index de4e726..a8e52a1 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -918,6 +918,16 @@ bfa_ioc_ct2_pll_init(void __iomem *rb, enum bfi_asic_mode mode)
 
 		}
 	}
+	/*
+	* The very first PCIe DMA Read done by LPU fails with a fatal error,
+	* when Address Translation Cache (ATC) has been enabled by system BIOS.
+	*
+	* Workaround:
+	* Disable Invalidated Tag Match Enable capability by setting the bit 26
+	* of CHIP_MISC_PRG to 0, by default it is set to 1.
+	*/
+	r32 = readl(rb + CT2_CHIP_MISC_PRG);
+	writel((r32 & 0xfbffffff), (rb + CT2_CHIP_MISC_PRG));
 
 	/*
 	 * Mask the interrupts and clear any
-- 
1.7.12

