From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 4/5] lpfc: Allow fast timed-out io recovery
Date: Mon, 20 May 2013 15:15:02 +0800
Message-ID: <1369034103-31644-5-git-send-email-renmx@cn.fujitsu.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, james.smart@emulex.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu
Cc: robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements fast timed-out io recovery in LLDD(lpfc) by
checking the corresponding bit fields specified in the new added
interface "fast_io_tmo_flags" and returning "FAST_IO" to avoid the
scsi_eh recovery actions on corresponding levels.

This is mainly for redundant configurations. To non-redundant
systems, the thorough recovery is necessary.

Furthermore, userland tools such as multipath-tools should ensure
that this policy is available only if there are more than one path
active, which will be implemented later.

Here is an example which can show the improvement of this patch:

  before:
    - takes about 3s to write 800MB normally
    # dd if=/dev/zero of=/dev/mapper/mpathb bs=4k count=200000
    200000+0 records in
    200000+0 records out
    819200000 bytes (819 MB) copied, 3.10581 s, 264 MB/s

    - takes about 105s to write 800MB when I/Os timed out
    # grep lpfc_template /proc/kallsyms
    ffffffffa00f83a0 d lpfc_template    [lpfc]
    # insmod scsi_timeout.ko param=0xffffffffa00f83a0,2:0:0:1[*]
    # dd if=/dev/zero of=/dev/mapper/mpathb bs=4k count=200000
    200000+0 records in
    200000+0 records out
    819200000 bytes (819 MB) copied, 104.91 s, 7.8 MB/s

  after:
    - takes about 34s to write 800MB by using this patch when I/Os
      timed out
    # echo 0x1f > /sys/devices/pci0000:00/0000:00:03.0/\
                   0000:01:00.0/0000:02:01.0/0000:0a:00.0/\
                   0000:0b:01.0/0000:0d:00.0/host2/rport-2:0-2/\
                   fc_remote_ports/rport-2:0-2/fast_io_tmo_flags
    # insmod scsi_timeout.ko param=0xffffffffa00f83a0,2:0:0:1
    # dd if=/dev/zero of=/dev/mapper/mpathb bs=4k count=200000
    200000+0 records in
    200000+0 records out
    819200000 bytes (819 MB) copied, 33.7718 s, 24.3 MB/s

  * scsi_timeout.ko is a self-made module which wraps the scsi
    queuecommand handler and ignores I/Os to the specified device
    and any I/Os are not passed to LLDD.
    Reference:
      http://www.spinics.net/lists/linux-scsi/msg35091.html

So with this patch, we just spend time writing(about 3s) and
waiting through timeout(30s), and save about 71s in scsi eh.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8523b27..796893b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4798,6 +4798,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct fc_rport   *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_iocbq *iocb;
 	struct lpfc_iocbq *abtsiocb;
@@ -4811,6 +4812,11 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
+	if (rport->fast_io_tmo_flags & FC_RPORT_IGN_ABORT_CMDS) {
+		scsi_device_set_state(cmnd->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
+
 	spin_lock_irqsave(&phba->hbalock, flags);
 	/* driver queued commands are in process of being flushed */
 	if (phba->hba_flag & HBA_FCP_IOQ_FLUSH) {
@@ -5150,6 +5156,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct fc_rport   *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
@@ -5167,6 +5174,11 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
+	if (rport->fast_io_tmo_flags & FC_RPORT_IGN_DEVICE_RESET) {
+		scsi_device_set_state(cmnd->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
+
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5217,6 +5229,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct fc_rport   *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *pnode;
 	unsigned tgt_id = cmnd->device->id;
@@ -5234,6 +5247,11 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
+	if (rport->fast_io_tmo_flags & FC_RPORT_IGN_TARGET_RESET) {
+		scsi_device_set_state(cmnd->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
+
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
 	if (status == FAILED) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5284,6 +5302,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct fc_rport   *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct lpfc_nodelist *ndlp = NULL;
 	struct lpfc_scsi_event_header scsi_event;
 	int match;
@@ -5302,6 +5321,11 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 	if (status != 0 && status != SUCCESS)
 		return status;
 
+	if (rport->fast_io_tmo_flags & FC_RPORT_IGN_BUS_RESET) {
+		scsi_device_set_state(cmnd->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
+
 	/*
 	 * Since the driver manages a single bus device, reset all
 	 * targets known to the driver.  Should any target reset
@@ -5373,11 +5397,17 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 static int
 lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
+	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba *phba = vport->phba;
+	struct fc_rport   *rport = starget_to_rport(scsi_target(cmnd->device));
+	struct lpfc_hba   *phba = vport->phba;
 	int rc, ret = SUCCESS;
 
+	if (rport->fast_io_tmo_flags & FC_RPORT_IGN_HOST_RESET) {
+		scsi_device_set_state(cmnd->device, SDEV_OFFLINE);
+		return FAST_IO;
+	}
+
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "3172 SCSI layer issued Host Reset Data:\n");
 
-- 
1.7.1
