From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/5] qla2xxx: Code changes to support new dynamic logging infrastructure.
Date: Thu, 14 Jul 2011 12:00:13 -0700
Message-ID: <1310670016-30216-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42431 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753071Ab1GNTJL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 15:09:11 -0400
In-Reply-To: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

The code is changed to support the new dynamic logging infrastructure.
Following are the levels added.
Default is 0 - no logging.  0x40000000 - Module Init & Probe.
0x20000000 - Mailbox Cmnds. 0x10000000 - Device Discovery.
0x08000000 - IO tracing.    0x04000000 - DPC Thread.
0x02000000 - Async events.  0x01000000 - Timer routines.
0x00800000 - User space.    0x00400000 - Task Management.
0x00200000 - AER/EEH.       0x00100000 - Multi Q.
0x00080000 - P3P Specific.  0x00040000 - Virtual Port.
0x00020000 - Buffer Dump.   0x00010000 - Misc.
0x7fffffff - For enabling all logs, can be too many logs.

Setting ql2xextended_error_logging module parameter to any of the above
value, will enable the debug for that particular level.
Do LOGICAL OR of the value to enable more than one level.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  183 ++++++-----
 drivers/scsi/qla2xxx/qla_bsg.c  |  441 ++++++++++++++------------
 drivers/scsi/qla2xxx/qla_isr.c  |  663 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_nx.c   |  556 ++++++++++++++++++--------------
 4 files changed, 976 insertions(+), 867 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 532313e..7836eb0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -42,8 +42,8 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 	int reading;
 
 	if (IS_QLA82XX(ha)) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-			"Firmware dump not supported for ISP82xx\n"));
+		ql_dbg(ql_dbg_user, vha, 0x705b,
+		    "Firmware dump not supported for ISP82xx\n");
 		return count;
 	}
 
@@ -56,7 +56,7 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 		if (!ha->fw_dump_reading)
 			break;
 
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_info, vha, 0x705d,
 		    "Firmware dump cleared on (%ld).\n", vha->host_no);
 
 		ha->fw_dump_reading = 0;
@@ -66,7 +66,7 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 		if (ha->fw_dumped && !ha->fw_dump_reading) {
 			ha->fw_dump_reading = 1;
 
-			qla_printk(KERN_INFO, ha,
+			ql_log(ql_log_info, vha, 0x705e,
 			    "Raw firmware dump ready for read on (%ld).\n",
 			    vha->host_no);
 		}
@@ -148,7 +148,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 	}
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x705f,
 		    "HBA not online, failing NVRAM update.\n");
 		return -EAGAIN;
 	}
@@ -158,6 +158,8 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->nvram, ha->nvram_base,
 	    count);
 
+	ql_dbg(ql_dbg_user, vha, 0x7060,
+	    "Setting ISP_ABORT_NEEDED\n");
 	/* NVRAM settings take effect immediately. */
 	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	qla2xxx_wake_dpc(vha);
@@ -255,9 +257,9 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 
 		ha->optrom_state = QLA_SWAITING;
 
-		DEBUG2(qla_printk(KERN_INFO, ha,
+		ql_dbg(ql_dbg_user, vha, 0x7061,
 		    "Freeing flash region allocation -- 0x%x bytes.\n",
-		    ha->optrom_region_size));
+		    ha->optrom_region_size);
 
 		vfree(ha->optrom_buffer);
 		ha->optrom_buffer = NULL;
@@ -273,7 +275,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		ha->optrom_state = QLA_SREADING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x7062,
 			    "Unable to allocate memory for optrom retrieval "
 			    "(%x).\n", ha->optrom_region_size);
 
@@ -282,14 +284,14 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		}
 
 		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
-			qla_printk(KERN_WARNING, ha,
-				"HBA not online, failing NVRAM update.\n");
+			ql_log(ql_log_warn, vha, 0x7063,
+			    "HBA not online, failing NVRAM update.\n");
 			return -EAGAIN;
 		}
 
-		DEBUG2(qla_printk(KERN_INFO, ha,
+		ql_dbg(ql_dbg_user, vha, 0x7064,
 		    "Reading flash region -- 0x%x/0x%x.\n",
-		    ha->optrom_region_start, ha->optrom_region_size));
+		    ha->optrom_region_start, ha->optrom_region_size);
 
 		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		ha->isp_ops->read_optrom(vha, ha->optrom_buffer,
@@ -328,7 +330,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		else if (IS_QLA25XX(ha) || IS_QLA8XXX_TYPE(ha))
 			valid = 1;
 		if (!valid) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x7065,
 			    "Invalid start region 0x%x/0x%x.\n", start, size);
 			return -EINVAL;
 		}
@@ -340,17 +342,17 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		ha->optrom_state = QLA_SWRITING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x7066,
 			    "Unable to allocate memory for optrom update "
-			    "(%x).\n", ha->optrom_region_size);
+			    "(%x)\n", ha->optrom_region_size);
 
 			ha->optrom_state = QLA_SWAITING;
 			return count;
 		}
 
-		DEBUG2(qla_printk(KERN_INFO, ha,
+		ql_dbg(ql_dbg_user, vha, 0x7067,
 		    "Staging flash region write -- 0x%x/0x%x.\n",
-		    ha->optrom_region_start, ha->optrom_region_size));
+		    ha->optrom_region_start, ha->optrom_region_size);
 
 		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		break;
@@ -359,14 +361,14 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 			break;
 
 		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x7068,
 			    "HBA not online, failing flash update.\n");
 			return -EAGAIN;
 		}
 
-		DEBUG2(qla_printk(KERN_INFO, ha,
+		ql_dbg(ql_dbg_user, vha, 0x7069,
 		    "Writing flash region -- 0x%x/0x%x.\n",
-		    ha->optrom_region_start, ha->optrom_region_size));
+		    ha->optrom_region_start, ha->optrom_region_size);
 
 		ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
@@ -425,7 +427,7 @@ qla2x00_sysfs_write_vpd(struct file *filp, struct kobject *kobj,
 		return 0;
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x706a,
 		    "HBA not online, failing VPD update.\n");
 		return -EAGAIN;
 	}
@@ -440,7 +442,7 @@ qla2x00_sysfs_write_vpd(struct file *filp, struct kobject *kobj,
 
 	tmp_data = vmalloc(256);
 	if (!tmp_data) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x706b,
 		    "Unable to allocate memory for VPD information update.\n");
 		goto done;
 	}
@@ -480,7 +482,7 @@ qla2x00_sysfs_read_sfp(struct file *filp, struct kobject *kobj,
 	ha->sfp_data = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
 	    &ha->sfp_data_dma);
 	if (!ha->sfp_data) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x706c,
 		    "Unable to allocate memory for SFP read-data.\n");
 		return 0;
 	}
@@ -499,9 +501,10 @@ do_read:
 		rval = qla2x00_read_sfp(vha, ha->sfp_data_dma, ha->sfp_data,
 		    addr, offset, SFP_BLOCK_SIZE, 0);
 		if (rval != QLA_SUCCESS) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0x706d,
 			    "Unable to read SFP data (%x/%x/%x).\n", rval,
 			    addr, offset);
+
 			count = 0;
 			break;
 		}
@@ -538,8 +541,8 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 	type = simple_strtol(buf, NULL, 10);
 	switch (type) {
 	case 0x2025c:
-		qla_printk(KERN_INFO, ha,
-		    "Issuing ISP reset on (%ld).\n", vha->host_no);
+		ql_log(ql_log_info, vha, 0x706e,
+		    "Issuing ISP reset.\n");
 
 		scsi_block_requests(vha->host);
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -551,8 +554,8 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 		if (!IS_QLA81XX(ha))
 			break;
 
-		qla_printk(KERN_INFO, ha,
-		    "Issuing MPI reset on (%ld).\n", vha->host_no);
+		ql_log(ql_log_info, vha, 0x706f,
+		    "Issuing MPI reset.\n");
 
 		/* Make sure FC side is not in reset */
 		qla2x00_wait_for_hba_online(vha);
@@ -560,20 +563,19 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 		/* Issue MPI reset */
 		scsi_block_requests(vha->host);
 		if (qla81xx_restart_mpi_firmware(vha) != QLA_SUCCESS)
-			qla_printk(KERN_WARNING, ha,
-			    "MPI reset failed on (%ld).\n", vha->host_no);
+			ql_log(ql_log_warn, vha, 0x7070,
+			    "MPI reset failed.\n");
 		scsi_unblock_requests(vha->host);
 		break;
 	case 0x2025e:
 		if (!IS_QLA82XX(ha) || vha != base_vha) {
-			qla_printk(KERN_INFO, ha,
-			    "FCoE ctx reset not supported for host%ld.\n",
-			    vha->host_no);
+			ql_log(ql_log_info, vha, 0x7071,
+			    "FCoE ctx reset no supported.\n");
 			return count;
 		}
 
-		qla_printk(KERN_INFO, ha,
-		    "Issuing FCoE CTX reset on host%ld.\n", vha->host_no);
+		ql_log(ql_log_info, vha, 0x7072,
+		    "Issuing FCoE ctx reset.\n");
 		set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
 		qla2x00_wait_for_fcoe_ctx_reset(vha);
@@ -611,8 +613,8 @@ qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 		ha->edc_data = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
 		    &ha->edc_data_dma);
 		if (!ha->edc_data) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "Unable to allocate memory for EDC write.\n"));
+			ql_log(ql_log_warn, vha, 0x7073,
+			    "Unable to allocate memory for EDC write.\n");
 			return 0;
 		}
 	}
@@ -631,9 +633,9 @@ qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 	rval = qla2x00_write_sfp(vha, ha->edc_data_dma, ha->edc_data,
 	    dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "Unable to write EDC (%x) %02x:%02x:%04x:%02x:%02x.\n",
-		    rval, dev, adr, opt, len, buf[8]));
+		ql_log(ql_log_warn, vha, 0x7074,
+		    "Unable to write EDC (%x) %02x:%04x:%02x:%02x\n",
+		    rval, dev, adr, opt, len, buf[8]);
 		return 0;
 	}
 
@@ -669,8 +671,8 @@ qla2x00_sysfs_write_edc_status(struct file *filp, struct kobject *kobj,
 		ha->edc_data = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
 		    &ha->edc_data_dma);
 		if (!ha->edc_data) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "Unable to allocate memory for EDC status.\n"));
+			ql_log(ql_log_warn, vha, 0x708c,
+			    "Unable to allocate memory for EDC status.\n");
 			return 0;
 		}
 	}
@@ -688,9 +690,9 @@ qla2x00_sysfs_write_edc_status(struct file *filp, struct kobject *kobj,
 	rval = qla2x00_read_sfp(vha, ha->edc_data_dma, ha->edc_data,
 			dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "Unable to write EDC status (%x) %02x:%02x:%04x:%02x.\n",
-		    rval, dev, adr, opt, len));
+		ql_log(ql_log_info, vha, 0x7075,
+		    "Unable to write EDC status (%x) %02x:%04x:%02x.\n",
+		    rval, dev, adr, opt, len);
 		return 0;
 	}
 
@@ -749,7 +751,7 @@ qla2x00_sysfs_read_xgmac_stats(struct file *filp, struct kobject *kobj,
 	ha->xgmac_data = dma_alloc_coherent(&ha->pdev->dev, XGMAC_DATA_SIZE,
 	    &ha->xgmac_data_dma, GFP_KERNEL);
 	if (!ha->xgmac_data) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x7076,
 		    "Unable to allocate memory for XGMAC read-data.\n");
 		return 0;
 	}
@@ -761,7 +763,7 @@ do_read:
 	rval = qla2x00_get_xgmac_stats(vha, ha->xgmac_data_dma,
 	    XGMAC_DATA_SIZE, &actual_size);
 	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x7077,
 		    "Unable to read XGMAC data (%x).\n", rval);
 		count = 0;
 	}
@@ -801,7 +803,7 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 	ha->dcbx_tlv = dma_alloc_coherent(&ha->pdev->dev, DCBX_TLV_DATA_SIZE,
 	    &ha->dcbx_tlv_dma, GFP_KERNEL);
 	if (!ha->dcbx_tlv) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x7078,
 		    "Unable to allocate memory for DCBX TLV read-data.\n");
 		return 0;
 	}
@@ -813,8 +815,8 @@ do_read:
 	rval = qla2x00_get_dcbx_params(vha, ha->dcbx_tlv_dma,
 	    DCBX_TLV_DATA_SIZE);
 	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Unable to read DCBX TLV data (%x).\n", rval);
+		ql_log(ql_log_warn, vha, 0x7079,
+		    "Unable to read DCBX TLV (%x).\n", rval);
 		count = 0;
 	}
 
@@ -869,9 +871,13 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
 		if (ret)
-			qla_printk(KERN_INFO, vha->hw,
-			    "Unable to create sysfs %s binary attribute "
-			    "(%d).\n", iter->name, ret);
+			ql_log(ql_log_warn, vha, 0x00f3,
+			    "Unable to create sysfs %s binary attribute (%d).\n",
+			    iter->name, ret);
+		else
+			ql_dbg(ql_dbg_init, vha, 0x00f4,
+			    "Successfully created sysfs %s binary attribure.\n",
+			    iter->name);
 	}
 }
 
@@ -1126,7 +1132,7 @@ qla2x00_beacon_store(struct device *dev, struct device_attribute *attr,
 		return -EPERM;
 
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x707a,
 		    "Abort ISP active -- ignoring beacon request.\n");
 		return -EBUSY;
 	}
@@ -1322,9 +1328,8 @@ qla2x00_thermal_temp_show(struct device *dev,
 	temp = frac = 0;
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
 	    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
-		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): isp reset in progress.\n",
-		    __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x707b,
+		    "ISP reset active.\n");
 	else if (!vha->hw->flags.eeh_busy)
 		rval = qla2x00_get_thermal_temp(vha, &temp, &frac);
 	if (rval != QLA_SUCCESS)
@@ -1343,8 +1348,8 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
 		test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
-		DEBUG2_3_11(printk("%s(%ld): isp reset in progress.\n",
-			__func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x707c,
+		    "ISP reset active.\n");
 	else if (!vha->hw->flags.eeh_busy)
 		rval = qla2x00_get_firmware_state(vha, state);
 	if (rval != QLA_SUCCESS)
@@ -1645,8 +1650,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 
 	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
 	if (stats == NULL) {
-		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
-		    __func__, base_vha->host_no));
+		ql_log(ql_log_warn, vha, 0x707d,
+		    "Failed to allocate memory for stats.\n");
 		goto done;
 	}
 	memset(stats, 0, DMA_POOL_SIZE);
@@ -1746,15 +1751,14 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
 	if (ret) {
-		DEBUG15(printk("qla24xx_vport_create_req_sanity_check failed, "
-		    "status %x\n", ret));
+		ql_log(ql_log_warn, vha, 0x707e,
+		    "Vport sanity check failed, status %x\n", ret);
 		return (ret);
 	}
 
 	vha = qla24xx_create_vhost(fc_vport);
 	if (vha == NULL) {
-		DEBUG15(printk ("qla24xx_create_vhost failed, vha = %p\n",
-		    vha));
+		ql_log(ql_log_warn, vha, 0x707f, "Vport create host failed.\n");
 		return FC_VPORT_FAILED;
 	}
 	if (disable) {
@@ -1764,8 +1768,8 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 		atomic_set(&vha->vp_state, VP_FAILED);
 
 	/* ready to create vport */
-	qla_printk(KERN_INFO, vha->hw, "VP entry id %d assigned.\n",
-							vha->vp_idx);
+	ql_log(ql_log_info, vha, 0x7080,
+	    "VP entry id %d assigned.\n", vha->vp_idx);
 
 	/* initialized vport states */
 	atomic_set(&vha->loop_state, LOOP_DOWN);
@@ -1775,8 +1779,8 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	if (atomic_read(&base_vha->loop_state) == LOOP_DOWN ||
 	    atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
 		/* Don't retry or attempt login of this virtual port */
-		DEBUG15(printk ("scsi(%ld): pport loop_state is not UP.\n",
-		    base_vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x7081,
+		    "Vport loop state is not UP.\n");
 		atomic_set(&vha->loop_state, LOOP_DEAD);
 		if (!disable)
 			fc_vport_set_state(fc_vport, FC_VPORT_LINKDOWN);
@@ -1785,9 +1789,8 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && ql2xenabledif) {
 		if (ha->fw_attributes & BIT_4) {
 			vha->flags.difdix_supported = 1;
-			DEBUG18(qla_printk(KERN_INFO, ha,
-			    "Registering for DIF/DIX type 1 and 3"
-			    " protection.\n"));
+			ql_dbg(ql_dbg_user, vha, 0x7082,
+			    "Registered for DIF/DIX type 1 and 3 protection.\n");
 			scsi_host_set_prot(vha->host,
 			    SHOST_DIF_TYPE1_PROTECTION
 			    | SHOST_DIF_TYPE2_PROTECTION
@@ -1802,8 +1805,8 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	if (scsi_add_host_with_dma(vha->host, &fc_vport->dev,
 				   &ha->pdev->dev)) {
-		DEBUG15(printk("scsi(%ld): scsi_add_host failure for VP[%d].\n",
-			vha->host_no, vha->vp_idx));
+		ql_dbg(ql_dbg_user, vha, 0x7083,
+		    "scsi_add_host failure for VP[%d].\n", vha->vp_idx);
 		goto vport_create_failed_2;
 	}
 
@@ -1820,6 +1823,10 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 	if (ha->flags.cpu_affinity_enabled) {
 		req = ha->req_q_map[1];
+		ql_dbg(ql_dbg_multiq, vha, 0xc000,
+		    "Request queue %p attached with "
+		    "VP[%d], cpu affinity =%d\n",
+		    req, vha->vp_idx, ha->flags.cpu_affinity_enabled);
 		goto vport_queue;
 	} else if (ql2xmaxqueues == 1 || !ha->npiv_info)
 		goto vport_queue;
@@ -1836,13 +1843,16 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 		ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, 0,
 			qos);
 		if (!ret)
-			qla_printk(KERN_WARNING, ha,
-			"Can't create request queue for vp_idx:%d\n",
-			vha->vp_idx);
+			ql_log(ql_log_warn, vha, 0x7084,
+			    "Can't create request queue for VP[%d]\n",
+			    vha->vp_idx);
 		else {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			"Request Que:%d (QoS: %d) created for vp_idx:%d\n",
-			ret, qos, vha->vp_idx));
+			ql_dbg(ql_dbg_multiq, vha, 0xc001,
+			    "Request Que:%d Q0s: %d) created for VP[%d]\n",
+			    ret, qos, vha->vp_idx);
+			ql_dbg(ql_dbg_user, vha, 0x7085,
+			    "Request Que:%d Q0s: %d) created for VP[%d]\n",
+			    ret, qos, vha->vp_idx);
 			req = ha->req_q_map[ret];
 		}
 	}
@@ -1882,12 +1892,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	if (vha->timer_active) {
 		qla2x00_vp_stop_timer(vha);
-		DEBUG15(printk(KERN_INFO "scsi(%ld): timer for the vport[%d]"
-		" = %p has stopped\n", vha->host_no, vha->vp_idx, vha));
+		ql_dbg(ql_dbg_user, vha, 0x7086,
+		    "Timer for the VP[%d] has stopped\n", vha->vp_idx);
 	}
 
 	/* No pending activities shall be there on the vha now */
-	DEBUG(msleep(random32()%10));  /* Just to see if something falls on
+	if (ql2xextended_error_logging & ql_dbg_user)
+		msleep(random32()%10);  /* Just to see if something falls on
 					* the net we have placed below */
 
 	BUG_ON(atomic_read(&vha->vref_count));
@@ -1901,12 +1912,12 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	if (vha->req->id && !ha->flags.cpu_affinity_enabled) {
 		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
-			qla_printk(KERN_WARNING, ha,
-				"Queue delete failed.\n");
+			ql_log(ql_log_warn, vha, 0x7087,
+			    "Queue delete failed.\n");
 	}
 
 	scsi_host_put(vha->host);
-	qla_printk(KERN_INFO, ha, "vport %d deleted\n", id);
+	ql_log(ql_log_info, vha, 0x7088, "VP[%d] deleted.\n", id);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8c10e2c..07d1767 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -36,7 +36,8 @@ done:
 }
 
 int
-qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *pri_cfg, uint8_t flag)
+qla24xx_fcp_prio_cfg_valid(scsi_qla_host_t *vha,
+	struct qla_fcp_prio_cfg *pri_cfg, uint8_t flag)
 {
 	int i, ret, num_valid;
 	uint8_t *bcode;
@@ -51,18 +52,17 @@ qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *pri_cfg, uint8_t flag)
 
 	if (bcode_val == 0xFFFFFFFF) {
 		/* No FCP Priority config data in flash */
-		DEBUG2(printk(KERN_INFO
-		    "%s: No FCP priority config data.\n",
-		    __func__));
+		ql_dbg(ql_dbg_user, vha, 0x7051,
+		    "No FCP Priority config data.\n");
 		return 0;
 	}
 
 	if (bcode[0] != 'H' || bcode[1] != 'Q' || bcode[2] != 'O' ||
 			bcode[3] != 'S') {
 		/* Invalid FCP priority data header*/
-		DEBUG2(printk(KERN_ERR
-		    "%s: Invalid FCP Priority data header. bcode=0x%x\n",
-		    __func__, bcode_val));
+		ql_dbg(ql_dbg_user, vha, 0x7052,
+		    "Invalid FCP Priority data header. bcode=0x%x.\n",
+		    bcode_val);
 		return 0;
 	}
 	if (flag != 1)
