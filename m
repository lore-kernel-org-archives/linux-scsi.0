From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 02/11] libata: Convert to host_lock less w/ interrupts disabled internally
Date: Thu, 11 Nov 2010 16:13:37 -0800
Message-ID: <1289520817-16458-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:22811 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755156Ab0KLANn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 19:13:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes ata_scsi_queuecmd_lck() to a host lock less
ata_scsi_queuecmd() that will disable interrupts internally using
ap->lock and drops the now legacy host_lock unlock.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/ata/libata-scsi.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a007c36..9614758 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3173,25 +3173,22 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  *	SCSI commands.  This creates the overall effect of
  *	ATA and ATAPI devices appearing as SCSI devices.
  *
- *	LOCKING:
- *	Releases scsi-layer-held lock, and obtains host lock.
- *
  *	RETURNS:
  *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
  *	0 otherwise.
  */
-static int ata_scsi_queuecmd_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	struct ata_port *ap;
 	struct ata_device *dev;
 	struct scsi_device *scsidev = cmd->device;
 	struct Scsi_Host *shost = scsidev->host;
+	unsigned long irq_flags;
 	int rc = 0;
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
-	spin_lock(ap->lock);
+	spin_lock_irqsave(ap->lock, irq_flags);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
@@ -3203,13 +3200,10 @@ static int ata_scsi_queuecmd_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi
 		done(cmd);
 	}
 
-	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
+	spin_unlock_irqrestore(ap->lock, irq_flags);
 	return rc;
 }
 
-DEF_SCSI_QCMD(ata_scsi_queuecmd)
-
 /**
  *	ata_scsi_simulate - simulate SCSI command on ATA device
  *	@dev: the target device
-- 
1.7.2.3

