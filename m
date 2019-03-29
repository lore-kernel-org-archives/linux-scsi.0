From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.1-rc2
Date: Fri, 29 Mar 2019 12:27:50 -0700
Message-ID: <1553887670.2911.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

13 Fixes, 7 of which are for IBM fibre channel and three additional for
fairly serious bugs in drivers (qla2xxx, mpt3sas, aacraid).  Of the
three core fixes, the most significant is probably the missed run queue
causing an indefinite hang.  The others are fixing a potential use
after free on device close and silencing an incorrect warning.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: sd: Fix a race between closing an sd device and sd I/O

Dave Carroll (1):
      scsi: aacraid: Insure we don't access PCIe space during AER/EEH

Kangjie Lu (1):
      scsi: qla4xxx: fix a potential NULL pointer dereference

Martin K. Petersen (1):
      scsi: sd: Quiesce warning if device does not report optimal I/O size

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during expander reset

Steffen Maier (3):
      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RSCN
      scsi: zfcp: fix scsi_eh host reset with port_forced ERP for non-NPIV FCP devices
      scsi: zfcp: fix rport unblock if deleted SCSI devices on Scsi_Host

Tyrel Datwyler (4):
      scsi: ibmvfc: Clean up transport events
      scsi: ibmvfc: Byte swap status and error codes when logging
      scsi: ibmvfc: Add failed PRLI to cmd_status lookup array
      scsi: ibmvfc: Remove "failed" from logged errors

zhengbin (1):
      scsi: core: Run queue when state is set to running after being blocked

And the diffstat:

 drivers/s390/scsi/zfcp_erp.c         | 17 ++++++++++++++++
 drivers/s390/scsi/zfcp_ext.h         |  2 ++
 drivers/s390/scsi/zfcp_fc.c          | 21 +++++++++++++++----
 drivers/s390/scsi/zfcp_scsi.c        |  4 ++++
 drivers/scsi/aacraid/aacraid.h       |  7 ++++++-
 drivers/scsi/aacraid/commsup.c       |  4 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c       | 39 ++++++++++++++++++++----------------
 drivers/scsi/ibmvscsi/ibmvfc.h       |  7 ++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  6 ++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 12 +++++++++++
 drivers/scsi/qla4xxx/ql4_os.c        |  2 ++
 drivers/scsi/scsi_sysfs.c            |  6 ++++++
 drivers/scsi/sd.c                    | 22 ++++++++++++++------
 13 files changed, 118 insertions(+), 31 deletions(-)

With full diff below.

James

---

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 744a64680d5b..e8fc28dba8df 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -624,6 +624,20 @@ static void zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
 	add_timer(&erp_action->timer);
 }
 
+void zfcp_erp_port_forced_reopen_all(struct zfcp_adapter *adapter,
+				     int clear, char *dbftag)
+{
+	unsigned long flags;
+	struct zfcp_port *port;
+
+	write_lock_irqsave(&adapter->erp_lock, flags);
+	read_lock(&adapter->port_list_lock);
+	list_for_each_entry(port, &adapter->port_list, list)
+		_zfcp_erp_port_forced_reopen(port, clear, dbftag);
+	read_unlock(&adapter->port_list_lock);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
+}
+
 static void _zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter,
 				      int clear, char *dbftag)
 {
@@ -1341,6 +1355,9 @@ static void zfcp_erp_try_rport_unblock(struct zfcp_port *port)
 		struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);
 		int lun_status;
 
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL)
+			continue;
 		if (zsdev->port != port)
 			continue;
 		/* LUN under port of interest */
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 3fce47b0b21b..c6acca521ffe 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -70,6 +70,8 @@ extern void zfcp_erp_port_reopen(struct zfcp_port *port, int clear,
 				 char *dbftag);
 extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *);
 extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *);