@@ -77,15 +77,14 @@ qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *pri_cfg, uint8_t flag)
 
 	if (num_valid == 0) {
 		/* No valid FCP priority data entries */
-		DEBUG2(printk(KERN_ERR
-		    "%s: No valid FCP Priority data entries.\n",
-		    __func__));
+		ql_dbg(ql_dbg_user, vha, 0x7053,
+		    "No valid FCP Priority data entries.\n");
 		ret = 0;
 	} else {
 		/* FCP priority data is valid */
-		DEBUG2(printk(KERN_INFO
-		    "%s: Valid FCP priority data. num entries = %d\n",
-		    __func__, num_valid));
+		ql_dbg(ql_dbg_user, vha, 0x7054,
+		    "Valid FCP priority data. num entries = %d.\n",
+		    num_valid);
 	}
 
 	return ret;
@@ -182,10 +181,9 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 		if (!ha->fcp_prio_cfg) {
 			ha->fcp_prio_cfg = vmalloc(FCP_PRIO_CFG_SIZE);
 			if (!ha->fcp_prio_cfg) {
-				qla_printk(KERN_WARNING, ha,
-					"Unable to allocate memory "
-					"for fcp prio config data (%x).\n",
-					FCP_PRIO_CFG_SIZE);
+				ql_log(ql_log_warn, vha, 0x7050,
+				    "Unable to allocate memory for fcp prio "
+				    "config data (%x).\n", FCP_PRIO_CFG_SIZE);
 				bsg_job->reply->result = (DID_ERROR << 16);
 				ret = -ENOMEM;
 				goto exit_fcp_prio_cfg;
@@ -198,9 +196,9 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct fc_bsg_job *bsg_job)
 			FCP_PRIO_CFG_SIZE);
 
 		/* validate fcp priority data */
-		if (!qla24xx_fcp_prio_cfg_valid(
-			(struct qla_fcp_prio_cfg *)
-			ha->fcp_prio_cfg, 1)) {
+
+		if (!qla24xx_fcp_prio_cfg_valid(vha,
+		    (struct qla_fcp_prio_cfg *) ha->fcp_prio_cfg, 1)) {
 			bsg_job->reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
@@ -256,9 +254,8 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 
 	/* pass through is supported only for ISP 4Gb or higher */
 	if (!IS_FWI2_CAPABLE(ha)) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "scsi(%ld):ELS passthru not supported for ISP23xx based "
-		    "adapters\n", vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x7001,
+		    "ELS passthru not supported for ISP23xx based adapters.\n");
 		rval = -EPERM;
 		goto done;
 	}
@@ -266,11 +263,11 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	/*  Multiple SG's are not supported for ELS requests */
 	if (bsg_job->request_payload.sg_cnt > 1 ||
 		bsg_job->reply_payload.sg_cnt > 1) {
-		DEBUG2(printk(KERN_INFO
-			"multiple SG's are not supported for ELS requests"
-			" [request_sg_cnt: %x reply_sg_cnt: %x]\n",
-			bsg_job->request_payload.sg_cnt,
-			bsg_job->reply_payload.sg_cnt));
+		ql_dbg(ql_dbg_user, vha, 0x7002,
+		    "Multiple SG's are not suppored for ELS requests, "
+		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
+		    bsg_job->request_payload.sg_cnt,
+		    bsg_job->reply_payload.sg_cnt);
 		rval = -EPERM;
 		goto done;
 	}
@@ -281,9 +278,9 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		 * if not perform fabric login
 		 */
 		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			"failed to login port %06X for ELS passthru\n",
-			fcport->d_id.b24));
+			ql_dbg(ql_dbg_user, vha, 0x7003,
+			    "Failed to login port %06X for ELS passthru.\n",
+			    fcport->d_id.b24);
 			rval = -EIO;
 			goto done;
 		}
@@ -314,8 +311,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	}
 
 	if (!vha->flags.online) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		"host not online\n"));
+		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
 		rval = -EIO;
 		goto done;
 	}
@@ -337,12 +333,11 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 
 	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
 		(rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		DEBUG2(printk(KERN_INFO
-			"dma mapping resulted in different sg counts \
-			[request_sg_cnt: %x dma_request_sg_cnt: %x\
-			reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-			bsg_job->request_payload.sg_cnt, req_sg_cnt,
-			bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		ql_log(ql_log_warn, vha, 0x7008,
+		    "dma mapping resulted in different sg counts, "
+		    "request_sg_cnt: %x dma_request_sg_cnt:%x reply_sg_cnt:%x "
+		    "dma_reply_sg_cnt:%x.\n", bsg_job->request_payload.sg_cnt,
+		    req_sg_cnt, bsg_job->reply_payload.sg_cnt, rsp_sg_cnt);
 		rval = -EAGAIN;
 		goto done_unmap_sg;
 	}
@@ -363,15 +358,16 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 		"bsg_els_rpt" : "bsg_els_hst");
 	els->u.bsg_job = bsg_job;
 
-	DEBUG2(qla_printk(KERN_INFO, ha,
-		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
-		"portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
-		bsg_job->request->rqst_data.h_els.command_code,
-		fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
-		fcport->d_id.b.al_pa));
+	ql_dbg(ql_dbg_user, vha, 0x700a,
+	    "bsg rqst type: %s els type: %x - loop-id=%x "
+	    "portid=%-2x%02x%02x.\n", type,
+	    bsg_job->request->rqst_data.h_els.command_code, fcport->loop_id,
+	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x700e,
+		    "qla2x00_start_sp failed = %d\n", rval);
 		kfree(sp->ctx);
 		mempool_free(sp, ha->srb_mempool);
 		rval = -EIO;
@@ -411,6 +407,8 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	if (!req_sg_cnt) {
+		ql_log(ql_log_warn, vha, 0x700f,
+		    "dma_map_sg return %d for request\n", req_sg_cnt);
 		rval = -ENOMEM;
 		goto done;
 	}
@@ -418,24 +416,25 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
 		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 	if (!rsp_sg_cnt) {
+		ql_log(ql_log_warn, vha, 0x7010,
+		    "dma_map_sg return %d for reply\n", rsp_sg_cnt);
 		rval = -ENOMEM;
 		goto done;
 	}
 
 	if ((req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
 	    (rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "[request_sg_cnt: %x dma_request_sg_cnt: %x\
-		    reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-		    bsg_job->request_payload.sg_cnt, req_sg_cnt,
-		    bsg_job->reply_payload.sg_cnt, rsp_sg_cnt));
+		ql_log(ql_log_warn, vha, 0x7011,
+		    "request_sg_cnt: %x dma_request_sg_cnt: %x reply_sg_cnt:%x "
+		    "dma_reply_sg_cnt: %x\n", bsg_job->request_payload.sg_cnt,
+		    req_sg_cnt, bsg_job->reply_payload.sg_cnt, rsp_sg_cnt);
 		rval = -EAGAIN;
 		goto done_unmap_sg;
 	}
 
 	if (!vha->flags.online) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-			"host not online\n"));
+		ql_log(ql_log_warn, vha, 0x7012,
+		    "Host is not online.\n");
 		rval = -EIO;
 		goto done_unmap_sg;
 	}
@@ -451,8 +450,8 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 		loop_id = vha->mgmt_svr_loop_id;
 		break;
 	default:
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "Unknown loop id: %x\n", loop_id));
+		ql_dbg(ql_dbg_user, vha, 0x7013,
+		    "Unknown loop id: %x.\n", loop_id);
 		rval = -EINVAL;
 		goto done_unmap_sg;
 	}
@@ -464,6 +463,8 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	 */
 	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (!fcport) {
+		ql_log(ql_log_warn, vha, 0x7014,
+		    "Failed to allocate fcport.\n");
 		rval = -ENOMEM;
 		goto done_unmap_sg;
 	}
@@ -479,6 +480,8 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	/* Alloc SRB structure */
 	sp = qla2x00_get_ctx_bsg_sp(vha, fcport, sizeof(struct srb_ctx));
 	if (!sp) {
+		ql_log(ql_log_warn, vha, 0x7015,
+		    "qla2x00_get_ctx_bsg_sp failed.\n");
 		rval = -ENOMEM;
 		goto done_free_fcport;
 	}
@@ -488,15 +491,17 @@ qla2x00_process_ct(struct fc_bsg_job *bsg_job)
 	ct->name = "bsg_ct";
 	ct->u.bsg_job = bsg_job;
 
-	DEBUG2(qla_printk(KERN_INFO, ha,
-		"scsi(%ld:%x): bsg rqst type: %s els type: %x - loop-id=%x "
-		"portid=%02x%02x%02x.\n", vha->host_no, sp->handle, type,
-		(bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
-		fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
-		fcport->d_id.b.al_pa));
+	ql_dbg(ql_dbg_user, vha, 0x7016,
+	    "bsg rqst type: %s else type: %x - "
+	    "loop-id=%x portid=%02x%02x%02x.\n", type,
+	    (bsg_job->request->rqst_data.h_ct.preamble_word2 >> 16),
+	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
+	    fcport->d_id.b.al_pa);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x7017,
+		    "qla2x00_start_sp failed=%d.\n", rval);
 		kfree(sp->ctx);
 		mempool_free(sp, ha->srb_mempool);
 		rval = -EIO;
@@ -535,9 +540,8 @@ qla81xx_set_internal_loopback(scsi_qla_host_t *vha, uint16_t *config,
 	ha->notify_dcbx_comp = 1;
 	ret = qla81xx_set_port_config(vha, new_config);
 	if (ret != QLA_SUCCESS) {
-		DEBUG2(printk(KERN_ERR
-		    "%s(%lu): Set port config failed\n",
-		    __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7021,
+		    "set port config failed.\n");
 		ha->notify_dcbx_comp = 0;
 		rval = -EINVAL;
 		goto done_set_internal;
@@ -545,11 +549,11 @@ qla81xx_set_internal_loopback(scsi_qla_host_t *vha, uint16_t *config,
 
 	/* Wait for DCBX complete event */
 	if (!wait_for_completion_timeout(&ha->dcbx_comp, (20 * HZ))) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "State change notificaition not received.\n"));
+		ql_dbg(ql_dbg_user, vha, 0x7022,
+		    "State change notification not received.\n");
 	} else
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "State change RECEIVED\n"));
+		ql_dbg(ql_dbg_user, vha, 0x7023,
+		    "State change received.\n");
 
 	ha->notify_dcbx_comp = 0;
 
@@ -581,9 +585,8 @@ qla81xx_reset_internal_loopback(scsi_qla_host_t *vha, uint16_t *config,
 		ha->notify_dcbx_comp = wait;
 		ret = qla81xx_set_port_config(vha, new_config);
 		if (ret != QLA_SUCCESS) {
-			DEBUG2(printk(KERN_ERR
-			    "%s(%lu): Set port config failed\n",
-			     __func__, vha->host_no));
+			ql_log(ql_log_warn, vha, 0x7025,
+			    "Set port config failed.\n");
 			ha->notify_dcbx_comp = 0;
 			rval = -EINVAL;
 			goto done_reset_internal;
@@ -592,14 +595,14 @@ qla81xx_reset_internal_loopback(scsi_qla_host_t *vha, uint16_t *config,
 		/* Wait for DCBX complete event */
 		if (wait && !wait_for_completion_timeout(&ha->dcbx_comp,
 			(20 * HZ))) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "State change notificaition not received.\n"));
+			ql_dbg(ql_dbg_user, vha, 0x7026,
+			    "State change notification not received.\n");
 			ha->notify_dcbx_comp = 0;
 			rval = -EINVAL;
 			goto done_reset_internal;
 		} else
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "State change RECEIVED\n"));
+			ql_dbg(ql_dbg_user, vha, 0x7027,
+			    "State change received.\n");
 
 		ha->notify_dcbx_comp = 0;
 	}
@@ -629,11 +632,13 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+		ql_log(ql_log_warn, vha, 0x7018, "Abort active or needed.\n");
 		return -EBUSY;
+	}
 
 	if (!vha->flags.online) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "host not online\n"));
+		ql_log(ql_log_warn, vha, 0x7019, "Host is not online.\n");
 		return -EIO;
 	}
 
@@ -641,26 +646,31 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 		bsg_job->request_payload.sg_list, bsg_job->request_payload.sg_cnt,
 		DMA_TO_DEVICE);
 
-	if (!elreq.req_sg_cnt)
+	if (!elreq.req_sg_cnt) {
+		ql_log(ql_log_warn, vha, 0x701a,
+		    "dma_map_sg returned %d for request.\n", elreq.req_sg_cnt);
 		return -ENOMEM;
+	}
 
 	elreq.rsp_sg_cnt = dma_map_sg(&ha->pdev->dev,
 		bsg_job->reply_payload.sg_list, bsg_job->reply_payload.sg_cnt,
 		DMA_FROM_DEVICE);
 
 	if (!elreq.rsp_sg_cnt) {
+		ql_log(ql_log_warn, vha, 0x701b,
+		    "dma_map_sg returned %d for reply.\n", elreq.rsp_sg_cnt);
 		rval = -ENOMEM;
 		goto done_unmap_req_sg;
 	}
 
 	if ((elreq.req_sg_cnt !=  bsg_job->request_payload.sg_cnt) ||
 		(elreq.rsp_sg_cnt != bsg_job->reply_payload.sg_cnt)) {
-		DEBUG2(printk(KERN_INFO
-			"dma mapping resulted in different sg counts "
-			"[request_sg_cnt: %x dma_request_sg_cnt: %x "
-			"reply_sg_cnt: %x dma_reply_sg_cnt: %x]\n",
-			bsg_job->request_payload.sg_cnt, elreq.req_sg_cnt,
-			bsg_job->reply_payload.sg_cnt, elreq.rsp_sg_cnt));
+		ql_log(ql_log_warn, vha, 0x701c,
+		    "dma mapping resulted in different sg counts, "
+		    "request_sg_cnt: %x dma_request_sg_cnt: %x "
+		    "reply_sg_cnt: %x dma_reply_sg_cnt: %x.\n",
+		    bsg_job->request_payload.sg_cnt, elreq.req_sg_cnt,
+		    bsg_job->reply_payload.sg_cnt, elreq.rsp_sg_cnt);
 		rval = -EAGAIN;
 		goto done_unmap_sg;
 	}
@@ -668,8 +678,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	req_data = dma_alloc_coherent(&ha->pdev->dev, req_data_len,
 		&req_data_dma, GFP_KERNEL);
 	if (!req_data) {
-		DEBUG2(printk(KERN_ERR "%s: dma alloc for req_data "
-			"failed for host=%lu\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x701d,
+		    "dma alloc failed for req_data.\n");
 		rval = -ENOMEM;
 		goto done_unmap_sg;
 	}
@@ -677,8 +687,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	rsp_data = dma_alloc_coherent(&ha->pdev->dev, rsp_data_len,
 		&rsp_data_dma, GFP_KERNEL);
 	if (!rsp_data) {
-		DEBUG2(printk(KERN_ERR "%s: dma alloc for rsp_data "
-			"failed for host=%lu\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7004,
+		    "dma alloc failed for rsp_data.\n");
 		rval = -ENOMEM;
 		goto done_free_dma_req;
 	}
@@ -699,8 +709,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	    && req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
 		elreq.options == EXTERNAL_LOOPBACK) {
 		type = "FC_BSG_HST_VENDOR_ECHO_DIAG";
-		DEBUG2(qla_printk(KERN_INFO, ha,
-			"scsi(%ld) bsg rqst type: %s\n", vha->host_no, type));
+		ql_dbg(ql_dbg_user, vha, 0x701e,
+		    "BSG request type: %s.\n", type);
 		command_sent = INT_DEF_LB_ECHO_CMD;
 		rval = qla2x00_echo_test(vha, &elreq, response);
 	} else {
@@ -708,9 +718,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			memset(config, 0, sizeof(config));
 			memset(new_config, 0, sizeof(new_config));
 			if (qla81xx_get_port_config(vha, config)) {
-				DEBUG2(printk(KERN_ERR
-					"%s(%lu): Get port config failed\n",
-					__func__, vha->host_no));
+				ql_log(ql_log_warn, vha, 0x701f,
+				    "Get port config failed.\n");
 				bsg_job->reply->reply_payload_rcv_len = 0;
 				bsg_job->reply->result = (DID_ERROR << 16);
 				rval = -EPERM;
@@ -718,11 +727,13 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			}
 
 			if (elreq.options != EXTERNAL_LOOPBACK) {
-				DEBUG2(qla_printk(KERN_INFO, ha,
-					"Internal: current port config = %x\n",
-					config[0]));
+				ql_dbg(ql_dbg_user, vha, 0x7020,
+				    "Internal: curent port config = %x\n",
+				    config[0]);
 				if (qla81xx_set_internal_loopback(vha, config,
 					new_config)) {
+					ql_log(ql_log_warn, vha, 0x7024,
+					    "Internal loopback failed.\n");
 					bsg_job->reply->reply_payload_rcv_len =
 						0;
 					bsg_job->reply->result =
@@ -746,9 +757,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			}
 
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
-			DEBUG2(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) bsg rqst type: %s\n",
-				vha->host_no, type));
+			ql_dbg(ql_dbg_user, vha, 0x7028,
+			    "BSG request type: %s.\n", type);
 
 			command_sent = INT_DEF_LB_LOOPBACK_CMD;
 			rval = qla2x00_loopback_test(vha, &elreq, response);
@@ -763,17 +773,16 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 			if (response[0] == MBS_COMMAND_ERROR &&
 					response[1] == MBS_LB_RESET) {
-				DEBUG2(printk(KERN_ERR "%s(%ld): ABORTing "
-					"ISP\n", __func__, vha->host_no));
+				ql_log(ql_log_warn, vha, 0x7029,
+				    "MBX command error, Aborting ISP.\n");
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 				qla2xxx_wake_dpc(vha);
 				qla2x00_wait_for_chip_reset(vha);
 				/* Also reset the MPI */
 				if (qla81xx_restart_mpi_firmware(vha) !=
 				    QLA_SUCCESS) {
-					qla_printk(KERN_INFO, ha,
-					    "MPI reset failed for host%ld.\n",
-					    vha->host_no);
+					ql_log(ql_log_warn, vha, 0x702a,
+					    "MPI reset failed.\n");
 				}
 
 				bsg_job->reply->reply_payload_rcv_len = 0;
@@ -783,17 +792,16 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 			}
 		} else {
 			type = "FC_BSG_HST_VENDOR_LOOPBACK";
-			DEBUG2(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) bsg rqst type: %s\n",
-				vha->host_no, type));
+			ql_dbg(ql_dbg_user, vha, 0x702b,
+			    "BSG request type: %s.\n", type);
 			command_sent = INT_DEF_LB_LOOPBACK_CMD;
 			rval = qla2x00_loopback_test(vha, &elreq, response);
 		}
 	}
 
 	if (rval) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-		    "request %s failed\n", vha->host_no, type));
+		ql_log(ql_log_warn, vha, 0x702c,
+		    "Vendor request %s failed.\n", type);
 
 		fw_sts_ptr = ((uint8_t *)bsg_job->req->sense) +
 		    sizeof(struct fc_bsg_reply);
@@ -805,8 +813,8 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 		bsg_job->reply->reply_payload_rcv_len = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 	} else {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-			"request %s completed\n", vha->host_no, type));
+		ql_dbg(ql_dbg_user, vha, 0x702d,
+		    "Vendor request %s completed.\n", type);
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
 			sizeof(response) + sizeof(uint8_t);
@@ -851,12 +859,13 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 
 	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 	    test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+	    test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+		ql_log(ql_log_warn, vha, 0x702e, "Abort active or needed.\n");
 		return -EBUSY;
+	}
 
 	if (!IS_QLA84XX(ha)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld): Not 84xx, "
-		   "exiting.\n", vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x702f, "Not 84xx, exiting.\n");
 		return -EINVAL;
 	}
 
@@ -865,14 +874,14 @@ qla84xx_reset(struct fc_bsg_job *bsg_job)
 	rval = qla84xx_reset_chip(vha, flag == A84_ISSUE_RESET_DIAG_FW);
 
 	if (rval) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-		    "request 84xx reset failed\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7030,
+		    "Vendor request 84xx reset failed.\n");
 		rval = bsg_job->reply->reply_payload_rcv_len = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 
 	} else {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-		    "request 84xx reset completed\n", vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x7031,
+		    "Vendor request 84xx reset completed.\n");
 		bsg_job->reply->result = DID_OK;
 	}
 
@@ -902,21 +911,24 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 		return -EBUSY;
 
 	if (!IS_QLA84XX(ha)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld): Not 84xx, "
