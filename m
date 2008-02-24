From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/5] aic94xx: plumb in I_T_nexus_reset task management
	function
Date: Sat, 23 Feb 2008 23:37:26 -0600
Message-ID: <1203831446.3139.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59697 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbYBXFh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:37:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id C08288989
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:37:27 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7T6RXC+UX5oi for <linux-scsi@vger.kernel.org>;
	Sat, 23 Feb 2008 23:37:27 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 8A29D8112
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:37:26 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Currently aic94xx has no exported I_T_nexus_reset function.  This is a
bit of a huge problem, since sas_ata relies on this function to
perform an ATA phy reset and also it means that if abort fails, we
really have no bigger hammer to hit everything with.

Plumb in the I_T_nexus_reset by quiescing the sequencer, sending the
correct phy reset (link for ATA and hard for SAS) and then carefully
resuming the sequencer again.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/aic94xx/aic94xx.h      |    1 +
 drivers/scsi/aic94xx/aic94xx_init.c |    2 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |   58 ++++++++++++++++++++++++++++++++--
 3 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx.h b/drivers/scsi/aic94xx/aic94xx.h
index 32f513b..eb8efdc 100644
--- a/drivers/scsi/aic94xx/aic94xx.h
+++ b/drivers/scsi/aic94xx/aic94xx.h
@@ -102,6 +102,7 @@ int  asd_abort_task_set(struct domain_device *, u8 *lun);
 int  asd_clear_aca(struct domain_device *, u8 *lun);
 int  asd_clear_task_set(struct domain_device *, u8 *lun);
 int  asd_lu_reset(struct domain_device *, u8 *lun);
+int  asd_I_T_nexus_reset(struct domain_device *dev);
 int  asd_query_task(struct sas_task *);
 
 /* ---------- Adapter and Port management ---------- */
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 5d761eb..88d1e73 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -1003,7 +1003,7 @@ static struct sas_domain_function_template aic94xx_transport_functions = {
 	.lldd_abort_task_set	= asd_abort_task_set,
 	.lldd_clear_aca		= asd_clear_aca,
 	.lldd_clear_task_set	= asd_clear_task_set,
-	.lldd_I_T_nexus_reset	= NULL,
+	.lldd_I_T_nexus_reset	= asd_I_T_nexus_reset,
 	.lldd_lu_reset		= asd_lu_reset,
 	.lldd_query_task	= asd_query_task,
 
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 144f5ad..d684c74 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -140,8 +140,14 @@ int asd_clear_nexus_port(struct asd_sas_port *port)
 	CLEAR_NEXUS_POST;
 }
 
-#if 0
-static int asd_clear_nexus_I_T(struct domain_device *dev)
+enum clear_nexus_phase {
+	NEXUS_PHASE_PRE,
+	NEXUS_PHASE_POST,
+	NEXUS_PHASE_RESUME,
+};
+
+static int asd_clear_nexus_I_T(struct domain_device *dev,
+			       enum clear_nexus_phase phase)
 {
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 	struct asd_ascb *ascb;
@@ -150,12 +156,56 @@ static int asd_clear_nexus_I_T(struct domain_device *dev)
 
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_I_T;
-	scb->clear_nexus.flags = SEND_Q | EXEC_Q | NOTINQ;
+	switch (phase) {
+	case NEXUS_PHASE_PRE:
+		scb->clear_nexus.flags = EXEC_Q | SUSPEND_TX;
+		break;
+	case NEXUS_PHASE_POST:
+		scb->clear_nexus.flags = SEND_Q | NOTINQ;
+		break;
+	case NEXUS_PHASE_RESUME:
+		scb->clear_nexus.flags = RESUME_TX;
+	}
 	scb->clear_nexus.conn_handle = cpu_to_le16((u16)(unsigned long)
 						   dev->lldd_dev);
 	CLEAR_NEXUS_POST;
 }
-#endif
+
+int asd_I_T_nexus_reset(struct domain_device *dev)
+{
+	int res, tmp_res, i;
+	struct sas_phy *phy = sas_find_local_phy(dev);
+	/* Standard mandates link reset for ATA  (type 0) and
+	 * hard reset for SSP (type 1) */
+	int reset_type = (dev->dev_type == SATA_DEV ||
+			  (dev->tproto & SAS_PROTOCOL_STP)) ? 0 : 1;
+
+	asd_clear_nexus_I_T(dev, NEXUS_PHASE_PRE);
+	/* send a hard reset */
+	ASD_DPRINTK("sending %s reset to %s\n",
+		    reset_type ? "hard" : "soft", phy->dev.bus_id);
+	res = sas_phy_reset(phy, reset_type);
+	if (res == TMF_RESP_FUNC_COMPLETE) {
+		/* wait for the maximum settle time */
+		msleep(500);
+		/* clear all outstanding commands (keep nexus suspended) */
+		asd_clear_nexus_I_T(dev, NEXUS_PHASE_POST);
+	}
+	for (i = 0 ; i < 3; i++) {
+		tmp_res = asd_clear_nexus_I_T(dev, NEXUS_PHASE_RESUME);
+		if (tmp_res == TC_RESUME)
+			return res;
+		msleep(500);
+	}
+
+	/* This is a bit of a problem:  the sequencer is still suspended
+	 * and is refusing to resume.  Hope it will resume on a bigger hammer
+	 * or the disk is lost */
+	dev_printk(KERN_ERR, &phy->dev,
+		   "Failed to resume nexus after reset 0x%x\n", tmp_res);
+
+	return TMF_RESP_FUNC_FAILED;
+}
 
 static int asd_clear_nexus_I_T_L(struct domain_device *dev, u8 *lun)
 {
-- 
1.5.4.1



