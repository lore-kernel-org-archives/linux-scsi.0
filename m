From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/4] scsi: megaraid_sas - Add the dumy readl to force PCI
 flush
Date: Fri, 1 Aug 2008 10:19:07 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C31B08093F@cosmail02.lsi.com>
References: <FFD04EB4FBD32E4B929B6CFDEDA6AA0D632A9F@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53072 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYHAQTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 12:19:33 -0400
In-Reply-To: <FFD04EB4FBD32E4B929B6CFDEDA6AA0D632A9F@NAMAIL1.ad.lsil.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'James.Bottomley@SteelEye.com'" <James.Bottomley@SteelEye.com>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Austria, Winston" <Winston.Austria@lsi.com>, "poswald@novell.com" <poswald@novell.com>

MegaRAID SAS Driver get unexpected Interrupt.  Add the dumy readl to force PCI flush will fix this issue.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |    6 ++++++
1 files changed, 6 insertions(+)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2008-07-31 12:00:58.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2008-07-31 12:30:35.000000000 -0400
@@ -198,6 +198,9 @@ megasas_clear_intr_xscale(struct megasas
         */
        writel(status, &regs->outbound_intr_status);

+       /* Dummy readl to force pci flush */
+       readl(&regs->outbound_intr_status);
+
        return 0;
 }

@@ -293,6 +296,9 @@ megasas_clear_intr_ppc(struct megasas_re
         */
        writel(status, &regs->outbound_doorbell_clear);

+       /* Dummy readl to force pci flush */
+       readl(&regs->outbound_doorbell_clear);
+
        return 0;
 }
 /**