-			"exiting.\n", vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x7032,
+		    "Not 84xx, exiting.\n");
 		return -EINVAL;
 	}
 
 	sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
-	if (!sg_cnt)
+	if (!sg_cnt) {
+		ql_log(ql_log_warn, vha, 0x7033,
+		    "dma_map_sg returned %d for request.\n", sg_cnt);
 		return -ENOMEM;
+	}
 
 	if (sg_cnt != bsg_job->request_payload.sg_cnt) {
-		DEBUG2(printk(KERN_INFO
-			"dma mapping resulted in different sg counts "
-			"request_sg_cnt: %x dma_request_sg_cnt: %x ",
-			bsg_job->request_payload.sg_cnt, sg_cnt));
+		ql_log(ql_log_warn, vha, 0x7034,
+		    "DMA mapping resulted in different sg counts, "
+		    "request_sg_cnt: %x dma_request_sg_cnt: %x.\n",
+		    bsg_job->request_payload.sg_cnt, sg_cnt);
 		rval = -EAGAIN;
 		goto done_unmap_sg;
 	}
@@ -925,8 +937,8 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 	fw_buf = dma_alloc_coherent(&ha->pdev->dev, data_len,
 		&fw_dma, GFP_KERNEL);
 	if (!fw_buf) {
-		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw_buf "
-			"failed for host=%lu\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7035,
+		    "DMA alloc failed for fw_buf.\n");
 		rval = -ENOMEM;
 		goto done_unmap_sg;
 	}
@@ -936,8 +948,8 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 
 	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (!mn) {
-		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw buffer "
-			"failed for host=%lu\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7036,
+		    "DMA alloc failed for fw buffer.\n");
 		rval = -ENOMEM;
 		goto done_free_fw_buf;
 	}
@@ -965,15 +977,15 @@ qla84xx_updatefw(struct fc_bsg_job *bsg_job)
 	rval = qla2x00_issue_iocb_timeout(vha, mn, mn_dma, 0, 120);
 
 	if (rval) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-			"request 84xx updatefw failed\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7037,
+		    "Vendor request 84xx updatefw failed.\n");
 
 		rval = bsg_job->reply->reply_payload_rcv_len = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 
 	} else {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-			"request 84xx updatefw completed\n", vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x7038,
+		    "Vendor request 84xx updatefw completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 		bsg_job->reply->result = DID_OK;
@@ -1009,27 +1021,30 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 
 	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+		ql_log(ql_log_warn, vha, 0x7039,
+		    "Abort active or needed.\n");
 		return -EBUSY;
+	}
 
 	if (!IS_QLA84XX(ha)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld): Not 84xx, "
-			"exiting.\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x703a,
+		    "Not 84xx, exiting.\n");
 		return -EINVAL;
 	}
 
 	ql84_mgmt = (struct qla_bsg_a84_mgmt *)((char *)bsg_job->request +
 		sizeof(struct fc_bsg_request));
 	if (!ql84_mgmt) {
-		DEBUG2(printk("%s(%ld): mgmt header not provided, exiting.\n",
-			__func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x703b,
+		    "MGMT header not provided, exiting.\n");
 		return -EINVAL;
 	}
 
 	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (!mn) {
-		DEBUG2(printk(KERN_ERR "%s: dma alloc for fw buffer "
-			"failed for host=%lu\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x703c,
+		    "DMA alloc failed for fw buffer.\n");
 		return -ENOMEM;
 	}
 
@@ -1044,6 +1059,8 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 			bsg_job->reply_payload.sg_list,
 			bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 		if (!sg_cnt) {
+			ql_log(ql_log_warn, vha, 0x703d,
+			    "dma_map_sg returned %d for reply.\n", sg_cnt);
 			rval = -ENOMEM;
 			goto exit_mgmt;
 		}
@@ -1051,10 +1068,10 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		dma_direction = DMA_FROM_DEVICE;
 
 		if (sg_cnt != bsg_job->reply_payload.sg_cnt) {
-			DEBUG2(printk(KERN_INFO
-				"dma mapping resulted in different sg counts "
-				"reply_sg_cnt: %x dma_reply_sg_cnt: %x\n",
-				bsg_job->reply_payload.sg_cnt, sg_cnt));
+			ql_log(ql_log_warn, vha, 0x703e,
+			    "DMA mapping resulted in different sg counts, "
+			    "reply_sg_cnt: %x dma_reply_sg_cnt: %x.\n",
+			    bsg_job->reply_payload.sg_cnt, sg_cnt);
 			rval = -EAGAIN;
 			goto done_unmap_sg;
 		}
@@ -1064,9 +1081,8 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		mgmt_b = dma_alloc_coherent(&ha->pdev->dev, data_len,
 		    &mgmt_dma, GFP_KERNEL);
 		if (!mgmt_b) {
-			DEBUG2(printk(KERN_ERR "%s: dma alloc for mgmt_b "
-				"failed for host=%lu\n",
-				__func__, vha->host_no));
+			ql_log(ql_log_warn, vha, 0x703f,
+			    "DMA alloc failed for mgmt_b.\n");
 			rval = -ENOMEM;
 			goto done_unmap_sg;
 		}
@@ -1094,6 +1110,8 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
 		if (!sg_cnt) {
+			ql_log(ql_log_warn, vha, 0x7040,
+			    "dma_map_sg returned %d.\n", sg_cnt);
 			rval = -ENOMEM;
 			goto exit_mgmt;
 		}
@@ -1101,10 +1119,10 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		dma_direction = DMA_TO_DEVICE;
 
 		if (sg_cnt != bsg_job->request_payload.sg_cnt) {
-			DEBUG2(printk(KERN_INFO
-				"dma mapping resulted in different sg counts "
-				"request_sg_cnt: %x dma_request_sg_cnt: %x ",
-				bsg_job->request_payload.sg_cnt, sg_cnt));
+			ql_log(ql_log_warn, vha, 0x7041,
+			    "DMA mapping resulted in different sg counts, "
+			    "request_sg_cnt: %x dma_request_sg_cnt: %x.\n",
+			    bsg_job->request_payload.sg_cnt, sg_cnt);
 			rval = -EAGAIN;
 			goto done_unmap_sg;
 		}
@@ -1113,9 +1131,8 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 		mgmt_b = dma_alloc_coherent(&ha->pdev->dev, data_len,
 			&mgmt_dma, GFP_KERNEL);
 		if (!mgmt_b) {
-			DEBUG2(printk(KERN_ERR "%s: dma alloc for mgmt_b "
-				"failed for host=%lu\n",
-				__func__, vha->host_no));
+			ql_log(ql_log_warn, vha, 0x7042,
+			    "DMA alloc failed for mgmt_b.\n");
 			rval = -ENOMEM;
 			goto done_unmap_sg;
 		}
@@ -1156,15 +1173,15 @@ qla84xx_mgmt_cmd(struct fc_bsg_job *bsg_job)
 	rval = qla2x00_issue_iocb(vha, mn, mn_dma, 0);
 
 	if (rval) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-			"request 84xx mgmt failed\n", vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7043,
+		    "Vendor request 84xx mgmt failed.\n");
 
 		rval = bsg_job->reply->reply_payload_rcv_len = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 
 	} else {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "scsi(%ld) Vendor "
-			"request 84xx mgmt completed\n", vha->host_no));
+		ql_dbg(ql_dbg_user, vha, 0x7044,
+		    "Vendor request 84xx mgmt completed.\n");
 
 		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 		bsg_job->reply->result = DID_OK;
@@ -1204,7 +1221,6 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 {
 	struct Scsi_Host *host = bsg_job->shost;
 	scsi_qla_host_t *vha = shost_priv(host);
-	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 	struct qla_port_param *port_param = NULL;
 	fc_port_t *fcport = NULL;
@@ -1215,26 +1231,27 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 
 	if (test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
 		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))
+		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+		ql_log(ql_log_warn, vha, 0x7045, "abort active or needed.\n");
 		return -EBUSY;
+	}
 
 	if (!IS_IIDMA_CAPABLE(vha->hw)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha, "%s(%lu): iiDMA not "
-			"supported\n",  __func__, vha->host_no));
+		ql_log(ql_log_info, vha, 0x7046, "iiDMA not supported.\n");
 		return -EINVAL;
 	}
 
 	port_param = (struct qla_port_param *)((char *)bsg_job->request +
 		sizeof(struct fc_bsg_request));
 	if (!port_param) {
-		DEBUG2(printk("%s(%ld): port_param header not provided, "
-			"exiting.\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7047,
+		    "port_param header not provided.\n");
 		return -EINVAL;
 	}
 
 	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
-		DEBUG2(printk(KERN_ERR "%s(%ld): Invalid destination type\n",
-			__func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7048,
+		    "Invalid destination type.\n");
 		return -EINVAL;
 	}
 
@@ -1249,21 +1266,20 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 	}
 
 	if (!fcport) {
-		DEBUG2(printk(KERN_ERR "%s(%ld): Failed to find port\n",
-			__func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x7049,
+		    "Failed to find port.\n");
 		return -EINVAL;
 	}
 
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
-		DEBUG2(printk(KERN_ERR "%s(%ld): Port not online\n",
-			__func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x704a,
+		    "Port is not online.\n");
 		return -EINVAL;
 	}
 
 	if (fcport->flags & FCF_LOGIN_NEEDED) {
-		DEBUG2(printk(KERN_ERR "%s(%ld): Remote port not logged in, "
-		    "flags = 0x%x\n",
-		    __func__, vha->host_no, fcport->flags));
+		ql_log(ql_log_warn, vha, 0x704b,
+		    "Remote port not logged in flags = 0x%x.\n", fcport->flags);
 		return -EINVAL;
 	}
 
@@ -1275,15 +1291,13 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 			&port_param->speed, mb);
 
 	if (rval) {
-		DEBUG16(printk(KERN_ERR "scsi(%ld): iIDMA cmd failed for "
-			"%02x%02x%02x%02x%02x%02x%02x%02x -- "
-			"%04x %x %04x %04x.\n",
-			vha->host_no, fcport->port_name[0],
-			fcport->port_name[1],
-			fcport->port_name[2], fcport->port_name[3],
-			fcport->port_name[4], fcport->port_name[5],
-			fcport->port_name[6], fcport->port_name[7], rval,
-			fcport->fp_speed, mb[0], mb[1]));
+		ql_log(ql_log_warn, vha, 0x704c,
+		    "iIDMA cmd failed for %02x%02x%02x%02x%02x%02x%02x%02x -- "
+		    "%04x %x %04x %04x.\n", fcport->port_name[0],
+		    fcport->port_name[1], fcport->port_name[2],
+		    fcport->port_name[3], fcport->port_name[4],
+		    fcport->port_name[5], fcport->port_name[6],
+		    fcport->port_name[7], rval, fcport->fp_speed, mb[0], mb[1]);
 		rval = 0;
 		bsg_job->reply->result = (DID_ERROR << 16);
 
@@ -1307,11 +1321,12 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 }
 
 static int
-qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
+qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, scsi_qla_host_t *vha,
 	uint8_t is_update)
 {
 	uint32_t start = 0;
 	int valid = 0;
+	struct qla_hw_data *ha = vha->hw;
 
 	bsg_job->reply->reply_payload_rcv_len = 0;
 
@@ -1319,14 +1334,20 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
 		return -EINVAL;
 
 	start = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
-	if (start > ha->optrom_size)
+	if (start > ha->optrom_size) {
+		ql_log(ql_log_warn, vha, 0x7055,
+		    "start %d > optrom_size %d.\n", start, ha->optrom_size);
 		return -EINVAL;
+	}
 
-	if (ha->optrom_state != QLA_SWAITING)
+	if (ha->optrom_state != QLA_SWAITING) {
+		ql_log(ql_log_info, vha, 0x7056,
+		    "optrom_state %d.\n", ha->optrom_state);
 		return -EBUSY;
+	}
 
 	ha->optrom_region_start = start;
-
+	ql_dbg(ql_dbg_user, vha, 0x7057, "is_update=%d.\n", is_update);
 	if (is_update) {
 		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
 			valid = 1;
@@ -1337,9 +1358,9 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
 		    IS_QLA8XXX_TYPE(ha))
 			valid = 1;
 		if (!valid) {
-			qla_printk(KERN_WARNING, ha,
-			    "Invalid start region 0x%x/0x%x.\n",
-			    start, bsg_job->request_payload.payload_len);
+			ql_log(ql_log_warn, vha, 0x7058,
+			    "Invalid start region 0x%x/0x%x.\n", start,
+			    bsg_job->request_payload.payload_len);
 			return -EINVAL;
 		}
 
@@ -1358,9 +1379,9 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
 
 	ha->optrom_buffer = vmalloc(ha->optrom_region_size);
 	if (!ha->optrom_buffer) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x7059,
 		    "Read: Unable to allocate memory for optrom retrieval "
-		    "(%x).\n", ha->optrom_region_size);
+		    "(%x)\n", ha->optrom_region_size);
 
 		ha->optrom_state = QLA_SWAITING;
 		return -ENOMEM;
@@ -1378,7 +1399,7 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
-	rval = qla2x00_optrom_setup(bsg_job, ha, 0);
+	rval = qla2x00_optrom_setup(bsg_job, vha, 0);
 	if (rval)
 		return rval;
 
@@ -1406,7 +1427,7 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
-	rval = qla2x00_optrom_setup(bsg_job, ha, 1);
+	rval = qla2x00_optrom_setup(bsg_job, vha, 1);
 	if (rval)
 		return rval;
 
@@ -1464,6 +1485,23 @@ int
 qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 {
 	int ret = -EINVAL;
+	struct fc_rport *rport;
+	fc_port_t *fcport = NULL;
+	struct Scsi_Host *host;
+	scsi_qla_host_t *vha;
+
+	if (bsg_job->request->msgcode == FC_BSG_RPT_ELS) {
+		rport = bsg_job->rport;
+		fcport = *(fc_port_t **) rport->dd_data;
+		host = rport_to_shost(rport);
+		vha = shost_priv(host);
+	} else {
+		host = bsg_job->shost;
+		vha = shost_priv(host);
+	}
+
+	ql_dbg(ql_dbg_user, vha, 0x7000,
+	    "Entered %s msgcode=%d.\n", __func__, bsg_job->request->msgcode);
 
 	switch (bsg_job->request->msgcode) {
 	case FC_BSG_RPT_ELS:
@@ -1480,7 +1518,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	case FC_BSG_HST_DEL_RPORT:
 	case FC_BSG_RPT_CT:
 	default:
-		DEBUG2(printk("qla2xxx: unsupported BSG request\n"));
+		ql_log(ql_log_warn, vha, 0x705a, "Unsupported BSG request.\n");
 		break;
 	}
 	return ret;
@@ -1514,17 +1552,15 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 					&& (sp_bsg->u.bsg_job == bsg_job)) {
 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
 					if (ha->isp_ops->abort_command(sp)) {
-						DEBUG2(qla_printk(KERN_INFO, ha,
-						    "scsi(%ld): mbx "
-						    "abort_command failed\n",
-						    vha->host_no));
+						ql_log(ql_log_warn, vha, 0x7089,
+						    "mbx abort_command "
+						    "failed.\n");
 						bsg_job->req->errors =
 						bsg_job->reply->result = -EIO;
 					} else {
-						DEBUG2(qla_printk(KERN_INFO, ha,
-						    "scsi(%ld): mbx "
-						    "abort_command success\n",
-						    vha->host_no));
+						ql_dbg(ql_dbg_user, vha, 0x708a,
+						    "mbx abort_command "
+						    "success.\n");
 						bsg_job->req->errors =
 						bsg_job->reply->result = 0;
 					}
@@ -1535,8 +1571,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 		}
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	DEBUG2(qla_printk(KERN_INFO, ha,
-		"scsi(%ld) SRB not found to abort\n", vha->host_no));
+	ql_log(ql_log_info, vha, 0x708b, "SRB not found to abort.\n");
 	bsg_job->req->errors = bsg_job->reply->result = -ENXIO;
 	return 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1b60a95..0891e60 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -45,7 +45,7 @@ qla2100_intr_handler(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-		    "%s(): NULL response queue pointer\n", __func__);
+		    "%s(): NULL response queue pointer.\n", __func__);
 		return (IRQ_NONE);
 	}
 
@@ -91,9 +91,9 @@ qla2100_intr_handler(int irq, void *dev_id)
 				qla2x00_async_event(vha, rsp, mb);
 			} else {
 				/*EMPTY*/
-				DEBUG2(printk("scsi(%ld): Unrecognized "
-				    "interrupt type (%d).\n",
-				    vha->host_no, mb[0]));
+				ql_dbg(ql_dbg_async, vha, 0x5025,
+				    "Unrecognized interrupt type (%d).\n",
+				    mb[0]);
 			}
 			/* Release mailbox registers. */
 			WRT_REG_WORD(&reg->semaphore, 0);
@@ -142,7 +142,7 @@ qla2300_intr_handler(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-		    "%s(): NULL response queue pointer\n", __func__);
+		    "%s(): NULL response queue pointer.\n", __func__);
 		return (IRQ_NONE);
 	}
 
@@ -160,11 +160,13 @@ qla2300_intr_handler(int irq, void *dev_id)
 
 			hccr = RD_REG_WORD(&reg->hccr);
 			if (hccr & (BIT_15 | BIT_13 | BIT_11 | BIT_8))
-				qla_printk(KERN_INFO, ha, "Parity error -- "
-				    "HCCR=%x, Dumping firmware!\n", hccr);
+				ql_log(ql_log_warn, vha, 0x5026,
+				    "Parity error -- HCCR=%x, Dumping "
+				    "firmware.\n", hccr);
 			else
-				qla_printk(KERN_INFO, ha, "RISC paused -- "
-				    "HCCR=%x, Dumping firmware!\n", hccr);
+				ql_log(ql_log_warn, vha, 0x5027,
+				    "RISC paused -- HCCR=%x, Dumping "
+				    "firmware.\n", hccr);
 
 			/*
 			 * Issue a "HARD" reset in order for the RISC
@@ -213,9 +215,8 @@ qla2300_intr_handler(int irq, void *dev_id)
 			qla2x00_async_event(vha, rsp, mb);
 			break;
 		default:
-			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
-			    "(%d).\n",
-			    vha->host_no, stat & 0xff));
+			ql_dbg(ql_dbg_async, vha, 0x5028,
+			    "Unrecognized interrupt type (%d).\n", stat & 0xff);
 			break;
 		}
 		WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
@@ -262,11 +263,11 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	}
 
 	if (ha->mcp) {
-		DEBUG3(printk("%s(%ld): Got mailbox completion. cmd=%x.\n",
-		    __func__, vha->host_no, ha->mcp->mb[0]));
+		ql_dbg(ql_dbg_async, vha, 0x5000,
+		    "Got mbx completion. cmd=%x.\n", ha->mcp->mb[0]);
 	} else {
-		DEBUG2_3(printk("%s(%ld): MBX pointer ERROR!\n",
-		    __func__, vha->host_no));
+		ql_dbg(ql_dbg_async, vha, 0x5001,
+		    "MBX pointer ERROR.\n");
 	}
 }
 
@@ -285,22 +286,24 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 	for (cnt = 0; cnt < QLA_IDC_ACK_REGS; cnt++, wptr++)
 		mb[cnt] = RD_REG_WORD(wptr);
 
-	DEBUG2(printk("scsi(%ld): Inter-Driver Commucation %s -- "
-	    "%04x %04x %04x %04x %04x %04x %04x.\n", vha->host_no,
-	    event[aen & 0xff],
-	    mb[0], mb[1], mb[2], mb[3], mb[4], mb[5], mb[6]));
+	ql_dbg(ql_dbg_async, vha, 0x5021,
+	    "Inter-Driver Commucation %s -- "
+	    "%04x %04x %04x %04x %04x %04x %04x.\n",
+	    event[aen & 0xff], mb[0], mb[1], mb[2], mb[3],
+	    mb[4], mb[5], mb[6]);
 
 	/* Acknowledgement needed? [Notify && non-zero timeout]. */
 	timeout = (descr >> 8) & 0xf;
 	if (aen != MBA_IDC_NOTIFY || !timeout)
 		return;
 
-	DEBUG2(printk("scsi(%ld): Inter-Driver Commucation %s -- "
-	    "ACK timeout=%d.\n", vha->host_no, event[aen & 0xff], timeout));
+	ql_dbg(ql_dbg_async, vha, 0x5022,
+	    "Inter-Driver Commucation %s -- ACK timeout=%d.\n",
+	    vha->host_no, event[aen & 0xff], timeout);
 
 	rval = qla2x00_post_idc_ack_work(vha, mb);
 	if (rval != QLA_SUCCESS)
-		qla_printk(KERN_WARNING, vha->hw,
+		ql_log(ql_log_warn, vha, 0x5023,
 		    "IDC failed to post ACK.\n");
 }
 
@@ -393,15 +396,15 @@ skip_rio:
 		break;
 
 	case MBA_RESET:			/* Reset */
