From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.14-rc6
Date: Fri, 27 Oct 2017 16:02:52 +0200
Message-ID: <1509112972.3315.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Six fixes for mostly minor issues, most of which have small race
windows for occurring.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: Suppress a kernel warning in case the prep function returns BLKPREP_DEFER

Ben Hutchings (1):
      scsi: sg: Re-fix off by one in sg_fill_request_table()

Christos Gkekas (1):
      scsi: hpsa: Fix configured_logical_drive_count·check

Himanshu Madhani (1):
      scsi: qla2xxx: Initialize Work element before requesting IRQs

Raghava Aditya Renukunta (1):
      scsi: aacraid: Fix controller initialization failure

Steffen Maier (1):
      scsi: zfcp: fix erp_action use-before-initialize in REC action trace

And the diffstat:

 drivers/s390/scsi/zfcp_aux.c    |  5 +++++
 drivers/s390/scsi/zfcp_erp.c    | 18 +++++++++++-------
 drivers/s390/scsi/zfcp_scsi.c   |  5 +++++
 drivers/scsi/aacraid/comminit.c |  8 +++++---
 drivers/scsi/aacraid/linit.c    |  7 ++++++-
 drivers/scsi/hpsa.c             |  2 +-
 drivers/scsi/qla2xxx/qla_os.c   |  4 ++--
 drivers/scsi/scsi_lib.c         |  8 +-------
 drivers/scsi/sg.c               |  2 +-
 9 files changed, 37 insertions(+), 22 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 82ac331d9125..84752152d41f 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -357,6 +357,8 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	adapter->next_port_scan = jiffies;
 
+	adapter->erp_action.adapter = adapter;
+
 	if (zfcp_qdio_setup(adapter))
 		goto failed;
 
@@ -513,6 +515,9 @@ struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *adapter, u64 wwpn,
 	port->dev.groups = zfcp_port_attr_groups;
 	port->dev.release = zfcp_port_release;
 
