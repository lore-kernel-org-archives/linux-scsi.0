From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: remove unneeded volatile declarations
Date: Thu, 07 Apr 2011 12:12:30 -0700
Message-ID: <4D9E0C9E.9050906@linux.vnet.ibm.com>
References: <20110407190943.063847426@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50629 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1DGTMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2011 15:12:33 -0400
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p37IrSBT008916
	for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2011 14:53:29 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id DD5A838C803B
	for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2011 15:12:23 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p37JCV8R442418
	for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2011 15:12:32 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p37JCVM0001882
	for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2011 13:12:31 -0600
In-Reply-To: <20110407190943.063847426@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

This patch removes three volatile declarations based on some feedback and code
analysis.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-04-07 09:27:10.624626866 -0700
+++ b/drivers/scsi/ipr.c	2011-04-07 09:31:21.364355876 -0700
@@ -4953,7 +4953,7 @@ static int ipr_eh_abort(struct scsi_cmnd
  * 	IRQ_NONE / IRQ_HANDLED
  **/
 static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg,
-					      volatile u32 int_reg)
+					      u32 int_reg)
 {
 	irqreturn_t rc = IRQ_HANDLED;

@@ -5016,7 +5016,7 @@ static irqreturn_t ipr_isr(int irq, void
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
 	unsigned long lock_flags = 0;
-	volatile u32 int_reg, int_mask_reg;
+	u32 int_reg, int_mask_reg;
 	u32 ioasc;
 	u16 cmd_index;
 	int num_hrrq = 0;
@@ -7517,7 +7517,7 @@ static int ipr_reset_get_unit_check_job(
 static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	volatile u32 int_reg;
+	u32 int_reg;

 	ENTER;
 	ioa_cfg->pdev->state_saved = true;

