From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 01:29:58 -0500
Message-ID: <20101117062958.GA2894@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


This is in #upstream-fixes...  Each libata command is now two lock-ops
less expensive... for free!  Should be nice for multi-core SSD users etc.

(not a pull request, Linus, just an FYI)


commit 02ab5c49284c91901cad783921e816297c92ebf8
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Nov 17 01:19:11 2010 -0500

    [libata] kill unlock+relock cycle in SCSI queuecommand hook
    
    Now that SCSI's ->queuecommand hook is unlocked, ATA no longer needs
    to unlock the SCSI host_lock prior to work, and re-lock the host_lock
    once our work is complete.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/libata-scsi.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 19835d3..d72340e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3166,8 +3166,8 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 
 /**
  *	ata_scsi_queuecmd - Issue SCSI cdb to libata-managed device
+ *	@shost: SCSI host destination for given command
  *	@cmd: SCSI command to be sent
- *	@done: Completion function, called when command is complete
  *
  *	In some cases, this function translates SCSI commands into
  *	ATA taskfiles, and queues the taskfiles to be sent to
@@ -3183,36 +3183,41 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
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
 
-	ap = ata_shost_to_port(shost);
+	local_irq_save(irq_flags);
 
+	spin_lock(shost->host_lock);
+	scsi_cmd_get_serial(shost, cmd);
 	spin_unlock(shost->host_lock);
+
+	ap = ata_shost_to_port(shost);
+
 	spin_lock(ap->lock);
 
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
 
 	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
+
+	local_irq_restore(irq_flags);
+
 	return rc;
 }
 
-DEF_SCSI_QCMD(ata_scsi_queuecmd)
-
 /**
  *	ata_scsi_simulate - simulate SCSI command on ATA device
  *	@dev: the target device
