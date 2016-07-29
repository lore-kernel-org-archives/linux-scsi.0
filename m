From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH 3/3] mpt3sas: Fix warnings exposed by W=1
Date: Thu, 28 Jul 2016 21:38:22 -0700
Message-ID: <094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com>
References: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Calvin Owens <calvinowens@fb.com>
List-Id: linux-scsi@vger.kernel.org

Trivial non-functional changes for a couple annoying things:

  1) Functions local to files are not declared static, which is
  frustrating when reading the code because it's non-obvious at first
  glance what's actually called from other files.

  2) Set-but-unused variables abound, presumably to mask -Wunused-result
  errors in the past. None of these are flagged today though (with one
  exception noted below), so remove them.

Fixing (2) exposed the fact that we improperly ignore the return value of
scsi_device_reprobe() in _scsih_reprobe_lun(). Fixing the calling code to
deal with the potential error is non-trivial, so for now just WARN().

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 18 +++-----
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 29 ++++++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 70 +++++++++++++++-----------------
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 16 ++------
 5 files changed, 56 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0956183..df95d1a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2039,7 +2039,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
  * mpt3sas_base_unmap_resources - free controller resources
  * @ioc: per adapter object
  */
-void
+static void
 mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct pci_dev *pdev = ioc->pdev;
@@ -3884,7 +3884,6 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	MPI2DefaultReply_t *default_reply = (MPI2DefaultReply_t *)reply;
 	int i;
 	u8 failed;
-	u16 dummy;
 	__le32 *mfp;
 
 	/* make sure doorbell is not in use */
@@ -3964,7 +3963,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			return -EFAULT;
 		}
 		if (i >=  reply_bytes/2) /* overflow case */
-			dummy = readl(&ioc->chip->Doorbell);
+			readl(&ioc->chip->Doorbell);
 		else
 			reply[i] = le16_to_cpu(readl(&ioc->chip->Doorbell)
 			    & MPI2_DOORBELL_DATA_MASK);
