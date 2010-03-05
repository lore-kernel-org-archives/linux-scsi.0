From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Fri, 05 Mar 2010 16:16:58 +0530
Message-ID: <1267786018.8894.43.camel@mulgrave.site>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab0CEKrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Mar 2010 05:47:22 -0500
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2010-02-16 at 16:40 +0530, Srinivas Naga Venkatasatya
Pasagadugula - ERS, HCL Tech wrote:
> From: Srinivas <satyasrinivasp@hcl.in>
> Date: Mon, 15 Feb 2010

So, I'll add it, it seems to work based on the reports.

> Subject: [PATCH]: Fix for hot plug handling and IO issues.
> 	Added code for handling of hot-plugging drives and tape issues. 

This is a bit terse for a change like this.

> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>

This is the only bit that seems to have a serious technical problem:

> @@ -2085,6 +2145,11 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
>  							phy_no, tmp);
>  			}
>  			mvs_update_phyinfo(mvi, phy_no, 0);
> +			if (phy->phy_type & PORT_TYPE_SAS) {
> +				MVS_CHIP_DISP->phy_reset(mvi, phy_no, 2);
> +				mdelay(100);
> +			}
> +
>  			mvs_bytes_dmaed(mvi, phy_no);
>  			/* whether driver is going to handle hot plug */
>  			if (phy->phy_event & PHY_PLUG_OUT) {

It's doing a 100ms CPU spin for each port initialisation.  For an eight
port system, that's nearly a second, all of which is done with the
mvi->lock held.  In particular, this is done in the ISR on some systems,
so that's really going to add massive delays.

It looks like this is just a bus settle time for the SAS ports, so
obviously they could all be reset in parallel and then the settle time
could be waited out (rather than doing each one in sequence), but
realistically even a single 100ms wait in an interrupt routine is too
long ... the port probably has to be marked as in reset somehow to avoid
this.

Other than the above, there were a large number of checkpatch errors,
which I fixed:

total: 58 errors, 19 warnings, 632 lines checked

can you start with the patch below to carry these fixes forwards?

Thanks,

James

---

diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.c
index 10a5077..afc7f6f 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -132,9 +132,9 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
 	tmp &= ~PHYEV_RDY_CH;
 	mvs_write_port_irq_stat(mvi, phy_id, tmp);
 	tmp = mvs_read_phy_ctl(mvi, phy_id);
-	if (hard)
+	if (hard == 1)
 		tmp |= PHY_RST_HARD;
-	else
+	else if (hard == 0)
 		tmp |= PHY_RST;
 	mvs_write_phy_ctl(mvi, phy_id, tmp);
 	if (hard) {
@@ -144,6 +144,26 @@ static void mvs_64xx_phy_reset(struct mvs_info *mvi, u32 phy_id, int hard)
 	}
 }
 
