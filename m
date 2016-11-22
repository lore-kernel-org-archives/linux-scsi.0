From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc6
Date: Mon, 21 Nov 2016 22:27:56 -0800
Message-ID: <1479796076.2309.74.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two small fixes.  One prevents timeouts on mpt3sas when trying to use
the secure erase protocol which causes the erase protocol to be
aborted.  The second is a regression in a prior fix which causes all
commands to abort during PCI extended error recovery, which is
incorrect because PCI EEH is independent from what's happening on the
FC transport.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Andrey Grodzovsky (1):
      scsi: mpt3sas: Fix secure erase premature termination

Mauricio Faria de Oliveira (1):
      scsi: qla2xxx: do not abort all commands in the adapter during EEH recovery

And the diffstat:

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c        | 21 +++++++++++++--------
 2 files changed, 27 insertions(+), 9 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8aa769a..91b70bc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4010,7 +4010,10 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
 
 /**
  * scsih_qcmd - main scsi request entry point
@@ -4038,6 +4041,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	if (ioc->logging_level & MPT_DEBUG_SCSI)
 		scsi_print_command(scmd);
 
+	/*
+	 * Lock the device for any subsequent command until command is
+	 * done.
+	 */
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_block(scmd->device);
+
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4613,6 +4623,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	if (scmd == NULL)
 		return 1;
 
+	if (ata_12_16_cmd(scmd))
+		scsi_internal_device_unblock(scmd->device, SDEV_RUNNING);
+
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 
 	if (mpi_reply == NULL) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 567fa08..56d6142 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1456,15 +1456,20 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
-				/* Get a reference to the sp and drop the lock.
-				 * The reference ensures this sp->done() call
-				 * - and not the call in qla2xxx_eh_abort() -
-				 * ends the SCSI command (with result 'res').
+				/* Don't abort commands in adapter during EEH
+				 * recovery as it's not accessible/responding.
 				 */
-				sp_get(sp);
-				spin_unlock_irqrestore(&ha->hardware_lock, flags);
-				qla2xxx_eh_abort(GET_CMD_SP(sp));
-				spin_lock_irqsave(&ha->hardware_lock, flags);
+				if (!ha->flags.eeh_busy) {
+					/* Get a reference to the sp and drop the lock.
+					 * The reference ensures this sp->done() call
+					 * - and not the call in qla2xxx_eh_abort() -
+					 * ends the SCSI command (with result 'res').
+					 */
+					sp_get(sp);
+					spin_unlock_irqrestore(&ha->hardware_lock, flags);
+					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					spin_lock_irqsave(&ha->hardware_lock, flags);
+				}
 				req->outstanding_cmds[cnt] = NULL;
 				sp->done(vha, sp, res);
 			}
