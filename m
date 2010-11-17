From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v2] libata: remove scsi host lock and serial number usage
Date: Wed, 17 Nov 2010 12:21:11 -0500
Message-ID: <20101117172111.GA26812@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33046 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934939Ab0KQRVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 12:21:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, James.Bottomley@suse.de


Much better...  Just updated #upstream-fixes with the below patch.

James just posted to linux-scsi
	[PATCH] Eliminate error handler overload of the SCSI serial number
but as Tejun pointed out, we _completely and entirely_ replace the SCSI
error handler apparatus with our own, thereby eliminating any
possibility that we would ever read or use cmd->serial_number.

Our lock profile is quite a bit improved.

Further simplifications and cleanups related to 'done' are possible,
but those are kept separate from the change below.


commit 23e701e6208191ad103517ae7a700f2dc59ab2ec
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Nov 17 12:03:58 2010 -0500

    [libata] remove SCSI host lock and serial number usage from ata_scsi_queuecmd
    
    cmd->serial_number is never tested in any path we reach; therefore we may
    remove the call to scsi_cmd_get_serial() inside DEF_SCSI_QCMD, the SCSI
    host_lock acquisition surrounding it, and our own SCSI host_lock
    unlock+relock cycle.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/libata-scsi.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

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