+void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u8 reg_set, u8 clear_all)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+	if (clear_all) {
+		tmp = mr32(MVS_INT_STAT_SRS_0);
+		if (tmp) {
+			printk(KERN_DEBUG "check SRS 0 %08X.\n", tmp);
+			mw32(MVS_INT_STAT_SRS_0, tmp);
+		}
+	} else {
+		tmp = mr32(MVS_INT_STAT_SRS_0);
+		if (tmp &  (1 << (reg_set % 32))) {
+			printk(KERN_DEBUG "register set 0x%x was stopped.\n",
+			       reg_set);
+			mw32(MVS_INT_STAT_SRS_0, 1 << (reg_set % 32));
+		}
+	}
+}
+
 static int __devinit mvs_64xx_chip_reset(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs;
@@ -761,6 +781,7 @@ const struct mvs_dispatch mvs_64xx_dispatch = {
 	mvs_write_port_irq_mask,
 	mvs_get_sas_addr,
 	mvs_64xx_command_active,
+	mvs_64xx_clear_srs_irq,
 	mvs_64xx_issue_stop,
 	mvs_start_delivery,
 	mvs_rx_update,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cae6b2c..203ff93 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -37,6 +37,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 };
 
 #define SOC_SAS_NUM 2
+#define SG_MX 64
 
 static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
@@ -53,10 +54,10 @@ static struct scsi_host_template mvs_sht = {
 	.can_queue		= 1,
 	.cmd_per_lun		= 1,
 	.this_id		= -1,
-	.sg_tablesize		= SG_ALL,
+	.sg_tablesize		= SG_MX,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.eh_device_reset_handler	= sas_eh_device_reset_handler,
+	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
 	.slave_alloc		= mvs_slave_alloc,
 	.target_destroy		= sas_target_destroy,
@@ -65,19 +66,17 @@ static struct scsi_host_template mvs_sht = {
 
 static struct sas_domain_function_template mvs_transport_ops = {
 	.lldd_dev_found 	= mvs_dev_found,
-	.lldd_dev_gone	= mvs_dev_gone,
-
+	.lldd_dev_gone		= mvs_dev_gone,
 	.lldd_execute_task	= mvs_queue_command,
 	.lldd_control_phy	= mvs_phy_control,
 
 	.lldd_abort_task	= mvs_abort_task,
 	.lldd_abort_task_set    = mvs_abort_task_set,
 	.lldd_clear_aca         = mvs_clear_aca,
-       .lldd_clear_task_set    = mvs_clear_task_set,
+	.lldd_clear_task_set    = mvs_clear_task_set,
 	.lldd_I_T_nexus_reset	= mvs_I_T_nexus_reset,
 	.lldd_lu_reset 		= mvs_lu_reset,
 	.lldd_query_task	= mvs_query_task,
-
 	.lldd_port_formed	= mvs_port_formed,
 	.lldd_port_deformed     = mvs_port_deformed,
 
@@ -213,7 +212,11 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 
 static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 {
-	int i, slot_nr;
+	int i = 0, j = 0, slot_nr;
+	unsigned long buf_size;
+    void *buf;
+    dma_addr_t buf_dma;
+    struct mvs_slot_info *slot = 0;
 
 	if (mvi->flags & MVF_FLAG_SOC)
 		slot_nr = MVS_SOC_SLOTS;
@@ -232,6 +235,7 @@ static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 		mvi->devices[i].dev_type = NO_DEVICE;
 		mvi->devices[i].device_id = i;
 		mvi->devices[i].dev_status = MVS_DEV_NORMAL;
+		init_timer(&mvi->devices[i].timer);
 	}
 
 	/*
@@ -437,6 +441,7 @@ static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
 
 	sha->sas_phy = arr_phy;
 	sha->sas_port = arr_port;
+	sha->core.shost = shost;
 
 	sha->lldd_ha = kzalloc(sizeof(struct mvs_prv_info), GFP_KERNEL);
 	if (!sha->lldd_ha)
@@ -574,6 +579,10 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 		}
 		nhost++;
 	} while (nhost < chip->n_host);
+#ifdef MVS_USE_TASKLET
+	tasklet_init(&mv_tasklet, mvs_tasklet,
+		     (unsigned long)SHOST_TO_SAS_HA(shost));
+#endif
 
 	mvs_post_sas_ha_init(shost, chip);
 
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 0d21386..4be7010 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -259,8 +259,6 @@ static inline void mvs_free_reg_set(struct mvs_info *mvi,
 		mv_printk("device has been free.\n");
 		return;
 	}
-	if (dev->runing_req != 0)
-		return;
 	if (dev->taskfileset == MVS_ID_NOT_MAPPED)
 		return;
 	MVS_CHIP_DISP->free_reg_set(mvi, &dev->taskfileset);
@@ -597,7 +595,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	struct mvs_slot_info *slot;
 	void *buf_prd;
 	u32 tag = tei->tag, hdr_tag;
-	u32 flags, del_q;
+	u32 flags, del_q, phy_mask;
 	void *buf_tmp;
 	u8 *buf_cmd, *buf_oaf;
 	dma_addr_t buf_tmp_dma;
@@ -762,8 +760,6 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	}
 	if (is_tmf)
 		flags |= (MCH_SSP_FR_TASK << MCH_SSP_FR_TYPE_SHIFT);
-	else
-		flags |= (MCH_SSP_FR_CMD << MCH_SSP_FR_TYPE_SHIFT);
 	hdr->flags = cpu_to_le32(flags | (tei->n_elem << MCH_PRD_LEN_SHIFT));
 	hdr->tags = cpu_to_le32(tag);
 	hdr->data_len = cpu_to_le32(task->total_xfer_len);
@@ -878,14 +874,15 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 	struct mvs_slot_info *slot;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
 	u32 n = num, pass = 0;
-	unsigned long flags = 0;
+	unsigned long flags = 0,  flags_libsas = 0;
 
 	if (!dev->port) {
 		struct task_status_struct *tsm = &t->task_status;
 
 		tsm->resp = SAS_TASK_UNDELIVERED;
 		tsm->stat = SAS_PHY_DOWN;
-		t->task_done(t);
+		if (dev->dev_type != SATA_DEV)
+			t->task_done(t);
 		return 0;
 	}
 
@@ -910,12 +907,24 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 		else
 			tei.port = &mvi->port[dev->port->id];
 
-		if (!tei.port->port_attached) {
+		if (tei.port && !tei.port->port_attached) {
 			if (sas_protocol_ata(t->task_proto)) {
 				mv_dprintk("port %d does not"
 					"attached device.\n", dev->port->id);
-				rc = SAS_PHY_DOWN;
-				goto out_done;
+				struct task_status_struct *ts = &t->task_status;
+				ts->stat = SAS_PROTO_RESPONSE;
+				ts->stat = SAS_PHY_DOWN;
+				spin_unlock_irqrestore(dev->sata_dev.ap->lock,
+						       flags_libsas);
+				spin_unlock_irqrestore(&mvi->lock, flags);
+				t->task_done(t);
+				spin_lock_irqsave(&mvi->lock, flags);
+				spin_lock_irqsave(dev->sata_dev.ap->lock,
+						  flags_libsas);
+				if (n > 1)
+					t = list_entry(t->list.next,
+						       struct sas_task, list);
+				continue;
 			} else {
 				struct task_status_struct *ts = &t->task_status;
 				ts->resp = SAS_TASK_UNDELIVERED;
@@ -973,8 +982,8 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 			break;
 		default:
 			dev_printk(KERN_ERR, mvi->dev,
-				"unknown sas_task proto: 0x%x\n",
-				t->task_proto);
+				   "unknown sas_task proto: 0x%x\n",
+				   t->task_proto);
 			rc = -EINVAL;
 			break;
 		}
@@ -993,11 +1002,15 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 		spin_unlock(&t->task_state_lock);
 
 		mvs_hba_memory_dump(mvi, tag, t->task_proto);
-		mvi_dev->runing_req++;
+		mvi_dev->running_req++;
 		++pass;
 		mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
 		if (n > 1)
 			t = list_entry(t->list.next, struct sas_task, list);
+		if (likely(pass))
+			MVS_CHIP_DISP->start_delivery(mvi, (mvi->tx_prod - 1) &
+						      (MVS_CHIP_SLOT_SZ - 1));
+
 	} while (--n);
 	rc = 0;
 	goto out_done;
@@ -1012,10 +1025,6 @@ err_out:
 			dma_unmap_sg(mvi->dev, t->scatter, n_elem,
 				     t->data_dir);
 out_done:
-	if (likely(pass)) {
-		MVS_CHIP_DISP->start_delivery(mvi,
-			(mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
-	}
 	spin_unlock_irqrestore(&mvi->lock, flags);
 	return rc;
 }
@@ -1187,7 +1196,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st)
 				MVS_CHIP_DISP->phy_reset(mvi, i, 0);
 				goto out_done;
 			}
-		}		else if (phy->phy_type & PORT_TYPE_SAS
+		}	else if (phy->phy_type & PORT_TYPE_SAS
 			|| phy->att_dev_info & PORT_SSP_INIT_MASK) {
 			phy->phy_attached = 1;
 			phy->identify.device_type =
@@ -1256,7 +1265,20 @@ static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock)
 
 static void mvs_port_notify_deformed(struct asd_sas_phy *sas_phy, int lock)
 {
-	/*Nothing*/
+	struct domain_device *dev;
+	struct mvs_phy *phy = sas_phy->lldd_phy;
+	struct mvs_info *mvi = phy->mvi;
+	struct asd_sas_port *port = sas_phy->port;
+	int phy_no = 0;
+
+	while (phy != &mvi->phy[phy_no]) {
+		phy_no++;
+		if (phy_no >= MVS_MAX_PHYS)
+			return;
+	}
+	list_for_each_entry(dev, &port->dev_list, dev_list_node)
+		mvs_do_release_task(phy->mvi, phy_no, NULL);
+
 }
 
 
@@ -1316,6 +1338,7 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
 		goto found_out;
 	}
 	dev->lldd_dev = mvi_device;
+	mvi_device->dev_status = MVS_DEV_NORMAL;
 	mvi_device->dev_type = dev->dev_type;
 	mvi_device->mvi_info = mvi;
 	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type)) {
@@ -1351,18 +1374,18 @@ int mvs_dev_found(struct domain_device *dev)
 	return mvs_dev_found_notify(dev, 1);
 }
 
