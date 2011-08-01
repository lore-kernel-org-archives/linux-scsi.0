From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] [SCSI] ipr: Always initiate hard reset in kdump kernel
Date: Mon, 1 Aug 2011 19:43:45 +1000
Message-ID: <20110801194345.12673e74@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:44156 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1HAJny (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2011 05:43:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wayneb@linux.vnet.ibm.com, brking@us.ibm.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org


During kdump testing I noticed timeouts when initialising each IPR
adapter. While the driver has logic to detect an adapter in an
indeterminate state, it wasn't triggering and each adapter went
through a 5 minute timeout before finally going operational.

Some analysis showed the needs_hard_reset flag wasn't getting set.
We can check the reset_devices kernel parameter which is set by
kdump and force a full reset. This fixes the problem.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c	2011-07-28 13:47:17.000000000 +1000
+++ linux-2.6/drivers/scsi/ipr.c	2011-07-29 18:46:57.000000000 +1000
@@ -8812,7 +8812,7 @@ static int __devinit ipr_probe_ioa(struc
 	uproc = readl(ioa_cfg->regs.sense_uproc_interrupt_reg32);
 	if ((mask & IPR_PCII_HRRQ_UPDATED) == 0 || (uproc & IPR_UPROCI_RESET_ALERT))
 		ioa_cfg->needs_hard_reset = 1;
-	if (interrupts & IPR_PCII_ERROR_INTERRUPTS)
+	if ((interrupts & IPR_PCII_ERROR_INTERRUPTS) || reset_devices)
 		ioa_cfg->needs_hard_reset = 1;
 	if (interrupts & IPR_PCII_IOA_UNIT_CHECKED)
 		ioa_cfg->ioa_unit_checked = 1;
