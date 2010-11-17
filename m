From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/11] libsas: Convert to host_lock less w/ interrupts disabled externally
Date: Wed, 17 Nov 2010 14:18:51 -0800
Message-ID: <1290032331-4919-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3.bullet.mail.ac4.yahoo.com ([98.139.52.200]:26653 "HELO
	nm3.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935486Ab0KQWS5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 17:18:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the libsas queuecommand to run in host_lock less mode
w/ the new IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling
->queuecommand() dispatch.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libsas/sas_scsi_host.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 29251fa..595ed21 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -189,7 +189,7 @@ int sas_queue_up(struct sas_task *task)
  * Note: XXX: Remove the host unlock/lock pair when SCSI Core can
  * call us without holding an IRQ spinlock...
  */
-static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
+static int sas_queuecommand_irq_disable(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
 	__releases(host->host_lock)
 	__acquires(dev->sata_dev.ap->lock)
@@ -254,7 +254,7 @@ out:
 	return res;
 }
 
-DEF_SCSI_QCMD(sas_queuecommand)
+IRQ_DISABLE_SCSI_QCMD(sas_queuecommand)
 
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
-- 
1.7.2.3

