Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DB1C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7814C206DC
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfKNKIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:08:46 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:37004 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfKNKIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:08:45 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: G2ZNYZDIdgHQSaMIbk0cdCx3hT5SAOB7bfmh3ktFGVgJIOzq50ek9LUZa2VQpiugCIPnjrkI6M
 A5DMMghY09HAbJOAakRlSWpgikOz8Z1RGTfLNhAIT5cPJnlAwHftRQl//PtzRk2pkxFa/hslOS
 C2QXe5rapQvdT162Hs0jgI6WOOd4oMCs1OYF1mAPXUyn6bw/SOoLRdT09hEYBB16+fx1P4XK3L
 pItebumLbJz9fHdyXnOFBmeTTlhiLYeDr67R3SGX+6TkyD3ABqRWcG7qkuJPCwiut3JT3AIL4E
 3yY=
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="55582493"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2019 03:08:45 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 14 Nov
 2019 02:08:44 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 14 Nov
 2019 02:08:43 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH V2 08/13] pm80xx : Fix command issue sizing.
Date:   Thu, 14 Nov 2019 15:39:05 +0530
Message-ID: <20191114100910.6153-9-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191114100910.6153-1-deepak.ukey@microchip.com>
References: <20191114100910.6153-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: peter chang <dpf@google.com>

The commands to the controller are sent in fixed sized chunks which are
set per-chip-generation and stashed in iomb_size. The driver fills in
structs matching the register layout and memcpy this to memory shared
with the controller. however, there are two problem cases:
	1)Things like phy_start_req are too large because they share the
	sas_identify_frame definition with libsas, and it includes the
	crc word. this means that it's overwriting the start of the next
	command block, that's ok except if it happens at the end of the
	shared memory area.
	2)Things like set_nvm_data_req which are shared between the HAL
	layers. this means that it's sending 'random' data for things
	that are in the reserved area. so far we haven't found a case
	where the controller FW cares, but sending possible gibberish
	(for most of the structures this is in the reserved area so
	previously zeroed) is not recommended.

Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 69 ++++++++++++++++++++++++++--------------
 drivers/scsi/pm8001/pm8001_sas.h |  3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 47 +++++++++++++++++----------
 3 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2c1c722eca17..1cbcade747fe 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1336,10 +1336,13 @@ int pm8001_mpi_msg_free_get(struct inbound_queue_table *circularQ,
  * @circularQ: the inbound queue we want to transfer to HBA.
  * @opCode: the operation code represents commands which LLDD and fw recognized.
  * @payload: the command payload of each operation command.
+ * @nb: size in bytes of the command payload
+ * @responseQueue: queue to interrupt on w/ command response (if any)
  */
 int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 			 struct inbound_queue_table *circularQ,
-			 u32 opCode, void *payload, u32 responseQueue)
+			 u32 opCode, void *payload, size_t nb,
+			 u32 responseQueue)
 {
 	u32 Header = 0, hpriority = 0, bc = 1, category = 0x02;
 	void *pMessage;
@@ -1350,10 +1353,13 @@ int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 			pm8001_printk("No free mpi buffer\n"));
 		return -ENOMEM;
 	}
-	BUG_ON(!payload);
-	/*Copy to the payload*/
-	memcpy(pMessage, payload, (pm8001_ha->iomb_size -
-				sizeof(struct mpi_msg_hdr)));
+
+	if (nb > (pm8001_ha->iomb_size - sizeof(struct mpi_msg_hdr)))
+		nb = pm8001_ha->iomb_size - sizeof(struct mpi_msg_hdr);
+	memcpy(pMessage, payload, nb);
+	if (nb + sizeof(struct mpi_msg_hdr) < pm8001_ha->iomb_size)
+		memset(pMessage + nb, 0, pm8001_ha->iomb_size -
+				(nb + sizeof(struct mpi_msg_hdr)));
 
 	/*Build the header*/
 	Header = ((1 << 31) | (hpriority << 30) | ((bc & 0x1f) << 24)
@@ -1763,7 +1769,8 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	task_abort.tag = cpu_to_le32(ccb_tag);
 
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
+			sizeof(task_abort), 0);
 	if (ret)
 		pm8001_tag_free(pm8001_ha, ccb_tag);
 