-		DEBUG2(printk("scsi(%ld): Asynchronous RESET.\n",
-			vha->host_no));
+		ql_dbg(ql_dbg_async, vha, 0x5002,
+		    "Asynchronous RESET.\n");
 
 		set_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
 		mbx = IS_QLA81XX(ha) ? RD_REG_WORD(&reg24->mailbox7) : 0;
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_warn, vha, 0x5003,
 		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh "
 		    "mbx7=%xh.\n", mb[1], mb[2], mb[3], mbx);
 
@@ -409,7 +412,7 @@ skip_rio:
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
-				qla_printk(KERN_ERR, ha,
+				ql_log(ql_log_fatal, vha, 0x5004,
 				    "Unrecoverable Hardware Error: adapter "
 				    "marked OFFLINE!\n");
 				vha->flags.online = 0;
@@ -422,7 +425,7 @@ skip_rio:
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			}
 		} else if (mb[1] == 0) {
-			qla_printk(KERN_INFO, ha,
+			ql_log(ql_log_fatal, vha, 0x5005,
 			    "Unrecoverable Hardware Error: adapter marked "
 			    "OFFLINE!\n");
 			vha->flags.online = 0;
@@ -431,31 +434,27 @@ skip_rio:
 		break;
 
 	case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
-		DEBUG2(printk("scsi(%ld): ISP Request Transfer Error (%x).\n",
-		    vha->host_no, mb[1]));
-		qla_printk(KERN_WARNING, ha,
-		    "ISP Request Transfer Error (%x).\n", mb[1]);
+		ql_log(ql_log_warn, vha, 0x5006,
+		    "ISP Request Transfer Error (%x).\n",  mb[1]);
 
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
-		DEBUG2(printk("scsi(%ld): ISP Response Transfer Error.\n",
-		    vha->host_no));
-		qla_printk(KERN_WARNING, ha, "ISP Response Transfer Error.\n");
+		ql_log(ql_log_warn, vha, 0x5007,
+		    "ISP Response Transfer Error.\n");
 
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		break;
 
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up */
-		DEBUG2(printk("scsi(%ld): Asynchronous WAKEUP_THRES.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_async, vha, 0x5008,
+		    "Asynchronous WAKEUP_THRES.\n");
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
-		DEBUG2(printk("scsi(%ld): LIP occurred (%x).\n", vha->host_no,
-		    mb[1]));
-		qla_printk(KERN_INFO, ha, "LIP occurred (%x).\n", mb[1]);
+		ql_log(ql_log_info, vha, 0x5009,
+		    "LIP occurred (%x).\n", mb[1]);
 
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
@@ -488,10 +487,8 @@ skip_rio:
 			ha->link_data_rate = mb[1];
 		}
 
-		DEBUG2(printk("scsi(%ld): Asynchronous LOOP UP (%s Gbps).\n",
-		    vha->host_no, link_speed));
-		qla_printk(KERN_INFO, ha, "LOOP UP detected (%s Gbps).\n",
-		    link_speed);
+		ql_log(ql_log_info, vha, 0x500a,
+		    "LOOP UP detected (%s Gbps).\n", link_speed);
 
 		vha->flags.management_server_logged_in = 0;
 		qla2x00_post_aen_work(vha, FCH_EVT_LINKUP, ha->link_data_rate);
@@ -500,12 +497,9 @@ skip_rio:
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
 		mbx = IS_QLA81XX(ha) ? RD_REG_WORD(&reg24->mailbox4) : 0;
 		mbx = IS_QLA82XX(ha) ? RD_REG_WORD(&reg82->mailbox_out[4]) : mbx;
-		DEBUG2(printk("scsi(%ld): Asynchronous LOOP DOWN "
-		    "(%x %x %x %x).\n", vha->host_no, mb[1], mb[2], mb[3],
-		    mbx));
-		qla_printk(KERN_INFO, ha,
-		    "LOOP DOWN detected (%x %x %x %x).\n", mb[1], mb[2], mb[3],
-		    mbx);
+		ql_log(ql_log_info, vha, 0x500b,
+		    "LOOP DOWN detected (%x %x %x %x).\n",
+		    mb[1], mb[2], mb[3], mbx);
 
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
@@ -525,9 +519,7 @@ skip_rio:
 		break;
 
 	case MBA_LIP_RESET:		/* LIP reset occurred */
-		DEBUG2(printk("scsi(%ld): Asynchronous LIP RESET (%x).\n",
-		    vha->host_no, mb[1]));
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_info, vha, 0x500c,
 		    "LIP reset occurred (%x).\n", mb[1]);
 
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
@@ -554,14 +546,15 @@ skip_rio:
 			break;
 
 		if (IS_QLA8XXX_TYPE(ha)) {
-			DEBUG2(printk("scsi(%ld): DCBX Completed -- %04x %04x "
-			    "%04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+			ql_dbg(ql_dbg_async, vha, 0x500d,
+			    "DCBX Completed -- %04x %04x %04x.\n",
+			    mb[1], mb[2], mb[3]);
 			if (ha->notify_dcbx_comp)
 				complete(&ha->dcbx_comp);
 
 		} else
-			DEBUG2(printk("scsi(%ld): Asynchronous P2P MODE "
-			    "received.\n", vha->host_no));
+			ql_dbg(ql_dbg_async, vha, 0x500e,
+			    "Asynchronous P2P MODE received.\n");
 
 		/*
 		 * Until there's a transition from loop down to loop up, treat
@@ -594,10 +587,7 @@ skip_rio:
 		if (IS_QLA2100(ha))
 			break;
 
-		DEBUG2(printk("scsi(%ld): Asynchronous Change In Connection "
-		    "received.\n",
-		    vha->host_no));
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_info, vha, 0x500f,
 		    "Configuration change detected: value=%x.\n", mb[1]);
 
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
@@ -640,11 +630,9 @@ skip_rio:
 
 		/* Global event -- port logout or port unavailable. */
 		if (mb[1] == 0xffff && mb[2] == 0x7) {
-			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE.\n",
-			    vha->host_no));
-			DEBUG(printk(KERN_INFO
-			    "scsi(%ld): Port unavailable %04x %04x %04x.\n",
-			    vha->host_no, mb[1], mb[2], mb[3]));
+			ql_dbg(ql_dbg_async, vha, 0x5010,
+			    "Port unavailable %04x %04x %04x.\n",
+			    mb[1], mb[2], mb[3]);
 
 			if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 				atomic_set(&vha->loop_state, LOOP_DOWN);
@@ -674,17 +662,15 @@ skip_rio:
 		atomic_set(&vha->loop_down_timer, 0);
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN &&
 		    atomic_read(&vha->loop_state) != LOOP_DEAD) {
-			DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE "
-			    "ignored %04x/%04x/%04x.\n", vha->host_no, mb[1],
-			    mb[2], mb[3]));
+			ql_dbg(ql_dbg_async, vha, 0x5011,
+			    "Asynchronous PORT UPDATE ignored %04x/%04x/%04x.\n",
+			    mb[1], mb[2], mb[3]);
 			break;
 		}
 
-		DEBUG2(printk("scsi(%ld): Asynchronous PORT UPDATE.\n",
-		    vha->host_no));
-		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): Port database changed %04x %04x %04x.\n",
-		    vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x5012,
+		    "Port database changed %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 
 		/*
 		 * Mark all devices as missing so we will login again.
@@ -707,20 +693,17 @@ skip_rio:
 		if (ha->flags.npiv_supported && vha->vp_idx != (mb[3] & 0xff))
 			break;
 
-		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
-		    vha->host_no));
-		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): RSCN database changed -- %04x %04x %04x.\n",
-		    vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x5013,
+		    "RSCN database changed -- %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 
 		rscn_entry = ((mb[1] & 0xff) << 16) | mb[2];
 		host_pid = (vha->d_id.b.domain << 16) | (vha->d_id.b.area << 8)
 				| vha->d_id.b.al_pa;
 		if (rscn_entry == host_pid) {
-			DEBUG(printk(KERN_INFO
-			    "scsi(%ld): Ignoring RSCN update to local host "
-			    "port ID (%06x)\n",
-			    vha->host_no, host_pid));
+			ql_dbg(ql_dbg_async, vha, 0x5014,
+			    "Ignoring RSCN update to local host "
+			    "port ID (%06x).\n", host_pid);
 			break;
 		}
 
@@ -747,8 +730,8 @@ skip_rio:
 
 	/* case MBA_RIO_RESPONSE: */
 	case MBA_ZIO_RESPONSE:
-		DEBUG3(printk("scsi(%ld): [R|Z]IO update completion.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_async, vha, 0x5015,
+		    "[R|Z]IO update completion.\n");
 
 		if (IS_FWI2_CAPABLE(ha))
 			qla24xx_process_response_queue(vha, rsp);
@@ -757,61 +740,68 @@ skip_rio:
 		break;
 
 	case MBA_DISCARD_RND_FRAME:
-		DEBUG2(printk("scsi(%ld): Discard RND Frame -- %04x %04x "
-		    "%04x.\n", vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x5016,
+		    "Discard RND Frame -- %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 		break;
 
 	case MBA_TRACE_NOTIFICATION:
-		DEBUG2(printk("scsi(%ld): Trace Notification -- %04x %04x.\n",
-		vha->host_no, mb[1], mb[2]));
+		ql_dbg(ql_dbg_async, vha, 0x5017,
+		    "Trace Notification -- %04x %04x.\n", mb[1], mb[2]);
 		break;
 
 	case MBA_ISP84XX_ALERT:
-		DEBUG2(printk("scsi(%ld): ISP84XX Alert Notification -- "
-		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x5018,
+		    "ISP84XX Alert Notification -- %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 
 		spin_lock_irqsave(&ha->cs84xx->access_lock, flags);
 		switch (mb[1]) {
 		case A84_PANIC_RECOVERY:
-			qla_printk(KERN_INFO, ha, "Alert 84XX: panic recovery "
-			    "%04x %04x\n", mb[2], mb[3]);
+			ql_log(ql_log_info, vha, 0x5019,
+			    "Alert 84XX: panic recovery %04x %04x.\n",
+			    mb[2], mb[3]);
 			break;
 		case A84_OP_LOGIN_COMPLETE:
 			ha->cs84xx->op_fw_version = mb[3] << 16 | mb[2];
-			DEBUG2(qla_printk(KERN_INFO, ha, "Alert 84XX:"
-			    "firmware version %x\n", ha->cs84xx->op_fw_version));
+			ql_log(ql_log_info, vha, 0x501a,
+			    "Alert 84XX: firmware version %x.\n",
+			    ha->cs84xx->op_fw_version);
 			break;
 		case A84_DIAG_LOGIN_COMPLETE:
 			ha->cs84xx->diag_fw_version = mb[3] << 16 | mb[2];
-			DEBUG2(qla_printk(KERN_INFO, ha, "Alert 84XX:"
-			    "diagnostic firmware version %x\n",
-			    ha->cs84xx->diag_fw_version));
+			ql_log(ql_log_info, vha, 0x501b,
+			    "Alert 84XX: diagnostic firmware version %x.\n",
+			    ha->cs84xx->diag_fw_version);
 			break;
 		case A84_GOLD_LOGIN_COMPLETE:
 			ha->cs84xx->diag_fw_version = mb[3] << 16 | mb[2];
 			ha->cs84xx->fw_update = 1;
-			DEBUG2(qla_printk(KERN_INFO, ha, "Alert 84XX: gold "
-			    "firmware version %x\n",
-			    ha->cs84xx->gold_fw_version));
+			ql_log(ql_log_info, vha, 0x501c,
+			    "Alert 84XX: gold firmware version %x.\n",
+			    ha->cs84xx->gold_fw_version);
 			break;
 		default:
-			qla_printk(KERN_ERR, ha,
-			    "Alert 84xx: Invalid Alert %04x %04x %04x\n",
+			ql_log(ql_log_warn, vha, 0x501d,
+			    "Alert 84xx: Invalid Alert %04x %04x %04x.\n",
 			    mb[1], mb[2], mb[3]);
 		}
 		spin_unlock_irqrestore(&ha->cs84xx->access_lock, flags);
 		break;
 	case MBA_DCBX_START:
-		DEBUG2(printk("scsi(%ld): DCBX Started -- %04x %04x %04x\n",
-		    vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x501e,
+		    "DCBX Started -- %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 		break;
 	case MBA_DCBX_PARAM_UPDATE:
-		DEBUG2(printk("scsi(%ld): DCBX Parameters Updated -- "
-		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x501f,
+		    "DCBX Parameters Updated -- %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 		break;
 	case MBA_FCF_CONF_ERR:
-		DEBUG2(printk("scsi(%ld): FCF Configuration Error -- "
-		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+		ql_dbg(ql_dbg_async, vha, 0x5020,
+		    "FCF Configuration Error -- %04x %04x %04x.\n",
+		    mb[1], mb[2], mb[3]);
 		break;
 	case MBA_IDC_COMPLETE:
 	case MBA_IDC_NOTIFY:
@@ -838,10 +828,8 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 
 	/* Validate handle. */
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
-		DEBUG2(printk("scsi(%ld): Invalid SCSI completion handle %d.\n",
-		    vha->host_no, index));
-		qla_printk(KERN_WARNING, ha,
-		    "Invalid SCSI completion handle %d.\n", index);
+		ql_log(ql_log_warn, vha, 0x3014,
+		    "Invalid SCSI command index (%x).\n", index);
 
 		if (IS_QLA82XX(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
@@ -859,10 +847,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		sp->cmd->result = DID_OK << 16;
 		qla2x00_sp_compl(ha, sp);
 	} else {
-		DEBUG2(printk("scsi(%ld) Req:%d: Invalid ISP SCSI completion"
-			" handle(0x%x)\n", vha->host_no, req->id, index));
-		qla_printk(KERN_WARNING, ha,
-		    "Invalid ISP SCSI completion handle\n");
+		ql_log(ql_log_warn, vha, 0x3016, "Invalid SCSI SRB.\n");
 
 		if (IS_QLA82XX(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
@@ -882,8 +867,8 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 
 	index = LSW(pkt->handle);
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
-		qla_printk(KERN_WARNING, ha,
-		    "%s: Invalid completion handle (%x).\n", func, index);
+		ql_log(ql_log_warn, vha, 0x5031,
+		    "Invalid command index (%x).\n", index);
 		if (IS_QLA82XX(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		else
@@ -892,15 +877,13 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	}
 	sp = req->outstanding_cmds[index];
 	if (!sp) {
-		qla_printk(KERN_WARNING, ha,
-		    "%s: Invalid completion handle (%x) -- timed-out.\n", func,
-		    index);
+		ql_log(ql_log_warn, vha, 0x5032,
+		    "Invalid completion handle (%x) -- timed-out.\n", index);
 		return sp;
 	}
 	if (sp->handle != index) {
-		qla_printk(KERN_WARNING, ha,
-		    "%s: SRB handle (%x) mismatch %x.\n", func, sp->handle,
-		    index);
+		ql_log(ql_log_warn, vha, 0x5033,
+		    "SRB handle (%x) mismatch %x.\n", sp->handle, index);
 		return NULL;
 	}
 
@@ -937,17 +920,17 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 	    QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (mbx->entry_status) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error entry - portid=%02x%02x%02x "
+		ql_dbg(ql_dbg_async, vha, 0x5043,
+		    "Async-%s error entry - portid=%02x%02x%02x "
 		    "entry-status=%x status=%x state-flag=%x "
 		    "status-flags=%x.\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    type, fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mbx->entry_status,
 		    le16_to_cpu(mbx->status), le16_to_cpu(mbx->state_flags),
-		    le16_to_cpu(mbx->status_flags)));
+		    le16_to_cpu(mbx->status_flags));
 
-		DEBUG2(qla2x00_dump_buffer((uint8_t *)mbx, sizeof(*mbx)));
+		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5057,
+		    (uint8_t *)mbx, sizeof(*mbx));
 
 		goto logio_done;
 	}
@@ -957,12 +940,10 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE)
 		status = 0;
 	if (!status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
-		DEBUG2(printk(KERN_DEBUG
-		    "scsi(%ld:%x): Async-%s complete - portid=%02x%02x%02x "
-		    "mbx1=%x.\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, le16_to_cpu(mbx->mb1)));
+		ql_dbg(ql_dbg_async, vha, 0x5045,
+		    "Async-%s complete - portid=%02x%02x%02x mbx1=%x.\n",
+		    type, fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, le16_to_cpu(mbx->mb1));
 
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (ctx->type == SRB_LOGIN_CMD) {
@@ -987,14 +968,14 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		break;
 	}
 
-	DEBUG2(printk(KERN_WARNING
-	    "scsi(%ld:%x): Async-%s failed - portid=%02x%02x%02x status=%x "
+	ql_log(ql_log_warn, vha, 0x5046,
+	    "Async-%s failed - portid=%02x%02x%02x status=%x "
 	    "mb0=%x mb1=%x mb2=%x mb6=%x mb7=%x.\n",
-	    fcport->vha->host_no, sp->handle, type, fcport->d_id.b.domain,
+	    type, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa, status,
 	    le16_to_cpu(mbx->mb0), le16_to_cpu(mbx->mb1),
 	    le16_to_cpu(mbx->mb2), le16_to_cpu(mbx->mb6),
-	    le16_to_cpu(mbx->mb7)));
+	    le16_to_cpu(mbx->mb7));
 
 logio_done:
 	lio->done(sp);
@@ -1025,9 +1006,8 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		type = "ct pass-through";
 		break;
 	default:
-		qla_printk(KERN_WARNING, ha,
-		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
-		    sp_bsg->type);
+		ql_log(ql_log_warn, vha, 0x5047,
+		    "Unrecognized SRB: (%p) type=%d.\n", sp, sp_bsg->type);
 		return;
 	}
 
@@ -1045,20 +1025,20 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			bsg_job->reply->reply_payload_rcv_len =
 			    le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
 
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "scsi(%ld): CT pass-through-%s error "
+			ql_log(ql_log_warn, vha, 0x5048,
+			    "CT pass-through-%s error "
 			    "comp_status-status=0x%x total_byte = 0x%x.\n",
-			    vha->host_no, type, comp_status,
-			    bsg_job->reply->reply_payload_rcv_len));
+			    type, comp_status,
+			    bsg_job->reply->reply_payload_rcv_len);
 		} else {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "scsi(%ld): CT pass-through-%s error "
-			    "comp_status-status=0x%x.\n",
-			    vha->host_no, type, comp_status));
+			ql_log(ql_log_warn, vha, 0x5049,
+			    "CT pass-through-%s error "
+			    "comp_status-status=0x%x.\n", type, comp_status);
 			bsg_job->reply->result = DID_ERROR << 16;
 			bsg_job->reply->reply_payload_rcv_len = 0;
 		}
-		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
+		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5058,
+		    (uint8_t *)pkt, sizeof(*pkt));
 	} else {
 		bsg_job->reply->result =  DID_OK << 16;
 		bsg_job->reply->reply_payload_rcv_len =
@@ -1110,9 +1090,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		type = "ct pass-through";
 		break;
 	default:
-		qla_printk(KERN_WARNING, ha,
-		    "%s: Unrecognized SRB: (%p) type=%d.\n", func, sp,
-		    sp_bsg->type);
+		ql_log(ql_log_warn, vha, 0x503e,
+		    "Unrecognized SRB: (%p) type=%d.\n", sp, sp_bsg->type);
 		return;
 	}
 
@@ -1132,27 +1111,31 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			bsg_job->reply->reply_payload_rcv_len =
 				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->total_byte_count);
 
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "scsi(%ld:0x%x): ELS-CT pass-through-%s error comp_status-status=0x%x "
+			ql_log(ql_log_info, vha, 0x503f,
+			    "ELS-CT pass-through-%s error comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x total_byte = 0x%x.\n",
-				vha->host_no, sp->handle, type, comp_status, fw_status[1], fw_status[2],
-				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->total_byte_count)));
+			    type, comp_status, fw_status[1], fw_status[2],
+			    le16_to_cpu(((struct els_sts_entry_24xx *)
+				pkt)->total_byte_count));
 			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		else {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			    "scsi(%ld:0x%x): ELS-CT pass-through-%s error comp_status-status=0x%x "
+			ql_log(ql_log_info, vha, 0x5040,
+			    "ELS-CT pass-through-%s error comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x.\n",
-				vha->host_no, sp->handle, type, comp_status,
-				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_1),
-				le16_to_cpu(((struct els_sts_entry_24xx*)pkt)->error_subcode_2)));
+			    type, comp_status,
+			    le16_to_cpu(((struct els_sts_entry_24xx *)
+				pkt)->error_subcode_1),
+			    le16_to_cpu(((struct els_sts_entry_24xx *)
+				    pkt)->error_subcode_2));
 			bsg_job->reply->result = DID_ERROR << 16;
 			bsg_job->reply->reply_payload_rcv_len = 0;
 			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
-		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
+		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5056,
+				(uint8_t *)pkt, sizeof(*pkt));
 	}
 	else {
 		bsg_job->reply->result =  DID_OK << 16;
@@ -1201,25 +1184,24 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 		QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (logio->entry_status) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error entry - "
+		ql_log(ql_log_warn, vha, 0x5034,
+		    "Async-%s error entry - "
 		    "portid=%02x%02x%02x entry-status=%x.\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, logio->entry_status));
-		DEBUG2(qla2x00_dump_buffer((uint8_t *)logio, sizeof(*logio)));
+		    type, fcport->d_id.b.domain, fcport->d_id.b.area,
+		    fcport->d_id.b.al_pa, logio->entry_status);
+		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5059,
+		    (uint8_t *)logio, sizeof(*logio));
 
 		goto logio_done;
 	}
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
-		DEBUG2(printk(KERN_DEBUG
-		    "scsi(%ld:%x): Async-%s complete - portid=%02x%02x%02x "
+		ql_dbg(ql_dbg_async, vha, 0x5036,
+		    "Async-%s complete - portid=%02x%02x%02x "
 		    "iop0=%x.\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
+		    type, fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa,
-		    le32_to_cpu(logio->io_parameter[0])));
+		    le32_to_cpu(logio->io_parameter[0]));
 
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (ctx->type != SRB_LOGIN_CMD)
@@ -1256,14 +1238,14 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		break;
 	}
 