+extern void zfcp_erp_port_forced_reopen_all(struct zfcp_adapter *adapter,
+					    int clear, char *dbftag);
 extern void zfcp_erp_set_lun_status(struct scsi_device *, u32);
 extern void zfcp_erp_clear_lun_status(struct scsi_device *, u32);
 extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *);
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index db00b5e3abbe..33eddb02ee30 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -239,10 +239,6 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 	list_for_each_entry(port, &adapter->port_list, list) {
 		if ((port->d_id & range) == (ntoh24(page->rscn_fid) & range))
 			zfcp_fc_test_link(port);
-		if (!port->d_id)
-			zfcp_erp_port_reopen(port,
-					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "fcrscn1");
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
@@ -250,6 +246,7 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 {
 	struct fsf_status_read_buffer *status_buffer = (void *)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fc_els_rscn *head;
 	struct fc_els_rscn_page *page;
 	u16 i;
@@ -263,6 +260,22 @@ static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 	no_entries = be16_to_cpu(head->rscn_plen) /
 		sizeof(struct fc_els_rscn_page);
 
+	if (no_entries > 1) {
+		/* handle failed ports */
+		unsigned long flags;
+		struct zfcp_port *port;
+
+		read_lock_irqsave(&adapter->port_list_lock, flags);
+		list_for_each_entry(port, &adapter->port_list, list) {
+			if (port->d_id)
+				continue;
+			zfcp_erp_port_reopen(port,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     "fcrscn1");
+		}
+		read_unlock_irqrestore(&adapter->port_list_lock, flags);
+	}
+
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
 		page++;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index f4f6a07c5222..221d0dfb8493 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -368,6 +368,10 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	int ret = SUCCESS, fc_ret;
 
+	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
+		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
+		zfcp_erp_wait(adapter);
+	}
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
 	fc_ret = fc_block_scsi_eh(scpnt);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 1df5171594b8..11fb68d7e60d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2640,9 +2640,14 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 	return capacity;
 }
 
+static inline int aac_pci_offline(struct aac_dev *dev)
+{
+	return pci_channel_offline(dev->pdev) || dev->handle_pci_error;
+}
+
 static inline int aac_adapter_check_health(struct aac_dev *dev)
 {
-	if (unlikely(pci_channel_offline(dev->pdev)))
+	if (unlikely(aac_pci_offline(dev)))
 		return -1;
 
 	return (dev)->a_ops.adapter_check_health(dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index e67e032936ef..78430a7b294c 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -672,7 +672,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					return -ETIMEDOUT;
 				}
 
-				if (unlikely(pci_channel_offline(dev->pdev)))
+				if (unlikely(aac_pci_offline(dev)))
 					return -EFAULT;
 
 				if ((blink = aac_adapter_check_health(dev)) > 0) {
@@ -772,7 +772,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
-		if (unlikely(pci_channel_offline(dev->pdev)))
+		if (unlikely(aac_pci_offline(dev)))
 			return -EFAULT;
 
 		fibptr->flags |= FIB_CONTEXT_FLAG_WAIT;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index dbaa4f131433..3ad997ac3510 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -139,6 +139,7 @@ static const struct {
 	{ IBMVFC_FC_FAILURE, IBMVFC_VENDOR_SPECIFIC, DID_ERROR, 1, 1, "vendor specific" },
 
 	{ IBMVFC_FC_SCSI_ERROR, 0, DID_OK, 1, 0, "SCSI error" },
+	{ IBMVFC_FC_SCSI_ERROR, IBMVFC_COMMAND_FAILED, DID_ERROR, 0, 1, "PRLI to device failed." },
 };
 
 static void ibmvfc_npiv_login(struct ibmvfc_host *);
@@ -1494,9 +1495,9 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt)
 	if (rsp->flags & FCP_RSP_LEN_VALID)
 		rsp_code = rsp->data.info.rsp_code;
 
-	scmd_printk(KERN_ERR, cmnd, "Command (%02X) failed: %s (%x:%x) "
+	scmd_printk(KERN_ERR, cmnd, "Command (%02X) : %s (%x:%x) "
 		    "flags: %x fcp_rsp: %x, resid=%d, scsi_status: %x\n",
-		    cmnd->cmnd[0], err, vfc_cmd->status, vfc_cmd->error,
+		    cmnd->cmnd[0], err, be16_to_cpu(vfc_cmd->status), be16_to_cpu(vfc_cmd->error),
 		    rsp->flags, rsp_code, scsi_get_resid(cmnd), rsp->scsi_status);
 }
 
@@ -2022,7 +2023,7 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 		sdev_printk(KERN_ERR, sdev, "%s reset failed: %s (%x:%x) "
 			    "flags: %x fcp_rsp: %x, scsi_status: %x\n", desc,
 			    ibmvfc_get_cmd_error(be16_to_cpu(rsp_iu.cmd.status), be16_to_cpu(rsp_iu.cmd.error)),
-			    rsp_iu.cmd.status, rsp_iu.cmd.error, fc_rsp->flags, rsp_code,
+			    be16_to_cpu(rsp_iu.cmd.status), be16_to_cpu(rsp_iu.cmd.error), fc_rsp->flags, rsp_code,
 			    fc_rsp->scsi_status);
 		rsp_rc = -EIO;
 	} else