-void mvs_dev_gone_notify(struct domain_device *dev, int lock)
+void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
-	if (lock)
-		spin_lock_irqsave(&mvi->lock, flags);
+	spin_lock_irqsave(&mvi->lock, flags);
 
 	if (mvi_dev) {
 		mv_dprintk("found dev[%d:%x] is gone.\n",
 			mvi_dev->device_id, mvi_dev->dev_type);
+		mvs_release_task(mvi, dev);
 		mvs_free_reg_set(mvi, mvi_dev);
 		mvs_free_dev(mvi_dev);
 	} else {
@@ -1370,14 +1393,13 @@ void mvs_dev_gone_notify(struct domain_device *dev, int lock)
 	}
 	dev->lldd_dev = NULL;
 
-	if (lock)
 		spin_unlock_irqrestore(&mvi->lock, flags);
 }
 
 
 void mvs_dev_gone(struct domain_device *dev)
 {
-	mvs_dev_gone_notify(dev, 1);
+	mvs_dev_gone_notify(dev);
 }
 
 static  struct sas_task *mvs_alloc_task(void)
@@ -1540,7 +1562,7 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 		num = mvs_find_dev_phyno(dev, phyno);
 		spin_lock_irqsave(&mvi->lock, flags);
 		for (i = 0; i < num; i++)
