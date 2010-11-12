From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 06/11] mpt2sas: Convert to host_lock less w/ interrupts disabled externally
Date: Thu, 11 Nov 2010 16:14:13 -0800
Message-ID: <1289520853-16550-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:34411 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757249Ab0KLAPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:15:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the mpt2sas driver to run in host_lock less mode
with the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while
calling ->queuecommand() dispatch

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 1a96a00..e564fe7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3304,7 +3304,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 }
 
 /**
- * _scsih_qcmd - main scsi request entry point
+ * _scsih_qcmd_irq_disable - main scsi request entry point
  * @scmd: pointer to scsi command object
  * @done: function pointer to be invoked on completion
  *
@@ -3315,7 +3315,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
 static int
-_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
+_scsih_qcmd_irq_disable(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 {
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
@@ -3441,7 +3441,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static DEF_SCSI_QCMD(_scsih_qcmd)
+static IRQ_DISABLE_SCSI_QCMD(_scsih_qcmd)
 
 /**
  * _scsih_normalize_sense - normalize descriptor and fixed format sense data
-- 
1.7.2.3

