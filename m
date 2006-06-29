From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Fwd: Fwd: [RFC] [PATCH 3/7] requested for qla4xxx!!!
Date: Wed, 28 Jun 2006 23:50:06 -0700
Message-ID: <20060629065006.GD7220@ranandlinuxbox.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35677 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S932697AbWF2Gtq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 02:49:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: open-iscsi <open-iscsi@googlegroups.com>

ISP4xxx driver OS files.

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Doug Maxey <dwm@bubba.enoyolf.org>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
diff --git a/drivers/scsi/qla4xxx/Kconfig b/drivers/scsi/qla4xxx/Kconfig
new file mode 100644
index 0000000..6492798
--- /dev/null
+++ b/drivers/scsi/qla4xxx/Kconfig
@@ -0,0 +1,5 @@
+config SCSI_QLA_ISCSI
+	tristate "QLogic ISP4XXX host adapter family support"
+	depends on PCI && SCSI
+	---help---
+	This driver supports the QLogic 40xx (ISP4XXX) host adapter family.
diff --git a/drivers/scsi/qla4xxx/Makefile b/drivers/scsi/qla4xxx/Makefile
new file mode 100644
index 0000000..86ea37b
--- /dev/null
+++ b/drivers/scsi/qla4xxx/Makefile
@@ -0,0 +1,5 @@
+qla4xxx-y := ql4_os.o ql4_init.o ql4_mbx.o ql4_iocb.o ql4_isr.o \
+		ql4_nvram.o ql4_dbg.o
+
+obj-$(CONFIG_SCSI_QLA_ISCSI) += qla4xxx.o
+
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
new file mode 100644
index 0000000..27bc7f6
--- /dev/null
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -0,0 +1,2006 @@
+/*
+ * QLogic iSCSI HBA Driver
+ * Copyright (c)  2003-2006 QLogic Corporation
+ *
+ * See LICENSE.qla4xxx for copyright and licensing details.
+ */
+#include <linux/moduleparam.h>
+
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsicam.h>
+
+#include "ql4_def.h"
+
+/*
+ * Driver version
+ */
+char qla4xxx_version_str[40];
+
+/*
+ * SRB allocation cache
+ */
+static kmem_cache_t *srb_cachep;
+
+/*
+ * Module parameter information and variables
+ */
+int ql4xdiscoverywait = 60;
+module_param(ql4xdiscoverywait, int, S_IRUGO | S_IRUSR);
+MODULE_PARM_DESC(ql4xdiscoverywait, "Discovery wait time");
+int ql4xdontresethba = 0;
+module_param(ql4xdontresethba, int, S_IRUGO | S_IRUSR);
+MODULE_PARM_DESC(ql4xdontresethba,
+		 "Dont reset the HBA when the driver gets 0x8002 AEN "
+		 " default it will reset hba :0"
+		 " set to 1 to avoid resetting HBA");
+
+int extended_error_logging = 0; /* 0 = off, 1 = log errors */
+module_param(extended_error_logging, int, S_IRUGO | S_IRUSR);
+MODULE_PARM_DESC(extended_error_logging,
+		 "Option to enable extended error logging, "
+		 "Default is 0 - no logging, 1 - debug logging");
+
+/*
+ * SCSI host template entry points
+ */
+
+static int qla4xxx_mem_alloc(struct scsi_qla_host *ha);
+static void qla4xxx_mem_free(struct scsi_qla_host *ha);
+static void qla4xxx_timer(struct scsi_qla_host *ha);
+static void qla4xxx_do_dpc(void *data);
+static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha);
+int qla4xxx_reset_target(struct scsi_qla_host *ha,
+			 struct ddb_entry * ddb_entry);
+int qla4xxx_recover_adapter(struct scsi_qla_host *ha, uint8_t renew_ddb_list);
+void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
+
+static int qla4xxx_iospace_config(struct scsi_qla_host *ha);
+static void qla4xxx_free_adapter(struct scsi_qla_host *ha);
+
+/*
+ * iSCSI template entry points
+ */
+static int qla4xxx_tgt_dscvr(enum iscsi_tgt_dscvr type, uint32_t host_no,
+			     uint32_t enable, struct sockaddr *dst_addr);
+static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
+				  enum iscsi_param param, char *buf);
+static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
+				  enum iscsi_param param, char *buf);
+static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag);
+static int qla4xxx_conn_start(struct iscsi_cls_conn *conn);
+static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
+
+/*
+ * SCSI host template entry points
+ */
+static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
+				void (*done) (struct scsi_cmnd *));
+static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_bus_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_slave_alloc(struct scsi_device *device);
+static int qla4xxx_slave_configure(struct scsi_device *device);
+
+static struct scsi_host_template qla4xxx_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= DRIVER_NAME,
+	.proc_name		= DRIVER_NAME,
+	.queuecommand		= qla4xxx_queuecommand,
+
+	.eh_abort_handler	= qla4xxx_eh_abort,
+	.eh_device_reset_handler = qla4xxx_eh_device_reset,
+	.eh_bus_reset_handler	= qla4xxx_eh_bus_reset,
+	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
+
+	.slave_configure	= qla4xxx_slave_configure,
+	.slave_alloc		= qla4xxx_slave_alloc,
+
+	.this_id		= -1,
+	.cmd_per_lun		= 3,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.sg_tablesize		= SG_ALL,
+
+	.max_sectors		= 0xFFFF,
+};
+
+static struct iscsi_transport qla4xxx_iscsi_transport = {
+	.owner			= THIS_MODULE,
+	.name			= DRIVER_NAME,
+	.param_mask		= ISCSI_CONN_PORT |
+				  ISCSI_CONN_ADDRESS |
+				  ISCSI_TARGET_NAME |
+				  ISCSI_TPGT,
+	.sessiondata_size	= sizeof(struct ddb_entry),
+	.host_template		= &qla4xxx_driver_template,
+
+	.tgt_dscvr		= qla4xxx_tgt_dscvr,
+	.get_conn_param		= qla4xxx_conn_get_param,
+	.get_session_param	= qla4xxx_sess_get_param,
+	.start_conn		= qla4xxx_conn_start,
+	.stop_conn		= qla4xxx_conn_stop,
+	.session_recovery_timedout = qla4xxx_recovery_timedout,
+};
+
+static struct scsi_transport_template *qla4xxx_scsi_transport;
+
+static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
+{
+	struct ddb_entry *ddb_entry = session->dd_data;
+	struct scsi_qla_host *ha = ddb_entry->ha;
+
+	DEBUG2(printk("scsi%ld: %s: index [%d] port down retry count of (%d) "
+		      "secs exhausted, marking device DEAD.\n", ha->host_no,
+		      __func__, ddb_entry->fw_ddb_index,
+		      ha->port_down_retry_count));
+
+	atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
+
+	DEBUG2(printk("scsi%ld: %s: scheduling dpc routine - dpc flags = "
+		      "0x%lx\n", ha->host_no, __func__, ha->dpc_flags));
+	queue_work(ha->dpc_thread, &ha->dpc_work);
+}
+
+static int qla4xxx_conn_start(struct iscsi_cls_conn *conn)
+{
+	struct iscsi_cls_session *session;
+	struct ddb_entry *ddb_entry;
+
+	session = iscsi_dev_to_session(conn->dev.parent);
+	ddb_entry = session->dd_data;
+
+	DEBUG2(printk("scsi%ld: %s: index [%d] starting conn\n",
+		      ddb_entry->ha->host_no, __func__,
+		      ddb_entry->fw_ddb_index));
+	iscsi_unblock_session(session);
+	return 0;
+}
+
+static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag)
+{
+	struct iscsi_cls_session *session;
+	struct ddb_entry *ddb_entry;
+
+	session = iscsi_dev_to_session(conn->dev.parent);
+	ddb_entry = session->dd_data;
+
+	DEBUG2(printk("scsi%ld: %s: index [%d] stopping conn\n",
+		      ddb_entry->ha->host_no, __func__,
+		      ddb_entry->fw_ddb_index));
+	if (flag == STOP_CONN_RECOVER)
+		iscsi_block_session(session);
+	else
+		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
+}
+
+static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
+				  enum iscsi_param param, char *buf)
+{
+	struct ddb_entry *ddb_entry = sess->dd_data;
+	int len;
+
+	switch (param) {
+	case ISCSI_PARAM_TARGET_NAME:
+		len = snprintf(buf, PAGE_SIZE - 1, "%s\n",
+			       ddb_entry->iscsi_name);
+		break;
+	case ISCSI_PARAM_TPGT:
+		len = sprintf(buf, "%u\n", ddb_entry->tpgt);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+
+static int qla4xxx_conn_get_param(struct iscsi_cls_conn *conn,
+				  enum iscsi_param param, char *buf)
+{
+	struct iscsi_cls_session *session;
+	struct ddb_entry *ddb_entry;
+	int len;
+
+	session = iscsi_dev_to_session(conn->dev.parent);
+	ddb_entry = session->dd_data;
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_PORT:
+		len = sprintf(buf, "%hu\n", ddb_entry->port);
+		break;
+	case ISCSI_PARAM_CONN_ADDRESS:
+		/* TODO: what are the ipv6 bits */
+		len = sprintf(buf, "%u.%u.%u.%u\n",
+			      NIPQUAD(ddb_entry->ip_addr));
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+
+static int qla4xxx_tgt_dscvr(enum iscsi_tgt_dscvr type, uint32_t host_no,
+			     uint32_t enable, struct sockaddr *dst_addr)
+{
+	struct scsi_qla_host *ha;
+	struct Scsi_Host *shost;
+	struct sockaddr_in *addr;
+	struct sockaddr_in6 *addr6;
+	int ret = 0;
+
+	shost = scsi_host_lookup(host_no);
+	if (IS_ERR(shost)) {
+		printk(KERN_ERR "Could not find host no %u\n", host_no);
+		return -ENODEV;
+	}
+
+	ha = (struct scsi_qla_host *) shost->hostdata;
+
+	switch (type) {
+	case ISCSI_TGT_DSCVR_SEND_TARGETS:
+		if (dst_addr->sa_family == AF_INET) {
+			addr = (struct sockaddr_in *)dst_addr;
+			if (qla4xxx_send_tgts(ha, (char *)&addr->sin_addr,
+					      addr->sin_port) != QLA_SUCCESS)
+				ret = -EIO;
+		} else if (dst_addr->sa_family == AF_INET6) {
+			/*
+			 * TODO: fix qla4xxx_send_tgts
+			 */
+			addr6 = (struct sockaddr_in6 *)dst_addr;
+			if (qla4xxx_send_tgts(ha, (char *)&addr6->sin6_addr,
+					      addr6->sin6_port) != QLA_SUCCESS)
+				ret = -EIO;
+		} else
+			ret = -ENOSYS;
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	scsi_host_put(shost);
+	return ret;
+}
+
+void qla4xxx_destroy_sess(struct ddb_entry *ddb_entry)
+{
+	if (!ddb_entry->sess)
+		return;
+
+	if (ddb_entry->conn) {
+		iscsi_if_destroy_session_done(ddb_entry->conn);
+		iscsi_destroy_conn(ddb_entry->conn);
+		iscsi_remove_session(ddb_entry->sess);
+	}
+	iscsi_free_session(ddb_entry->sess);
+}
+
+int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
+{
+	int err;
+
+	err = iscsi_add_session(ddb_entry->sess, ddb_entry->fw_ddb_index);
+	if (err) {
+		DEBUG2(printk(KERN_ERR "Could not add session.\n"));
+		return err;
+	}
+
+	ddb_entry->conn = iscsi_create_conn(ddb_entry->sess, 0);
+	if (!ddb_entry->conn) {
+		iscsi_remove_session(ddb_entry->sess);
+		DEBUG2(printk(KERN_ERR "Could not add connection.\n"));
+		return -ENOMEM;
+	}
+
+	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+	iscsi_if_create_session_done(ddb_entry->conn);
+	return 0;
+}
+
+struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry;
+	struct iscsi_cls_session *sess;
+
+	sess = iscsi_alloc_session(ha->host, &qla4xxx_iscsi_transport);
+	if (!sess)
+		return NULL;
+
+	ddb_entry = sess->dd_data;
+	memset(ddb_entry, 0, sizeof(*ddb_entry));
+	ddb_entry->ha = ha;
+	ddb_entry->sess = sess;
+	return ddb_entry;
+}
+
+/*
+ * Timer routines
+ */
+
+static void qla4xxx_start_timer(struct scsi_qla_host *ha, void *func,
+				unsigned long interval)
+{
+	DEBUG(printk("scsi: %s: Starting timer thread for adapter %d\n",
+		     __func__, ha->host->host_no));
+	init_timer(&ha->timer);
+	ha->timer.expires = jiffies + interval * HZ;
+	ha->timer.data = (unsigned long)ha;
+	ha->timer.function = (void (*)(unsigned long))func;
+	add_timer(&ha->timer);
+	ha->timer_active = 1;
+}
+
+static void qla4xxx_stop_timer(struct scsi_qla_host *ha)
+{
+	del_timer_sync(&ha->timer);
+	ha->timer_active = 0;
+}
+
+/**************************************************************************
+ * qla4xxx_mark_device_missing
+ *	This routine marks a device missing and resets the relogin retry count.
+ *
+ * Input:
+ *	ha - Pointer to host adapter structure.
+ *	ddb_entry - Pointer to device database entry
+ *
+ * Returns:
+ *	None
+ *
+ **************************************************************************/
+void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
+				 struct ddb_entry *ddb_entry)
+{
+	atomic_set(&ddb_entry->state, DDB_STATE_MISSING);
+	DEBUG3(printk("scsi%d:%d:%d: index [%d] marked MISSING\n",
+		      ha->host_no, ddb_entry->bus, ddb_entry->target,
+		      ddb_entry->fw_ddb_index));
+	iscsi_conn_error(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
+}
+
+static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
+				       struct ddb_entry *ddb_entry,
+				       struct scsi_cmnd *cmd,
+				       void (*done)(struct scsi_cmnd *))
+{
+	struct srb *srb;
+
+	srb = mempool_alloc(ha->srb_mempool, GFP_ATOMIC);
+	if (!srb)
+		return srb;
+
+	atomic_set(&srb->ref_count, 1);
+	srb->ha = ha;
+	srb->ddb = ddb_entry;
+	srb->cmd = cmd;
+	srb->flags = 0;
+	cmd->SCp.ptr = (void *)srb;
+	cmd->scsi_done = done;
+
+	return srb;
+}
+
+static void qla4xxx_srb_free_dma(struct scsi_qla_host *ha, struct srb *srb)
+{
+	struct scsi_cmnd *cmd = srb->cmd;
+
+	if (srb->flags & SRB_DMA_VALID) {
+		if (cmd->use_sg) {
+			dma_unmap_sg(&ha->pdev->dev, cmd->request_buffer,
+				     cmd->use_sg, cmd->sc_data_direction);
+		} else if (cmd->request_bufflen) {
+			dma_unmap_single(&ha->pdev->dev, srb->dma_handle,
+					 cmd->request_bufflen,
+					 cmd->sc_data_direction);
+		}
+		srb->flags &= ~SRB_DMA_VALID;
+	}
+	cmd->SCp.ptr = NULL;
+}
+
+void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb)
+{
+	struct scsi_cmnd *cmd = srb->cmd;
+
+	qla4xxx_srb_free_dma(ha, srb);
+
+	mempool_free(srb, ha->srb_mempool);
+
+	cmd->scsi_done(cmd);
+}
+
+/**************************************************************************
+ * qla4xxx_queuecommand
+ *	This routine is invoked by Linux to send a SCSI command to the driver.
+ *
+ * Input:
+ *	cmd - Pointer to Linux's SCSI command structure
+ *	done_fn - Function that the driver calls to notify the SCSI mid-layer
+ *		  that the command has been processed.
+ *
+ * Remarks:
+ *    The mid-level driver tries to ensure that queuecommand never gets
+ *    invoked concurrently with itself or the interrupt handler (although
+ *    the interrupt handler may call this routine as part of request-
+ *    completion handling).   Unfortunely, it sometimes calls the scheduler
+ *    in interrupt context which is a big NO! NO!.
+ *
+ * Returns:
+ *	None
+ **************************************************************************/
+static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
+				void (*done)(struct scsi_cmnd *))
+{
+	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
+	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct srb *srb;
+	int rval;
+
+	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
+			cmd->result = DID_NO_CONNECT << 16;
+			goto qc_fail_command;
+		}
+		goto qc_host_busy;
+	}
+
+	spin_unlock_irq(ha->host->host_lock);
+
+	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
+	if (!srb)
+		goto qc_host_busy_lock;
+
+	rval = qla4xxx_send_command_to_isp(ha, srb);
+	if (rval != QLA_SUCCESS)
+		goto qc_host_busy_free_sp;
+
+	spin_lock_irq(ha->host->host_lock);
+	return 0;
+
+qc_host_busy_free_sp:
+	qla4xxx_srb_free_dma(ha, srb);
+	mempool_free(srb, ha->srb_mempool);
+
+qc_host_busy_lock:
+	spin_lock_irq(ha->host->host_lock);
+
+qc_host_busy:
+	return SCSI_MLQUEUE_HOST_BUSY;
+
+qc_fail_command:
+	done(cmd);
+
+	return 0;
+}
+
+/**************************************************************************
+ * qla4xxx_probe_adapter
+ *    This routine will probe for Qlogic 4010 iSCSI host adapters.
+ *    It returns the number of host adapters of a particular
+ *    type that were found.  It also initializes all data necessary for
+ *    the driver.  It is passed-in the host number, so that it
+ *    knows where its first entry is in the scsi_hosts[] array.
+ *
+ * Input:
+ *
+ * Returns:
+ **************************************************************************/
+static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
+					   const struct pci_device_id *ent)
+{
+	int ret = -ENODEV, status;
+	struct Scsi_Host *host;
+	struct scsi_qla_host *ha;
+	struct ddb_entry *ddb_entry, *ddbtemp;
+	uint8_t init_retry_count = 0;
+	char buf[34];
+
+	if (pci_enable_device(pdev))
+		return -1;
+
+	host = scsi_host_alloc(&qla4xxx_driver_template, sizeof(*ha));
+	if (host == NULL) {
+		printk(KERN_WARNING
+		       "qla4xxx: Couldn't allocate host from scsi layer!\n");
+		goto probe_disable_device;
+	}
+
+	/* Clear our data area */
+	ha = (struct scsi_qla_host *) host->hostdata;
+	memset(ha, 0, sizeof(*ha));
+
+	/* Save the information from PCI BIOS.	*/
+	ha->pdev = pdev;
+	ha->host = host;
+	ha->host_no = host->host_no;
+
+	/* Configure PCI I/O space. */
+	ret = qla4xxx_iospace_config(ha);
+	if (ret)
+		goto probe_failed;
+
+	ql4_printk(KERN_INFO, ha, "Found an ISP%04x, irq %d, iobase 0x%p\n",
+		   pdev->device, pdev->irq, ha->reg);
+
+	qla4xxx_config_dma_addressing(ha);
+
+	/* Initialize lists and spinlocks. */
+	INIT_LIST_HEAD(&ha->ddb_list);
+	INIT_LIST_HEAD(&ha->free_srb_q);
+
+	mutex_init(&ha->mbox_sem);
+	init_waitqueue_head(&ha->mailbox_wait_queue);
+
+	spin_lock_init(&ha->hardware_lock);
+	spin_lock_init(&ha->list_lock);
+
+	/* Allocate dma buffers */
+	if (qla4xxx_mem_alloc(ha)) {
+		ql4_printk(KERN_WARNING, ha,
+			   "[ERROR] Failed to allocate memory for adapter\n");
+
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
+
+	/*
+	 * Initialize the Host adapter request/response queues and
+	 * firmware
+	 * NOTE: interrupts enabled upon successful completion
+	 */
+	status = qla4xxx_initialize_adapter(ha, REBUILD_DDB_LIST);
+	while (status == QLA_ERROR && init_retry_count++ < MAX_INIT_RETRIES) {
+		DEBUG2(printk("scsi: %s: retrying adapter initialization "
+			      "(%d)\n", __func__, init_retry_count));
+		qla4xxx_soft_reset(ha);
+		status = qla4xxx_initialize_adapter(ha, REBUILD_DDB_LIST);
+	}
+	if (status == QLA_ERROR) {
+		ql4_printk(KERN_WARNING, ha, "Failed to initialize adapter\n");
+
+		ret = -ENODEV;
+		goto probe_failed;
+	}
+
+	host->cmd_per_lun = 3;
+	host->max_channel = 0;
+	host->max_lun = MAX_LUNS - 1;
+	host->max_id = MAX_TARGETS;
+	host->max_cmd_len = IOCB_MAX_CDB_LEN;
+	host->can_queue = REQUEST_QUEUE_DEPTH + 128;
+	host->transportt = qla4xxx_scsi_transport;
+
+	/* Startup the kernel thread for this host adapter. */
+	DEBUG2(printk("scsi: %s: Starting kernel thread for "
+		      "qla4xxx_dpc\n", __func__));
+	sprintf(buf, "qla4xxx_%lu_dpc", ha->host_no);
+	ha->dpc_thread = create_singlethread_workqueue(buf);
+	if (!ha->dpc_thread) {
+		ql4_printk(KERN_WARNING, ha, "Unable to start DPC thread!\n");
+		ret = -ENODEV;
+		goto probe_failed;
+	}
+	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc, ha);
+
+	ret = request_irq(pdev->irq, qla4xxx_intr_handler,
+			  SA_INTERRUPT|SA_SHIRQ, "qla4xxx", ha);
+	if (ret) {
+		ql4_printk(KERN_WARNING, ha,
+			   "Failed to reserve interrupt %d already in use.\n",
+			   pdev->irq);
+		goto probe_failed;
+	}
+	set_bit(AF_IRQ_ATTACHED, &ha->flags);
+	host->irq = pdev->irq;
+	DEBUG(printk("scsi%d: irq %d attached\n", ha->host_no, ha->pdev->irq));
+
+	qla4xxx_enable_intrs(ha);
+
+	/* Start timer thread. */
+	qla4xxx_start_timer(ha, qla4xxx_timer, 1);
+
+	set_bit(AF_INIT_DONE, &ha->flags);
+
+	pci_set_drvdata(pdev, ha);
+
+	ret = scsi_add_host(host, &pdev->dev);
+	if (ret)
+		goto probe_failed;
+
+	/* Update transport device information for all devices. */
+	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
+		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE)
+			if (qla4xxx_add_sess(ddb_entry))
+				goto remove_host;
+	}
+
+	printk(KERN_INFO
+	       " QLogic iSCSI HBA Driver version: %s\n"
+	       "  QLogic ISP%04x @ %s, host#=%ld, fw=%02d.%02d.%02d.%02d\n",
+	       qla4xxx_version_str, ha->pdev->device, pci_name(ha->pdev),
+	       ha->host_no, ha->firmware_version[0], ha->firmware_version[1],
+	       ha->patch_number, ha->build_number);
+
+	return 0;
+
+remove_host:
+	qla4xxx_free_ddb_list(ha);
+	scsi_remove_host(host);
+
+probe_failed:
+	qla4xxx_free_adapter(ha);
+	scsi_host_put(ha->host);
+
+probe_disable_device:
+	pci_disable_device(pdev);
+
+	return ret;
+}
+
+/**************************************************************************
+ * qla4xxx_remove_adapter
+ *
+ * Input:
+ *	pci_dev - PCI device pointer
+ *
+ * Returns:
+ **************************************************************************/
+static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
+{
+	struct scsi_qla_host *ha;
+
+	ha = pci_get_drvdata(pdev);
+
+	/* remove devs from iscsi_sessions to scsi_devices */
+	qla4xxx_free_ddb_list(ha);
+
+	scsi_remove_host(ha->host);
+
+	qla4xxx_free_adapter(ha);
+
+	scsi_host_put(ha->host);
+
+	pci_set_drvdata(pdev, NULL);
+}
+
+/**************************************************************************
+ * qla4xxx_free_adapter
+ *
+ * Input:
+ *	pci_dev - PCI device pointer
+ *
+ * Returns:
+ **************************************************************************/
+static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
+{
+
+	if (test_bit(AF_INTERRUPTS_ON, &ha->flags)) {
+		/* Turn-off interrupts on the card. */
+		qla4xxx_disable_intrs(ha);
+	}
+
+	/* Kill the kernel thread for this host */
+	if (ha->dpc_thread)
+		destroy_workqueue(ha->dpc_thread);
+
+	/* Issue Soft Reset to put firmware in unknown state */
+	qla4xxx_soft_reset(ha);
+
+	/* Remove timer thread, if present */
+	if (ha->timer_active)
+		qla4xxx_stop_timer(ha);
+
+	/* free extra memory */
+	qla4xxx_mem_free(ha);
+
+	/* Detach interrupts */
+	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
+		free_irq(ha->pdev->irq, ha);
+
+	pci_disable_device(ha->pdev);
+
+}
+
+/**************************************************************************
+ * qla4xxx_iospace_config
+ *    This routine
+ *
+ * Input:
+ *
+ * Returns:
+ **************************************************************************/
+static int qla4xxx_iospace_config(struct scsi_qla_host *ha)
+{
+	unsigned long pio, pio_len, pio_flags;
+	unsigned long mmio, mmio_len, mmio_flags;
+
+	pio = pci_resource_start(ha->pdev, 0);
+	pio_len = pci_resource_len(ha->pdev, 0);
+	pio_flags = pci_resource_flags(ha->pdev, 0);
+	if (pio_flags & IORESOURCE_IO) {
+		if (pio_len < MIN_IOBASE_LEN) {
+			ql4_printk(KERN_WARNING, ha,
+				   "Invalid PCI I/O region size (%s)...\n",
+				   pci_name(ha->pdev));
+			pio = 0;
+		}
+	} else {
+		ql4_printk(KERN_WARNING, ha,
+			   "region #0 not a PIO resource (%s)...\n",
+			   pci_name(ha->pdev));
+		pio = 0;
+	}
+
+	/* Use MMIO operations for all accesses. */
+	mmio = pci_resource_start(ha->pdev, 1);
+	mmio_len = pci_resource_len(ha->pdev, 1);
+	mmio_flags = pci_resource_flags(ha->pdev, 1);
+
+	if (!(mmio_flags & IORESOURCE_MEM)) {
+		ql4_printk(KERN_ERR, ha,
+			   "region #0 not an MMIO resource (%s), aborting\n",
+			   pci_name(ha->pdev));
+		goto iospace_error_exit;
+	}
+	if (mmio_len < MIN_IOBASE_LEN) {
+		ql4_printk(KERN_ERR, ha,
+			   "Invalid PCI mem region size (%s), aborting\n",
+			   pci_name(ha->pdev));
+		goto iospace_error_exit;
+	}
+
+	if (pci_request_regions(ha->pdev, DRIVER_NAME)) {
+		ql4_printk(KERN_WARNING, ha,
+			   "Failed to reserve PIO/MMIO regions (%s)\n",
+			   pci_name(ha->pdev));
+
+		goto iospace_error_exit;
+	}
+
+	ha->pio_address = pio;
+	ha->pio_length = pio_len;
+	ha->reg = ioremap(mmio, MIN_IOBASE_LEN);
+	if (!ha->reg) {
+		ql4_printk(KERN_ERR, ha,
+			   "cannot remap MMIO (%s), aborting\n",
+			   pci_name(ha->pdev));
+
+		goto iospace_error_exit;
+	}
+
+	return 0;
+
+iospace_error_exit:
+	return -ENOMEM;
+}
+
+/**
+ * qla4xxx_config_dma_addressing() - Configure OS DMA addressing method.
+ * @ha: HA context
+ *
+ * At exit, the @ha's flags.enable_64bit_addressing set to indicated
+ * supported addressing method.
+ */
+void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha)
+{
+	int retval;
+
+	/* Update our PCI device dma_mask for full 64 bit mask */
+	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK) == 0) {
+		if (pci_set_consistent_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
+			ql4_printk(KERN_DEBUG, ha,
+				   "Failed to set 64 bit PCI consistent mask; "
+				   "using 32 bit.\n");
+			retval = pci_set_consistent_dma_mask(ha->pdev,
+							     DMA_32BIT_MASK);
+		}
+	} else
+		retval = pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK);
+}
+
+/**************************************************************************
+ * qla4xxx_mem_alloc
+ *	This routine allocates memory use by the adapter.
+ *
+ * Input:
+ *	ha - Pointer to host adapter structure
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully allocated adapter memory
+ *	QLA_ERROR   - Failed to allocate adapter memory
+ *
+ **************************************************************************/
+static int qla4xxx_mem_alloc(struct scsi_qla_host *ha)
+{
+	unsigned long align;
+
+	/* Allocate contiguous block of DMA memory for queues. */
+	ha->queues_len = ((REQUEST_QUEUE_DEPTH * QUEUE_SIZE) +
+			  (RESPONSE_QUEUE_DEPTH * QUEUE_SIZE) +
+			  sizeof(struct shadow_regs) +
+			  MEM_ALIGN_VALUE +
+			  (PAGE_SIZE - 1)) & ~(PAGE_SIZE - 1);
+	ha->queues = dma_alloc_coherent(&ha->pdev->dev, ha->queues_len,
+					&ha->queues_dma, GFP_KERNEL);
+	if (ha->queues == NULL) {
+		ql4_printk(KERN_WARNING, ha,
+			   "Memory Allocation failed - queues.\n");
+
+		goto mem_alloc_error_exit;
+	}
+	memset(ha->queues, 0, ha->queues_len);
+
+	/*
+	 * As per RISC alignment requirements -- the bus-address must be a
+	 * multiple of the request-ring size (in bytes).
+	 */
+	align = 0;
+	if ((unsigned long)ha->queues_dma & (MEM_ALIGN_VALUE - 1))
+		align = MEM_ALIGN_VALUE - ((unsigned long)ha->queues_dma &
+					   (MEM_ALIGN_VALUE - 1));
+
+	/* Update request and response queue pointers. */
+	ha->request_dma = ha->queues_dma + align;
+	ha->request_ring = (struct queue_entry *) (ha->queues + align);
+	ha->response_dma = ha->queues_dma + align +
+		(REQUEST_QUEUE_DEPTH * QUEUE_SIZE);
+	ha->response_ring = (struct queue_entry *) (ha->queues + align +
+						    (REQUEST_QUEUE_DEPTH *
+						     QUEUE_SIZE));
+	ha->shadow_regs_dma = ha->queues_dma + align +
+		(REQUEST_QUEUE_DEPTH * QUEUE_SIZE) +
+		(RESPONSE_QUEUE_DEPTH * QUEUE_SIZE);
+	ha->shadow_regs = (struct shadow_regs *) (ha->queues + align +
+						  (REQUEST_QUEUE_DEPTH *
+						   QUEUE_SIZE) +
+						  (RESPONSE_QUEUE_DEPTH *
+						   QUEUE_SIZE));
+
+	/* Allocate memory for srb pool. */
+	ha->srb_mempool = mempool_create(SRB_MIN_REQ, mempool_alloc_slab,
+					 mempool_free_slab, srb_cachep);
+	if (ha->srb_mempool == NULL) {
+		ql4_printk(KERN_WARNING, ha,
+			   "Memory Allocation failed - SRB Pool.\n");
+
+		goto mem_alloc_error_exit;
+	}
+
+	return QLA_SUCCESS;
+
+mem_alloc_error_exit:
+	qla4xxx_mem_free(ha);
+	return QLA_ERROR;
+}
+
+/**************************************************************************
+ * qla4xxx_mem_free
+ *	This routine frees adapter allocated memory
+ *
+ * Input:
+ *	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	None
+ **************************************************************************/
+static void qla4xxx_mem_free(struct scsi_qla_host *ha)
+{
+	if (ha->queues)
+		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
+				  ha->queues_dma);
+
+	ha->queues_len = 0;
+	ha->queues = NULL;
+	ha->queues_dma = 0;
+	ha->request_ring = NULL;
+	ha->request_dma = 0;
+	ha->response_ring = NULL;
+	ha->response_dma = 0;
+	ha->shadow_regs = NULL;
+	ha->shadow_regs_dma = 0;
+
+	/* Free srb pool. */
+	if (ha->srb_mempool)
+		mempool_destroy(ha->srb_mempool);
+
+	ha->srb_mempool = NULL;
+
+	/* release io space registers  */
+	if (ha->reg)
+		iounmap(ha->reg);
+	pci_release_regions(ha->pdev);
+}
+
+static int qla4xxx_slave_alloc(struct scsi_device *sdev)
+{
+	struct iscsi_cls_session *sess = starget_to_session(sdev->sdev_target);
+	struct ddb_entry *ddb = sess->dd_data;
+
+	sdev->hostdata = ddb;
+	return 0;
+}
+
+static int qla4xxx_slave_configure(struct scsi_device *sdev)
+{
+	if (sdev->tagged_supported)
+		scsi_activate_tcq(sdev, 32);
+	else
+		scsi_deactivate_tcq(sdev, 32);
+
+	return 0;
+}
+
+/**************************************************************************
+ * del_from_active_array
+ *	This routine removes and returns the srb at the specified index
+ *
+ * Input:
+ *	ha - Pointer to host adapter structure.
+ *	index - index into to the active_array
+ *
+ * Returns:
+ *	Pointer to corresponding SCSI Request Block
+ **************************************************************************/
+struct srb * del_from_active_array(struct scsi_qla_host *ha, uint32_t index)
+{
+	struct srb *srb = NULL;
+
+	/* validate handle and remove from active array */
+	if (index >= MAX_SRBS)
+		return srb;
+
+	srb = ha->active_srb_array[index];
+	ha->active_srb_array[index] = NULL;
+	if (!srb)
+		return srb;
+
+	/* update counters */
+	if (srb->flags & SRB_DMA_VALID) {
+		ha->req_q_count += srb->iocb_cnt;
+		ha->iocb_cnt -= srb->iocb_cnt;
+		if (srb->cmd)
+			srb->cmd->host_scribble = NULL;
+	}
+	return srb;
+}
+
+/**************************************************************************
+ * qla4xxx_timer
+ *	This routine is scheduled to be invoked every second to search for
+ *	work to do.
+ *
+ * Input:
+ *	p - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	None
+ **************************************************************************/
+void qla4xxx_timer(struct scsi_qla_host *ha)
+{
+	struct ddb_entry *ddb_entry, *dtemp;
+	int start_dpc = 0;
+
+	/* Search for relogin's to time-out and port down retry. */
+	list_for_each_entry_safe(ddb_entry, dtemp, &ha->ddb_list, list) {
+		/* Count down time between sending relogins */
+		if (adapter_up(ha) &&
+		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
+		    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
+			if (atomic_read(&ddb_entry->retry_relogin_timer) !=
+			    INVALID_ENTRY) {
+				if (atomic_read(&ddb_entry->retry_relogin_timer)
+				    		== 0) {
+					atomic_set(&ddb_entry->
+						retry_relogin_timer,
+						INVALID_ENTRY);
+					set_bit(DPC_RELOGIN_DEVICE,
+						&ha->dpc_flags);
+					set_bit(DF_RELOGIN, &ddb_entry->flags);
+					DEBUG2(printk("scsi%ld: %s: index [%d]"
+						      " login device\n",
+						      ha->host_no, __func__,
+						      ddb_entry->fw_ddb_index));
+				} else
+					atomic_dec(&ddb_entry->
+							retry_relogin_timer);
+			}
+		}
+
+		/* Wait for relogin to timeout */
+		if (atomic_read(&ddb_entry->relogin_timer) &&
+		    (atomic_dec_and_test(&ddb_entry->relogin_timer) != 0)) {
+			/*
+			 * If the relogin times out and the device is
+			 * still NOT ONLINE then try and relogin again.
+			 */
+			if (atomic_read(&ddb_entry->state) !=
+			    DDB_STATE_ONLINE &&
+			    ddb_entry->fw_ddb_device_state ==
+			    DDB_DS_SESSION_FAILED) {
+				/* Reset retry relogin timer */
+				atomic_inc(&ddb_entry->relogin_retry_count);
+				DEBUG2(printk("scsi%ld: index[%d] relogin"
+					      " timed out-retrying"
+					      " relogin (%d)\n",
+					      ha->host_no,
+					      ddb_entry->fw_ddb_index,
+					      atomic_read(&ddb_entry->
+							  relogin_retry_count))
+					);
+				start_dpc++;
+				DEBUG(printk("scsi%ld:%d:%d: index [%d] "
+					     "initate relogin after"
+					     " %d seconds\n",
+					     ha->host_no, ddb_entry->bus,
+					     ddb_entry->target,
+					     ddb_entry->fw_ddb_index,
+					     ddb_entry->default_time2wait + 4)
+					);
+
+				atomic_set(&ddb_entry->retry_relogin_timer,
+					   ddb_entry->default_time2wait + 4);
+			}
+		}
+	}
+
+	/* Check for heartbeat interval. */
+	if (ha->firmware_options & FWOPT_HEARTBEAT_ENABLE &&
+	    ha->heartbeat_interval != 0) {
+		ha->seconds_since_last_heartbeat++;
+		if (ha->seconds_since_last_heartbeat >
+		    ha->heartbeat_interval + 2)
+			set_bit(DPC_RESET_HA, &ha->dpc_flags);
+	}
+
+
+	/* Wakeup the dpc routine for this adapter, if needed. */
+	if ((start_dpc ||
+	     test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	     test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags) ||
+	     test_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags) ||
+	     test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags) ||
+	     test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
+	     test_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags) ||
+	     test_bit(DPC_AEN, &ha->dpc_flags)) &&
+	     ha->dpc_thread) {
+		DEBUG2(printk("scsi%ld: %s: scheduling dpc routine"
+			      " - dpc flags = 0x%lx\n",
+			      ha->host_no, __func__, ha->dpc_flags));
+		queue_work(ha->dpc_thread, &ha->dpc_work);
+	}
+
+	/* Reschedule timer thread to call us back in one second */
+	mod_timer(&ha->timer, jiffies + HZ);
+
+	DEBUG2(ha->seconds_since_last_intr++);
+}
+
+
+/**************************************************************************
+ * qla4xxx_do_dpc
+ *	This routine is a task that is schedule by the interrupt handler
+ *	to perform the background processing for interrupts.  We put it
+ *	on a task queue that is consumed whenever the scheduler runs; that's
+ *	so you can do anything (i.e. put the process to sleep etc).  In fact,
+ *	the mid-level tries to sleep when it reaches the driver threshold
+ *	"host->can_queue". This can cause a panic if we were in our interrupt
+ *	code.
+ *
+ * Input:
+ *	p - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	None
+ **************************************************************************/
+static void qla4xxx_do_dpc(void *data)
+{
+	struct scsi_qla_host *ha = (struct scsi_qla_host *) data;
+	struct ddb_entry *ddb_entry, *dtemp;
+
+	DEBUG2(printk("scsi%ld: %s: DPC handler waking up.\n",
+		      ha->host_no, __func__));
+
+	DEBUG2(printk("scsi%ld: %s: ha->flags = 0x%08lx\n",
+		      ha->host_no, __func__, ha->flags));
+	DEBUG2(printk("scsi%ld: %s: ha->dpc_flags = 0x%08lx\n",
+		      ha->host_no, __func__, ha->dpc_flags));
+
+	/* Initialization not yet finished. Don't do anything yet. */
+	if (!test_bit(AF_INIT_DONE, &ha->flags))
+		return;
+
+	if (adapter_up(ha) ||
+	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags) ||
+	    test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags)) {
+		if (test_bit(DPC_RESET_HA_DESTROY_DDB_LIST, &ha->dpc_flags))
+			/*
+			 * dg 09/23 Never initialize ddb list
+			 * once we up and running
+			 * qla4xxx_recover_adapter(ha,
+			 *    REBUILD_DDB_LIST);
+			 */
+			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
+
+		if (test_bit(DPC_RESET_HA, &ha->dpc_flags))
+			qla4xxx_recover_adapter(ha, PRESERVE_DDB_LIST);
+
+		if (test_and_clear_bit(DPC_RESET_HA_INTR, &ha->dpc_flags)) {
+			uint8_t wait_time = RESET_INTR_TOV;
+			unsigned long flags = 0;
+
+			qla4xxx_flush_active_srbs(ha);
+
+			spin_lock_irqsave(&ha->hardware_lock, flags);
+			while ((readw(&ha->reg->ctrl_status) &
+				(CSR_SOFT_RESET | CSR_FORCE_SOFT_RESET)) != 0) {
+				if (--wait_time == 0)
+					break;
+
+				spin_unlock_irqrestore(&ha->hardware_lock,
+						       flags);
+
+				msleep(1000);
+
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+			}
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+			if (wait_time == 0)
+				DEBUG2(printk("scsi%ld: %s: SR|FSR "
+					      "bit not cleared-- resetting\n",
+					      ha->host_no, __func__));
+		}
+	}
+
+	/* ---- process AEN? --- */
+	if (test_and_clear_bit(DPC_AEN, &ha->dpc_flags))
+		qla4xxx_process_aen(ha, PROCESS_ALL_AENS);
+
+	/* ---- Get DHCP IP Address? --- */
+	if (test_and_clear_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags))
+		qla4xxx_get_dhcp_ip_address(ha);
+
+	/* ---- relogin device? --- */
+	if (adapter_up(ha) &&
+	    test_and_clear_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags)) {
+		list_for_each_entry_safe(ddb_entry, dtemp,
+					 &ha->ddb_list, list) {
+			if (test_and_clear_bit(DF_RELOGIN, &ddb_entry->flags) &&
+			    atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
+				qla4xxx_relogin_device(ha, ddb_entry);
+
+			/*
+			 * If mbx cmd times out there is no point
+			 * in continuing further.
+			 * With large no of targets this can hang
+			 * the system.
+			 */
+			if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
+				printk(KERN_WARNING "scsi%ld: %s: "
+				       "need to reset hba\n",
+				       ha->host_no, __func__);
+				break;
+			}
+		}
+	}
+}
+
+/**************************************************************************
+ * qla4010_soft_reset
+ *	This routine performs a SOFT RESET.
+ *
+ * Input:
+ *	ha - Pointer to host adapter structure.
+ *
+ * Returns:
+ *	QLA_SUCCESS - Successfully reset the firmware
+ *	QLA_ERROR   - Failed to reset the firmware
+ **************************************************************************/
+int qla4010_soft_reset(struct scsi_qla_host *ha)
+{
+	uint32_t max_wait_time;
+	unsigned long flags = 0;
+	int status = QLA_ERROR;
+	uint32_t ctrl_status;
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/*
+	 * If the SCSI Reset Interrupt bit is set, clear it.
+	 * Otherwise, the Soft Reset won't work.
+	 */
+	ctrl_status = readw(&ha->reg->ctrl_status);
+	if ((ctrl_status & CSR_SCSI_RESET_INTR) != 0)
+		writel(set_rmask(CSR_SCSI_RESET_INTR), &ha->reg->ctrl_status);
+
+	/* Issue Soft Reset */
+	writel(set_rmask(CSR_SOFT_RE