-			mvs_release_task(mvi, phyno[i], dev);
+			mvs_release_task(mvi, dev);
 		spin_unlock_irqrestore(&mvi->lock, flags);
 	}
 	/* If failed, fall-through I_T_Nexus reset */
@@ -1552,8 +1574,8 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun)
 int mvs_I_T_nexus_reset(struct domain_device *dev)
 {
 	unsigned long flags;
-	int i, phyno[WIDE_PORT_MAX_PHY], num , rc = TMF_RESP_FUNC_FAILED;
-	struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
+	int rc = TMF_RESP_FUNC_FAILED;
+    struct mvs_device * mvi_dev = (struct mvs_device *)dev->lldd_dev;
 	struct mvs_info *mvi = mvi_dev->mvi_info;
 
 	if (mvi_dev->dev_status != MVS_DEV_EH)
@@ -1563,10 +1585,8 @@ int mvs_I_T_nexus_reset(struct domain_device *dev)
 		__func__, mvi_dev->device_id, rc);
 
 	/* housekeeper */
-	num = mvs_find_dev_phyno(dev, phyno);
 	spin_lock_irqsave(&mvi->lock, flags);
-	for (i = 0; i < num; i++)
-		mvs_release_task(mvi, phyno[i], dev);
+	mvs_release_task(mvi, dev);
 	spin_unlock_irqrestore(&mvi->lock, flags);
 
 	return rc;
@@ -1603,6 +1623,9 @@ int mvs_query_task(struct sas_task *task)
 		case TMF_RESP_FUNC_FAILED:
 		case TMF_RESP_FUNC_COMPLETE:
 			break;
