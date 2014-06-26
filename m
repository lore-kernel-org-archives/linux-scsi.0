From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/4] pm8001: honor return value
Date: Thu, 26 Jun 2014 17:17:34 +0200
Message-ID: <1403795856-4300-2-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906AbaFZPSE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 11:18:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: AnandKumar.Santhanam@pmcs.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, Tomas Henzl <thenzl@redhat.com>

The driver ignores the return value in a lot of places, fix
it at least somewhere (and release the resources in such cases),
to avoid that bad things happen.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 27 +++++++++++++++++++-------
 drivers/scsi/pm8001/pm80xx_hwi.c | 41 +++++++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 9294379..cacb429 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1346,7 +1346,7 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 		&pMessage) < 0) {
 		PM8001_IO_DBG(pm8001_ha,
 			pm8001_printk("No free mpi buffer\n"));
-		return -1;
+		return -ENOMEM;
 	}
 	BUG_ON(!payload);
 	/*Copy to the payload*/
@@ -1751,6 +1751,8 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task_abort.tag = cpu_to_le32(ccb_tag);
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
+	if (ret)
+		pm8001_tag_free(pm8001_ha, ccb_tag);
 
 }
 
@@ -1792,10 +1794,9 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 			pm8001_printk("Domain device cannot be allocated\n"));
 		sas_free_task(task);
 		return;
-	} else {
-		task->dev = dev;
-		task->dev->lldd_dev = pm8001_ha_dev;
 	}
+	task->dev = dev;
+	task->dev->lldd_dev = pm8001_ha_dev;
 
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
@@ -1821,7 +1822,10 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
-
+	if (res) {
+		sas_free_task(task);
+		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
 }
 
 /**
@@ -4257,7 +4261,10 @@ static int pm8001_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 	smp_cmd.long_smp_req.long_resp_size =
 		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag, &smp_cmd);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
+	if (rc)
+		goto err_out_2;
+
 	return 0;
 
 err_out_2:
@@ -4789,6 +4796,10 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		break;
 	}
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
+	if (rc) {
+		kfree(fw_control_context);
+		pm8001_tag_free(pm8001_ha, tag);
+	}
 	return rc;
 }
 
@@ -5061,7 +5072,7 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 	memset(&payload, 0, sizeof(payload));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		return -1;
+		return -ENOMEM;
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->ccb_tag = tag;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -5070,6 +5081,8 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 	payload.sata_hol_tmo = cpu_to_le32(80);
 	payload.open_reject_cmdretries_data_retries = cpu_to_le32(0xff00ff);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
 
 }
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d70587f..d392e7a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -856,6 +856,8 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 	payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
 
 }
@@ -936,6 +938,8 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
 			 sizeof(SASProtocolTimerConfig_t));
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 
 	return rc;
 }
@@ -1059,6 +1063,8 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 					KEK_MGMT_SUBOP_KEYCARDUPDATE);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 
 	return rc;
 }
@@ -1383,8 +1389,10 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task->task_done = pm8001_task_done;
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (res) {
+		sas_free_task(task);
 		return;
+	}
 
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
@@ -1399,7 +1407,10 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task_abort.tag = cpu_to_le32(ccb_tag);
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
-
+	if (ret) {
+		sas_free_task(task);
+		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
 }
 
 static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
@@ -1426,6 +1437,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 	if (res) {
+		sas_free_task(task);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("cannot allocate tag !!!\n"));
 		return;
@@ -1436,15 +1448,16 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	*/
 	dev = kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
 	if (!dev) {
+		sas_free_task(task);
+		pm8001_tag_free(pm8001_ha, ccb_tag);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Domain device cannot be allocated\n"));
-		sas_free_task(task);
 		return;
-	} else {
-		task->dev = dev;
-		task->dev->lldd_dev = pm8001_ha_dev;
 	}
 
+	task->dev = dev;
+	task->dev->lldd_dev = pm8001_ha_dev;
+
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
@@ -1469,7 +1482,11 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
 	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
-
+	if (res) {
+		sas_free_task(task);
+		pm8001_tag_free(pm8001_ha, ccb_tag);
+		kfree(dev);
+	}
 }
 
 /**
@@ -3815,7 +3832,9 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
 				&smp_cmd, pm8001_ha->smp_exp_mode, length);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
+	if (rc)
+		goto err_out_2;
 	return 0;
 
 err_out_2:
@@ -4406,6 +4425,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 
 	return rc;
 }
@@ -4484,7 +4505,9 @@ void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 		payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
 		j++;
 	}
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 }
 
 void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
-- 
1.8.3.1