@@ -1836,7 +1843,8 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	sata_cmd.ncqtag_atap_dir_m |= ((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
-	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
+	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
+			sizeof(sata_cmd), 0);
 	if (res) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
@@ -3375,7 +3383,8 @@ static void pm8001_hw_event_ack_req(struct pm8001_hba_info *pm8001_ha,
 		((phyId & 0x0F) << 4) | (port_id & 0x0F));
 	payload.param0 = cpu_to_le32(param0);
 	payload.param1 = cpu_to_le32(param1);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 }
 
 static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
@@ -4305,7 +4314,7 @@ static int pm8001_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 		cpu_to_le32((u32)sg_dma_len(&task->smp_task.smp_resp)-4);
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag, &smp_cmd);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-					(u32 *)&smp_cmd, 0);
+			&smp_cmd, sizeof(smp_cmd), 0);
 	if (rc)
 		goto err_out_2;
 
@@ -4373,7 +4382,8 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		ssp_cmd.len = cpu_to_le32(task->total_xfer_len);
 		ssp_cmd.esgl = 0;
 	}
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd,
+			sizeof(ssp_cmd), 0);
 	return ret;
 }
 
@@ -4482,7 +4492,8 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 		}
 	}
 
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
+			sizeof(sata_cmd), 0);
 	return ret;
 }
 
@@ -4517,7 +4528,8 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 	memcpy(payload.sas_identify.sas_addr,
 		pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -4539,7 +4551,8 @@ static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -4598,7 +4611,8 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		cpu_to_le32(ITNT | (firstBurstSize * 0x10000));
 	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	return rc;
 }
 
@@ -4619,7 +4633,8 @@ int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	payload.device_id = cpu_to_le32(device_id);
 	PM8001_MSG_DBG(pm8001_ha,
 		pm8001_printk("unregister device device_id = %d\n", device_id));
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -4642,7 +4657,8 @@ static int pm8001_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(1);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xff) << 8) | (phyId & 0x0F));
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -4696,7 +4712,8 @@ static int send_task_abort(struct pm8001_hba_info *pm8001_ha, u32 opc,
 		task_abort.device_id = cpu_to_le32(dev_id);
 		task_abort.tag = cpu_to_le32(cmd_tag);
 	}
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
+			sizeof(task_abort), 0);
 	return ret;
 }
 
@@ -4753,7 +4770,8 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
 	if (pm8001_ha->chip_id != chip_8001)
 		sspTMCmd.ds_ads_m = 0x08;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd,
+			sizeof(sspTMCmd), 0);
 	return ret;
 }
 