+		default:
+			rc = TMF_RESP_FUNC_COMPLETE;
+			break;
 		}
 	}
 	mv_printk("%s:rc= %d\n", __func__, rc);
@@ -1621,8 +1644,11 @@ int mvs_abort_task(struct sas_task *task)
 	unsigned long flags;
 	u32 tag;
 
-	if (mvi->exp_req)
-		mvi->exp_req--;
+	if (!mvi_dev) {
+		mv_printk("%s:%d TMF_RESP_FUNC_FAILED\n", __func__, __LINE__);
+		rc = TMF_RESP_FUNC_FAILED;
+	}
+
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -1630,6 +1656,7 @@ int mvs_abort_task(struct sas_task *task)
 		goto out;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	mvi_dev->dev_status = MVS_DEV_EH;
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd * cmnd = (struct scsi_cmnd *)task->uldd_task;
 
@@ -1654,12 +1681,31 @@ int mvs_abort_task(struct sas_task *task)
 			if (task->lldd_task) {
 				slot = task->lldd_task;
 				slot_no = (u32) (slot - mvi->slot_info);
+				spin_lock_irqsave(&mvi->lock, flags);
 				mvs_slot_complete(mvi, slot_no, 1);
+				spin_unlock_irqrestore(&mvi->lock, flags);
 			}
 		}
+
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		/* to do free register_set */
+		if (SATA_DEV == dev->dev_type) {
+			struct mvs_slot_info *slot = task->lldd_task;
+			struct task_status_struct *tstat;
+			u32 slot_idx = (u32)(slot - mvi->slot_info);
+			tstat = &task->task_status;
+			mv_dprintk(KERN_DEBUG "mv_abort_task() mvi=%p task=%p "
+				   "slot=%p slot_idx=x%x\n",
+				   mvi, task, slot, slot_idx);
+			tstat->stat = SAS_ABORTED_TASK;
+			if (mvi_dev && mvi_dev->running_req)
+				mvi_dev->running_req--;
+			if (sas_protocol_ata(task->task_proto))
+				mvs_free_reg_set(mvi, mvi_dev);
+			mvs_slot_task_free(mvi, task, slot, slot_idx);
+			return -1;
+		}
 	} else {
 		/* SMP */
 
@@ -1717,8 +1763,13 @@ static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
 	       SATA_RECEIVED_D2H_FIS(mvi_dev->taskfileset),
 	       sizeof(struct dev_to_host_fis));
 	tstat->buf_valid_size = sizeof(*resp);
-	if (unlikely(err))
-		stat = SAS_PROTO_RESPONSE;
+	if (unlikely(err)) {
+		if (unlikely(err & CMD_ISS_STPD))
+			stat = SAS_OPEN_REJECT;
+		else
+			stat = SAS_PROTO_RESPONSE;
+       }
+
 	return stat;
 }
 
@@ -1728,6 +1779,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
 	int stat;
 	u32 err_dw0 = le32_to_cpu(*(u32 *) (slot->response));
+	u32 err_dw1 = le32_to_cpu(*((u32 *)slot->response+1));
 	u32 tfs = 0;
 	enum mvs_port_type type = PORT_TYPE_SAS;
 
@@ -1753,9 +1805,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 			mv_printk("find reserved error, why?\n");
 
 		task->ata_task.use_ncq = 0;
-		stat = SAS_PROTO_RESPONSE;
-		mvs_sata_done(mvi, task, slot_idx, 1);
-
+		mvs_sata_done(mvi, task, slot_idx, err_dw0);
 	}
 		break;
 	default:
@@ -1772,18 +1822,20 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	struct sas_task *task = slot->task;
 	struct mvs_device *mvi_dev = NULL;
 	struct task_status_struct *tstat;
+	struct domain_device *dev;
+	u32 aborted;
 
-	bool aborted;
 	void *to;
 	enum exec_status sts;
 
 	if (mvi->exp_req)
 		mvi->exp_req--;
-	if (unlikely(!task || !task->lldd_task))
+	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return -1;
 
 	tstat = &task->task_status;