-	DEBUG2(printk(KERN_WARNING
-	    "scsi(%ld:%x): Async-%s failed - portid=%02x%02x%02x comp=%x "
+	ql_dbg(ql_dbg_async, vha, 0x5037,
+	    "Async-%s failed - portid=%02x%02x%02x comp=%x "
 	    "iop0=%x iop1=%x.\n",
-	    fcport->vha->host_no, sp->handle, type, fcport->d_id.b.domain,
+	    type, fcport->d_id.b.domain,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa,
 	    le16_to_cpu(logio->comp_status),
 	    le32_to_cpu(logio->io_parameter[0]),
-	    le32_to_cpu(logio->io_parameter[1])));
+	    le32_to_cpu(logio->io_parameter[1]));
 
 logio_done:
 	lio->done(sp);
@@ -1292,38 +1274,34 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	fcport = sp->fcport;
 
 	if (sts->entry_status) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error - entry-status(%x).\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    sts->entry_status));
+		ql_log(ql_log_warn, vha, 0x5038,
+		    "Async-%s error - entry-status(%x).\n",
+		    type, sts->entry_status);
 	} else if (sts->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error - completion status(%x).\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    sts->comp_status));
+		ql_log(ql_log_warn, vha, 0x5039,
+		    "Async-%s error - completion status(%x).\n",
+		    type, sts->comp_status);
 	} else if (!(le16_to_cpu(sts->scsi_status) &
 	    SS_RESPONSE_INFO_LEN_VALID)) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error - no response info(%x).\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    sts->scsi_status));
+		ql_log(ql_log_warn, vha, 0x503a,
+		    "Async-%s error - no response info(%x).\n",
+		    type, sts->scsi_status);
 	} else if (le32_to_cpu(sts->rsp_data_len) < 4) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error - not enough response(%d).\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    sts->rsp_data_len));
+		ql_log(ql_log_warn, vha, 0x503b,
+		    "Async-%s error - not enough response(%d).\n",
+		    type, sts->rsp_data_len);
 	} else if (sts->data[3]) {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld:%x): Async-%s error - response(%x).\n",
-		    fcport->vha->host_no, sp->handle, type,
-		    sts->data[3]));
+		ql_log(ql_log_warn, vha, 0x503c,
+		    "Async-%s error - response(%x).\n",
+		    type, sts->data[3]);
 	} else {
 		error = 0;
 	}
 
 	if (error) {
 		iocb->u.tmf.data = error;
-		DEBUG2(qla2x00_dump_buffer((uint8_t *)sts, sizeof(*sts)));
+		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5055,
+		    (uint8_t *)sts, sizeof(*sts));
 	}
 
 	iocb->done(sp);
@@ -1360,8 +1338,8 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 		}
 
 		if (pkt->entry_status != 0) {
-			DEBUG3(printk(KERN_INFO
-			    "scsi(%ld): Process error entry.\n", vha->host_no));
+			ql_log(ql_log_warn, vha, 0x5035,
+			    "Process error entry.\n");
 
 			qla2x00_error_entry(vha, rsp, pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -1399,10 +1377,10 @@ qla2x00_process_response_queue(struct rsp_que *rsp)
 			break;
 		default:
 			/* Type Not Supported. */
-			DEBUG4(printk(KERN_WARNING
-			    "scsi(%ld): Received unknown response pkt type %x "
+			ql_log(ql_log_warn, vha, 0x504a,
+			    "Received unknown response pkt type %x "
 			    "entry status=%x.\n",
-			    vha->host_no, pkt->entry_type, pkt->entry_status));
+			    pkt->entry_type, pkt->entry_status);
 			break;
 		}
 		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -1418,6 +1396,7 @@ static inline void
 qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
     uint32_t sense_len, struct rsp_que *rsp)
 {
+	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct scsi_cmnd *cp = sp->cmd;
 
 	if (sense_len >= SCSI_SENSE_BUFFERSIZE)
@@ -1435,11 +1414,13 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 	if (sp->request_sense_length != 0)
 		rsp->status_srb = sp;
 
-	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
-	    "cmd=%p\n", __func__, sp->fcport->vha->host_no,
-	    cp->device->channel, cp->device->id, cp->device->lun, cp));
+	ql_dbg(ql_dbg_io, vha, 0x301c,
+	    "Check condition Sense data, scsi(%ld:%d:%d:%d) cmd=%p.\n",
+	    sp->fcport->vha->host_no, cp->device->channel, cp->device->id,
+	    cp->device->lun, cp);
 	if (sense_len)
-		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer, sense_len));
+		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302b,
+		    cp->sense_buffer, sense_len);
 }
 
 struct scsi_dif_tuple {
@@ -1457,6 +1438,7 @@ struct scsi_dif_tuple {
 static inline void
 qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 {
+	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct scsi_dif_tuple	*ep =
 			(struct scsi_dif_tuple *)&sts24->data[20];
@@ -1473,15 +1455,15 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	e_guard = be16_to_cpu(ep->guard);
 	a_guard = be16_to_cpu(ap->guard);
 
-	DEBUG18(printk(KERN_DEBUG
-	    "%s(): iocb(s) %p Returned STATUS\n", __func__, sts24));
+	ql_dbg(ql_dbg_io, vha, 0x3023,
+	    "iocb(s) %p Returned STATUS.\n", sts24);
 
-	DEBUG18(printk(KERN_ERR "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
+	ql_dbg(ql_dbg_io, vha, 0x3024,
+	    "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
 	    " tag=0x%x, exp ref_tag=0x%x, act app tag=0x%x, exp app"
-	    " tag=0x%x, act guard=0x%x, exp guard=0x%x\n",
+	    " tag=0x%x, act guard=0x%x, exp guard=0x%x.\n",
 	    cmd->cmnd[0], (u64)scsi_get_lba(cmd), a_ref_tag, e_ref_tag,
-	    a_app_tag, e_app_tag, a_guard, e_guard));
-
+	    a_app_tag, e_app_tag, a_guard, e_guard);
 
 	/* check guard */
 	if (e_guard != a_guard) {
@@ -1569,9 +1551,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		sp = NULL;
 
 	if (sp == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		    "scsi(%ld): Invalid status handle (0x%x).\n", vha->host_no,
-		    sts->handle);
+		ql_log(ql_log_warn, vha, 0x3017,
+		    "Invalid status handle (0x%x).\n", sts->handle);
 
 		if (IS_QLA82XX(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
@@ -1582,9 +1563,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 	cp = sp->cmd;
 	if (cp == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		    "scsi(%ld): Command already returned (0x%x/%p).\n",
-		    vha->host_no, sts->handle, sp);
+		ql_log(ql_log_warn, vha, 0x3018,
+		    "Command already returned (0x%x/%p).\n",
+		    sts->handle, sp);
 
 		return;
 	}
@@ -1629,10 +1610,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			par_sense_len -= rsp_info_len;
 		}
 		if (rsp_info_len > 3 && rsp_info[3]) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "scsi(%ld:%d:%d): FCP I/O protocol failure "
-			    "(0x%x/0x%x).\n", vha->host_no, cp->device->id,
-			    cp->device->lun, rsp_info_len, rsp_info[3]));
+			ql_log(ql_log_warn, vha, 0x3019,
+			    "FCP I/O protocol failure (0x%x/0x%x).\n",
+			    rsp_info_len, rsp_info[3]);
 
 			cp->result = DID_BUS_BUSY << 16;
 			goto out;
@@ -1661,11 +1641,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			if (!lscsi_status &&
 			    ((unsigned)(scsi_bufflen(cp) - resid) <
 			     cp->underflow)) {
-				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d): Mid-layer underflow "
+				ql_log(ql_log_warn, vha, 0x301a,
+				    "Mid-layer underflow "
 				    "detected (0x%x of 0x%x bytes).\n",
-				    vha->host_no, cp->device->id,
-				    cp->device->lun, resid, scsi_bufflen(cp));
+				    resid, scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16;
 				break;
@@ -1674,9 +1653,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		cp->result = DID_OK << 16 | lscsi_status;
 
 		if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "scsi(%ld:%d:%d) QUEUE FULL detected.\n",
-			    vha->host_no, cp->device->id, cp->device->lun));
+			ql_log(ql_log_warn, vha, 0x301b,
+			    "QUEUE FULL detected.\n");
 			break;
 		}
 		logit = 0;
@@ -1697,11 +1675,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		scsi_set_resid(cp, resid);
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			if (IS_FWI2_CAPABLE(ha) && fw_resid_len != resid_len) {
-				DEBUG2(qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d) Dropped frame(s) detected "
-				    "(0x%x of 0x%x bytes).\n", vha->host_no,
-				    cp->device->id, cp->device->lun, resid,
-				    scsi_bufflen(cp)));
+				ql_log(ql_log_warn, vha, 0x301d,
+				    "Dropped frame(s) detected "
+				    "(0x%x of 0x%x bytes).\n",
+				    resid, scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16 | lscsi_status;
 				break;
@@ -1710,20 +1687,18 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			if (!lscsi_status &&
 			    ((unsigned)(scsi_bufflen(cp) - resid) <
 			    cp->underflow)) {
-				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d): Mid-layer underflow "
+				ql_log(ql_log_warn, vha, 0x301e,
+				    "Mid-layer underflow "
 				    "detected (0x%x of 0x%x bytes).\n",
-				    vha->host_no, cp->device->id,
-				    cp->device->lun, resid, scsi_bufflen(cp));
+				    resid, scsi_bufflen(cp));
 
 				cp->result = DID_ERROR << 16;
 				break;
 			}
 		} else {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "scsi(%ld:%d:%d) Dropped frame(s) detected (0x%x "
-			    "of 0x%x bytes).\n", vha->host_no, cp->device->id,
-			    cp->device->lun, resid, scsi_bufflen(cp)));
+			ql_log(ql_log_warn, vha, 0x301f,
+			    "Dropped frame(s) detected (0x%x "
+			    "of 0x%x bytes).\n", resid, scsi_bufflen(cp));
 
 			cp->result = DID_ERROR << 16 | lscsi_status;
 			goto check_scsi_status;
@@ -1739,10 +1714,8 @@ check_scsi_status:
 		 */
 		if (lscsi_status != 0) {
 			if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
-				DEBUG2(qla_printk(KERN_INFO, ha,
-				    "scsi(%ld:%d:%d) QUEUE FULL detected.\n",
-				    vha->host_no, cp->device->id,
-				    cp->device->lun));
+				ql_log(ql_log_warn, vha, 0x3020,
+				    "QUEUE FULL detected.\n");
 				logit = 1;
 				break;
 			}
@@ -1781,10 +1754,9 @@ check_scsi_status:
 				break;
 		}
 
-		DEBUG2(qla_printk(KERN_INFO, ha,
-			"scsi(%ld:%d:%d) Port down status: port-state=0x%x\n",
-			vha->host_no, cp->device->id, cp->device->lun,
-			atomic_read(&fcport->state)));
+		ql_dbg(ql_dbg_io, vha, 0x3021,
+		    "Port down status: port-state=0x%x.\n",
+		    atomic_read(&fcport->state));
 
 		if (atomic_read(&fcport->state) == FCS_ONLINE)
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
@@ -1804,15 +1776,13 @@ check_scsi_status:
 
 out:
 	if (logit)
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "scsi(%ld:%d:%d) FCP command status: 0x%x-0x%x (0x%x) "
-		    "portid=%02x%02x%02x oxid=0x%x cdb=%02x%02x%02x len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x\n", vha->host_no,
-		    cp->device->id, cp->device->lun, comp_status, scsi_status,
-		    cp->result, fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, ox_id, cp->cmnd[0], cp->cmnd[1],
-		    cp->cmnd[2], scsi_bufflen(cp), rsp_info_len, resid_len,
-		    fw_resid_len));
+		ql_dbg(ql_dbg_io, vha, 0x3022,
+		    "FCP command status: 0x%x-0x%x (0x%x) "
+		    "oxid=0x%x cdb=%02x%02x%02x len=0x%x "
+		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
+		    comp_status, scsi_status, cp->result, ox_id, cp->cmnd[0],
+		    cp->cmnd[1], cp->cmnd[2], scsi_bufflen(cp), rsp_info_len,
+		    resid_len, fw_resid_len);
 
 	if (rsp->status_srb == NULL)
 		qla2x00_sp_compl(ha, sp);
@@ -1830,16 +1800,15 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 {
 	uint8_t		sense_sz = 0;
 	struct qla_hw_data *ha = rsp->hw;
+	struct scsi_qla_host *vha = pci_get_drvdata(ha->pdev);
 	srb_t		*sp = rsp->status_srb;
 	struct scsi_cmnd *cp;
 
 	if (sp != NULL && sp->request_sense_length != 0) {
 		cp = sp->cmd;
 		if (cp == NULL) {
-			DEBUG2(printk("%s(): Cmd already returned back to OS "
-			    "sp=%p.\n", __func__, sp));
-			qla_printk(KERN_INFO, ha,
-			    "cmd is NULL: already returned to OS (sp=%p)\n",
+			ql_log(ql_log_warn, vha, 0x3025,
+			    "cmd is NULL: already returned to OS (sp=%p).\n",
 			    sp);
 
 			rsp->status_srb = NULL;
@@ -1856,7 +1825,8 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 		if (IS_FWI2_CAPABLE(ha))
 			host_to_fcp_swap(pkt->data, sizeof(pkt->data));
 		memcpy(sp->request_sense_ptr, pkt->data, sense_sz);
-		DEBUG5(qla2x00_dump_buffer(sp->request_sense_ptr, sense_sz));
+		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302c,
+			sp->request_sense_ptr, sense_sz);
 
 		sp->request_sense_ptr += sense_sz;
 		sp->request_sense_length -= sense_sz;
@@ -1882,21 +1852,25 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	uint32_t handle = LSW(pkt->handle);
 	uint16_t que = MSW(pkt->handle);
 	struct req_que *req = ha->req_q_map[que];
-#if defined(QL_DEBUG_LEVEL_2)
+
 	if (pkt->entry_status & RF_INV_E_ORDER)
-		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Order\n", __func__);
+		ql_dbg(ql_dbg_async, vha, 0x502a,
+		    "Invalid Entry Order.\n");
 	else if (pkt->entry_status & RF_INV_E_COUNT)
-		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Count\n", __func__);
+		ql_dbg(ql_dbg_async, vha, 0x502b,
+		    "Invalid Entry Count.\n");
 	else if (pkt->entry_status & RF_INV_E_PARAM)
-		qla_printk(KERN_ERR, ha,
-		    "%s: Invalid Entry Parameter\n", __func__);
+		ql_dbg(ql_dbg_async, vha, 0x502c,
+		    "Invalid Entry Parameter.\n");
 	else if (pkt->entry_status & RF_INV_E_TYPE)
-		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Type\n", __func__);
+		ql_dbg(ql_dbg_async, vha, 0x502d,
+		    "Invalid Entry Type.\n");
 	else if (pkt->entry_status & RF_BUSY)
-		qla_printk(KERN_ERR, ha, "%s: Busy\n", __func__);
+		ql_dbg(ql_dbg_async, vha, 0x502e,
+		    "Busy.\n");
 	else
-		qla_printk(KERN_ERR, ha, "%s: UNKNOWN flag error\n", __func__);
-#endif
+		ql_dbg(ql_dbg_async, vha, 0x502f,
+		    "UNKNOWN flag error.\n");
 
 	/* Validate handle. */
 	if (handle < MAX_OUTSTANDING_COMMANDS)
@@ -1923,10 +1897,8 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	} else if (pkt->entry_type == COMMAND_A64_TYPE || pkt->entry_type ==
 		COMMAND_TYPE || pkt->entry_type == COMMAND_TYPE_7
 		|| pkt->entry_type == COMMAND_TYPE_6) {
-		DEBUG2(printk("scsi(%ld): Error entry - invalid handle\n",
-			vha->host_no));
-		qla_printk(KERN_WARNING, ha,
-			"Error entry - invalid handle\n");
+		ql_log(ql_log_warn, vha, 0x5030,
+		    "Error entry - invalid handle.\n");
 
 		if (IS_QLA82XX(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
@@ -1960,11 +1932,11 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	}
 
 	if (ha->mcp) {
-		DEBUG3(printk("%s(%ld): Got mailbox completion. cmd=%x.\n",
-		    __func__, vha->host_no, ha->mcp->mb[0]));
+		ql_dbg(ql_dbg_async, vha, 0x504d,
+		    "Got mailbox completion. cmd=%x.\n", ha->mcp->mb[0]);
 	} else {
-		DEBUG2_3(printk("%s(%ld): MBX pointer ERROR!\n",
-		    __func__, vha->host_no));
+		ql_dbg(ql_dbg_async, vha, 0x504e,
+		    "MBX pointer ERROR.\n");
 	}
 }
 
@@ -1993,8 +1965,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 		}
 
 		if (pkt->entry_status != 0) {
-			DEBUG3(printk(KERN_INFO
-			    "scsi(%ld): Process error entry.\n", vha->host_no));
+			ql_dbg(ql_dbg_async, vha, 0x5029,
+			    "Process error entry.\n");
 
 			qla2x00_error_entry(vha, rsp, (sts_entry_t *) pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -2030,10 +2002,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			break;
 		default:
 			/* Type Not Supported. */
-			DEBUG4(printk(KERN_WARNING
-			    "scsi(%ld): Received unknown response pkt type %x "
+			ql_dbg(ql_dbg_async, vha, 0x5042,
+			    "Received unknown response pkt type %x "
 			    "entry status=%x.\n",
-			    vha->host_no, pkt->entry_type, pkt->entry_status));
+			    pkt->entry_type, pkt->entry_status);
 			break;
 		}
 		((response_t *)pkt)->signature = RESPONSE_PROCESSED;
@@ -2088,7 +2060,8 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 
 next_test:
 	if (RD_REG_DWORD(&reg->iobase_c8) & BIT_3)
-		qla_printk(KERN_INFO, ha, "Additional code -- 0x55AA.\n");
+		ql_log(ql_log_info, vha, 0x504c,
+		    "Additional code -- 0x55AA.\n");
 
 done:
 	WRT_REG_DWORD(&reg->iobase_window, 0x0000);
@@ -2121,7 +2094,7 @@ qla24xx_intr_handler(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-		    "%s(): NULL response queue pointer\n", __func__);
+		    "%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 
@@ -2142,8 +2115,9 @@ qla24xx_intr_handler(int irq, void *dev_id)
 
 			hccr = RD_REG_DWORD(&reg->hccr);
 
-			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
-			    "Dumping firmware!\n", hccr);
+			ql_log(ql_log_warn, vha, 0x504b,
+			    "RISC paused -- HCCR=%x, Dumping firmware.\n",
+			    hccr);
 
 			qla2xxx_check_risc_status(vha);
 
@@ -2174,9 +2148,8 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
-			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
-			    "(%d).\n",
-			    vha->host_no, stat & 0xff));
+			ql_dbg(ql_dbg_async, vha, 0x504f,
+			    "Unrecognized interrupt type (%d).\n", stat * 0xff);
 			break;
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
@@ -2205,7 +2178,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-		"%s(): NULL response queue pointer\n", __func__);
+		"%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 	ha = rsp->hw;
@@ -2235,7 +2208,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-			"%s(): NULL response queue pointer\n", __func__);
+			"%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 	ha = rsp->hw;
@@ -2268,8 +2241,8 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
-		DEBUG(printk(
-		"%s(): NULL response queue pointer\n", __func__));
+		printk(KERN_INFO
+			"%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 	ha = rsp->hw;
@@ -2286,8 +2259,9 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 			hccr = RD_REG_DWORD(&reg->hccr);
 
-			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
-			    "Dumping firmware!\n", hccr);
+			ql_log(ql_log_info, vha, 0x5050,
+			    "RISC paused -- HCCR=%x, Dumping firmware.\n",
+			    hccr);
 
 			qla2xxx_check_risc_status(vha);
 
@@ -2318,9 +2292,8 @@ qla24xx_msix_default(int irq, void *dev_id)
 			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
