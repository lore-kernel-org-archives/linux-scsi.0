From: James.Smart@Emulex.Com
Subject: [PATCH 9/11][REPOST #2]  lpfc 8.1.1 : Add polled-mode support
Date: Thu, 1 Dec 2005 10:54:06 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B85@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41445 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932175AbVLAPyK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 10:54:10 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jB1Fs9s3014472
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 07:54:09 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

<<killed that last style change>>


Add polled-mode support to the driver:
- Add functionality to run in polled mode only. Includes run time
  attribute to enable mode.
- Enable runtime writable hba settings for coallescing and delay parameters

Customers have requested a mode in the driver to run strictly polled.
This is generally to support an environment where the server is extremely
loaded and is looking to reclaim some cpu cycles from adapter interrupt
handling.

This patch adds a new "poll" attribute, and the following behavior:

if value is 0 (default):
  The driver uses the normal method for i/o completion. It uses the
  firmware feature of interrupt coalesing. The firmware allows a
  minimum number of i/o completions before an interrupt, or a maximum
  time delay between interrupts.  By default, the driver sets these
  to no delay (disabled) or 1 i/o - meaning coalescing is largely
  disabled.

  Attributes were provided to change the coalescing values, but it was
  a module-load time only and global across all adapters.
  This patch allows them to be writable on a per-adapter basis.

if value is 1 :
  Interrupts are left enabled, expecting that the user has tuned the
  interrupt coalescing values. When this setting is enabled, the driver
  will attempt to service completed i/o whenever new i/o is submitted
  to the adapter. If the coalescing values are large, and the i/o
  generation rate steady, an interrupt will be avoided by servicing
  completed i/o prior to the coalescing thresholds kicking in. However,
  if the i/o completion load is high enough or i/o generation slow, the
  coalescion values will ensure that completed i/o is serviced in a timely
  fashion.

if value is 3 :
  Turns off FCP i/o interrupts altogether. The coalescing values now have
  no effect. A new attribute "poll_tmo" (default 10ms) exists to set
  the polling interval for i/o completion.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2005-12-01 10:42:52.000000000 -0500
@@ -278,6 +278,70 @@ lpfc_board_online_store(struct class_dev
 		return -EIO;
 }
 
+static ssize_t
+lpfc_poll_show(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+
+	return snprintf(buf, PAGE_SIZE, "%#x\n", phba->cfg_poll);
+}
+
+static ssize_t
+lpfc_poll_store(struct class_device *cdev, const char *buf,
+		size_t count)
+{
+	struct Scsi_Host *host = class_to_shost(cdev);
+	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];
+	uint32_t creg_val;
+	uint32_t old_val;
+	int val=0;
+
+	if (!isdigit(buf[0]))
+		return -EINVAL;
+
+	if (sscanf(buf, "%i", &val) != 1)
+		return -EINVAL;
+
+	if ((val & 0x3) != val)
+		return -EINVAL;
+
+	spin_lock_irq(phba->host->host_lock);
+
+	old_val = phba->cfg_poll;
+
+	if (val & ENABLE_FCP_RING_POLLING) {
+		if ((val & DISABLE_FCP_RING_INT) &&
+		    !(old_val & DISABLE_FCP_RING_INT)) {
+			creg_val = readl(phba->HCregaddr);
+			creg_val &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
+			writel(creg_val, phba->HCregaddr);
+			readl(phba->HCregaddr); /* flush */
+
+			lpfc_poll_start_timer(phba);
+		}
+	} else if (val != 0x0) {
+		spin_unlock_irq(phba->host->host_lock);
+		return -EINVAL;
+	}
+
+	if (!(val & DISABLE_FCP_RING_INT) &&
+	    (old_val & DISABLE_FCP_RING_INT)) {
+		spin_unlock_irq(phba->host->host_lock);
+		del_timer(&phba->fcp_poll_timer);
+		spin_lock_irq(phba->host->host_lock);
+		creg_val = readl(phba->HCregaddr);
+		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
+		writel(creg_val, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
+
+	phba->cfg_poll = val;
+
+	spin_unlock_irq(phba->host->host_lock);
+
+	return strlen(buf);
+}
 
 #define lpfc_param_show(attr)	\
 static ssize_t \
@@ -416,6 +480,15 @@ static CLASS_DEVICE_ATTR(management_vers
 static CLASS_DEVICE_ATTR(board_online, S_IRUGO | S_IWUSR,
 			 lpfc_board_online_show, lpfc_board_online_store);
 
+static int lpfc_poll = 0;
+module_param(lpfc_poll, int, 0);
+MODULE_PARM_DESC(lpfc_poll, "FCP ring polling mode control:"
+		 " 0 - none,"
+		 " 1 - poll with interrupts enabled"
+		 " 3 - poll and disable FCP ring interrupts");
+
+static CLASS_DEVICE_ATTR(lpfc_poll, S_IRUGO | S_IWUSR,
+			 lpfc_poll_show, lpfc_poll_store);
 
 /*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
@@ -523,10 +596,10 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 
 # is 0. Default value of cr_count is 1. The cr_count feature is disabled if
 # cr_delay is set to 0.
 */
-LPFC_ATTR(cr_delay, 0, 0, 63, "A count of milliseconds after which an"
+LPFC_ATTR_RW(cr_delay, 0, 0, 63, "A count of milliseconds after which an"
 		"interrupt response is generated");
 
-LPFC_ATTR(cr_count, 1, 1, 255, "A count of I/O completions after which an"
+LPFC_ATTR_RW(cr_count, 1, 1, 255, "A count of I/O completions after which an"
 		"interrupt response is generated");
 
 /*
@@ -553,6 +626,13 @@ LPFC_ATTR(discovery_threads, 32, 1, 64, 
 LPFC_ATTR_R(max_luns, 256, 1, 32768,
 	     "Maximum number of LUNs per target driver will support");
 
+/*
+# lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.
+# Value range is [1,255], default value is 10.
+*/
+LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
+	     "Milliseconds driver will wait between polling FCP ring");
+
 struct class_device_attribute *lpfc_host_attrs[] = {
 	&class_device_attr_info,
 	&class_device_attr_serialnum,
@@ -575,11 +655,15 @@ struct class_device_attribute *lpfc_host
 	&class_device_attr_lpfc_topology,
 	&class_device_attr_lpfc_scan_down,
 	&class_device_attr_lpfc_link_speed,
+	&class_device_attr_lpfc_cr_delay,
+	&class_device_attr_lpfc_cr_count,
 	&class_device_attr_lpfc_fdmi_on,
 	&class_device_attr_lpfc_max_luns,
 	&class_device_attr_nport_evt_cnt,
 	&class_device_attr_management_version,
 	&class_device_attr_board_online,
+	&class_device_attr_lpfc_poll,
+	&class_device_attr_lpfc_poll_tmo,
 	NULL,
 };
 
@@ -1292,6 +1376,9 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
 	lpfc_discovery_threads_init(phba, lpfc_discovery_threads);
 	lpfc_max_luns_init(phba, lpfc_max_luns);
+	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
+
+	phba->cfg_poll = lpfc_poll;
 
 	/*
 	 * The total number of segments is the configuration value plus 2
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2005-11-24 10:07:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2005-12-01 10:42:52.000000000 -0500
@@ -143,6 +143,9 @@ LPFC_MBOXQ_t *lpfc_mbox_get(struct lpfc_
 int lpfc_mem_alloc(struct lpfc_hba *);
 void lpfc_mem_free(struct lpfc_hba *);
 
+void lpfc_poll_timeout(unsigned long ptr);
+void lpfc_poll_start_timer(struct lpfc_hba * phba);
+void lpfc_sli_poll_fcp_ring(struct lpfc_hba * hba);
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba * phba, struct lpfc_iocbq * iocb);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2005-11-29 15:05:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2005-12-01 10:42:52.000000000 -0500
@@ -45,6 +45,11 @@ struct lpfc_sli2_slim;
 
 #define MAX_HBAEVT	32
 
+enum lpfc_polling_flags {
+	ENABLE_FCP_RING_POLLING = 0x1,
+	DISABLE_FCP_RING_INT    = 0x2
+};
+
 /* Provide DMA memory definitions the driver uses per port instance. */
 struct lpfc_dmabuf {
 	struct list_head list;
@@ -287,6 +292,8 @@ struct lpfc_hba {
 	uint32_t cfg_fcp_bind_method;
 	uint32_t cfg_discovery_threads;
 	uint32_t cfg_max_luns;
+	uint32_t cfg_poll;
+	uint32_t cfg_poll_tmo;
 	uint32_t cfg_sg_seg_cnt;
 	uint32_t cfg_sg_dma_buf_size;
 
@@ -338,7 +345,9 @@ struct lpfc_hba {
 #define VPD_PORT            0x8         /* valid vpd port data */
 #define VPD_MASK            0xf         /* mask for any vpd data */
 
+	struct timer_list fcp_poll_timer;
 	struct timer_list els_tmofunc;
+
 	/*
 	 * stat  counters
 	 */
@@ -349,6 +358,7 @@ struct lpfc_hba {
 	struct lpfc_sysfs_mbox sysfs_mbox;
 
 	/* fastpath list. */
+	spinlock_t scsi_buf_list_lock;
 	struct list_head lpfc_scsi_buf_list;
 	uint32_t total_scsi_bufs;
 	struct list_head lpfc_iocb_list;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2005-11-29 15:05:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2005-12-01 10:42:52.000000000 -0500
@@ -370,6 +370,10 @@ lpfc_config_port_post(struct lpfc_hba * 
 	if (psli->num_rings > 3)
 		status |= HC_R3INT_ENA;
 
+	if ((phba->cfg_poll & ENABLE_FCP_RING_POLLING) &&
+	    (phba->cfg_poll & DISABLE_FCP_RING_INT))
+		status &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
+
 	writel(status, phba->HCregaddr);
 	readl(phba->HCregaddr); /* flush */
 	spin_unlock_irq(phba->host->host_lock);
@@ -1237,6 +1241,7 @@ lpfc_stop_timer(struct lpfc_hba * phba)
 		}
 	}
 
+	del_timer_sync(&phba->fcp_poll_timer);
 	del_timer_sync(&phba->fc_estabtmo);
 	del_timer_sync(&phba->fc_disctmo);
 	del_timer_sync(&phba->fc_fdmitmo);
@@ -1416,6 +1421,10 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	psli->mbox_tmo.function = lpfc_mbox_timeout;
 	psli->mbox_tmo.data = (unsigned long)phba;
 
+	init_timer(&phba->fcp_poll_timer);
+	phba->fcp_poll_timer.function = lpfc_poll_timeout;
+	phba->fcp_poll_timer.data = (unsigned long)phba;
+
 	/*
 	 * Get all the module params for configuring this host and then
 	 * establish the host parameters.
@@ -1530,6 +1539,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	host->max_cmd_len = 16;
 
 	/* Initialize the list of scsi buffers used by driver for scsi IO. */
+	spin_lock_init(&phba->scsi_buf_list_lock);
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list);
 
 	host->transportt = lpfc_transport_template;
@@ -1561,6 +1571,12 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (error)
 		goto out_free_irq;
 
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		spin_lock_irq(phba->host->host_lock);
+		lpfc_poll_start_timer(phba);
+		spin_unlock_irq(phba->host->host_lock);
+	}
+
 	/*
 	 * set fixed host attributes
 	 * Must done after lpfc_sli_hba_setup()
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-29 15:05:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2005-12-01 10:49:18.000000000 -0500
@@ -151,18 +151,22 @@ lpfc_new_scsi_buf(struct lpfc_hba * phba
 }
 
 struct  lpfc_scsi_buf*
-lpfc_sli_get_scsi_buf(struct lpfc_hba * phba)
+lpfc_get_scsi_buf(struct lpfc_hba * phba)
 {
 	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
 	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
+	unsigned long iflag = 0;
 
+	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
 	list_remove_head(scsi_buf_list, lpfc_cmd, struct lpfc_scsi_buf, list);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
 	return  lpfc_cmd;
 }
 
 static void
 lpfc_release_scsi_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
 {
+	unsigned long iflag = 0;
 	/*
 	 * There are only two special cases to consider.  (1) the scsi command
 	 * requested scatter-gather usage or (2) the scsi command allocated
@@ -180,8 +184,10 @@ lpfc_release_scsi_buf(struct lpfc_hba * 
 		 }
 	}
 
+	spin_lock_irqsave(&phba->scsi_buf_list_lock, iflag);
 	psb->pCmd = NULL;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_lock, iflag);
 }
 
 static int
@@ -403,7 +409,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
-	unsigned long iflag;
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -457,9 +462,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 
 	cmd->scsi_done(cmd);
 
-	spin_lock_irqsave(phba->host->host_lock, iflag);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
-	spin_unlock_irqrestore(phba->host->host_lock, iflag);
 }
 
 static void
@@ -707,6 +710,37 @@ lpfc_info(struct Scsi_Host *host)
 	return lpfcinfobuf;
 }
 
+static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
+{
+	unsigned long  poll_tmo_expires =
+		(jiffies + msecs_to_jiffies(phba->cfg_poll_tmo));
+
+	if (phba->sli.ring[LPFC_FCP_RING].txcmplq_cnt)
+		mod_timer(&phba->fcp_poll_timer,
+			  poll_tmo_expires);
+}
+
+void lpfc_poll_start_timer(struct lpfc_hba * phba)
+{
+	lpfc_poll_rearm_timer(phba);
+}
+
+void lpfc_poll_timeout(unsigned long ptr)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba *)ptr;
+	unsigned long iflag;
+
+	spin_lock_irqsave(phba->host->host_lock, iflag);
+
+	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		lpfc_sli_poll_fcp_ring (phba);
+		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
+			lpfc_poll_rearm_timer(phba);
+	}
+
+	spin_unlock_irqrestore(phba->host->host_lock, iflag);
+}
+
 static int
 lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 {
@@ -733,7 +767,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
 		goto out_fail_command;
 	}
-	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
+	lpfc_cmd = lpfc_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
 				"%d:0707 driver's buffer pool is empty, "
@@ -761,11 +795,17 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 				&lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
 	if (err)
 		goto out_host_busy_free_buf;
+
+	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		lpfc_sli_poll_fcp_ring(phba);
+		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
+			lpfc_poll_rearm_timer(phba);
+	}
+
 	return 0;
 
  out_host_busy_free_buf:
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
-	cmnd->host_scribble = NULL;
  out_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -839,9 +879,14 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		goto out;
 	}
 
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
+		lpfc_sli_poll_fcp_ring (phba);
+
 	/* Wait for abort to complete */
-	while (lpfc_cmd->pCmd == cmnd)
-	{
+	while (lpfc_cmd->pCmd == cmnd) {
+		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
+			lpfc_sli_poll_fcp_ring (phba);
+
 		spin_unlock_irq(phba->host->host_lock);
 			schedule_timeout_uninterruptible(LPFC_ABORT_WAIT*HZ);
 		spin_lock_irq(phba->host->host_lock);
@@ -905,7 +950,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 			break;
 	}
 
-	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
+	lpfc_cmd = lpfc_get_scsi_buf (phba);
 	if (lpfc_cmd == NULL)
 		goto out;
 
@@ -1001,7 +1046,7 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	lpfc_block_requests(phba);
 	spin_lock_irq(shost->host_lock);
 
-	lpfc_cmd = lpfc_sli_get_scsi_buf (phba);
+	lpfc_cmd = lpfc_get_scsi_buf(phba);
 	if (lpfc_cmd == NULL)
 		goto out;
 
@@ -1136,10 +1181,10 @@ lpfc_slave_alloc(struct scsi_device *sde
 			break;
 		}
 
-		spin_lock_irqsave(phba->host->host_lock, flags);
+		spin_lock_irqsave(&phba->scsi_buf_list_lock, flags);
 		phba->total_scsi_bufs++;
 		list_add_tail(&scsi_buf->list, &phba->lpfc_scsi_buf_list);
-		spin_unlock_irqrestore(phba->host->host_lock, flags);
+		spin_unlock_irqrestore(&phba->scsi_buf_list_lock, flags);
 	}
 	return 0;
 }
@@ -1163,6 +1208,12 @@ lpfc_slave_configure(struct scsi_device 
 	 */
 	rport->dev_loss_tmo = phba->cfg_nodev_tmo + 5;
 
+	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
+		lpfc_sli_poll_fcp_ring(phba);
+		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
+			lpfc_poll_rearm_timer(phba);
+	}
+
 	return 0;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2005-11-24 10:07:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2005-12-01 10:42:52.000000000 -0500
@@ -886,6 +886,182 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 	return rc;
 }
 
+static void lpfc_sli_rsp_pointers_error(struct lpfc_hba * phba,
+					struct lpfc_sli_ring * pring)
+{
+	struct lpfc_pgp *pgp = &phba->slim2p->mbx.us.s2.port[pring->ringno];
+	/*
+	 * Ring <ringno> handler: portRspPut <portRspPut> is bigger then
+	 * rsp ring <portRspMax>
+	 */
+	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+			"%d:0312 Ring %d handler: portRspPut %d "
+			"is bigger then rsp ring %d\n",
+			phba->brd_no, pring->ringno,
+			le32_to_cpu(pgp->rspPutInx),
+			pring->numRiocb);
+
+	phba->hba_state = LPFC_HBA_ERROR;
+
+	/*
+	 * All error attention handlers are posted to
+	 * worker thread
+	 */
+	phba->work_ha |= HA_ERATT;
+	phba->work_hs = HS_FFER3;
+	if (phba->work_wait)
+		wake_up(phba->work_wait);
+
+	return;
+}
+
+void lpfc_sli_poll_fcp_ring(struct lpfc_hba * phba)
+{
+	struct lpfc_sli      * psli   = &phba->sli;
+	struct lpfc_sli_ring * pring = &psli->ring[LPFC_FCP_RING];
+	IOCB_t *irsp = NULL;
+	IOCB_t *entry = NULL;
+	struct lpfc_iocbq *cmdiocbq = NULL;
+	struct lpfc_iocbq rspiocbq;
+	struct lpfc_pgp *pgp;
+	uint32_t status;
+	uint32_t portRspPut, portRspMax;
+	int type;
+	uint32_t rsp_cmpl = 0;
+	void __iomem *to_slim;
+	uint32_t ha_copy;
+
+	pring->stats.iocb_event++;
+
+	/* The driver assumes SLI-2 mode */
+	pgp =  &phba->slim2p->mbx.us.s2.port[pring->ringno];
+
+	/*
+	 * The next available response entry should never exceed the maximum
+	 * entries.  If it does, treat it as an adapter hardware error.
+	 */
+	portRspMax = pring->numRiocb;
+	portRspPut = le32_to_cpu(pgp->rspPutInx);
+	if (unlikely(portRspPut >= portRspMax)) {
+		lpfc_sli_rsp_pointers_error(phba, pring);
+		return;
+	}
+
+	rmb();
+	while (pring->rspidx != portRspPut) {
+
+		entry = IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
+
+		if (++pring->rspidx >= portRspMax)
+			pring->rspidx = 0;
+
+		lpfc_sli_pcimem_bcopy((uint32_t *) entry,
+				      (uint32_t *) &rspiocbq.iocb,
+				      sizeof (IOCB_t));
+		irsp = &rspiocbq.iocb;
+		type = lpfc_sli_iocb_cmd_type(irsp->ulpCommand & CMD_IOCB_MASK);
+		pring->stats.iocb_rsp++;
+		rsp_cmpl++;
+
+		if (unlikely(irsp->ulpStatus)) {
+			/* Rsp ring <ringno> error: IOCB */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
+					"%d:0326 Rsp Ring %d error: IOCB Data: "
+					"x%x x%x x%x x%x x%x x%x x%x x%x\n",
+					phba->brd_no, pring->ringno,
+					irsp->un.ulpWord[0],
+					irsp->un.ulpWord[1],
+					irsp->un.ulpWord[2],
+					irsp->un.ulpWord[3],
+					irsp->un.ulpWord[4],
+					irsp->un.ulpWord[5],
+					*(((uint32_t *) irsp) + 6),
+					*(((uint32_t *) irsp) + 7));
+		}
+
+		switch (type) {
+		case LPFC_ABORT_IOCB:
+		case LPFC_SOL_IOCB:
+			/*
+			 * Idle exchange closed via ABTS from port.  No iocb
+			 * resources need to be recovered.
+			 */
+			if (unlikely(irsp->ulpCommand == CMD_XRI_ABORTED_CX)) {
+				printk(KERN_INFO "%s: IOCB cmd 0x%x processed."
+				       " Skipping completion\n", __FUNCTION__,
+				       irsp->ulpCommand);
+				break;
+			}
+
+			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
+							 &rspiocbq);
+			if ((cmdiocbq) && (cmdiocbq->iocb_cmpl)) {
+				(cmdiocbq->iocb_cmpl)(phba, cmdiocbq,
+						      &rspiocbq);
+			}
+			break;
+		default:
+			if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
+				char adaptermsg[LPFC_MAX_ADPTMSG];
+				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
+				memcpy(&adaptermsg[0], (uint8_t *) irsp,
+				       MAX_MSG_DATA);
+				dev_warn(&((phba->pcidev)->dev), "lpfc%d: %s",
+					 phba->brd_no, adaptermsg);
+			} else {
+				/* Unknown IOCB command */
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"%d:0321 Unknown IOCB command "
+						"Data: x%x, x%x x%x x%x x%x\n",
+						phba->brd_no, type,
+						irsp->ulpCommand,
+						irsp->ulpStatus,
+						irsp->ulpIoTag,
+						irsp->ulpContext);
+			}
+			break;
+		}
+
+		/*
+		 * The response IOCB has been processed.  Update the ring
+		 * pointer in SLIM.  If the port response put pointer has not
+		 * been updated, sync the pgp->rspPutInx and fetch the new port
+		 * response put pointer.
+		 */
+		to_slim = phba->MBslimaddr +
+			(SLIMOFF + (pring->ringno * 2) + 1) * 4;
+		writeb(pring->rspidx, to_slim);
+
+		if (pring->rspidx == portRspPut)
+			portRspPut = le32_to_cpu(pgp->rspPutInx);
+	}
+
+	ha_copy = readl(phba->HAregaddr);
+	ha_copy >>= (LPFC_FCP_RING * 4);
+
+	if ((rsp_cmpl > 0) && (ha_copy & HA_R0RE_REQ)) {
+		pring->stats.iocb_rsp_full++;
+		status = ((CA_R0ATT | CA_R0RE_RSP) << (LPFC_FCP_RING * 4));
+		writel(status, phba->CAregaddr);
+		readl(phba->CAregaddr);
+	}
+	if ((ha_copy & HA_R0CE_RSP) &&
+	    (pring->flag & LPFC_CALL_RING_AVAILABLE)) {
+		pring->flag &= ~LPFC_CALL_RING_AVAILABLE;
+		pring->stats.iocb_cmd_empty++;
+
+		/* Force update of the local copy of cmdGetInx */
+		pring->local_getidx = le32_to_cpu(pgp->cmdGetInx);
+		lpfc_sli_resume_iocb(phba, pring);
+
+		if ((pring->lpfc_sli_cmd_available))
+			(pring->lpfc_sli_cmd_available) (phba, pring);
+
+	}
+
+	return;
+}
+
 /*
  * This routine presumes LPFC_FCP_RING handling and doesn't bother
  * to check it explicitly.
@@ -917,24 +1093,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 	portRspMax = pring->numRiocb;
 	portRspPut = le32_to_cpu(pgp->rspPutInx);
 	if (unlikely(portRspPut >= portRspMax)) {
-		/*
-		 * Ring <ringno> handler: portRspPut <portRspPut> is bigger then
-		 * rsp ring <portRspMax>
-		 */
-		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"%d:0312 Ring %d handler: portRspPut %d "
-				"is bigger then rsp ring %d\n",
-				phba->brd_no, pring->ringno, portRspPut,
-				portRspMax);
-
-		phba->hba_state = LPFC_HBA_ERROR;
-
-		/* All error attention handlers are posted to worker thread */
-		phba->work_ha |= HA_ERATT;
-		phba->work_hs = HS_FFER3;
-		if (phba->work_wait)
-			wake_up(phba->work_wait);
-
+		lpfc_sli_rsp_pointers_error(phba, pring);
 		spin_unlock_irqrestore(phba->host->host_lock, iflag);
 		return 1;
 	}