-	mvi_dev = task->dev->lldd_dev;
+	dev = task->dev;
+	mvi_dev = dev->lldd_dev;
 
 	mvs_hba_cq_dump(mvi);
 
@@ -1800,8 +1852,8 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 
 	if (unlikely(aborted)) {
 		tstat->stat = SAS_ABORTED_TASK;
-		if (mvi_dev)
-			mvi_dev->runing_req--;
+		if (mvi_dev && mvi_dev->running_req)
+			mvi_dev->running_req--;
 		if (sas_protocol_ata(task->task_proto))
 			mvs_free_reg_set(mvi, mvi_dev);
 
@@ -1809,24 +1861,17 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		return -1;
 	}
 
-	if (unlikely(!mvi_dev || !slot->port->port_attached || flags)) {
-		mv_dprintk("port has not device.\n");
+	if (unlikely(!mvi_dev || flags)) {
+		if (!mvi_dev)
+			mv_dprintk("port has not device.\n");
 		tstat->stat = SAS_PHY_DOWN;
 		goto out;
 	}
 
-	/*
-	if (unlikely((rx_desc & RXQ_ERR) || (*(u64 *) slot->response))) {
-		 mv_dprintk("Find device[%016llx] RXQ_ERR %X,
-		 err info:%016llx\n",
-		 SAS_ADDR(task->dev->sas_addr),
-		 rx_desc, (u64)(*(u64 *) slot->response));
-	}
-	*/
-
 	/* error info record present */
 	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
+		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
 	}
 
@@ -1868,11 +1913,16 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		tstat->stat = SAM_CHECK_COND;
 		break;
 	}
+	if (!slot->port->port_attached) {
+		mv_dprintk("port %d has removed.\n", slot->port->sas_port.id);
+		tstat->stat = SAS_PHY_DOWN;
+	}
+
 
 out:
-	if (mvi_dev) {
-		mvi_dev->runing_req--;
-		if (sas_protocol_ata(task->task_proto))
+	if (mvi_dev && mvi_dev->running_req) {
+		mvi_dev->running_req--;
+		if (sas_protocol_ata(task->task_proto) && !mvi_dev->running_req)
 			mvs_free_reg_set(mvi, mvi_dev);
 	}
 	mvs_slot_task_free(mvi, task, slot, slot_idx);
@@ -1888,10 +1938,10 @@ out:
 	return sts;
 }
 
