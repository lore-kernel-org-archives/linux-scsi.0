From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 02/11] libata: remove SCSI host lock and serial number usage from ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 14:18:33 -0800
Message-ID: <1290032313-4879-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm18.bullet.mail.ac4.yahoo.com ([98.139.52.215]:38519 "HELO
	nm18.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758610Ab0KQWZS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 17:25:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Jeff Garzik <jeff@garzik.org>

From: Jeff Garzik <jeff@garzik.org>

cmd->serial_number is never tested in any path we reach; therefore we may
remove the call to scsi_cmd_get_serial() inside DEF_SCSI_QCMD, the SCSI
host_lock acquisition surrounding it, and our own SCSI host_lock
unlock+relock cycle.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/ata/libata-scsi.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 19835d3..66aa4be 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3166,8 +3166,8 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 
 /**
  *	ata_scsi_queuecmd - Issue SCSI cdb to libata-managed device
+ *	@shost: SCSI host of command to be sent
  *	@cmd: SCSI command to be sent
- *	@done: Completion function, called when command is complete
  *
  *	In some cases, this function translates SCSI commands into
  *	ATA taskfiles, and queues the taskfiles to be sent to
@@ -3177,42 +3177,39 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  *	ATA and ATAPI devices appearing as SCSI devices.
  *
  *	LOCKING:
- *	Releases scsi-layer-held lock, and obtains host lock.
+ *	ATA host lock
  *
  *	RETURNS:
  *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
  *	0 otherwise.
  */
-static int ata_scsi_queuecmd_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	struct ata_port *ap;
 	struct ata_device *dev;
 	struct scsi_device *scsidev = cmd->device;
-	struct Scsi_Host *shost = scsidev->host;
 	int rc = 0;
+	unsigned long irq_flags;
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
-	spin_lock(ap->lock);
+	spin_lock_irqsave(ap->lock, irq_flags);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
 	dev = ata_scsi_find_dev(ap, scsidev);
 	if (likely(dev))
-		rc = __ata_scsi_queuecmd(cmd, done, dev);
+		rc = __ata_scsi_queuecmd(cmd, cmd->scsi_done, dev);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 	}
 
-	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
+	spin_unlock_irqrestore(ap->lock, irq_flags);
+
 	return rc;
 }
 
-DEF_SCSI_QCMD(ata_scsi_queuecmd)
-
 /**
  *	ata_scsi_simulate - simulate SCSI command on ATA device
  *	@dev: the target device
-- 
1.7.2.3