+	port->erp_action.adapter = adapter;
+	port->erp_action.port = port;
+
 	if (dev_set_name(&port->dev, "0x%016llx", (unsigned long long)wwpn)) {
 		kfree(port);
 		goto err_out;
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 37408f5f81ce..ec2532ee1822 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -193,9 +193,8 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		atomic_or(ZFCP_STATUS_COMMON_ERP_INUSE,
 				&zfcp_sdev->status);
 		erp_action = &zfcp_sdev->erp_action;
-		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
-		erp_action->port = port;
-		erp_action->sdev = sdev;
+		WARN_ON_ONCE(erp_action->port != port);
+		WARN_ON_ONCE(erp_action->sdev != sdev);
 		if (!(atomic_read(&zfcp_sdev->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
@@ -208,8 +207,8 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		zfcp_erp_action_dismiss_port(port);
 		atomic_or(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
-		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
-		erp_action->port = port;
+		WARN_ON_ONCE(erp_action->port != port);
+		WARN_ON_ONCE(erp_action->sdev != NULL);
 		if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
@@ -219,7 +218,8 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		zfcp_erp_action_dismiss_adapter(adapter);
 		atomic_or(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
 		erp_action = &adapter->erp_action;
-		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
+		WARN_ON_ONCE(erp_action->port != NULL);
+		WARN_ON_ONCE(erp_action->sdev != NULL);
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
@@ -229,7 +229,11 @@ static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 		return NULL;
 	}
 
-	erp_action->adapter = adapter;
+	WARN_ON_ONCE(erp_action->adapter != adapter);
+	memset(&erp_action->list, 0, sizeof(erp_action->list));
+	memset(&erp_action->timer, 0, sizeof(erp_action->timer));
+	erp_action->step = ZFCP_ERP_STEP_UNINITIALIZED;
+	erp_action->fsf_req_id = 0;
 	erp_action->action = need;
 	erp_action->status = act_status;
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index ec3ddd1d31d5..6cf8732627e0 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -115,10 +115,15 @@ static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
 	struct zfcp_unit *unit;
 	int npiv = adapter->connection_features & FSF_FEATURE_NPIV_MODE;
 
+	zfcp_sdev->erp_action.adapter = adapter;
+	zfcp_sdev->erp_action.sdev = sdev;
+
 	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
 	if (!port)
 		return -ENXIO;
 
+	zfcp_sdev->erp_action.port = port;
+
 	unit = zfcp_unit_find(port, zfcp_scsi_dev_lun(sdev));
 	if (unit)
 		put_device(&unit->dev);
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 97d269f16888..1bc623ad3faf 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -302,9 +302,11 @@ int aac_send_shutdown(struct aac_dev * dev)
 		return -ENOMEM;
 	aac_fib_init(fibctx);
 
-	mutex_lock(&dev->ioctl_mutex);
-	dev->adapter_shutdown = 1;
-	mutex_unlock(&dev->ioctl_mutex);
+	if (!dev->adapter_shutdown) {
+		mutex_lock(&dev->ioctl_mutex);
+		dev->adapter_shutdown = 1;
+		mutex_unlock(&dev->ioctl_mutex);
+	}
 
 	cmd = (struct aac_close *) fib_data(fibctx);
 	cmd->command = cpu_to_le32(VM_CloseAll);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 62beb2596466..c9252b138c1f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1551,8 +1551,9 @@ static void __aac_shutdown(struct aac_dev * aac)
 {
 	int i;
 
+	mutex_lock(&aac->ioctl_mutex);
 	aac->adapter_shutdown = 1;
-	aac_send_shutdown(aac);
+	mutex_unlock(&aac->ioctl_mutex);
 
 	if (aac->aif_thread) {
 		int i;
@@ -1565,7 +1566,11 @@ static void __aac_shutdown(struct aac_dev * aac)
 		}
 		kthread_stop(aac->thread);
 	}
+
+	aac_send_shutdown(aac);
+
 	aac_adapter_disable_int(aac);
+
 	if (aac_is_src(aac)) {
 		if (aac->max_msix > 1) {
 			for (i = 0; i < aac->max_msix; i++) {
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9abe81021484..4ed3d26ffdde 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4091,7 +4091,7 @@ static int hpsa_set_local_logical_count(struct ctlr_info *h,
 	memset(id_ctlr, 0, sizeof(*id_ctlr));
 	rc = hpsa_bmic_id_controller(h, id_ctlr, sizeof(*id_ctlr));
 	if (!rc)
-		if (id_ctlr->configured_logical_drive_count < 256)
+		if (id_ctlr->configured_logical_drive_count < 255)
 			*nlocals = id_ctlr->configured_logical_drive_count;
 		else
 			*nlocals = le16_to_cpu(
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 937209805baf..3bd956d3bc5d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3061,6 +3061,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->max_cmd_len, host->max_channel, host->max_lun,
 	    host->transportt, sht->vendor_id);
 
+	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
+
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
@@ -3175,8 +3177,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
-	INIT_WORK(&base_vha->iocb_work, qla2x00_iocb_work_fn);
-
 	if (ha->mqenable) {
 		bool mq = false;
 		bool startit = false;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..ad3ea24f0885 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1379,8 +1379,6 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 
 	ret = scsi_setup_cmnd(sdev, req);
 out:
-	if (ret != BLKPREP_OK)
-		cmd->flags &= ~SCMD_INITIALIZED;
 	return scsi_prep_return(q, req, ret);
 }
 
@@ -1900,7 +1898,6 @@ static int scsi_mq_prep_fn(struct request *req)
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
 	struct scatterlist *sg;
-	int ret;
 
 	scsi_init_command(sdev, cmd);
 
@@ -1934,10 +1931,7 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	blk_mq_start_request(req);
 
-	ret = scsi_setup_cmnd(sdev, req);
-	if (ret != BLK_STS_OK)
-		cmd->flags &= ~SCMD_INITIALIZED;
-	return ret;
+	return scsi_setup_cmnd(sdev, req);
 }
 
 static void scsi_mq_done(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0419c2298eab..aa28874e8fb9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -837,7 +837,7 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
 
 	val = 0;
 	list_for_each_entry(srp, &sfp->rq_list, entry) {
-		if (val > SG_MAX_QUEUE)
+		if (val >= SG_MAX_QUEUE)
 			break;
 		rinfo[val].req_state = srp->done + 1;
 		rinfo[val].problem =