@@ -4009,7 +4008,6 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 {
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	bool issue_reset = false;
 	int rc;
 	void *request;
@@ -4062,7 +4060,7 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 		ioc->ioc_link_reset_in_progress = 1;
 	init_completion(&ioc->base_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
+	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET) &&
@@ -4112,7 +4110,6 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 {
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	bool issue_reset = false;
 	int rc;
 	void *request;
@@ -4163,7 +4160,7 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
 	init_completion(&ioc->base_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
+	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -4548,7 +4545,6 @@ _base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2PortEnableRequest_t *mpi_request;
 	Mpi2PortEnableReply_t *mpi_reply;
-	unsigned long timeleft;
 	int r = 0;
 	u16 smid;
 	u16 ioc_status;
@@ -4576,8 +4572,7 @@ _base_send_port_enable(struct MPT3SAS_ADAPTER *ioc)
 
 	init_completion(&ioc->port_enable_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->port_enable_cmds.done,
-	    300*HZ);
+	wait_for_completion_timeout(&ioc->port_enable_cmds.done, 300*HZ);
 	if (!(ioc->port_enable_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
 		    ioc->name, __func__);
@@ -4728,7 +4723,6 @@ static int
 _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2EventNotificationRequest_t *mpi_request;
-	unsigned long timeleft;
 	u16 smid;
 	int r = 0;
 	int i;
@@ -4760,7 +4754,7 @@ _base_event_notification(struct MPT3SAS_ADAPTER *ioc)
 		    cpu_to_le32(ioc->event_masks[i]);
 	init_completion(&ioc->base_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
+	wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
 		    ioc->name, __func__);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 022f27f..cebfd73 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -285,7 +285,6 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 {
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	Mpi2ConfigRequest_t *config_request;
 	int r;
 	u8 retry_count, issue_host_reset = 0;
@@ -386,8 +385,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	_config_display_some_debug(ioc, smid, "config_request", NULL);
 	init_completion(&ioc->config_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
-	    timeout*HZ);
+	wait_for_completion_timeout(&ioc->config_cmds.done, timeout*HZ);
 	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
 		    ioc->name, __func__);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index c924012..26cdc12 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -518,7 +518,7 @@ mpt3sas_ctl_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase)
  *
  * Called when application request fasyn callback handler.
  */
-int
+static int
 _ctl_fasync(int fd, struct file *filep, int mode)
 {
 	return fasync_helper(fd, filep, mode, &async_queue);
@@ -530,7 +530,7 @@ _ctl_fasync(int fd, struct file *filep, int mode)
  * @wait -
  *
  */
-unsigned int
+static unsigned int
 _ctl_poll(struct file *filep, poll_table *wait)
 {
 	struct MPT3SAS_ADAPTER *ioc;
@@ -641,9 +641,8 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	MPI2RequestHeader_t *mpi_request = NULL, *request;
 	MPI2DefaultReply_t *mpi_reply;
 	u32 ioc_state;
-	u16 ioc_status;
 	u16 smid;
-	unsigned long timeout, timeleft;
+	unsigned long timeout;
 	u8 issue_reset;
 	u32 sz;
 	void *psge;
@@ -914,8 +913,7 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		timeout = MPT3_IOCTL_DEFAULT_TIMEOUT;
 	else
 		timeout = karg.timeout;
-	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
-	    timeout*HZ);
+	wait_for_completion_timeout(&ioc->ctl_cmds.done, timeout*HZ);
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
 		Mpi2SCSITaskManagementRequest_t *tm_request =
 		    (Mpi2SCSITaskManagementRequest_t *)mpi_request;
@@ -938,7 +936,6 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	}
 
 	mpi_reply = ioc->ctl_cmds.reply;
-	ioc_status = le16_to_cpu(mpi_reply->IOCStatus) & MPI2_IOCSTATUS_MASK;
 
 	if (mpi_reply->Function == MPI2_FUNCTION_SCSI_TASK_MGMT &&
 	    (ioc->logging_level & MPT_DEBUG_TM)) {
@@ -1378,7 +1375,6 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2DiagBufferPostRequest_t *mpi_request;
 	Mpi2DiagBufferPostReply_t *mpi_reply;
 	u8 buffer_type;
-	unsigned long timeleft;
 	u16 smid;
 	u16 ioc_status;
 	u32 ioc_state;
@@ -1496,7 +1492,7 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 
 	init_completion(&ioc->ctl_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
+	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -1796,7 +1792,6 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	u16 ioc_status;
 	u32 ioc_state;
 	int rc;
-	unsigned long timeleft;
 
 	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
@@ -1844,7 +1839,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 
 	init_completion(&ioc->ctl_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
+	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -1990,7 +1985,7 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	Mpi2DiagBufferPostReply_t *mpi_reply;
 	int rc, i;
 	u8 buffer_type;
-	unsigned long timeleft, request_size, copy_size;
+	unsigned long request_size, copy_size;
 	u16 smid;
 	u16 ioc_status;
 	u8 issue_reset = 0;
@@ -2111,7 +2106,7 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 
 	init_completion(&ioc->ctl_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
+	wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
@@ -2346,7 +2341,7 @@ out_unlock_pciaccess:
  * @cmd - ioctl opcode
  * @arg -
  */
-long
+static long
 _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
@@ -2366,7 +2361,7 @@ _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  * @cmd - ioctl opcode
  * @arg -
  */
-long
+static long
 _ctl_mpt2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
@@ -2386,7 +2381,7 @@ _ctl_mpt2_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
  *
  * This routine handles 32 bit applications in 64bit os.
  */
-long
+static long
 _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
@@ -2404,7 +2399,7 @@ _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
  *
  * This routine handles 32 bit applications in 64bit os.
  */
-long
+static long
 _ctl_mpt2_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 22d75a2a..7732e3e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1195,7 +1195,7 @@ _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
  *
  * Returns queue depth.
  */
-int
+static int
 scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -1244,7 +1244,7 @@ scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
-int
+static int
 scsih_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
@@ -1311,7 +1311,7 @@ scsih_target_alloc(struct scsi_target *starget)
  *
  * Returns nothing.
  */
-void
+static void
 scsih_target_destroy(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
@@ -1320,7 +1320,6 @@ scsih_target_destroy(struct scsi_target *starget)
 	struct _sas_device *sas_device;
 	struct _raid_device *raid_device;
 	unsigned long flags;
-	struct sas_rphy *rphy;
 
 	sas_target_priv_data = starget->hostdata;
 	if (!sas_target_priv_data)
@@ -1339,7 +1338,6 @@ scsih_target_destroy(struct scsi_target *starget)
 	}
 
 	spin_lock_irqsave(&ioc->sas_device_lock, flags);
-	rphy = dev_to_rphy(starget->dev.parent);
 	sas_device = __mpt3sas_get_sdev_from_target(ioc, sas_target_priv_data);
 	if (sas_device && (sas_device->starget == starget) &&
 	    (sas_device->id == starget->id) &&
@@ -1369,7 +1367,7 @@ scsih_target_destroy(struct scsi_target *starget)
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
-int
+static int
 scsih_slave_alloc(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
@@ -1434,7 +1432,7 @@ scsih_slave_alloc(struct scsi_device *sdev)
  *
  * Returns nothing.
  */
-void
+static void
 scsih_slave_destroy(struct scsi_device *sdev)
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data;
@@ -1527,7 +1525,7 @@ _scsih_display_sata_capabilities(struct MPT3SAS_ADAPTER *ioc,
  * scsih_is_raid - return boolean indicating device is raid volume
  * @dev the device struct object
  */
-int
+static int
 scsih_is_raid(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -1542,7 +1540,7 @@ scsih_is_raid(struct device *dev)
  * scsih_get_resync - get raid volume resync percent complete
  * @dev the device struct object
  */
-void
+static void
 scsih_get_resync(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -1603,7 +1601,7 @@ scsih_get_resync(struct device *dev)
  * scsih_get_state - get raid volume level
  * @dev the device struct object
  */
-void
+static void
 scsih_get_state(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -1805,7 +1803,7 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
  * Returns 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
-int
+static int
 scsih_slave_configure(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2021,7 +2019,7 @@ scsih_slave_configure(struct scsi_device *sdev)
  *
  * Return nothing.
  */
-int
+static int
 scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	sector_t capacity, int params[])
 {
@@ -2217,7 +2215,6 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	Mpi2SCSITaskManagementReply_t *mpi_reply;
 	u16 smid = 0;
 	u32 ioc_state;
-	unsigned long timeleft;
 	struct scsiio_tracker *scsi_lookup = NULL;
 	int rc;
 	u16 msix_task = 0;
@@ -2283,7 +2280,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	else
 		msix_task = 0;
 	mpt3sas_base_put_smid_hi_priority(ioc, smid, msix_task);
-	timeleft = wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
+	wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
 		    ioc->name, __func__);
@@ -2434,7 +2431,7 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-int
+static int
 scsih_abort(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
@@ -2493,7 +2490,7 @@ scsih_abort(struct scsi_cmnd *scmd)
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-int
+static int
 scsih_dev_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
@@ -2556,7 +2553,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-int
+static int
 scsih_target_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
@@ -2619,7 +2616,7 @@ scsih_target_reset(struct scsi_cmnd *scmd)
  *
  * Returns SUCCESS if command aborted else FAILED
  */
-int
+static int
 scsih_host_reset(struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
@@ -3449,7 +3446,7 @@ _scsih_tm_volume_tr_complete(struct MPT3SAS_ADAPTER *ioc, u16 smid,
  *
  * Context - processed in interrupt context.
  */
-void
+static void
 _scsih_issue_delayed_event_ack(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 event,
 				u32 event_context)
 {
@@ -3488,7 +3485,7 @@ _scsih_issue_delayed_event_ack(struct MPT3SAS_ADAPTER *ioc, u16 smid, u16 event,
  *
  * Context - processed in interrupt context.
  */
-void
+static void
 _scsih_issue_delayed_sas_io_unit_ctrl(struct MPT3SAS_ADAPTER *ioc,
 					u16 smid, u16 handle)
 	{
@@ -4026,7 +4023,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
  * SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
-int
+static int
 scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -6305,11 +6302,10 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 static void
 _scsih_reprobe_lun(struct scsi_device *sdev, void *no_uld_attach)
 {
-	int rc;
 	sdev->no_uld_attach = no_uld_attach ? 1 : 0;
 	sdev_printk(KERN_INFO, sdev, "%s raid component\n",
 	    sdev->no_uld_attach ? "hidding" : "exposing");
-	rc = scsi_device_reprobe(sdev);
+	WARN_ON(scsi_device_reprobe(sdev));
 }
 
 /**
@@ -8131,7 +8127,7 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
  * Routine called when unloading the driver.
  * Return nothing.
  */
-void scsih_remove(struct pci_dev *pdev)
+static void scsih_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8204,7 +8200,7 @@ void scsih_remove(struct pci_dev *pdev)
  *
  * Return nothing.
  */
-void
+static void
 scsih_shutdown(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -8445,7 +8441,7 @@ _scsih_probe_devices(struct MPT3SAS_ADAPTER *ioc)
  * of scanning the entire bus.  In our implemention, we will kick off
  * firmware discovery.
  */
-void
+static void
 scsih_scan_start(struct Scsi_Host *shost)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8472,7 +8468,7 @@ scsih_scan_start(struct Scsi_Host *shost)
  * scsi_host and the elapsed time of the scan in jiffies. In our implemention,
  * we wait for firmware discovery to complete, then return 1.
  */
-int
+static int
 scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -8602,7 +8598,7 @@ static struct raid_function_template mpt3sas_raid_functions = {
  *	MPI25_VERSION for SAS 3.0 HBA devices, and
  *	MPI26 VERSION for Cutlass & Invader SAS 3.0 HBA devices
  */
-u16
+static u16
 _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 {
 
@@ -8654,7 +8650,7 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
  *
  * Returns 0 success, anything else error.
  */
-int
+static int
 _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT3SAS_ADAPTER *ioc;
@@ -8863,7 +8859,7 @@ out_add_shost_fail:
  *
  * Returns 0 success, anything else error.
  */
-int
+static int
 scsih_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -8890,7 +8886,7 @@ scsih_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  * Returns 0 success, anything else error.
  */
-int
+static int
 scsih_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -8927,7 +8923,7 @@ scsih_resume(struct pci_dev *pdev)
  * Return value:
  *      PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
  */
-pci_ers_result_t
+static pci_ers_result_t
 scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -8964,7 +8960,7 @@ scsih_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
  * code after the PCI slot has been reset, just before we
  * should resume normal operations.
  */
-pci_ers_result_t
+static pci_ers_result_t
 scsih_pci_slot_reset(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -9000,7 +8996,7 @@ scsih_pci_slot_reset(struct pci_dev *pdev)
  * OK to resume normal operation. Use completion to allow
  * halted scsi ops to resume.
  */
-void
+static void
 scsih_pci_resume(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -9017,7 +9013,7 @@ scsih_pci_resume(struct pci_dev *pdev)
  * scsih_pci_mmio_enabled - Enable MMIO and dump debug registers
  * @pdev: pointer to PCI device
  */
-pci_ers_result_t
+static pci_ers_result_t
 scsih_pci_mmio_enabled(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -9145,7 +9141,7 @@ static struct pci_driver mpt3sas_driver = {
  *
  * Returns 0 success, anything else error.
  */
-int
+static int
 scsih_init(void)
 {
 	mpt2_ids = 0;
@@ -9195,7 +9191,7 @@ scsih_init(void)
  *
  * Returns 0 success, anything else error.
  */
-void
+static void
 scsih_exit(void)
 {
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index f58a8c6..b74faf1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -300,7 +300,6 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	int rc;
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	void *psge;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
@@ -394,8 +393,7 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 		ioc->name, (unsigned long long)sas_address));
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
-	    10*HZ);
+	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -1106,7 +1104,6 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	int rc;
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	void *psge;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
@@ -1202,8 +1199,7 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 		phy->number));
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
-	    10*HZ);
+	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -1419,7 +1415,6 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	int rc;
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	void *psge;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
@@ -1520,8 +1515,7 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 		phy->number, phy_operation));
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
-	    10*HZ);
+	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s: timeout\n",
@@ -1896,7 +1890,6 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	int rc;
 	u16 smid;
 	u32 ioc_state;
-	unsigned long timeleft;
 	void *psge;
 	u8 issue_reset = 0;
 	dma_addr_t dma_addr_in = 0;
@@ -2040,8 +2033,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	init_completion(&ioc->transport_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
-	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
-	    10*HZ);
+	wait_for_completion_timeout(&ioc->transport_cmds.done, 10*HZ);
 
 	if (!(ioc->transport_cmds.status & MPT3_CMD_COMPLETE)) {
 		pr_err(MPT3SAS_FMT "%s : timeout\n",
-- 
2.8.0.rc2