@@ -2381,7 +2382,7 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 		sdev_printk(KERN_ERR, sdev, "Abort failed: %s (%x:%x) "
 			    "flags: %x fcp_rsp: %x, scsi_status: %x\n",
 			    ibmvfc_get_cmd_error(be16_to_cpu(rsp_iu.cmd.status), be16_to_cpu(rsp_iu.cmd.error)),
-			    rsp_iu.cmd.status, rsp_iu.cmd.error, fc_rsp->flags, rsp_code,
+			    be16_to_cpu(rsp_iu.cmd.status), be16_to_cpu(rsp_iu.cmd.error), fc_rsp->flags, rsp_code,
 			    fc_rsp->scsi_status);
 		rsp_rc = -EIO;
 	} else
@@ -2755,16 +2756,18 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
 		if (crq->format == IBMVFC_PARTITION_MIGRATED) {
 			/* We need to re-setup the interpartition connection */
-			dev_info(vhost->dev, "Re-enabling adapter\n");
+			dev_info(vhost->dev, "Partition migrated, Re-enabling adapter\n");
 			vhost->client_migrated = 1;
 			ibmvfc_purge_requests(vhost, DID_REQUEUE);
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_REENABLE);
-		} else {
-			dev_err(vhost->dev, "Virtual adapter failed (rc=%d)\n", crq->format);
+		} else if (crq->format == IBMVFC_PARTNER_FAILED || crq->format == IBMVFC_PARTNER_DEREGISTER) {
+			dev_err(vhost->dev, "Host partner adapter deregistered or failed (rc=%d)\n", crq->format);
 			ibmvfc_purge_requests(vhost, DID_ERROR);
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_RESET);
+		} else {
+			dev_err(vhost->dev, "Received unknown transport event from partner (rc=%d)\n", crq->format);
 		}
 		return;
 	case IBMVFC_CRQ_CMD_RSP:
@@ -3348,7 +3351,7 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 
 		tgt_log(tgt, level, "Process Login failed: %s (%x:%x) rc=0x%02X\n",
 			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
-			rsp->status, rsp->error, status);
+			be16_to_cpu(rsp->status), be16_to_cpu(rsp->error), status);
 		break;
 	}
 
@@ -3446,9 +3449,10 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 			ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 
 		tgt_log(tgt, level, "Port Login failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
-			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)), rsp->status, rsp->error,
-			ibmvfc_get_fc_type(be16_to_cpu(rsp->fc_type)), rsp->fc_type,
-			ibmvfc_get_ls_explain(be16_to_cpu(rsp->fc_explain)), rsp->fc_explain, status);
+			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
+					     be16_to_cpu(rsp->status), be16_to_cpu(rsp->error),
+			ibmvfc_get_fc_type(be16_to_cpu(rsp->fc_type)), be16_to_cpu(rsp->fc_type),
+			ibmvfc_get_ls_explain(be16_to_cpu(rsp->fc_explain)), be16_to_cpu(rsp->fc_explain), status);
 		break;
 	}
 
@@ -3619,7 +3623,7 @@ static void ibmvfc_tgt_adisc_done(struct ibmvfc_event *evt)
 		fc_explain = (be32_to_cpu(mad->fc_iu.response[1]) & 0x0000ff00) >> 8;
 		tgt_info(tgt, "ADISC failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
 			 ibmvfc_get_cmd_error(be16_to_cpu(mad->iu.status), be16_to_cpu(mad->iu.error)),
-			 mad->iu.status, mad->iu.error,
+			 be16_to_cpu(mad->iu.status), be16_to_cpu(mad->iu.error),
 			 ibmvfc_get_fc_type(fc_reason), fc_reason,
 			 ibmvfc_get_ls_explain(fc_explain), fc_explain, status);
 		break;
@@ -3831,9 +3835,10 @@ static void ibmvfc_tgt_query_target_done(struct ibmvfc_event *evt)
 
 		tgt_log(tgt, level, "Query Target failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
 			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
-			rsp->status, rsp->error, ibmvfc_get_fc_type(be16_to_cpu(rsp->fc_type)),
-			rsp->fc_type, ibmvfc_get_gs_explain(be16_to_cpu(rsp->fc_explain)),
-			rsp->fc_explain, status);
+			be16_to_cpu(rsp->status), be16_to_cpu(rsp->error),
+			ibmvfc_get_fc_type(be16_to_cpu(rsp->fc_type)), be16_to_cpu(rsp->fc_type),
+			ibmvfc_get_gs_explain(be16_to_cpu(rsp->fc_explain)), be16_to_cpu(rsp->fc_explain),
+			status);
 		break;
 	}
 