-			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
-			    "(%d).\n",
-			    vha->host_no, stat & 0xff));
+			ql_dbg(ql_dbg_async, vha, 0x5051,
+			    "Unrecognized interrupt type (%d).\n", stat & 0xff);
 			break;
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
@@ -2358,6 +2331,7 @@ qla24xx_disable_msix(struct qla_hw_data *ha)
 {
 	int i;
 	struct qla_msix_entry *qentry;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	for (i = 0; i < ha->msix_count; i++) {
 		qentry = &ha->msix_entries[i];
@@ -2368,6 +2342,8 @@ qla24xx_disable_msix(struct qla_hw_data *ha)
 	kfree(ha->msix_entries);
 	ha->msix_entries = NULL;
 	ha->flags.msix_enabled = 0;
+	ql_dbg(ql_dbg_init, vha, 0x0042,
+	    "Disabled the MSI.\n");
 }
 
 static int
@@ -2377,11 +2353,15 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	entries = kzalloc(sizeof(struct msix_entry) * ha->msix_count,
 			GFP_KERNEL);
-	if (!entries)
+	if (!entries) {
+		ql_log(ql_log_warn, vha, 0x00bc,
+		    "Failed to allocate memory for msix_entry.\n");
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < ha->msix_count; i++)
 		entries[i].entry = i;
@@ -2391,16 +2371,18 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		if (ret < MIN_MSIX_COUNT)
 			goto msix_failed;
 
-		qla_printk(KERN_WARNING, ha,
-			"MSI-X: Failed to enable support -- %d/%d\n"
-			" Retry with %d vectors\n", ha->msix_count, ret, ret);
+		ql_log(ql_log_warn, vha, 0x00c6,
+		    "MSI-X: Failed to enable support "
+		    "-- %d/%d\n Retry with %d vectors.\n",
+		    ha->msix_count, ret, ret);
 		ha->msix_count = ret;
 		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
 		if (ret) {
 msix_failed:
-			qla_printk(KERN_WARNING, ha, "MSI-X: Failed to enable"
-				" support, giving up -- %d/%d\n",
-				ha->msix_count, ret);
+			ql_log(ql_log_fatal, vha, 0x00c7,
+			    "MSI-X: Failed to enable support, "
+			    "giving   up -- %d/%d.\n",
+			    ha->msix_count, ret);
 			goto msix_out;
 		}
 		ha->max_rsp_queues = ha->msix_count - 1;
@@ -2408,6 +2390,8 @@ msix_failed:
 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
 				ha->msix_count, GFP_KERNEL);
 	if (!ha->msix_entries) {
+		ql_log(ql_log_fatal, vha, 0x00c8,
+		    "Failed to allocate memory for ha->msix_entries.\n");
 		ret = -ENOMEM;
 		goto msix_out;
 	}
@@ -2434,9 +2418,9 @@ msix_failed:
 				0, msix_entries[i].name, rsp);
 		}
 		if (ret) {
-			qla_printk(KERN_WARNING, ha,
-			"MSI-X: Unable to register handler -- %x/%d.\n",
-			qentry->vector, ret);
+			ql_log(ql_log_fatal, vha, 0x00cb,
+			    "MSI-X: unable to register handler -- %x/%d.\n",
+			    qentry->vector, ret);
 			qla24xx_disable_msix(ha);
 			ha->mqenable = 0;
 			goto msix_out;
@@ -2449,6 +2433,12 @@ msix_failed:
 	/* Enable MSI-X vector for response queue update for queue 0 */
 	if (ha->mqiobase &&  (ha->max_rsp_queues > 1 || ha->max_req_queues > 1))
 		ha->mqenable = 1;
+	ql_dbg(ql_dbg_multiq, vha, 0xc005,
+	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
+	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
+	ql_dbg(ql_dbg_init, vha, 0x0055,
+	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
+	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
 
 msix_out:
 	kfree(entries);
@@ -2460,6 +2450,7 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 	int ret;
 	device_reg_t __iomem *reg = ha->iobase;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
@@ -2470,30 +2461,30 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		(ha->pdev->subsystem_device == 0x7040 ||
 		ha->pdev->subsystem_device == 0x7041 ||
 		ha->pdev->subsystem_device == 0x1705)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-			"MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X,0x%X).\n",
+		ql_log(ql_log_warn, vha, 0x0034,
+		    "MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x%X,0x%X).\n",
 			ha->pdev->subsystem_vendor,
-			ha->pdev->subsystem_device));
+			ha->pdev->subsystem_device);
 		goto skip_msi;
 	}
 
 	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
 		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		"MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
-			ha->pdev->revision, ha->fw_attributes));
+		ql_log(ql_log_warn, vha, 0x0035,
+		    "MSI-X; Unsupported ISP2432 (0x%X, 0x%X).\n",
+		    ha->pdev->revision, ha->fw_attributes);
 		goto skip_msix;
 	}
 
 	ret = qla24xx_enable_msix(ha, rsp);
 	if (!ret) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "MSI-X: Enabled (0x%X, 0x%X).\n", ha->chip_revision,
-		    ha->fw_attributes));
+		ql_dbg(ql_dbg_init, vha, 0x0036,
+		    "MSI-X: Enabled (0x%X, 0x%X).\n",
+		    ha->chip_revision, ha->fw_attributes);
 		goto clear_risc_ints;
 	}
-	qla_printk(KERN_WARNING, ha,
-	    "MSI-X: Falling back-to MSI mode -- %d.\n", ret);
+	ql_log(ql_log_info, vha, 0x0037,
+	    "MSI-X Falling back-to MSI mode -%d.\n", ret);
 skip_msix:
 
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
@@ -2502,18 +2493,19 @@ skip_msix:
 
 	ret = pci_enable_msi(ha->pdev);
 	if (!ret) {
-		DEBUG2(qla_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
+		ql_dbg(ql_dbg_init, vha, 0x0038,
+		    "MSI: Enabled.\n");
 		ha->flags.msi_enabled = 1;
 	} else
-		qla_printk(KERN_WARNING, ha,
-		    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
+		ql_log(ql_log_warn, vha, 0x0039,
+		    "MSI-X; Falling back-to INTa mode -- %d.\n", ret);
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
 	    ha->flags.msi_enabled ? 0 : IRQF_SHARED,
 	    QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0x003a,
 		    "Failed to reserve interrupt %d already in use.\n",
 		    ha->pdev->irq);
 		goto fail;
@@ -2563,13 +2555,14 @@ int qla25xx_request_irq(struct rsp_que *rsp)
 	struct qla_hw_data *ha = rsp->hw;
 	struct qla_init_msix_entry *intr = &msix_entries[2];
 	struct qla_msix_entry *msix = rsp->msix;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	int ret;
 
 	ret = request_irq(msix->vector, intr->handler, 0, intr->name, rsp);
 	if (ret) {
-		qla_printk(KERN_WARNING, ha,
-			"MSI-X: Unable to register handler -- %x/%d.\n",
-			msix->vector, ret);
+		ql_log(ql_log_fatal, vha, 0x00e6,
+		    "MSI-X: Unable to register handler -- %x/%d.\n",
+		    msix->vector, ret);
 		return ret;
 	}
 	msix->have_irq = 1;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index e1138bc..5cbf33a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -348,6 +348,7 @@ static void
 qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
 {
 	u32 win_read;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	ha->crb_win = CRB_HI(*off);
 	writel(ha->crb_win,
@@ -358,9 +359,10 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
 	 */
 	win_read = RD_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
 	if (win_read != ha->crb_win) {
-		DEBUG2(qla_printk(KERN_INFO, ha,
-		    "%s: Written crbwin (0x%x) != Read crbwin (0x%x), "
-		    "off=0x%lx\n", __func__, ha->crb_win, win_read, *off));
+		ql_dbg(ql_dbg_p3p, vha, 0xb000,
+		    "%s: Written crbwin (0x%x) "
+		    "!= Read crbwin (0x%x), off=0x%lx.\n",
+		    ha->crb_win, win_read, *off);
 	}
 	*off = (*off & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
 }
@@ -368,6 +370,7 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data *ha, ulong *off)
 static inline unsigned long
 qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	/* See if we are currently pointing to the region we want to use next */
 	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_DDR_NET)) {
 		/* No need to change window. PCIX and PCIEregs are in both
@@ -398,9 +401,10 @@ qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
 			return off;
 	}
 	/* strange address given */
-	qla_printk(KERN_WARNING, ha,
-		"%s: Warning: unm_nic_pci_set_crbwindow called with"
-		" an unknown address(%llx)\n", QLA2XXX_DRIVER_NAME, off);
+	ql_dbg(ql_dbg_p3p, vha, 0xb001,
+	    "%x: Warning: unm_nic_pci_set_crbwindow "
+	    "called with an unknown address(%llx).\n",
+	    QLA2XXX_DRIVER_NAME, off);
 	return off;
 }
 
@@ -563,6 +567,7 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 {
 	int window;
 	u32 win_read;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
 		QLA82XX_ADDR_DDR_NET_MAX)) {
@@ -574,8 +579,8 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 		win_read = qla82xx_rd_32(ha,
 			ha->mn_win_crb | QLA82XX_PCI_CRBSPACE);
 		if ((win_read << 17) != window) {
-			qla_printk(KERN_WARNING, ha,
-			    "%s: Written MNwin (0x%x) != Read MNwin (0x%x)\n",
+			ql_dbg(ql_dbg_p3p, vha, 0xb003,
+			    "%s: Written MNwin (0x%x) != Read MNwin (0x%x).\n",
 			    __func__, window, win_read);
 		}
 		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_DDR_NET;
@@ -583,7 +588,7 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 		QLA82XX_ADDR_OCM0_MAX)) {
 		unsigned int temp1;
 		if ((addr & 0x00ff800) == 0xff800) {
-			qla_printk(KERN_WARNING, ha,
+			ql_log(ql_log_warn, vha, 0xb004,
 			    "%s: QM access not handled.\n", __func__);
 			addr = -1UL;
 		}
@@ -596,8 +601,8 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 		temp1 = ((window & 0x1FF) << 7) |
 		    ((window & 0x0FFFE0000) >> 17);
 		if (win_read != temp1) {
-			qla_printk(KERN_WARNING, ha,
-			    "%s: Written OCMwin (0x%x) != Read OCMwin (0x%x)\n",
+			ql_log(ql_log_warn, vha, 0xb005,
+			    "%s: Written OCMwin (0x%x) != Read OCMwin (0x%x).\n",
 			    __func__, temp1, win_read);
 		}
 		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_OCM0_2M;
@@ -612,8 +617,8 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 		win_read = qla82xx_rd_32(ha,
 			ha->ms_win_crb | QLA82XX_PCI_CRBSPACE);
 		if (win_read != window) {
-			qla_printk(KERN_WARNING, ha,
-			    "%s: Written MSwin (0x%x) != Read MSwin (0x%x)\n",
+			ql_log(ql_log_warn, vha, 0xb006,
+			    "%s: Written MSwin (0x%x) != Read MSwin (0x%x).\n",
 			    __func__, window, win_read);
 		}
 		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_QDR_NET;
@@ -624,9 +629,9 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 		 */
 		if ((qla82xx_pci_set_window_warning_count++ < 8) ||
 		    (qla82xx_pci_set_window_warning_count%64 == 0)) {
-			qla_printk(KERN_WARNING, ha,
-			    "%s: Warning:%s Unknown address range!\n", __func__,
-			    QLA2XXX_DRIVER_NAME);
+			ql_log(ql_log_warn, vha, 0xb007,
+			    "%s: Warning:%s Unknown address range!.\n",
+			    __func__, QLA2XXX_DRIVER_NAME);
 		}
 		addr = -1UL;
 	}
@@ -671,6 +676,7 @@ static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
 	uint8_t         *mem_ptr = NULL;
 	unsigned long   mem_base;
 	unsigned long   mem_page;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	write_lock_irqsave(&ha->hw_lock, flags);
 
@@ -682,9 +688,10 @@ static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
 	if ((start == -1UL) ||
 		(qla82xx_pci_is_same_window(ha, off + size - 1) == 0)) {
 		write_unlock_irqrestore(&ha->hw_lock, flags);
-		qla_printk(KERN_ERR, ha,
-			"%s out of bound pci memory access. "
-			"offset is 0x%llx\n", QLA2XXX_DRIVER_NAME, off);
+		ql_log(ql_log_fatal, vha, 0xb008,
+		    "%s out of bound pci memory "
+		    "access, offset is 0x%llx.\n",
+		    QLA2XXX_DRIVER_NAME, off);
 		return -1;
 	}
 
@@ -741,6 +748,7 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 	uint8_t         *mem_ptr = NULL;
 	unsigned long   mem_base;
 	unsigned long   mem_page;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	write_lock_irqsave(&ha->hw_lock, flags);
 
@@ -752,9 +760,10 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 	if ((start == -1UL) ||
 		(qla82xx_pci_is_same_window(ha, off + size - 1) == 0)) {
 		write_unlock_irqrestore(&ha->hw_lock, flags);
-		qla_printk(KERN_ERR, ha,
-			"%s out of bound pci memory access. "
-			"offset is 0x%llx\n", QLA2XXX_DRIVER_NAME, off);
+		ql_log(ql_log_fatal, vha, 0xb009,
+		    "%s out of bount memory "
+		    "access, offset is 0x%llx.\n",
+		    QLA2XXX_DRIVER_NAME, off);
 		return -1;
 	}
 
@@ -855,15 +864,16 @@ qla82xx_wait_rom_busy(struct qla_hw_data *ha)
 {
 	long timeout = 0;
 	long done = 0 ;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while (done == 0) {
 		done = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_STATUS);
 		done &= 4;
 		timeout++;
 		if (timeout >= rom_max_timeout) {
-			DEBUG(qla_printk(KERN_INFO, ha,
-				"%s: Timeout reached waiting for rom busy",
-				QLA2XXX_DRIVER_NAME));
+			ql_dbg(ql_dbg_p3p, vha, 0xb00a,
+			    "%s: Timeout reached waiting for rom busy.\n",
+			    QLA2XXX_DRIVER_NAME);
 			return -1;
 		}
 	}
@@ -875,15 +885,16 @@ qla82xx_wait_rom_done(struct qla_hw_data *ha)
 {
 	long timeout = 0;
 	long done = 0 ;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while (done == 0) {
 		done = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_STATUS);
 		done &= 2;
 		timeout++;
 		if (timeout >= rom_max_timeout) {
-			DEBUG(qla_printk(KERN_INFO, ha,
-				"%s: Timeout reached  waiting for rom done",
-				QLA2XXX_DRIVER_NAME));
+			ql_dbg(ql_dbg_p3p, vha, 0xb00b,
+			    "%s: Timeout reached waiting for rom done.\n",
+			    QLA2XXX_DRIVER_NAME);
 			return -1;
 		}
 	}
@@ -893,15 +904,16 @@ qla82xx_wait_rom_done(struct qla_hw_data *ha)
 static int
 qla82xx_do_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, addr);
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 3);
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, 0xb);
 	qla82xx_wait_rom_busy(ha);
 	if (qla82xx_wait_rom_done(ha)) {
-		qla_printk(KERN_WARNING, ha,
-			"%s: Error waiting for rom done\n",
-			QLA2XXX_DRIVER_NAME);
+		ql_log(ql_log_fatal, vha, 0x00ba,
+		    "Error waiting for rom done.\n");
 		return -1;
 	}
 	/* Reset abyte_cnt and dummy_byte_cnt */
@@ -917,6 +929,7 @@ static int
 qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 {
 	int ret, loops = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
 		udelay(100);
@@ -924,9 +937,8 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 		loops++;
 	}
 	if (loops >= 50000) {
-		qla_printk(KERN_INFO, ha,
-			"%s: qla82xx_rom_lock failed\n",
-			QLA2XXX_DRIVER_NAME);
+		ql_log(ql_log_fatal, vha, 0x00b9,
+		    "Failed to aquire SEM2 lock.\n");
 		return -1;
 	}
 	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
@@ -937,11 +949,12 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 static int
 qla82xx_read_status_reg(struct qla_hw_data *ha, uint32_t *val)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_RDSR);
 	qla82xx_wait_rom_busy(ha);
 	if (qla82xx_wait_rom_done(ha)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Error waiting for rom done\n");
+		ql_log(ql_log_warn, vha, 0xb00c,
+		    "Error waiting for rom done.\n");
 		return -1;
 	}
 	*val = qla82xx_rd_32(ha, QLA82XX_ROMUSB_ROM_RDATA);
@@ -955,6 +968,7 @@ qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
 	uint32_t done = 1 ;
 	uint32_t val;
 	int ret = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
 	while ((done != 0) && (ret == 0)) {
@@ -964,8 +978,8 @@ qla82xx_flash_wait_write_finish(struct qla_hw_data *ha)
 		udelay(10);
 		cond_resched();
 		if (timeout >= 50000) {
-			qla_printk(KERN_WARNING, ha,
-			    "Timeout reached  waiting for write finish");
+			ql_log(ql_log_warn, vha, 0xb00d,
+			    "Timeout reached waiting for write finish.\n");
 			return -1;
 		}
 	}
@@ -992,13 +1006,14 @@ qla82xx_flash_set_write_enable(struct qla_hw_data *ha)
 static int
 qla82xx_write_status_reg(struct qla_hw_data *ha, uint32_t val)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	if (qla82xx_flash_set_write_enable(ha))
 		return -1;
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_WDATA, val);
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, 0x1);
 	if (qla82xx_wait_rom_done(ha)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Error waiting for rom done\n");
+		ql_log(ql_log_warn, vha, 0xb00e,
+		    "Error waiting for rom done.\n");
 		return -1;
 	}
 	return qla82xx_flash_wait_write_finish(ha);
@@ -1007,10 +1022,11 @@ qla82xx_write_status_reg(struct qla_hw_data *ha, uint32_t val)
 static int
 qla82xx_write_disable_flash(struct qla_hw_data *ha)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_WRDI);
 	if (qla82xx_wait_rom_done(ha)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Error waiting for rom done\n");
+		ql_log(ql_log_warn, vha, 0xb00f,
+		    "Error waiting for rom done.\n");
 		return -1;
 	}
 	return 0;
@@ -1020,13 +1036,16 @@ static int
 ql82xx_rom_lock_d(struct qla_hw_data *ha)
 {
 	int loops = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+
 	while ((qla82xx_rom_lock(ha) != 0) && (loops < 50000)) {
 		udelay(100);
 		cond_resched();
 		loops++;
 	}
 	if (loops >= 50000) {
-		qla_printk(KERN_WARNING, ha, "ROM lock failed\n");
+		ql_log(ql_log_warn, vha, 0xb010,
+		    "ROM lock failed.\n");
 		return -1;
 	}
 	return 0;;
@@ -1037,10 +1056,12 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 	uint32_t data)
 {
 	int ret = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	ret = ql82xx_rom_lock_d(ha);
 	if (ret < 0) {
-		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		ql_log(ql_log_warn, vha, 0xb011,
+		    "ROM lock failed.\n");
 		return ret;
 	}
 
@@ -1053,8 +1074,8 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_PP);
 	qla82xx_wait_rom_busy(ha);
 	if (qla82xx_wait_rom_done(ha)) {
-		qla_printk(KERN_WARNING, ha,
-			"Error waiting for rom done\n");
+		ql_log(ql_log_warn, vha, 0xb012,
+		    "Error waiting for rom done.\n");
 		ret = -1;
 		goto done_write;
 	}
@@ -1159,8 +1180,8 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	 */
 	if (qla82xx_rom_fast_read(ha, 0, &n) != 0 || n != 0xcafecafeUL ||
 	    qla82xx_rom_fast_read(ha, 4, &n) != 0) {
-		qla_printk(KERN_WARNING, ha,
-		    "[ERROR] Reading crb_init area: n: %08x\n", n);
+		ql_log(ql_log_fatal, vha, 0x006e,
+		    "Error Reading crb_init area: n: %08x.\n", n);
 		return -1;
 	}
 
@@ -1172,20 +1193,18 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 
 	/* number of addr/value pair should not exceed 1024 enteries */
 	if (n  >= 1024) {
-		qla_printk(KERN_WARNING, ha,
-		    "%s: %s:n=0x%x [ERROR] Card flash not initialized.\n",
-		    QLA2XXX_DRIVER_NAME, __func__, n);
+		ql_log(ql_log_fatal, vha, 0x0071,
+		    "Card flash not initialized:n=0x%x.\n", n);
 		return -1;
 	}
 
-	qla_printk(KERN_INFO, ha,
-	    "%s: %d CRB init values found in ROM.\n", QLA2XXX_DRIVER_NAME, n);
+	ql_log(ql_log_info, vha, 0x0072,
+	    "%d CRB init values found in ROM.\n", n);
 
 	buf = kmalloc(n * sizeof(struct crb_addr_pair), GFP_KERNEL);
 	if (buf == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		    "%s: [ERROR] Unable to malloc memory.\n",
-		    QLA2XXX_DRIVER_NAME);
+		ql_log(ql_log_fatal, vha, 0x010c,
+		    "Unable to allocate memory.\n");
 		return -1;
 	}
 
