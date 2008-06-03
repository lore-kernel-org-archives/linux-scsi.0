From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.26-rc4
Date: Tue, 03 Jun 2008 09:23:55 -0500
Message-ID: <1212503035.3370.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43560 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995AbYFCOYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 10:24:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a stack of qlogic fixes (in spite of the large number, there's
not an awful lot of change), one fusion fix and one mid layer fix to
prevent an intermittent oops.  It's available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (8):
      qla2xxx: Update version number to 8.02.01-k4.
      qla2xxx: Update version number to 8.02.01-k3.
      qla2xxx: Revert "qla2xxx: Validate mid-layer 'underflow' during check-cond
      qla2xxx: Disable local-interrupts while polling for RISC status.
      qla2xxx: Extend the 'fw_dump' SYSFS node the ability to initiate a firmwar
      qla2xxx: Don't depend on mailbox return values while enabling FCE tracing.
      qla2xxx: Correct locking within MSI-X interrupt handlers.
      qla2xxx: Display driver version at module init-time.

Brian King (1):
      ibmvscsi: Non SCSI error status fixup

Daniel Walker (1):
      qla2xxx: firmware semaphore to mutex

James Bottomley (1):
      fix intermittent oops in scsi_bus_uevent

Michael Reed (1):
      fusion mpt: fix target missing after resetting external raid

Seokmann Ju (2):
      qla2xxx: Correct handling of AENs postings for vports.
      qla2xxx: Revert "qla2xxx: Use proper HA during asynchronous event handling

Shyam Sundar (1):
      qla2xxx: Return correct port_type to FC-transport for Vports.

matthias@kaehlcke.net (1):
      qla2xxx: Convert vport_sem to a mutex


The diffstat:

 drivers/message/fusion/mptfc.c     |    2 -
 drivers/message/fusion/mptsas.c    |    2 -
 drivers/message/fusion/mptscsih.c  |    8 ----
 drivers/scsi/ibmvscsi/ibmvscsi.c   |    2 -
 drivers/scsi/ibmvscsi/viosrp.h     |    3 +
 drivers/scsi/qla2xxx/qla_attr.c    |   13 +++++--
 drivers/scsi/qla2xxx/qla_def.h     |    2 -
 drivers/scsi/qla2xxx/qla_gbl.h     |    3 +
 drivers/scsi/qla2xxx/qla_inline.h  |    4 ++
 drivers/scsi/qla2xxx/qla_isr.c     |   63 ++++++++-----------------------------
 drivers/scsi/qla2xxx/qla_mbx.c     |   12 ++-----
 drivers/scsi/qla2xxx/qla_mid.c     |   19 +++++------
 drivers/scsi/qla2xxx/qla_os.c      |   30 +++++++++--------
 drivers/scsi/qla2xxx/qla_version.h |    2 -
 drivers/scsi/scsi_sysfs.c          |    7 +++-
 15 files changed, 73 insertions(+), 99 deletions(-)

The entire diff is below for checking.

James

---

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 3cdd4e9..1e24ab4 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1238,8 +1238,6 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sh->max_id = ioc->pfacts->MaxDevices;
 	sh->max_lun = max_lun;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 4684807..4d492ba 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3193,8 +3193,6 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	sh->transportt = mptsas_transport_template;
 
-	sh->this_id = ioc->pfacts[0].PortSCSIID;
-
 	/* Required entry.
 	 */
 	sh->unique_id = ioc->id;
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index b109bd8..c68ef00 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2451,12 +2451,6 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    ioc->name, sdev->sdtr, sdev->wdtr,
 		    sdev->ppr, sdev->inquiry_len));
 
-	if (sdev->id > sh->max_id) {
-		/* error case, should never happen */
-		scsi_adjust_queue_depth(sdev, 0, 1);
-		goto slave_configure_exit;
-	}
-
 	vdevice->configured_lun = 1;
 	mptscsih_change_queue_depth(sdev, MPT_SCSI_CMD_PER_DEV_HIGH);
 
@@ -2470,8 +2464,6 @@ mptscsih_slave_configure(struct scsi_device *sdev)
 		    ioc->name, vtarget->negoFlags, vtarget->maxOffset,
 		    vtarget->minSyncFactor));
 
