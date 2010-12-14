From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.37-rc5
Date: Tue, 14 Dec 2010 13:48:15 -0600
Message-ID: <1292356095.3058.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420Ab0LNTsV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2010 14:48:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

this is quite a big tranche of fixes representing all the accumulations
since -rc1 (sorry, but it was put to me that I could either be on
holiday or on the computer and chose the former for reasons of domestic
harmony ... plus being snowed in in the UK didn't help).  It's mostly
fixes for corner case oopses and other faults like MSI not working
properly.  The biggest one is a PCI ID correction in hpsa which prevents
the wrongly defined device from binding.

The fix set is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (1):
      qla2xxx: Correct issue where NPIV-config data was not being allocated for 82xx parts.

Anil Ravindranath (1):
      pmcraid: disable msix and expand device config entry

Christof Schmitt (1):
      zfcp: Issue FCP command without holding SCSI host_lock

Dan Carpenter (1):
      osd: checking NULL instead of ERR_PTR()

James Bottomley (1):
      Eliminate error handler overload of the SCSI serial number

James Smart (1):
      bsg: correct fault if queue object removed while dev_t open

Madhuranath Iyengar (1):
      qla2xxx: Update version number to 8.03.05-k0.

Mike Hernandez (2):
      qla2xxx: Change MSI initialization from using incorrect request_irq parameter.
      qla2xxx: Populate Command Type 6 LUN field properly.

Mike Miller (1):
      hpsa: fix redefinition of PCI_DEVICE_ID_CISSF

Saurav Kashyap (1):
      qla2xxx: Properly set the return value in qla2xxx_eh_abort function.

Swen Schillig (4):
      zfcp: Prevent usage w/o holding a reference
      zfcp: No ERP escalation on gpn_ft eval
      zfcp: Correct false abort data assignment.
      zfcp: Fix common FCP request reception

and the diffstat:

 block/bsg.c                        |    8 ++++++++
 drivers/s390/scsi/zfcp_erp.c       |   11 ++++++++---
 drivers/s390/scsi/zfcp_fsf.c       |   11 ++++++-----
 drivers/s390/scsi/zfcp_scsi.c      |    7 ++-----
 drivers/scsi/hpsa.c                |    8 +-------
 drivers/scsi/osd/osd_initiator.c   |    4 ++--
 drivers/scsi/pmcraid.c             |    4 +++-
 drivers/scsi/pmcraid.h             |    6 ++----
 drivers/scsi/qla2xxx/qla_def.h     |    1 -
 drivers/scsi/qla2xxx/qla_iocb.c    |    1 +
 drivers/scsi/qla2xxx/qla_isr.c     |    5 +++--
 drivers/scsi/qla2xxx/qla_nx.c      |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |    3 ++-
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 drivers/scsi/scsi_error.c          |   26 ++------------------------
 drivers/scsi/scsi_lib.c            |    5 -----
 16 files changed, 43 insertions(+), 62 deletions(-)

With the full diff below.

James

---

diff --git a/block/bsg.c b/block/bsg.c
index f20d6a7..0c8b64a 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -250,6 +250,14 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 	int ret, rw;
 	unsigned int dxfer_len;
 	void *dxferp = NULL;
+	struct bsg_class_device *bcd = &q->bsg_dev;
+
+	/* if the LLD has been removed then the bsg_unregister_queue will
+	 * eventually be called and the class_dev was freed, so we can no
+	 * longer use this request_queue. Return no such address.
+	 */
+	if (!bcd->class_dev)
+		return ERR_PTR(-ENXIO);
 
 	dprintk("map hdr %llx/%u %llx/%u\n", (unsigned long long) hdr->dout_xferp,
 		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index d37c733..0bcd580 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -156,6 +156,8 @@ static int zfcp_erp_required_act(int want, struct zfcp_adapter *adapter,
 		if (!(a_status & ZFCP_STATUS_COMMON_RUNNING) ||
 		      a_status & ZFCP_STATUS_COMMON_ERP_FAILED)
 			return 0;
+		if (p_status & ZFCP_STATUS_COMMON_NOESC)
+			return need;
 		if (!(a_status & ZFCP_STATUS_COMMON_UNBLOCKED))
 			need = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
 		/* fall through */
@@ -188,6 +190,9 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
 				&zfcp_sdev->status);
 		erp_action = &zfcp_sdev->erp_action;
+		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
+		erp_action->port = port;
+		erp_action->sdev = sdev;
 		if (!(atomic_read(&zfcp_sdev->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
@@ -200,6 +205,8 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		zfcp_erp_action_dismiss_port(port);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
+		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
+		erp_action->port = port;
 		if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
@@ -209,6 +216,7 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		zfcp_erp_action_dismiss_adapter(adapter);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
 		erp_action = &adapter->erp_action;
+		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
@@ -218,10 +226,7 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		return NULL;
 	}
 
-	memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 	erp_action->adapter = adapter;
-	erp_action->port = port;
-	erp_action->sdev = sdev;
 	erp_action->action = need;
 	erp_action->status = act_status;
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index be03174..2eb7dd5 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -851,7 +851,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	req->data = zfcp_sdev;
+	req->data = sdev;
 	req->handler = zfcp_fsf_abort_fcp_command_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
@@ -2069,8 +2069,6 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 	struct fcp_resp_with_ext *fcp_rsp;
 	unsigned long flags;
 
-	zfcp_fsf_fcp_handler_common(req);
-
 	read_lock_irqsave(&req->adapter->abort_lock, flags);
 
 	scpnt = req->data;
@@ -2079,6 +2077,8 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 		return;
 	}
 
+	zfcp_fsf_fcp_handler_common(req);
+
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
 		goto skip_fsfstatus;
@@ -2170,12 +2170,13 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
 	struct fsf_qtcb_bottom_io *io;
+	unsigned long flags;
 
 	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
-	spin_lock(&qdio->req_q_lock);
+	spin_lock_irqsave(&qdio->req_q_lock, flags);
 	if (atomic_read(&qdio->req_q_free) <= 0) {
 		atomic_inc(&qdio->req_q_full);
 		goto out;
@@ -2239,7 +2240,7 @@ failed_scsi_cmnd:
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
-	spin_unlock(&qdio->req_q_lock);
+	spin_unlock_irqrestore(&qdio->req_q_lock, flags);
 	return retval;
 }
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 6bd2dbc..63529ed 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -76,8 +76,8 @@ static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 	scpnt->scsi_done(scpnt);
 }
 
-static int zfcp_scsi_queuecommand_lck(struct scsi_cmnd *scpnt,
-				  void (*done) (struct scsi_cmnd *))
+static
+int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
@@ -87,7 +87,6 @@ static int zfcp_scsi_queuecommand_lck(struct scsi_cmnd *scpnt,
 	/* reset the status for this request */
 	scpnt->result = 0;
 	scpnt->host_scribble = NULL;
-	scpnt->scsi_done = done;
 
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
@@ -127,8 +126,6 @@ static int zfcp_scsi_queuecommand_lck(struct scsi_cmnd *scpnt,
 	return ret;
 }
 
-static DEF_SCSI_QCMD(zfcp_scsi_queuecommand)
-
 static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b2fb2b2..a6dea08 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -90,11 +90,7 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
-#define PCI_DEVICE_ID_HP_CISSF 0x333f
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
-	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
-	{PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
+	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
@@ -113,8 +109,6 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3233103C, "StorageWorks P1210m", &SA5_access},
-	{0x333F103C, "StorageWorks P1210m", &SA5_access},
 	{0x3250103C, "Smart Array", &SA5_access},
 	{0x3250113C, "Smart Array", &SA5_access},
 	{0x3250123C, "Smart Array", &SA5_access},
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0433ea6..b37c8a3 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -951,8 +951,8 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	/* create a bio for continuation segment */
 	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
 			   GFP_KERNEL);
-	if (unlikely(!bio))
-		return -ENOMEM;
+	if (IS_ERR(bio))
+		return PTR_ERR(bio);
 
 	bio->bi_rw |= REQ_WRITE;
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5e76a62..300d59f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -62,6 +62,7 @@
 static unsigned int pmcraid_debug_log;
 static unsigned int pmcraid_disable_aen;
 static unsigned int pmcraid_log_level = IOASC_LOG_LEVEL_MUST;
+static unsigned int pmcraid_enable_msix;
 
 /*
  * Data structures to support multiple adapters by the LLD.
@@ -4691,7 +4692,8 @@ pmcraid_register_interrupt_handler(struct pmcraid_instance *pinstance)
 	int rc;
 	struct pci_dev *pdev = pinstance->pdev;
 
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+	if ((pmcraid_enable_msix) &&
+		(pci_find_capability(pdev, PCI_CAP_ID_MSIX))) {
 		int num_hrrq = PMCRAID_NUM_MSIX_VECTORS;
 		struct msix_entry entries[PMCRAID_NUM_MSIX_VECTORS];
 		int i;
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 1134279..4db210d 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -42,7 +42,7 @@
  */
 #define PMCRAID_DRIVER_NAME		"PMC MaxRAID"
 #define PMCRAID_DEVFILE			"pmcsas"
-#define PMCRAID_DRIVER_VERSION		"2.0.3"
+#define PMCRAID_DRIVER_VERSION		"1.0.3"
 #define PMCRAID_DRIVER_DATE		__DATE__
 
 #define PMCRAID_FW_VERSION_1		0x002
@@ -333,11 +333,9 @@ struct pmcraid_config_table_entry {
 	__u8  lun[PMCRAID_LUN_LEN];
 } __attribute__((packed, aligned(4)));
 
-/* extended configuration table sizes are of 64 bytes in size */
-#define PMCRAID_CFGTE_EXT_SIZE	32
+/* extended configuration table sizes are also of 32 bytes in size */
 struct pmcraid_config_table_entry_ext {
 	struct pmcraid_config_table_entry cfgte;
-	__u8  cfgte_ext[PMCRAID_CFGTE_EXT_SIZE];
 };
 
 /* resource types (config_table_entry.resource_type values) */
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3a22eff..9ce539d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2409,7 +2409,6 @@ struct qla_hw_data {
 		uint32_t	enable_target_reset	:1;
 		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_led_scheme	:1;
-		uint32_t	inta_enabled		:1;
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5f94430..4c1ba62 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1061,6 +1061,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		fcp_cmnd->additional_cdb_len |= 2;
 
 	int_to_scsilun(sp->cmd->device->lun, &fcp_cmnd->lun);
+	host_to_fcp_swap((uint8_t *)&fcp_cmnd->lun, sizeof(fcp_cmnd->lun));
 	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
 	cmd_pkt->fcp_cmnd_dseg_address[0] = cpu_to_le32(
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1f06ddd..7f77898 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2491,14 +2491,15 @@ skip_msix:
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
+	    ha->flags.msi_enabled ? 0 : IRQF_SHARED,
+	    QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    ha->pdev->irq);
 		goto fail;
 	}
-	ha->flags.inta_enabled = 1;
+
 clear_risc_ints:
 
 	/*
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 8d9edfb..ae2acac 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2749,6 +2749,7 @@ sufficient_dsds:
 			goto queuing_error_fcp_cmnd;
 
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
 		/* build FCP_CMND IU */
 		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1644eab..2c0876c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -829,7 +829,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret;
+	int ret = SUCCESS;
 	unsigned int id, lun;
 	unsigned long flags;
 	int wait = 0;
@@ -2064,6 +2064,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_82XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla82xx_isp_ops;
 		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 8edbccb..cf0075a 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.04-k0"
+#define QLA2XXX_VERSION      "8.03.05-k0"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	4
+#define QLA_DRIVER_PATCH_VER	5
 #define QLA_DRIVER_BETA_VER	0
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 824b8fc..30ac116 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -615,7 +615,7 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
-static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
+static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
 	if (!scmd->device->host->hostt->eh_abort_handler)
 		return FAILED;
@@ -623,31 +623,9 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 	return scmd->device->host->hostt->eh_abort_handler(scmd);
 }
 
-/**
- * scsi_try_to_abort_cmd - Ask host to abort a running command.
- * @scmd:	SCSI cmd to abort from Lower Level.
- *
- * Notes:
- *    This function will not return until the user's completion function
- *    has been called.  there is no timeout on this operation.  if the
- *    author of the low-level driver wishes this operation to be timed,
- *    they can provide this facility themselves.  helper functions in
- *    scsi_error.c can be supplied to make this easier to do.
- */
-static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
-{
-	/*
-	 * scsi_done was called just after the command timed out and before
-	 * we had a chance to process it. (db)
-	 */
-	if (scmd->serial_number == 0)
-		return SUCCESS;
-	return __scsi_try_to_abort_cmd(scmd);
-}
-
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
-	if (__scsi_try_to_abort_cmd(scmd) != SUCCESS)
+	if (scsi_try_to_abort_cmd(scmd) != SUCCESS)
 		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
 			if (scsi_try_target_reset(scmd) != SUCCESS)
 				if (scsi_try_bus_reset(scmd) != SUCCESS)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..5b6bbae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1403,11 +1403,6 @@ static void scsi_softirq_done(struct request *rq)
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
-	/*
-	 * Set the serial numbers back to zero
-	 */
-	cmd->serial_number = 0;
-
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);


