From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: fix eeh recovery for 64-bit adapters
Date: Mon, 16 Jan 2012 19:30:25 -0200
Message-ID: <1326749425-28778-1-git-send-email-klebers@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:52459 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab2APVbC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 16:31:02 -0500
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <klebers@linux.vnet.ibm.com>;
	Mon, 16 Jan 2012 19:30:59 -0200
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay02.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q0GLUtas14418104
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2012 19:30:56 -0200
Received: from d24av04.br.ibm.com (loopback [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q0GLUfxK012842
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2012 19:30:42 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Brian King <brking@linux.vnet.ibm.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

In some scenarios, an EEH error can take a long time to be detected, since the
driver issues an MMIO read only after a device reset command times out and we
try to reset the adapter. This patch adds some code in ipr_cancel_op() to read
a hardware register so we detect the error earlier in case the op is being
aborted because of a timeout caused by a frozen adapter slot.

Another problem in such scenarios is that in __ipr_eh_host_reset() we change the
dump state flag from WAIT_FOR_DUMP to GET_DUMP, and the flag is later changed
from GET_DUMP to READ_DUMP in ipr_reset_restore_cfg_space(). However, if when
__ipr_eh_host_reset() is called by the SCSI error handling the function
ipr_reset_restore_cfg_space() has already been called by the PCI EEH code, we
end up with the flag in an inconsistent state. This patch also prevents this
problem.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fd860d9..7969b5a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4613,11 +4613,13 @@ static int __ipr_eh_host_reset(struct scsi_cmnd * scsi_cmd)
 	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
 
-	dev_err(&ioa_cfg->pdev->dev,
-		"Adapter being reset as a result of error recovery.\n");
+	if (!ioa_cfg->in_reset_reload) {
+		dev_err(&ioa_cfg->pdev->dev,
+			"Adapter being reset as a result of error recovery.\n");
 
-	if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
-		ioa_cfg->sdt_state = GET_DUMP;
+		if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
+			ioa_cfg->sdt_state = GET_DUMP;
+	}
 
 	rc = ipr_reset_reload(ioa_cfg, IPR_SHUTDOWN_ABBREV);
 
@@ -4907,7 +4909,7 @@ static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 	struct ipr_cmd_pkt *cmd_pkt;
-	u32 ioasc;
+	u32 ioasc, int_reg;
 	int op_found = 0;
 
 	ENTER;
@@ -4920,7 +4922,17 @@ static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
 	 */
 	if (ioa_cfg->in_reset_reload || ioa_cfg->ioa_is_dead)
 		return FAILED;
-	if (!res || !ipr_is_gscsi(res))
+	if (!res)
+		return FAILED;
+
+	/*
+	 * If we are aborting a timed out op, chances are that the timeout was caused
+	 * by a still not detected EEH error. In such cases, reading a register will
+	 * trigger the EEH recovery infrastructure.
+	 */
+	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg);
+
+	if (!ipr_is_gscsi(res))
 		return FAILED;
 
 	list_for_each_entry(ipr_cmd, &ioa_cfg->pending_q, queue) {
-- 
1.7.1