@@ -4843,7 +4861,8 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	default:
 		break;
 	}
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req,
+			sizeof(nvmd_req), 0);
 	if (rc) {
 		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
@@ -4927,7 +4946,8 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	default:
 		break;
 	}
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &nvmd_req,
+			sizeof(nvmd_req), 0);
 	if (rc) {
 		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
@@ -4962,7 +4982,8 @@ pm8001_chip_fw_flash_update_build(struct pm8001_hba_info *pm8001_ha,
 		cpu_to_le32(lower_32_bits(le64_to_cpu(info->sgl.addr)));
 	payload.sgl_addr_hi =
 		cpu_to_le32(upper_32_bits(le64_to_cpu(info->sgl.addr)));
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -5109,7 +5130,8 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.device_id = cpu_to_le32(pm8001_dev->device_id);
 	payload.nds = cpu_to_le32(state);
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	return rc;
 
 }
@@ -5134,7 +5156,8 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 	payload.SSAHOLT = cpu_to_le32(0xd << 25);
 	payload.sata_hol_tmo = cpu_to_le32(80);
 	payload.open_reject_cmdretries_data_retries = cpu_to_le32(0xff00ff);
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 9e0da7bccb45..d64883b80da9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -674,7 +674,8 @@ int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
 void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha);
 int pm8001_mpi_build_cmd(struct pm8001_hba_info *pm8001_ha,
 			struct inbound_queue_table *circularQ,
-			u32 opCode, void *payload, u32 responseQueue);
+			u32 opCode, void *payload, size_t nb,
+			u32 responseQueue);
 int pm8001_mpi_msg_free_get(struct inbound_queue_table *circularQ,
 				u16 messageSize, void **messagePtr);
 u32 pm8001_mpi_msg_free_set(struct pm8001_hba_info *pm8001_ha, void *pMsg,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9d04e5cfffb4..09008db2efdc 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -955,7 +955,8 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 		"Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
 		payload.cfg_pg[0], payload.cfg_pg[1]));
 
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 	return rc;
@@ -1037,7 +1038,8 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_hba_info *pm8001_ha)
 	memcpy(&payload.cfg_pg, &SASConfigPage,
 			 sizeof(SASProtocolTimerConfig_t));
 
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 
@@ -1164,7 +1166,8 @@ static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
 		"Saving Encryption info to flash. payload 0x%x\n",
 		payload.new_curidx_ksop));
 
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 
@@ -1517,7 +1520,10 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
 	task_abort.tag = cpu_to_le32(ccb_tag);
 
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
+			sizeof(task_abort), 0);
+	PM8001_FAIL_DBG(pm8001_ha,
+		pm8001_printk("Executing abort task end\n"));
 	if (ret) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
@@ -1593,7 +1599,9 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	sata_cmd.ncqtag_atap_dir_m_dad |= ((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
 
-	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd, 0);
+	res = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
+			sizeof(sata_cmd), 0);
+	PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Executing read log end\n"));
 	if (res) {
 		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
@@ -2962,7 +2970,8 @@ static void pm80xx_hw_event_ack_req(struct pm8001_hba_info *pm8001_ha,
 		((phyId & 0xFF) << 24) | (port_id & 0xFF));
 	payload.param0 = cpu_to_le32(param0);
 	payload.param1 = cpu_to_le32(param1);
-	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 }
 
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
@@ -4082,8 +4091,8 @@ static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
 
 	build_smp_cmd(pm8001_dev->device_id, smp_cmd.tag,
 				&smp_cmd, pm8001_ha->smp_exp_mode, length);
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-					(u32 *)&smp_cmd, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &smp_cmd,
+			sizeof(smp_cmd), 0);
 	if (rc)
 		goto err_out_2;
 	return 0;
@@ -4291,7 +4300,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	q_index = (u32) (pm8001_dev->id & 0x00ffffff) % PM8001_MAX_OUTB_NUM;
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-						&ssp_cmd, q_index);
+			&ssp_cmd, sizeof(ssp_cmd), q_index);
 	return ret;
 }
 
@@ -4532,7 +4541,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	}
 	q_index = (u32) (pm8001_ha_dev->id & 0x00ffffff) % PM8001_MAX_OUTB_NUM;
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-						&sata_cmd, q_index);
+			&sata_cmd, sizeof(sata_cmd), q_index);
 	return ret;
 }
 
@@ -4587,7 +4596,8 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 	memcpy(payload.sas_identify.sas_addr,
 	  &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -4609,7 +4619,8 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload, 0);
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
+			sizeof(payload), 0);
 	return ret;
 }
 
@@ -4675,7 +4686,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	memcpy(payload.sas_addr, pm8001_dev->sas_device->sas_addr,
 		SAS_ADDR_SIZE);
 
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 
@@ -4705,7 +4717,8 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 }
 
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
@@ -4763,7 +4776,8 @@ void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 		payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
 		j++;
 	}
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 }
@@ -4805,7 +4819,8 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
 	for (i = 0; i < length; i++)
 		payload.reserved[i] = cpu_to_le32(*(buf + i));
 
-	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
 	if (rc)
 		pm8001_tag_free(pm8001_ha, tag);
 
-- 
2.16.3