@@ -1236,9 +1255,8 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 			continue;
 
 		if (off == ADDR_ERROR) {
-			qla_printk(KERN_WARNING, ha,
-			    "%s: [ERROR] Unknown addr: 0x%08lx\n",
-			    QLA2XXX_DRIVER_NAME, buf[i].addr);
+			ql_log(ql_log_fatal, vha, 0x0116,
+			    "Unknow addr: 0x%08lx.\n", buf[i].addr);
 			continue;
 		}
 
@@ -1370,7 +1388,7 @@ qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 		if (j >= MAX_CTL_CHECK) {
 			if (printk_ratelimit())
 				dev_err(&ha->pdev->dev,
-				    "failed to write through agent\n");
+				    "failed to write through agent.\n");
 			ret = -1;
 			break;
 		}
@@ -1460,7 +1478,7 @@ qla82xx_pci_mem_read_2M(struct qla_hw_data *ha,
 		if (j >= MAX_CTL_CHECK) {
 			if (printk_ratelimit())
 				dev_err(&ha->pdev->dev,
-				    "failed to read through agent\n");
+				    "failed to read through agent.\n");
 			break;
 		}
 
@@ -1633,17 +1651,15 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 	uint32_t len = 0;
 
 	if (pci_request_regions(ha->pdev, QLA2XXX_DRIVER_NAME)) {
-		qla_printk(KERN_WARNING, ha,
-			"Failed to reserve selected regions (%s)\n",
-			pci_name(ha->pdev));
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x000c,
+		    "Failed to reserver selected regions.\n");
 		goto iospace_error_exit;
 	}
 
 	/* Use MMIO operations for all accesses. */
 	if (!(pci_resource_flags(ha->pdev, 0) & IORESOURCE_MEM)) {
-		qla_printk(KERN_ERR, ha,
-			"region #0 not an MMIO resource (%s), aborting\n",
-			pci_name(ha->pdev));
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x000d,
+		    "Region #0 not an MMIO resource, aborting.\n");
 		goto iospace_error_exit;
 	}
 
@@ -1651,9 +1667,8 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 	ha->nx_pcibase =
 	    (unsigned long)ioremap(pci_resource_start(ha->pdev, 0), len);
 	if (!ha->nx_pcibase) {
-		qla_printk(KERN_ERR, ha,
-		    "cannot remap pcibase MMIO (%s), aborting\n",
-		    pci_name(ha->pdev));
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x000e,
+		    "Cannot remap pcibase MMIO, aborting.\n");
 		pci_release_regions(ha->pdev);
 		goto iospace_error_exit;
 	}
@@ -1667,9 +1682,8 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 		    (unsigned long)ioremap((pci_resource_start(ha->pdev, 4) +
 		    (ha->pdev->devfn << 12)), 4);
 		if (!ha->nxdb_wr_ptr) {
-			qla_printk(KERN_ERR, ha,
-			    "cannot remap MMIO (%s), aborting\n",
-			    pci_name(ha->pdev));
+			ql_log_pci(ql_log_fatal, ha->pdev, 0x000f,
+			    "Cannot remap MMIO, aborting.\n");
 			pci_release_regions(ha->pdev);
 			goto iospace_error_exit;
 		}
@@ -1687,6 +1701,16 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 
 	ha->max_req_queues = ha->max_rsp_queues = 1;
 	ha->msix_count = ha->max_rsp_queues + 1;
+	ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc006,
+	    "nx_pci_base=%p iobase=%p "
+	    "max_req_queues=%d msix_count=%d.\n",
+	    ha->nx_pcibase, ha->iobase,
+	    ha->max_req_queues, ha->msix_count);
+	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0010,
+	    "nx_pci_base=%p iobase=%p "
+	    "max_req_queues=%d msix_count=%d.\n",
+	    ha->nx_pcibase, ha->iobase,
+	    ha->max_req_queues, ha->msix_count);
 	return 0;
 
 iospace_error_exit:
@@ -1712,6 +1736,9 @@ qla82xx_pci_config(scsi_qla_host_t *vha)
 	pci_set_master(ha->pdev);
 	ret = pci_set_mwi(ha->pdev);
 	ha->chip_revision = ha->pdev->revision;
+	ql_dbg(ql_dbg_init, vha, 0x0043,
+	    "Chip revision:%ld.\n",
+	    ha->chip_revision);
 	return 0;
 }
 
@@ -1877,6 +1904,7 @@ qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
 {
 	u32 val = 0;
 	int retries = 60;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	do {
 		read_lock(&ha->hw_lock);
@@ -1892,15 +1920,15 @@ qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
 		default:
 			break;
 		}
-		qla_printk(KERN_WARNING, ha,
-			"CRB_CMDPEG_STATE: 0x%x and retries: 0x%x\n",
-			val, retries);
+		ql_log(ql_log_info, vha, 0x00a8,
+		    "CRB_CMDPEG_STATE: 0x%x and retries:0x%x.\n",
+		    val, retries);
 
 		msleep(500);
 
 	} while (--retries);
 
-	qla_printk(KERN_INFO, ha,
+	ql_log(ql_log_fatal, vha, 0x00a9,
 	    "Cmd Peg initialization failed: 0x%x.\n", val);
 
 	val = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_PEGTUNE_DONE);
@@ -1915,6 +1943,7 @@ qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
 {
 	u32 val = 0;
 	int retries = 60;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	do {
 		read_lock(&ha->hw_lock);
@@ -1930,17 +1959,16 @@ qla82xx_check_rcvpeg_state(struct qla_hw_data *ha)
 		default:
 			break;
 		}
-
-		qla_printk(KERN_WARNING, ha,
-			"CRB_RCVPEG_STATE: 0x%x and retries: 0x%x\n",
-			val, retries);
+		ql_log(ql_log_info, vha, 0x00ab,
+		    "CRB_RCVPEG_STATE: 0x%x and retries: 0x%x.\n",
+		    val, retries);
 
 		msleep(500);
 
 	} while (--retries);
 
-	qla_printk(KERN_INFO, ha,
-		"Rcv Peg initialization failed: 0x%x.\n", val);
+	ql_log(ql_log_fatal, vha, 0x00ac,
+	    "Rcv Peg initializatin failed: 0x%x.\n", val);
 	read_lock(&ha->hw_lock);
 	qla82xx_wr_32(ha, CRB_RCVPEG_STATE, PHAN_INITIALIZE_FAILED);
 	read_unlock(&ha->hw_lock);
@@ -1989,13 +2017,11 @@ qla82xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	}
 
 	if (ha->mcp) {
-		DEBUG3_11(printk(KERN_INFO "%s(%ld): "
-			"Got mailbox completion. cmd=%x.\n",
-			__func__, vha->host_no, ha->mcp->mb[0]));
+		ql_dbg(ql_dbg_async, vha, 0x5052,
+		    "Got mailbox completion. cmd=%x.\n", ha->mcp->mb[0]);
 	} else {
-		qla_printk(KERN_INFO, ha,
-			"%s(%ld): MBX pointer ERROR!\n",
-			__func__, vha->host_no);
+		ql_dbg(ql_dbg_async, vha, 0x5053,
+		    "MBX pointer ERROR.\n");
 	}
 }
 
@@ -2019,13 +2045,13 @@ qla82xx_intr_handler(int irq, void *dev_id)
 	int status = 0, status1 = 0;
 	unsigned long	flags;
 	unsigned long	iter;
-	uint32_t	stat;
+	uint32_t	stat = 0;
 	uint16_t	mb[4];
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-			"%s(): NULL response queue pointer\n", __func__);
+			"%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 	ha = rsp->hw;
@@ -2075,9 +2101,9 @@ qla82xx_intr_handler(int irq, void *dev_id)
 				qla24xx_process_response_queue(vha, rsp);
 				break;
 			default:
-				DEBUG2(printk("scsi(%ld): "
-					" Unrecognized interrupt type (%d).\n",
-					vha->host_no, stat & 0xff));
+				ql_dbg(ql_dbg_async, vha, 0x5054,
+				    "Unrecognized interrupt type (%d).\n",
+				    stat & 0xff);
 				break;
 			}
 		}
@@ -2089,8 +2115,8 @@ qla82xx_intr_handler(int irq, void *dev_id)
 
 #ifdef QL_DEBUG_LEVEL_17
 	if (!irq && ha->flags.eeh_busy)
-		qla_printk(KERN_WARNING, ha,
-		    "isr: status %x, cmd_flags %lx, mbox_int %x, stat %x\n",
+		ql_log(ql_log_warn, vha, 0x503d,
+		    "isr:status %x, cmd_flags %lx, mbox_int %x, stat %x.\n",
 		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
 #endif
 
@@ -2111,13 +2137,13 @@ qla82xx_msix_default(int irq, void *dev_id)
 	struct device_reg_82xx __iomem *reg;
 	int status = 0;
 	unsigned long flags;
-	uint32_t stat;
+	uint32_t stat = 0;
 	uint16_t mb[4];
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-			"%s(): NULL response queue pointer\n", __func__);
+			"%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 	ha = rsp->hw;
@@ -2149,9 +2175,9 @@ qla82xx_msix_default(int irq, void *dev_id)
 				qla24xx_process_response_queue(vha, rsp);
 				break;
 			default:
-				DEBUG2(printk("scsi(%ld): "
-					" Unrecognized interrupt type (%d).\n",
-					vha->host_no, stat & 0xff));
+				ql_dbg(ql_dbg_async, vha, 0x5041,
+				    "Unrecognized interrupt type (%d).\n",
+				    stat & 0xff);
 				break;
 			}
 		}
@@ -2162,9 +2188,9 @@ qla82xx_msix_default(int irq, void *dev_id)
 
 #ifdef QL_DEBUG_LEVEL_17
 	if (!irq && ha->flags.eeh_busy)
-		qla_printk(KERN_WARNING, ha,
-			"isr: status %x, cmd_flags %lx, mbox_int %x, stat %x\n",
-			status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
+		ql_log(ql_log_warn, vha, 0x5044,
+		    "isr:status %x, cmd_flags %lx, mbox_int %x, stat %x.\n",
+		    status, ha->mbx_cmd_flags, ha->flags.mbox_int, stat);
 #endif
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
@@ -2186,7 +2212,7 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-			"%s(): NULL response queue pointer\n", __func__);
+			"%s(): NULL response queue pointer.\n", __func__);
 		return IRQ_NONE;
 	}
 
@@ -2215,7 +2241,7 @@ qla82xx_poll(int irq, void *dev_id)
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
 		printk(KERN_INFO
-			"%s(): NULL response queue pointer\n", __func__);
+			"%s(): NULL response queue pointer.\n", __func__);
 		return;
 	}
 	ha = rsp->hw;
@@ -2245,9 +2271,9 @@ qla82xx_poll(int irq, void *dev_id)
 			qla24xx_process_response_queue(vha, rsp);
 			break;
 		default:
-			DEBUG2(printk("scsi(%ld): Unrecognized interrupt type "
-				"(%d).\n",
-				vha->host_no, stat & 0xff));
+			ql_dbg(ql_dbg_p3p, vha, 0xb013,
+			    "Unrecognized interrupt type (%d).\n",
+			    stat * 0xff);
 			break;
 		}
 	}
@@ -2347,9 +2373,8 @@ qla82xx_set_rst_ready(struct qla_hw_data *ha)
 		drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
 	}
 	drv_state |= (QLA82XX_DRVST_RST_RDY << (ha->portnum * 4));
-	qla_printk(KERN_INFO, ha,
-		"%s(%ld):drv_state = 0x%x\n",
-		__func__, vha->host_no, drv_state);
+	ql_log(ql_log_info, vha, 0x00bb,
+	    "drv_state = 0x%x.\n", drv_state);
 	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, drv_state);
 }
 
@@ -2392,8 +2417,8 @@ qla82xx_load_fw(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (qla82xx_pinit_from_rom(vha) != QLA_SUCCESS) {
-		qla_printk(KERN_ERR, ha,
-			"%s: Error during CRB Initialization\n", __func__);
+		ql_log(ql_log_fatal, vha, 0x009f,
+		    "Error during CRB initialization.\n");
 		return QLA_FUNCTION_FAILED;
 	}
 	udelay(500);
@@ -2411,27 +2436,27 @@ qla82xx_load_fw(scsi_qla_host_t *vha)
 	if (ql2xfwloadbin == 2)
 		goto try_blob_fw;
 
-	qla_printk(KERN_INFO, ha,
-		"Attempting to load firmware from flash\n");
+	ql_log(ql_log_info, vha, 0x00a0,
+	    "Attempting to load firmware from flash.\n");
 
 	if (qla82xx_fw_load_from_flash(ha) == QLA_SUCCESS) {
-		qla_printk(KERN_ERR, ha,
-		    "Firmware loaded successfully from flash\n");
+		ql_log(ql_log_info, vha, 0x00a1,
+		    "Firmware loaded successully from flash.\n");
 		return QLA_SUCCESS;
 	} else {
-		qla_printk(KERN_ERR, ha,
-		    "Firmware load from flash failed\n");
+		ql_log(ql_log_warn, vha, 0x0108,
+		    "Firmware load from flash failed.\n");
 	}
 
 try_blob_fw:
-	qla_printk(KERN_INFO, ha,
-	    "Attempting to load firmware from blob\n");
+	ql_log(ql_log_info, vha, 0x00a2,
+	    "Attempting to load firmware from blob.\n");
 
 	/* Load firmware blob. */
 	blob = ha->hablob = qla2x00_request_firmware(vha);
 	if (!blob) {
-		qla_printk(KERN_ERR, ha,
-			"Firmware image not present.\n");
+		ql_log(ql_log_fatal, vha, 0x00a3,
+		    "Firmware image not preset.\n");
 		goto fw_load_failed;
 	}
 
@@ -2441,20 +2466,19 @@ try_blob_fw:
 		/* Fallback to URI format */
 		if (qla82xx_validate_firmware_blob(vha,
 			QLA82XX_UNIFIED_ROMIMAGE)) {
-			qla_printk(KERN_ERR, ha,
-				"No valid firmware image found!!!");
+			ql_log(ql_log_fatal, vha, 0x00a4,
+			    "No valid firmware image found.\n");
 			return QLA_FUNCTION_FAILED;
 		}
 	}
 
 	if (qla82xx_fw_load_from_blob(ha) == QLA_SUCCESS) {
-		qla_printk(KERN_ERR, ha,
-			"%s: Firmware loaded successfully "
-			" from binary blob\n", __func__);
+		ql_log(ql_log_info, vha, 0x00a5,
+		    "Firmware loaded successfully from binary blob.\n");
 		return QLA_SUCCESS;
 	} else {
-		qla_printk(KERN_ERR, ha,
-		    "Firmware load failed from binary blob\n");
+		ql_log(ql_log_fatal, vha, 0x00a6,
+		    "Firmware load failed for binary blob.\n");
 		blob->fw = NULL;
 		blob = NULL;
 		goto fw_load_failed;
@@ -2486,15 +2510,15 @@ qla82xx_start_firmware(scsi_qla_host_t *vha)
 	qla82xx_wr_32(ha, QLA82XX_PEG_HALT_STATUS2, 0);
 
 	if (qla82xx_load_fw(vha) != QLA_SUCCESS) {
-		qla_printk(KERN_INFO, ha,
-			"%s: Error trying to start fw!\n", __func__);
+		ql_log(ql_log_fatal, vha, 0x00a7,
+		    "Error trying to start fw.\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
 	/* Handshake with the card before we register the devices. */
 	if (qla82xx_check_cmdpeg_state(ha) != QLA_SUCCESS) {
-		qla_printk(KERN_INFO, ha,
-			"%s: Error during card handshake!\n", __func__);
+		ql_log(ql_log_fatal, vha, 0x00aa,
+		    "Error during card handshake.\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2663,8 +2687,11 @@ qla82xx_start_scsi(srb_t *sp)
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
 		if (qla2x00_marker(vha, req,
-			rsp, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS)
+			rsp, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x300c,
+			    "qla2x00_marker failed for cmd=%p.\n", cmd);
 			return QLA_FUNCTION_FAILED;
+		}
 		vha->marker_needed = 0;
 	}
 
@@ -2701,8 +2728,13 @@ qla82xx_start_scsi(srb_t *sp)
 		uint16_t i;
 
 		more_dsd_lists = qla82xx_calc_dsd_lists(tot_dsds);
-		if ((more_dsd_lists + ha->gbl_dsd_inuse) >= NUM_DSD_CHAIN)
+		if ((more_dsd_lists + ha->gbl_dsd_inuse) >= NUM_DSD_CHAIN) {
+			ql_dbg(ql_dbg_io, vha, 0x300d,
+			    "Num of DSD list %d is than %d for cmd=%p.\n",
+			    more_dsd_lists + ha->gbl_dsd_inuse, NUM_DSD_CHAIN,
+			    cmd);
 			goto queuing_error;
+		}
 
 		if (more_dsd_lists <= ha->gbl_dsd_avail)
 			goto sufficient_dsds;
@@ -2711,13 +2743,20 @@ qla82xx_start_scsi(srb_t *sp)
 
 		for (i = 0; i < more_dsd_lists; i++) {
 			dsd_ptr = kzalloc(sizeof(struct dsd_dma), GFP_ATOMIC);
-			if (!dsd_ptr)
+			if (!dsd_ptr) {
+				ql_log(ql_log_fatal, vha, 0x300e,
+				    "Failed to allocate memory for dsd_dma "
+				    "for cmd=%p.\n", cmd);
 				goto queuing_error;
+			}
 
 			dsd_ptr->dsd_addr = dma_pool_alloc(ha->dl_dma_pool,
 				GFP_ATOMIC, &dsd_ptr->dsd_list_dma);
 			if (!dsd_ptr->dsd_addr) {
 				kfree(dsd_ptr);
+				ql_log(ql_log_fatal, vha, 0x300f,
+				    "Failed to allocate memory for dsd_addr "
+				    "for cmd=%p.\n", cmd);
 				goto queuing_error;
 			}
 			list_add_tail(&dsd_ptr->list, &ha->gbl_dsd_list);
@@ -2742,17 +2781,16 @@ sufficient_dsds:
 
 		ctx = sp->ctx = mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 		if (!sp->ctx) {
-			DEBUG(printk(KERN_INFO
-				"%s(%ld): failed to allocate"
-				" ctx.\n", __func__, vha->host_no));
+			ql_log(ql_log_fatal, vha, 0x3010,
+			    "Failed to allocate ctx for cmd=%p.\n", cmd);
 			goto queuing_error;
 		}
 		memset(ctx, 0, sizeof(struct ct6_dsd));
 		ctx->fcp_cmnd = dma_pool_alloc(ha->fcp_cmnd_dma_pool,
 			GFP_ATOMIC, &ctx->fcp_cmnd_dma);
 		if (!ctx->fcp_cmnd) {
-			DEBUG2_3(printk("%s(%ld): failed to allocate"
-				" fcp_cmnd.\n", __func__, vha->host_no));
+			ql_log(ql_log_fatal, vha, 0x3011,
+			    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
 			goto queuing_error_fcp_cmnd;
 		}
 
@@ -2766,6 +2804,9 @@ sufficient_dsds:
 				/* SCSI command bigger than 16 bytes must be
 				 * multiple of 4
 				 */
+				ql_log(ql_log_warn, vha, 0x3012,
+				    "scsi cmd len %d not multiple of 4 "
+				    "for cmd=%p.\n", cmd->cmd_len, cmd);
 				goto queuing_error_fcp_cmnd;
 			}
 			ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
@@ -2845,7 +2886,7 @@ sufficient_dsds:
 		cmd_pkt->entry_status = (uint8_t) rsp->id;
 	} else {
 		struct cmd_type_7 *cmd_pkt;
-		req_cnt = qla24xx_calc_iocbs(tot_dsds);
+		req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 		if (req->cnt < (req_cnt + 2)) {
 			cnt = (uint16_t)RD_REG_DWORD_RELAXED(
 			    &reg->req_q_out[0]);
@@ -2979,8 +3020,8 @@ qla82xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	/* Dword reads to flash. */
 	for (i = 0; i < length/4; i++, faddr += 4) {
 		if (qla82xx_rom_fast_read(ha, faddr, &val)) {
-			qla_printk(KERN_WARNING, ha,
-			    "Do ROM fast read failed\n");
+			ql_log(ql_log_warn, vha, 0x0106,
+			    "Do ROM fast read failed.\n");
 			goto done_read;
 		}
 		dwptr[i] = __constant_cpu_to_le32(val);
@@ -2994,10 +3035,12 @@ qla82xx_unprotect_flash(struct qla_hw_data *ha)
 {
 	int ret;
 	uint32_t val;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	ret = ql82xx_rom_lock_d(ha);
 	if (ret < 0) {
-		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		ql_log(ql_log_warn, vha, 0xb014,
+		    "ROM Lock failed.\n");
 		return ret;
 	}
 
@@ -3013,7 +3056,8 @@ qla82xx_unprotect_flash(struct qla_hw_data *ha)
 	}
 
 	if (qla82xx_write_disable_flash(ha) != 0)
-		qla_printk(KERN_WARNING, ha, "Write disable failed\n");
+		ql_log(ql_log_warn, vha, 0xb015,
+		    "Write disable failed.\n");
 
 done_unprotect:
 	qla82xx_rom_unlock(ha);
@@ -3025,10 +3069,12 @@ qla82xx_protect_flash(struct qla_hw_data *ha)
 {
 	int ret;
 	uint32_t val;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	ret = ql82xx_rom_lock_d(ha);
 	if (ret < 0) {
-		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		ql_log(ql_log_warn, vha, 0xb016,
+		    "ROM Lock failed.\n");
 		return ret;
 	}
 
@@ -3040,10 +3086,12 @@ qla82xx_protect_flash(struct qla_hw_data *ha)
 	/* LOCK all sectors */
 	ret = qla82xx_write_status_reg(ha, val);
 	if (ret < 0)
-		qla_printk(KERN_WARNING, ha, "Write status register failed\n");
+		ql_log(ql_log_warn, vha, 0xb017,
+		    "Write status register failed.\n");
 
 	if (qla82xx_write_disable_flash(ha) != 0)
-		qla_printk(KERN_WARNING, ha, "Write disable failed\n");
+		ql_log(ql_log_warn, vha, 0xb018,
+		    "Write disable failed.\n");
 done_protect:
 	qla82xx_rom_unlock(ha);
 	return ret;
@@ -3053,10 +3101,12 @@ static int
 qla82xx_erase_sector(struct qla_hw_data *ha, int addr)
 {
 	int ret = 0;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	ret = ql82xx_rom_lock_d(ha);
 	if (ret < 0) {
-		qla_printk(KERN_WARNING, ha, "ROM Lock failed\n");
+		ql_log(ql_log_warn, vha, 0xb019,
+		    "ROM Lock failed.\n");
 		return ret;
 	}
 
@@ -3066,8 +3116,8 @@ qla82xx_erase_sector(struct qla_hw_data *ha, int addr)
 	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, M25P_INSTR_SE);
 
 	if (qla82xx_wait_rom_done(ha)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Error waiting for rom done\n");
+		ql_log(ql_log_warn, vha, 0xb01a,
+		    "Error waiting for rom done.\n");
 		ret = -1;
 		goto done;
 	}
@@ -3110,10 +3160,10 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 		    &optrom_dma, GFP_KERNEL);
 		if (!optrom) {
-			qla_printk(KERN_DEBUG, ha,
-				"Unable to allocate memory for optrom "
-				"burst write (%x KB).\n",
-				OPTROM_BURST_SIZE / 1024);
+			ql_log(ql_log_warn, vha, 0xb01b,
+			    "Unable to allocate memory "
+			    "for optron burst write (%x KB).\n",
+			    OPTROM_BURST_SIZE / 1024);
 		}
 	}
 
@@ -3122,8 +3172,8 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 
 	ret = qla82xx_unprotect_flash(ha);
 	if (ret) {
-		qla_printk(KERN_WARNING, ha,
-			"Unable to unprotect flash for update.\n");
+		ql_log(ql_log_warn, vha, 0xb01c,
+		    "Unable to unprotect flash for update.\n");
 		goto write_done;
 	}
 
@@ -3133,9 +3183,9 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 
 			ret = qla82xx_erase_sector(ha, faddr);
 			if (ret) {
-				DEBUG9(qla_printk(KERN_ERR, ha,
-				    "Unable to erase sector: "
-				    "address=%x.\n", faddr));
+				ql_log(ql_log_warn, vha, 0xb01d,
+				    "Unable to erase sector: address=%x.\n",
+				    faddr);
 				break;
 			}
 		}
@@ -3149,12 +3199,12 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 			    (ha->flash_data_off | faddr),
 			    OPTROM_BURST_DWORDS);
 			if (ret != QLA_SUCCESS) {
-				qla_printk(KERN_WARNING, ha,
+				ql_log(ql_log_warn, vha, 0xb01e,
 				    "Unable to burst-write optrom segment "
 				    "(%x/%x/%llx).\n", ret,
 				    (ha->flash_data_off | faddr),
 				    (unsigned long long)optrom_dma);
-				qla_printk(KERN_WARNING, ha,
+				ql_log(ql_log_warn, vha, 0xb01f,
 				    "Reverting to slow-write.\n");
 
 				dma_free_coherent(&ha->pdev->dev,
@@ -3171,16 +3221,16 @@ qla82xx_write_flash_data(struct scsi_qla_host *vha, uint32_t *dwptr,
 		ret = qla82xx_write_flash_dword(ha, faddr,
 		    cpu_to_le32(*dwptr));
 		if (ret) {
-			DEBUG9(printk(KERN_DEBUG "%s(%ld) Unable to program"
-			    "flash address=%x data=%x.\n", __func__,
-			    ha->host_no, faddr, *dwptr));
+			ql_dbg(ql_dbg_p3p, vha, 0xb020,
+			    "Unable to program flash address=%x data=%x.\n",
+			    faddr, *dwptr);
 			break;
 		}
 	}
 
 	ret = qla82xx_protect_flash(ha);
 	if (ret)
-		qla_printk(KERN_WARNING, ha,
+		ql_log(ql_log_warn, vha, 0xb021,
 		    "Unable to protect flash after update.\n");
 write_done:
 	if (optrom)
@@ -3244,9 +3294,12 @@ qla82xx_start_iocbs(srb_t *sp)
 
 void qla82xx_rom_lock_recovery(struct qla_hw_data *ha)
 {
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+
 	if (qla82xx_rom_lock(ha))
 		/* Someone else is holding the lock. */
-		qla_printk(KERN_INFO, ha, "Resetting rom_lock\n");
+		ql_log(ql_log_info, vha, 0xb022,
+		    "Resetting rom_lock.\n");
 
 	/*
 	 * Either we got the lock, or someone
@@ -3313,7 +3366,8 @@ qla82xx_device_bootstrap(scsi_qla_host_t *vha)
 
 dev_initialize:
 	/* set to DEV_INITIALIZING */
-	qla_printk(KERN_INFO, ha, "HW State: INITIALIZING\n");
+	ql_log(ql_log_info, vha, 0x009e,
+	    "HW State: INITIALIZING.\n");
 	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_INITIALIZING);
 
 	/* Driver that sets device state to initializating sets IDC version */
@@ -3324,14 +3378,16 @@ dev_initialize:
 	qla82xx_idc_lock(ha);
 
 	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_INFO, ha, "HW State: FAILED\n");
+		ql_log(ql_log_fatal, vha, 0x00ad,
+		    "HW State: FAILED.\n");
 		qla82xx_clear_drv_active(ha);
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_FAILED);
 		return rval;
 	}
 
 dev_ready:
-	qla_printk(KERN_INFO, ha, "HW State: READY\n");
+	ql_log(ql_log_info, vha, 0x00ae,
+	    "HW State: READY.\n");
 	qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_READY);
 
 	return QLA_SUCCESS;
@@ -3376,15 +3432,15 @@ qla82xx_need_qsnt_handler(scsi_qla_host_t *vha)
 			/* quiescence timeout, other functions didn't ack
 			 * changing the state to DEV_READY
 			 */
-			qla_printk(KERN_INFO, ha,
-			    "%s: QUIESCENT TIMEOUT\n", QLA2XXX_DRIVER_NAME);
-			qla_printk(KERN_INFO, ha,
-			    "DRV_ACTIVE:%d DRV_STATE:%d\n", drv_active,
-			    drv_state);
+			ql_log(ql_log_info, vha, 0xb023,
+			    "%s : QUIESCENT TIMEOUT.\n", QLA2XXX_DRIVER_NAME);
+			ql_log(ql_log_info, vha, 0xb024,
+			    "DRV_ACTIVE:%d DRV_STATE:%d.\n",
+			    drv_active, drv_state);
 			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-						QLA82XX_DEV_READY);
-			qla_printk(KERN_INFO, ha,
-			    "HW State: DEV_READY\n");
+			    QLA82XX_DEV_READY);
+			ql_log(ql_log_info, vha, 0xb025,
+			    "HW State: DEV_READY.\n");
 			qla82xx_idc_unlock(ha);
 			qla2x00_perform_loop_resync(vha);
 			qla82xx_idc_lock(ha);
@@ -3404,7 +3460,8 @@ qla82xx_need_qsnt_handler(scsi_qla_host_t *vha)
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 	/* everyone acked so set the state to DEV_QUIESCENCE */
 	if (dev_state == QLA82XX_DEV_NEED_QUIESCENT) {
-		qla_printk(KERN_INFO, ha, "HW State: DEV_QUIESCENT\n");
+		ql_log(ql_log_info, vha, 0xb026,
+		    "HW State: DEV_QUIESCENT.\n");
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_QUIESCENT);
 	}
 }