-slave_configure_exit:
-
 	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		"tagged %d, simple %d, ordered %d\n",
 		ioc->name,sdev->tagged_supported, sdev->simple_tags,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index ccfd8ac..5d23368 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1348,7 +1348,7 @@ void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 
 	del_timer(&evt_struct->timer);
 
-	if (crq->status != VIOSRP_OK && evt_struct->cmnd)
+	if ((crq->status != VIOSRP_OK && crq->status != VIOSRP_OK2) && evt_struct->cmnd)
 		evt_struct->cmnd->result = DID_ERROR << 16;
 	if (evt_struct->done)
 		evt_struct->done(evt_struct);
diff --git a/drivers/scsi/ibmvscsi/viosrp.h b/drivers/scsi/ibmvscsi/viosrp.h
index 4c4aadb..2046045 100644
--- a/drivers/scsi/ibmvscsi/viosrp.h
+++ b/drivers/scsi/ibmvscsi/viosrp.h
@@ -65,7 +65,8 @@ enum viosrp_crq_status {
 	VIOSRP_VIOLATES_MAX_XFER = 0x2,
 	VIOSRP_PARTNER_PANIC = 0x3,
 	VIOSRP_DEVICE_BUSY = 0x8,
-	VIOSRP_ADAPTER_FAIL = 0x10
+	VIOSRP_ADAPTER_FAIL = 0x10,
+	VIOSRP_OK2 = 0x99,
 };
 
 struct viosrp_crq {
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2876908..8dd88fc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -70,6 +70,9 @@ qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
 	case 2:
 		qla2x00_alloc_fw_dump(ha);
 		break;
+	case 3:
+		qla2x00_system_error(ha);
+		break;
 	}
 	return (count);
 }