@@ -3959,7 +3964,7 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 		level += ibmvfc_retry_host_init(vhost);
 		ibmvfc_log(vhost, level, "Discover Targets failed: %s (%x:%x)\n",
 			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
-			   rsp->status, rsp->error);
+			   be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
@@ -4024,7 +4029,7 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_event *evt)
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
 		ibmvfc_log(vhost, level, "NPIV Login failed: %s (%x:%x)\n",
 			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
-						rsp->status, rsp->error);
+						be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
 		ibmvfc_free_event(evt);
 		return;
 	case IBMVFC_MAD_CRQ_ERROR:
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index b81a53c4a9a8..459cc288ba1d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -78,9 +78,14 @@ enum ibmvfc_crq_valid {
 	IBMVFC_CRQ_XPORT_EVENT		= 0xFF,
 };
 
-enum ibmvfc_crq_format {
+enum ibmvfc_crq_init_msg {
 	IBMVFC_CRQ_INIT			= 0x01,
 	IBMVFC_CRQ_INIT_COMPLETE	= 0x02,
+};
+
+enum ibmvfc_crq_xport_evts {
+	IBMVFC_PARTNER_FAILED		= 0x01,
+	IBMVFC_PARTNER_DEREGISTER	= 0x02,
 	IBMVFC_PARTITION_MIGRATED	= 0x06,
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e57774472e75..1d8c584ec1e9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3281,12 +3281,18 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 
 	if (smid < ioc->hi_priority_smid) {
 		struct scsiio_tracker *st;
+		void *request;
 
 		st = _get_st_from_smid(ioc, smid);
 		if (!st) {
 			_base_recovery_check(ioc);
 			return;
 		}
+
+		/* Clear MPI request frame */
+		request = mpt3sas_base_get_msg_frame(ioc, smid);
+		memset(request, 0, ioc->request_sz);
+
 		mpt3sas_base_clear_st(ioc, st);
 		_base_recovery_check(ioc);
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 8bb5b8f9f4d2..1ccfbc7eebe0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1462,11 +1462,23 @@ mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	struct scsi_cmnd *scmd = NULL;
 	struct scsiio_tracker *st;
+	Mpi25SCSIIORequest_t *mpi_request;
 
 	if (smid > 0  &&
 	    smid <= ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT) {
 		u32 unique_tag = smid - 1;
 
+		mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+
+		/*
+		 * If SCSI IO request is outstanding at driver level then
+		 * DevHandle filed must be non-zero. If DevHandle is zero
+		 * then it means that this smid is free at driver level,
+		 * so return NULL.
+		 */
+		if (!mpi_request->DevHandle)
+			return scmd;
+
 		scmd = scsi_host_find_tag(ioc->shost, unique_tag);
 		if (scmd) {
 			st = scsi_cmd_priv(scmd);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 16a18d5d856f..6e4f4931ae17 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3203,6 +3203,8 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
 		return -EINVAL;
 	ep = iscsi_lookup_endpoint(transport_fd);
+	if (!ep)
+		return -EINVAL;
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6a9040faed00..3b119ca0cc0c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -771,6 +771,12 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_device_set_state(sdev, state);
+	/*
+	 * If the device state changes to SDEV_RUNNING, we need to run
+	 * the queue to avoid I/O hang.
+	 */
+	if (ret == 0 && state == SDEV_RUNNING)
+		blk_mq_run_hw_queues(sdev->request_queue, true);
 	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 251db30d0882..2b2bc4b49d78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1415,11 +1415,6 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
 
-	/*
-	 * XXX and what if there are packets in flight and this close()
-	 * XXX is followed by a "rmmod sd_mod"?
-	 */
-
 	scsi_disk_put(sdkp);
 }
 
@@ -3076,6 +3071,9 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	unsigned int opt_xfer_bytes =
 		logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 
+	if (sdkp->opt_xfer_blocks == 0)
+		return false;
+
 	if (sdkp->opt_xfer_blocks > dev_max) {
 		sd_first_printk(KERN_WARNING, sdkp,
 				"Optimal transfer size %u logical blocks " \
@@ -3505,9 +3503,21 @@ static void scsi_disk_release(struct device *dev)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct gendisk *disk = sdkp->disk;
-	
+	struct request_queue *q = disk->queue;
+
 	ida_free(&sd_index_ida, sdkp->index);
 
+	/*
+	 * Wait until all requests that are in progress have completed.
+	 * This is necessary to avoid that e.g. scsi_end_request() crashes
+	 * due to clearing the disk->private_data pointer. Wait from inside
+	 * scsi_disk_release() instead of from sd_release() to avoid that
+	 * freezing and unfreezing the request queue affects user space I/O
+	 * in case multiple processes open a /dev/sd... node concurrently.
+	 */
+	blk_mq_freeze_queue(q);
+	blk_mq_unfreeze_queue(q);
+
 	disk->private_data = NULL;
 	put_disk(disk);
 	put_device(&sdkp->device->sdev_gendev);