-void mvs_release_task(struct mvs_info *mvi,
+void mvs_do_release_task(struct mvs_info *mvi,
 		int phy_no, struct domain_device *dev)
 {
-	int i = 0; u32 slot_idx;
+	u32 slot_idx;
 	struct mvs_phy *phy;
 	struct mvs_port *port;
 	struct mvs_slot_info *slot, *slot2;
@@ -1900,6 +1950,10 @@ void mvs_release_task(struct mvs_info *mvi,
 	port = phy->port;
 	if (!port)
 		return;
+	/* clean cmpl queue in case request is already finished */
+	mvs_int_rx(mvi, false);
+
+
 
 	list_for_each_entry_safe(slot, slot2, &port->list, entry) {
 		struct sas_task *task;
@@ -1911,18 +1965,22 @@ void mvs_release_task(struct mvs_info *mvi,
 
 		mv_printk("Release slot [%x] tag[%x], task [%p]:\n",
 			slot_idx, slot->slot_tag, task);
-
-		if (task->task_proto & SAS_PROTOCOL_SSP) {
-			mv_printk("attached with SSP task CDB[");
-			for (i = 0; i < 16; i++)
-				mv_printk(" %02x", task->ssp_task.cdb[i]);
-			mv_printk(" ]\n");
-		}
+		MVS_CHIP_DISP->command_active(mvi, slot_idx);
 
 		mvs_slot_complete(mvi, slot_idx, 1);
 	}
 }
 
+void mvs_release_task(struct mvs_info *mvi,
+		      struct domain_device *dev)
+{
+	int i, phyno[WIDE_PORT_MAX_PHY], num;
+	/* housekeeper */
+	num = mvs_find_dev_phyno(dev, phyno);
+	for (i = 0; i < num; i++)
+		mvs_do_release_task(mvi, phyno[i], dev);
+}
+
 static void mvs_phy_disconnected(struct mvs_phy *phy)
 {
 	phy->phy_attached = 0;
@@ -2029,16 +2087,18 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 	* we need check the interrupt status which belongs to per port.
 	*/
 
-	if (phy->irq_status & PHYEV_DCDR_ERR)
+	if (phy->irq_status & PHYEV_DCDR_ERR) {
 		mv_dprintk("port %d STP decoding error.\n",
-		phy_no+mvi->id*mvi->chip->n_phy);
+		phy_no + mvi->id*mvi->chip->n_phy);
+	}
 
 	if (phy->irq_status & PHYEV_POOF) {
 		if (!(phy->phy_event & PHY_PLUG_OUT)) {
 			int dev_sata = phy->phy_type & PORT_TYPE_SATA;
 			int ready;
-			mvs_release_task(mvi, phy_no, NULL);
+			mvs_do_release_task(mvi, phy_no, NULL);
 			phy->phy_event |= PHY_PLUG_OUT;
+			MVS_CHIP_DISP->clear_srs_irq(mvi, 0, 1);
 			mvs_handle_event(mvi,
 				(void *)(unsigned long)phy_no,
 				PHY_PLUG_EVENT);
@@ -2085,6 +2145,11 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 							phy_no, tmp);
 			}
 			mvs_update_phyinfo(mvi, phy_no, 0);
+			if (phy->phy_type & PORT_TYPE_SAS) {
+				MVS_CHIP_DISP->phy_reset(mvi, phy_no, 2);
+				mdelay(100);
+			}
+
 			mvs_bytes_dmaed(mvi, phy_no);
 			/* whether driver is going to handle hot plug */
 			if (phy->phy_event & PHY_PLUG_OUT) {
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index aa2270a..85b79c7 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -38,6 +38,7 @@
 #include <linux/irq.h>
 #include <linux/vmalloc.h>
 #include <scsi/libsas.h>
+#include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
 #include <linux/version.h>
@@ -48,7 +49,7 @@
 #define _MV_DUMP		0
 #define MVS_ID_NOT_MAPPED	0x7f
 /* #define DISABLE_HOTPLUG_DMA_FIX */
-#define MAX_EXP_RUNNING_REQ	2
+// #define MAX_EXP_RUNNING_REQ	2
 #define WIDE_PORT_MAX_PHY		4
 #define	MV_DISABLE_NCQ	0
 #define mv_printk(fmt, arg ...)	\
@@ -128,6 +129,7 @@ struct mvs_dispatch {
 
 	void (*get_sas_addr)(void *buf, u32 buflen);
 	void (*command_active)(struct mvs_info *mvi, u32 slot_idx);
+	void (*clear_srs_irq)(struct mvs_info *mvi, u8 reg_set, u8 clear_all);
 	void (*issue_stop)(struct mvs_info *mvi, enum mvs_port_type type,
 				u32 tfs);
 	void (*start_delivery)(struct mvs_info *mvi, u32 tx);
@@ -235,9 +237,10 @@ struct mvs_device {
 	enum sas_dev_type dev_type;
 	struct mvs_info *mvi_info;
 	struct domain_device *sas_device;
+	struct timer_list timer;
 	u32 attached_phy;
 	u32 device_id;
-	u32 runing_req;
+	u32 running_req;
 	u8 taskfileset;
 	u8 dev_status;
 	u16 reserved;
@@ -396,7 +399,9 @@ int mvs_lu_reset(struct domain_device *dev, u8 *lun);
 int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags);
 int mvs_I_T_nexus_reset(struct domain_device *dev);
 int mvs_query_task(struct sas_task *task);
-void mvs_release_task(struct mvs_info *mvi, int phy_no,
+void mvs_release_task(struct mvs_info *mvi,
+			struct domain_device *dev);
+void mvs_do_release_task(struct mvs_info *mvi, int phy_no,
 			struct domain_device *dev);
 void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events);
 void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);