@@ -886,9 +889,13 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 static void
 qla2x00_get_host_port_type(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *ha = to_qla_parent(shost_priv(shost));
+	scsi_qla_host_t *ha = shost_priv(shost);
 	uint32_t port_type = FC_PORTTYPE_UNKNOWN;
 
+	if (ha->parent) {
+		fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
+		return;
+	}
 	switch (ha->current_topology) {
 	case ISP_CFG_NL:
 		port_type = FC_PORTTYPE_LPORT;
@@ -1172,10 +1179,10 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	qla24xx_disable_vp(vha);
 	qla24xx_deallocate_vp_id(vha);
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	ha->cur_vport_count--;
 	clear_bit(vha->vp_idx, ha->vp_idx_map);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	kfree(vha->node_name);
 	kfree(vha->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 299eccf..8dd6000 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2457,7 +2457,7 @@ typedef struct scsi_qla_host {
 #define MBX_INTR_WAIT	2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct semaphore vport_sem;	/* Virtual port synchronization */
+	struct mutex vport_lock;	/* Virtual port synchronization */
 	struct completion mbx_cmd_comp;	/* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f882706..9b4bebe 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -228,6 +228,9 @@ extern int qla24xx_abort_target(struct fc_port *, unsigned int);
 extern int qla24xx_lun_reset(struct fc_port *, unsigned int);
 
 extern int
+qla2x00_system_error(scsi_qla_host_t *);
+
+extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index e9bae27..92fafbd 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -34,7 +34,11 @@ qla2x00_debounce_register(volatile uint16_t __iomem *addr)
 static inline void
 qla2x00_poll(scsi_qla_host_t *ha)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	ha->isp_ops->intr_handler(0, ha);
+	local_irq_restore(flags);
 }
 
 static __inline__ scsi_qla_host_t *
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5d9a64a..ec63b79 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -272,8 +272,6 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 	unsigned long	flags;
-	scsi_qla_host_t	*vha;
-	int		i;
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
@@ -544,18 +542,10 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
-		if ((ha->flags.npiv_supported) && (ha->num_vhosts)) {
-			for_each_mapped_vp_idx(ha, i) {
-				list_for_each_entry(vha, &ha->vp_list,
-				    vp_list) {
-					if ((mb[3] & 0xff)
-					    == vha->vp_idx) {
-						ha = vha;
-						break;
-					}
-				}
-			}
-		}
+		/* Only handle SCNs for our Vport index. */
+		if (ha->parent && ha->vp_idx != (mb[3] & 0xff))
+			break;
+
 		/*
 		 * If PORT UPDATE is global (recieved LIP_OCCURED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
@@ -590,18 +580,12 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-		if ((ha->flags.npiv_supported) && (ha->num_vhosts)) {
-			for_each_mapped_vp_idx(ha, i) {
-				list_for_each_entry(vha, &ha->vp_list,
-				    vp_list) {
-					if ((mb[3] & 0xff)
-					    == vha->vp_idx) {
-						ha = vha;
-						break;
-					}
-				}
-			}
-		}
+		/* Check if the Vport has issued a SCR */
+		if (ha->parent && test_bit(VP_SCR_NEEDED, &ha->vp_flags))
+			break;
+		/* Only handle SCNs for our Vport index. */
+		if (ha->parent && ha->vp_idx != (mb[3] & 0xff))
+			break;
 
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
@@ -1132,25 +1116,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha, void *pkt)
 				break;
 
 			qla2x00_handle_sense(sp, sense_data, sense_len);
-
-			/*
-			 * In case of a Underrun condition, set both the lscsi
-			 * status and the completion status to appropriate
-			 * values.
-			 */
-			if (resid &&
-			    ((unsigned)(scsi_bufflen(cp) - resid) <
-			     cp->underflow)) {
-				DEBUG2(qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d:%d): Mid-layer underflow "
-				    "detected (%x of %x bytes)...returning "
-				    "error status.\n", ha->host_no,
-				    cp->device->channel, cp->device->id,
-				    cp->device->lun, resid,
-				    scsi_bufflen(cp)));
-
-				cp->result = DID_ERROR << 16 | lscsi_status;
-			}
 		} else {
 			/*
 			 * If RISC reports underrun and target does not report
@@ -1639,12 +1604,12 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	ha = dev_id;
 	reg = &ha->iobase->isp24;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irq(&ha->hardware_lock);
 
 	qla24xx_process_response_queue(ha);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irq(&ha->hardware_lock);
 
 	return IRQ_HANDLED;
 }
@@ -1663,7 +1628,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irq(&ha->hardware_lock);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1716,7 +1681,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irq(&ha->hardware_lock);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2100604..250d2f6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2303,8 +2303,6 @@ qla24xx_lun_reset(struct fc_port *fcport, unsigned int l)
 	return __qla24xx_issue_tmf("Lun", TCF_LUN_RESET, fcport, l);
 }
 
-#if 0
-
 int
 qla2x00_system_error(scsi_qla_host_t *ha)
 {
@@ -2312,7 +2310,7 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_QLA23XX(ha) && !IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2334,8 +2332,6 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	return rval;
 }
 
-#endif  /*  0  */
-
 /**
  * qla2x00_set_serdes_params() -
  * @ha: HA context
@@ -2508,7 +2504,7 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 		if (mb)
 			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
 		if (dwords)
-			*dwords = mcp->mb[6];
+			*dwords = buffers;
 	}
 
 	return rval;
@@ -2807,9 +2803,9 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	 */
 	map = (vp_index - 1) / 8;
 	pos = (vp_index - 1) & 7;
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	vce->vp_idx_map[map] |= 1 << pos;
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	rval = qla2x00_issue_iocb(ha, vce, vce_dma, 0);
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f2b0497..62a3ad6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -32,12 +32,12 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	scsi_qla_host_t *ha = vha->parent;
 
 	/* Find an empty slot and assign an vp_id */
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	vp_id = find_first_zero_bit(ha->vp_idx_map, ha->max_npiv_vports + 1);
 	if (vp_id > ha->max_npiv_vports) {
 		DEBUG15(printk ("vp_id %d is bigger than max-supported %d.\n",
 		    vp_id, ha->max_npiv_vports));
-		up(&ha->vport_sem);
+		mutex_unlock(&ha->vport_lock);
 		return vp_id;
 	}
 
@@ -45,7 +45,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->vp_list, &ha->vp_list);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
 