@@ -947,6 +1106,10 @@ lpfc_sli_handle_fast_ring_event(struct l
 		 * network byte order and pci byte orders are different.
 		 */
 		entry = IOCB_ENTRY(pring->rspringaddr, pring->rspidx);
+
+		if (++pring->rspidx >= portRspMax)
+			pring->rspidx = 0;
+
 		lpfc_sli_pcimem_bcopy((uint32_t *) entry,
 				      (uint32_t *) &rspiocbq.iocb,
 				      sizeof (IOCB_t));
@@ -1020,9 +1183,6 @@ lpfc_sli_handle_fast_ring_event(struct l
 		 * been updated, sync the pgp->rspPutInx and fetch the new port
 		 * response put pointer.
 		 */
-		if (++pring->rspidx >= portRspMax)
-			pring->rspidx = 0;
-
 		to_slim = phba->MBslimaddr +
 			(SLIMOFF + (pring->ringno * 2) + 1) * 4;
 		writel(pring->rspidx, to_slim);
@@ -2615,6 +2775,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	DECLARE_WAIT_QUEUE_HEAD(done_q);
 	long timeleft, timeout_req = 0;
 	int retval = IOCB_SUCCESS;
+	uint32_t creg_val;
 
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
@@ -2630,6 +2791,13 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	piocb->context_un.wait_queue = &done_q;
 	piocb->iocb_flag &= ~LPFC_IO_WAKE;
 
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		creg_val = readl(phba->HCregaddr);
+		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
+		writel(creg_val, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
+
 	retval = lpfc_sli_issue_iocb(phba, pring, piocb, 0);
 	if (retval == IOCB_SUCCESS) {
 		timeout_req = timeout * HZ;
@@ -2663,6 +2831,13 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		retval = IOCB_ERROR;
 	}
 
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		creg_val = readl(phba->HCregaddr);
+		creg_val &= ~(HC_R0INT_ENA << LPFC_FCP_RING);
+		writel(creg_val, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
+
 	if (prspiocbq)
 		piocb->context2 = NULL;
  