@@ -3441,7 +3498,8 @@ qla82xx_dev_failed_handler(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Disable the board */
-	qla_printk(KERN_INFO, ha, "Disabling the board\n");
+	ql_log(ql_log_fatal, vha, 0x00b8,
+	    "Disabling the board.\n");
 
 	qla82xx_idc_lock(ha);
 	qla82xx_clear_drv_active(ha);
@@ -3492,8 +3550,8 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 
 	while (drv_state != drv_active) {
 		if (time_after_eq(jiffies, reset_timeout)) {
-			qla_printk(KERN_INFO, ha,
-				"%s: RESET TIMEOUT!\n", QLA2XXX_DRIVER_NAME);
+			ql_log(ql_log_warn, vha, 0x00b5,
+			    "Reset timeout.\n");
 			break;
 		}
 		qla82xx_idc_unlock(ha);
@@ -3504,12 +3562,15 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 	}
 
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-	qla_printk(KERN_INFO, ha, "3:Device state is 0x%x = %s\n", dev_state,
-		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
+	ql_log(ql_log_info, vha, 0x00b6,
+	    "Device state is 0x%x = %s.\n",
+	    dev_state,
+	    dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
 
 	/* Force to DEV_COLD unless someone else is starting a reset */
 	if (dev_state != QLA82XX_DEV_INITIALIZING) {
-		qla_printk(KERN_INFO, ha, "HW State: COLD/RE-INIT\n");
+		ql_log(ql_log_info, vha, 0x00b7,
+		    "HW State: COLD/RE-INIT.\n");
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_COLD);
 	}
 }
@@ -3523,8 +3584,12 @@ qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 	fw_heartbeat_counter = qla82xx_rd_32(vha->hw,
 		QLA82XX_PEG_ALIVE_COUNTER);
 	/* all 0xff, assume AER/EEH in progress, ignore */
-	if (fw_heartbeat_counter == 0xffffffff)
+	if (fw_heartbeat_counter == 0xffffffff) {
+		ql_dbg(ql_dbg_timer, vha, 0x6003,
+		    "FW heartbeat counter is 0xffffffff, "
+		    "returning status=%d.\n", status);
 		return status;
+	}
 	if (vha->fw_heartbeat_counter == fw_heartbeat_counter) {
 		vha->seconds_since_last_heartbeat++;
 		/* FW not alive after 2 seconds */
@@ -3535,6 +3600,9 @@ qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 	} else
 		vha->seconds_since_last_heartbeat = 0;
 	vha->fw_heartbeat_counter = fw_heartbeat_counter;
+	if (status)
+		ql_dbg(ql_dbg_timer, vha, 0x6004,
+		    "Returning status=%d.\n", status);
 	return status;
 }
 
@@ -3565,8 +3633,10 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 	old_dev_state = dev_state;
-	qla_printk(KERN_INFO, ha, "1:Device state is 0x%x = %s\n", dev_state,
-		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
+	ql_log(ql_log_info, vha, 0x009b,
+	    "Device state is 0x%x = %s.\n",
+	    dev_state,
+	    dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
 
 	/* wait for 30 seconds for device to go ready */
 	dev_init_timeout = jiffies + (ha->nx_dev_init_timeout * HZ);
@@ -3574,9 +3644,8 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 	while (1) {
 
 		if (time_after_eq(jiffies, dev_init_timeout)) {
-			DEBUG(qla_printk(KERN_INFO, ha,
-				"%s: device init failed!\n",
-				QLA2XXX_DRIVER_NAME));
+			ql_log(ql_log_fatal, vha, 0x009c,
+			    "Device init failed.\n");
 			rval = QLA_FUNCTION_FAILED;
 			break;
 		}
@@ -3586,10 +3655,11 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			old_dev_state = dev_state;
 		}
 		if (loopcount < 5) {
-			qla_printk(KERN_INFO, ha,
-			    "2:Device state is 0x%x = %s\n", dev_state,
-			    dev_state < MAX_STATES ?
-			    qdev_state[dev_state] : "Unknown");
+			ql_log(ql_log_info, vha, 0x009d,
+			    "Device state is 0x%x = %s.\n",
+			    dev_state,
+			    dev_state < MAX_STATES ? qdev_state[dev_state] :
+			    "Unknown");
 		}
 
 		switch (dev_state) {
@@ -3656,29 +3726,26 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 		if (dev_state == QLA82XX_DEV_NEED_RESET &&
 		    !test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags)) {
-			qla_printk(KERN_WARNING, ha,
-			    "scsi(%ld) %s: Adapter reset needed!\n",
-				vha->host_no, __func__);
+			ql_log(ql_log_warn, vha, 0x6001,
+			    "Adapter reset needed.\n");
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
 			!test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags)) {
-			DEBUG(qla_printk(KERN_INFO, ha,
-				"scsi(%ld) %s - detected quiescence needed\n",
-				vha->host_no, __func__));
+			ql_log(ql_log_warn, vha, 0x6002,
+			    "Quiescent needed.\n");
 			set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else {
 			if (qla82xx_check_fw_alive(vha)) {
 				halt_status = qla82xx_rd_32(ha,
 				    QLA82XX_PEG_HALT_STATUS1);
-				qla_printk(KERN_INFO, ha,
-				    "scsi(%ld): %s, Dumping hw/fw registers:\n "
-				    " PEG_HALT_STATUS1: 0x%x, PEG_HALT_STATUS2: 0x%x,\n "
-				    " PEG_NET_0_PC: 0x%x, PEG_NET_1_PC: 0x%x,\n "
-				    " PEG_NET_2_PC: 0x%x, PEG_NET_3_PC: 0x%x,\n "
-				    " PEG_NET_4_PC: 0x%x\n",
-				    vha->host_no, __func__, halt_status,
+				ql_dbg(ql_dbg_timer, vha, 0x6005,
+				    "dumping hw/fw registers:.\n "
+				    " PEG_HALT_STATUS1: 0x%x, PEG_HALT_STATUS2: 0x%x,.\n "
+				    " PEG_NET_0_PC: 0x%x, PEG_NET_1_PC: 0x%x,.\n "
+				    " PEG_NET_2_PC: 0x%x, PEG_NET_3_PC: 0x%x,.\n "
+				    " PEG_NET_4_PC: 0x%x.\n", halt_status,
 				    qla82xx_rd_32(ha, QLA82XX_PEG_HALT_STATUS2),
 				    qla82xx_rd_32(ha,
 					    QLA82XX_CRB_PEG_NET_0 + 0x3c),
@@ -3694,9 +3761,8 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 					set_bit(ISP_UNRECOVERABLE,
 					    &vha->dpc_flags);
 				} else {
-					qla_printk(KERN_INFO, ha,
-					    "scsi(%ld): %s - detect abort needed\n",
-					    vha->host_no, __func__);
+					ql_log(ql_log_info, vha, 0x6006,
+					    "Detect abort  needed.\n");
 					set_bit(ISP_ABORT_NEEDED,
 					    &vha->dpc_flags);
 				}
@@ -3704,10 +3770,10 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 				ha->flags.isp82xx_fw_hung = 1;
 				if (ha->flags.mbox_busy) {
 					ha->flags.mbox_int = 1;
-					DEBUG2(qla_printk(KERN_ERR, ha,
-					    "scsi(%ld) Due to fw hung, doing "
+					ql_log(ql_log_warn, vha, 0x6007,
+					    "Due to FW hung, doing "
 					    "premature completion of mbx "
-					    "command\n", vha->host_no));
+					    "command.\n");
 					if (test_bit(MBX_INTR_WAIT,
 					    &ha->mbx_cmd_flags))
 						complete(&ha->mbx_intr_comp);
@@ -3742,9 +3808,8 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 	uint32_t dev_state;
 
 	if (vha->device_flags & DFLG_DEV_FAILED) {
-		qla_printk(KERN_WARNING, ha,
-			"%s(%ld): Device in failed state, "
-			"Exiting.\n", __func__, vha->host_no);
+		ql_log(ql_log_warn, vha, 0x8024,
+		    "Device in failed state, exiting.\n");
 		return QLA_SUCCESS;
 	}
 	ha->flags.isp82xx_reset_hdlr_active = 1;
@@ -3752,13 +3817,14 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 	qla82xx_idc_lock(ha);
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
 	if (dev_state == QLA82XX_DEV_READY) {
-		qla_printk(KERN_INFO, ha, "HW State: NEED RESET\n");
+		ql_log(ql_log_info, vha, 0x8025,
+		    "HW State: NEED RESET.\n");
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 			QLA82XX_DEV_NEED_RESET);
 	} else
-		qla_printk(KERN_INFO, ha, "HW State: %s\n",
-			dev_state < MAX_STATES ?
-			qdev_state[dev_state] : "Unknown");
+		ql_log(ql_log_info, vha, 0x8026,
+		    "Hw State: %s.\n", dev_state < MAX_STATES ?
+		    qdev_state[dev_state] : "Unknown");
 	qla82xx_idc_unlock(ha);
 
 	rval = qla82xx_device_state_handler(vha);
@@ -3777,9 +3843,9 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 		vha->flags.online = 1;
 		if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 			if (ha->isp_abort_cnt == 0) {
-				qla_printk(KERN_WARNING, ha,
-				    "ISP error recovery failed - "
-				    "board disabled\n");
+				ql_log(ql_log_warn, vha, 0x8027,
+				    "ISP error recover failed - board "
+				    "disabled.\n");
 				/*
 				 * The next call disables the board
 				 * completely.
@@ -3791,16 +3857,16 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 				rval = QLA_SUCCESS;
 			} else { /* schedule another ISP abort */
 				ha->isp_abort_cnt--;
-				DEBUG(qla_printk(KERN_INFO, ha,
-				    "qla%ld: ISP abort - retry remaining %d\n",
-				    vha->host_no, ha->isp_abort_cnt));
+				ql_log(ql_log_warn, vha, 0x8036,
+				    "ISP abort - retry remaining %d.\n",
+				    ha->isp_abort_cnt);
 				rval = QLA_FUNCTION_FAILED;
 			}
 		} else {
 			ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
-			DEBUG(qla_printk(KERN_INFO, ha,
-			    "(%ld): ISP error recovery - retrying (%d) "
-			    "more times\n", vha->host_no, ha->isp_abort_cnt));
+			ql_dbg(ql_dbg_taskm, vha, 0x8029,
+			    "ISP error recovery - retrying (%d) more times.\n",
+			    ha->isp_abort_cnt);
 			set_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
 			rval = QLA_FUNCTION_FAILED;
 		}
@@ -3872,8 +3938,8 @@ int qla2x00_wait_for_fcoe_ctx_reset(scsi_qla_host_t *vha)
 			break;
 		}
 	}
-	DEBUG2(printk(KERN_INFO
-	    "%s status=%d\n", __func__, status));
+	ql_dbg(ql_dbg_p3p, vha, 0xb027,
+	    "%s status=%d.\n", status);
 
 	return status;
 }
@@ -3902,6 +3968,9 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 			}
 		}
 	}
+	ql_dbg(ql_dbg_init, vha, 0x00b0,
+	    "Entered %s fw_hung=%d.\n",
+	    __func__, ha->flags.isp82xx_fw_hung);
 
 	/* Abort all commands gracefully if fw NOT hung */
 	if (!ha->flags.isp82xx_fw_hung) {
@@ -3922,13 +3991,13 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 						spin_unlock_irqrestore(
 						    &ha->hardware_lock, flags);
 						if (ha->isp_ops->abort_command(sp)) {
-							qla_printk(KERN_INFO, ha,
-							    "scsi(%ld): mbx abort command failed in %s\n",
-							    vha->host_no, __func__);
+							ql_log(ql_log_info, vha,
+							    0x00b1,
+							    "mbx abort failed.\n");
 						} else {
-							qla_printk(KERN_INFO, ha,
-							    "scsi(%ld): mbx abort command success in %s\n",
-							    vha->host_no, __func__);
+							ql_log(ql_log_info, vha,
+							    0x00b2,
+							    "mbx abort success.\n");
 						}
 						spin_lock_irqsave(&ha->hardware_lock, flags);
 					}
@@ -3940,8 +4009,9 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 		/* Wait for pending cmds (physical and virtual) to complete */
 		if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
 		    WAIT_HOST) == QLA_SUCCESS) {
-			DEBUG2(qla_printk(KERN_INFO, ha,
-			    "Done wait for pending commands\n"));
+			ql_dbg(ql_dbg_init, vha, 0x00b3,
+			    "Done wait for "
+			    "pending commands.\n");
 		}
 	}
 }
-- 
1.6.0.2