@@ -55,12 +55,12 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	uint16_t vp_id;
 	scsi_qla_host_t *ha = vha->parent;
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
 	clear_bit(vp_id, ha->vp_idx_map);
 	list_del(&vha->vp_list);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 }
 
 static scsi_qla_host_t *
@@ -145,9 +145,9 @@ qla24xx_enable_vp(scsi_qla_host_t *vha)
 	}
 
 	/* Initialize the new vport unless it is a persistent port */
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	ret = qla24xx_modify_vp_config(vha);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	if (ret != QLA_SUCCESS) {
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
@@ -406,6 +406,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	INIT_LIST_HEAD(&vha->list);
 	INIT_LIST_HEAD(&vha->fcports);
 	INIT_LIST_HEAD(&vha->vp_fcports);
+	INIT_LIST_HEAD(&vha->work_list);
 
 	vha->dpc_flags = 0L;
 	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
@@ -437,10 +438,10 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->flags.init_done = 1;
 	num_hosts++;
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	set_bit(vha->vp_idx, ha->vp_idx_map);
 	ha->cur_vport_count++;
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	return vha;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3223fd1..48eaa3b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/mutex.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -1631,7 +1632,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
 
-	init_MUTEX(&ha->vport_sem);
+	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);
@@ -2156,13 +2157,14 @@ static int
 qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
 {
 	unsigned long flags;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
 	if (!locked)
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(&pha->hardware_lock, flags);
 	list_add_tail(&e->list, &ha->work_list);
 	qla2xxx_wake_dpc(ha);
 	if (!locked)
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&pha->hardware_lock, flags);
 	return QLA_SUCCESS;
 }
 
@@ -2202,12 +2204,13 @@ static void
 qla2x00_do_work(struct scsi_qla_host *ha)
 {
 	struct qla_work_evt *e;
+	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irq(&pha->hardware_lock);
 	while (!list_empty(&ha->work_list)) {
 		e = list_entry(ha->work_list.next, struct qla_work_evt, list);
 		list_del_init(&e->list);
-		spin_unlock_irq(&ha->hardware_lock);
+		spin_unlock_irq(&pha->hardware_lock);
 
 		switch (e->type) {
 		case QLA_EVT_AEN:
@@ -2221,9 +2224,9 @@ qla2x00_do_work(struct scsi_qla_host *ha)
 		}
 		if (e->flags & QLA_EVT_FLAG_FREE)
 			kfree(e);
-		spin_lock_irq(&ha->hardware_lock);
+		spin_lock_irq(&pha->hardware_lock);
 	}
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irq(&pha->hardware_lock);
 }
 
 /**************************************************************************
@@ -2634,7 +2637,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
 
-static DECLARE_MUTEX(qla_fw_lock);
+static DEFINE_MUTEX(qla_fw_lock);
 
 static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP21XX, .segs = { 0x1000, 0 }, },
@@ -2665,7 +2668,7 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 		blob = &qla_fw_blobs[FW_ISP25XX];
 	}
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	if (blob->fw)
 		goto out;
 
@@ -2678,7 +2681,7 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 	}
 
 out:
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 	return blob;
 }
 
@@ -2687,11 +2690,11 @@ qla2x00_release_firmware(void)
 {
 	int idx;
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	for (idx = 0; idx < FW_BLOBS; idx++)
 		if (qla_fw_blobs[idx].fw)
 			release_firmware(qla_fw_blobs[idx].fw);
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 }
 
 static pci_ers_result_t
@@ -2864,7 +2867,8 @@ qla2x00_module_init(void)
 		return -ENODEV;
 	}
 
-	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
+	printk(KERN_INFO "QLogic Fibre Channel HBA Driver: %s\n",
+	    qla2x00_version_str);
 	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index afeae2b..d058c88 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.02.01-k2"
+#define QLA2XXX_VERSION      "8.02.01-k4"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	2
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 049103f..93d2b67 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -359,7 +359,12 @@ static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 
 static int scsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_device *sdev;
+
+	if (dev->type != &scsi_dev_type)
+		return 0;
+
+	sdev = to_scsi_device(dev);
 
 	add_uevent_var(env, "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
 	return 0;


