From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ipr: fix a register read to use the correct address for
 64 bit adapters
Date: Mon, 10 May 2010 09:14:07 -0700
Message-ID: <4BE830CF.1090603@linux.vnet.ibm.com>
References: <20100510160631.899608040@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47371 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0EJQO0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2010 12:14:26 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o4AG4STQ025772
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 10:04:28 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o4AGE9WR057708
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 10:14:09 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o4AGGwZv009176
	for <linux-scsi@vger.kernel.org>; Mon, 10 May 2010 10:16:59 -0600
In-Reply-To: <20100510160631.899608040@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

Fix ipr_reset_enable_ioa() to read the correct IOA to host interrupt register
address for 64 bit adapters.  We need to read the lower 32 bits, not the upper
32 bits.

Also change the write of the 64 bit mask value to a single writeq instead
of two writel calls.

Finally, use the correct u8 type for the type field in the ipr_resource_entry
structure.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   12 ++++++++----
 drivers/scsi/ipr.h |    2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-05-07 09:46:11.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-05-07 09:46:12.000000000 -0700
@@ -7184,13 +7184,14 @@ static int ipr_reset_enable_ioa(struct i
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 	volatile u32 int_reg;
+	volatile u64 maskval;

 	ENTER;
 	ipr_cmd->job_step = ipr_ioafp_identify_hrrq;
 	ipr_init_ioa_mem(ioa_cfg);

 	ioa_cfg->allow_interrupts = 1;
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);

 	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
 		writel((IPR_PCII_ERROR_INTERRUPTS | IPR_PCII_HRRQ_UPDATED),
@@ -7202,9 +7203,12 @@ static int ipr_reset_enable_ioa(struct i
 	/* Enable destructive diagnostics on IOA */
 	writel(ioa_cfg->doorbell, ioa_cfg->regs.set_uproc_interrupt_reg32);

-	writel(IPR_PCII_OPER_INTERRUPTS, ioa_cfg->regs.clr_interrupt_mask_reg32);
-	if (ioa_cfg->sis64)
-		writel(IPR_PCII_IPL_STAGE_CHANGE, ioa_cfg->regs.clr_interrupt_mask_reg);
+	if (ioa_cfg->sis64) {
+		maskval = IPR_PCII_IPL_STAGE_CHANGE;
+		maskval = (maskval << 32) | IPR_PCII_OPER_INTERRUPTS;
+		writeq(maskval, ioa_cfg->regs.clr_interrupt_mask_reg);
+	} else
+		writel(IPR_PCII_OPER_INTERRUPTS, ioa_cfg->regs.clr_interrupt_mask_reg32);

 	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-05-07 09:46:11.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-05-07 09:46:12.000000000 -0700
@@ -1201,7 +1201,7 @@ struct ipr_resource_entry {
 	u8 flags;
 	__be16 res_flags;

-	__be32 type;
+	u8 type;

 	u8 qmodel;
 	struct ipr_std_inq_data std_inq_data;

