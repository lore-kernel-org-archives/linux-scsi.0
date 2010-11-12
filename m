From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 09/11] qla2xxx: Convert to host_lock less w/ interrupts disabled externally
Date: Thu, 11 Nov 2010 16:14:39 -0800
Message-ID: <1289520879-16610-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.ac4.yahoo.com ([76.13.13.242]:44505 "HELO
	smtp103.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751360Ab0KLAOp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:14:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts qla2xxx to run in host_lock less mode with the new
IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
dispatch.  It also drops the legacy host_lock unlock optimization.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_os.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 35f3f5d..f0c432b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -535,7 +535,8 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 }
 
 static int
-qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+qla2xxx_queuecommand_irq_disable(struct scsi_cmnd *cmd,
+				void (*done)(struct scsi_cmnd *))
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
@@ -545,7 +546,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	srb_t *sp;
 	int rval;
 
-	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -586,8 +586,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(vha->host->host_lock);
-
 	return 0;
 
 qc24_host_busy_free_sp:
@@ -595,21 +593,18 @@ qc24_host_busy_free_sp:
 	mempool_free(sp, ha->srb_mempool);
 
 qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
-	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
-	spin_lock_irq(vha->host->host_lock);
 	done(cmd);
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(qla2xxx_queuecommand)
+static IRQ_DISABLE_SCSI_QCMD(qla2xxx_queuecommand)
 
 
 /*
-- 
1.7.2.3

