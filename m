From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: [PATCH 6/8] pm8001: honor return value
Date: Wed,  9 Jul 2014 17:20:49 +0530
Message-ID: <1404906649-15816-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:49215 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbaGILvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 07:51:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com, rickard_strandqvist@spectrumdigital.se, bgrove@attotech.com, mlombard@redhat.com, thenzl@redhat.com

From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>

The driver ignores the return value in a lot of places, fix
it at least somewhere (and release the resources in such cases),
to avoid that bad things happen.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |   33 ++++++++++++++++++++++-------
 drivers/scsi/pm8001/pm80xx_hwi.c |   42 +++++++++++++++++++++++++++++--------
 2 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b6fa852..cc89d18 100644
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
 
@@ -1778,6 +1780,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 	if (res) {
+		sas_free_task(task);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("cannot allocate tag !!!\n"));
 		return;
@@ -1788,14 +1791,14 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
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
 
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
@@ -1821,7 +1824,11 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
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
@@ -4257,7 +4264,11 @@ static int pm8001_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 	smp_cmd.long_smp_req.long_resp_size =
 		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag, &smp_cmd);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
+					(u32 *)&smp_cmd, 0);
+	if (rc)
+		goto err_out_2;
+
 	return 0;
 
 err_out_2:
@@ -4789,6 +4800,10 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		break;
 	}
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
+	if (rc) {
+		kfree(fw_control_context);
+		pm8001_tag_free(pm8001_ha, tag);
+	}
 	return rc;
 }
 
@@ -5061,7 +5076,7 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 	memset(&payload, 0, sizeof(payload));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		return -1;
+		return -ENOMEM;
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->ccb_tag = tag;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
@@ -5070,6 +5085,8 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 	payload.sata_hol_tmo = cpu_to_le32(80);
 	payload.open_reject_cmdretries_data_retries = cpu_to_le32(0xff00ff);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
 
 }
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index add019b..b06443a 100644
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
@@ -1057,6 +1061,8 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 					KEK_MGMT_SUBOP_KEYCARDUPDATE);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 
 	return rc;
 }
@@ -1381,8 +1387,10 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task->task_done = pm8001_task_done;
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (res) {
+		sas_free_task(task);
 		return;
+	}
 
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
@@ -1397,7 +1405,10 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task_abort.tag = cpu_to_le32(ccb_tag);
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
-
+	if (ret) {
+		sas_free_task(task);
+		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
 }
 
 static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
@@ -1424,6 +1435,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 	if (res) {
+		sas_free_task(task);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("cannot allocate tag !!!\n"));
 		return;
@@ -1434,15 +1446,16 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
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
@@ -1467,7 +1480,11 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
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
@@ -3813,7 +3830,10 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
 				&smp_cmd, pm8001_ha->smp_exp_mode, length);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, (u32 *)&smp_cmd, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
+					(u32 *)&smp_cmd, 0);
+	if (rc)
+		goto err_out_2;
 	return 0;
 
 err_out_2:
@@ -4404,6 +4424,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
 
 	return rc;
 }
@@ -4482,7 +4504,9 @@ void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
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
1.7.1

