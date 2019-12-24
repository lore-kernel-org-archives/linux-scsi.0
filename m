Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61418C2D0D2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22B4D206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfLXElX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:23 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:31035 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLXElX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:23 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa6.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa6.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: Wam8A1OV37cK9xqzELV+4xuWVkLCB+8iy27AjUsask4Hmj99rtvcABcpGi5gKcNdf1OtmUuM8t
 T/b6XYaVFBngzfVHA1yMuvL/BnbivNMuNxt0HMhVpToBwjxA2z79TFZzfrOhKM18XaSCwdCkpU
 pKfizd7LHsD9x+YQY7h+jrq0eEPikbyXylNTgv3n5/rlZd2MvxWxFUOC+CXOmwjsX7n2oD2P4n
 hY0OHEdkUBWuQvnAwsJa3cH5V8Fo9b4WUO/DaampLhlnM2lVGlP6KZJLRw9vW+qAYG25zqjIIn
 RVw=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="58809224"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:41:15 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:41:15 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:41:14 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 09/12] pm80xx : IOCTL functionality for SGPIO.
Date:   Tue, 24 Dec 2019 10:11:40 +0530
Message-ID: <20191224044143.8178-10-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191224044143.8178-1-deepak.ukey@microchip.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <Deepak.Ukey@microchip.com>

Added the IOCTL functionality for SGPIO.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Yu Zheng <yuuzheng@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  |  73 ++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |  72 ++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  | 172 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.h  |  17 ++++
 drivers/scsi/pm8001/pm8001_init.c |   3 +
 drivers/scsi/pm8001/pm8001_sas.c  |  37 ++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  20 +++++
 drivers/scsi/pm8001/pm80xx_hwi.c  |   6 ++
 drivers/scsi/pm8001/pm80xx_hwi.h  |   3 +
 9 files changed, 402 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 8292074c1e6f..3e59b2a7185a 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1009,6 +1009,76 @@ static long pm8001_gpio_ioctl(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
+static long pm8001_sgpio_ioctl(struct pm8001_hba_info *pm8001_ha,
+		unsigned long arg)
+{
+	struct sgpio_buffer buffer;
+	struct read_write_req_resp *req = &buffer.sgpio_req;
+	struct sgpio_req payload;
+	struct sgpio_ioctl_resp *sgpio_resp;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	unsigned long timeout;
+	u32 ret = 0, i;
+
+	if (copy_from_user(&buffer, (struct sgpio_buffer *)arg,
+		sizeof(struct sgpio_buffer))) {
+		return ADPT_IOCTL_CALL_FAILED;
+	}
+	mutex_lock(&pm8001_ha->ioctl_mutex);
+	pm8001_ha->ioctl_completion = &completion;
+
+	payload.func_reg_index = cpu_to_le32((req->register_index << 24) |
+			(req->register_type << 16) | (req->function << 8) |
+			SMP_FRAME_REQ);
+	payload.count = req->register_count;
+
+	if (req->function == WRITE_SGPIO_REGISTER) {
+		if (req->register_count > MAX_SGPIO_REQ_PAYLOAD) {
+			ret = ADPT_IOCTL_CALL_FAILED;
+			goto exit;
+		}
+		for (i = 0; i < req->register_count; i++)
+			payload.value[i] = req->read_write_data[i];
+	}
+
+	ret = PM8001_CHIP_DISP->sgpio_req(pm8001_ha, &payload);
+	if (ret != 0) {
+		ret = ADPT_IOCTL_CALL_FAILED;
+		goto exit;
+	}
+	if (timeout < 2000)
+		timeout = 2000;
+
+	timeout = wait_for_completion_timeout(&completion,
+			msecs_to_jiffies(timeout));
+	if (timeout == 0) {
+		ret = ADPT_IOCTL_CALL_TIMEOUT;
+		goto exit;
+	}
+
+	sgpio_resp = &pm8001_ha->sgpio_resp;
+	req->frame_type		= sgpio_resp->func_result & 0xff;
+	req->function		= (sgpio_resp->func_result >> 8) & 0xff;
+	req->function_result	= (sgpio_resp->func_result >> 16) & 0xff;
+	if (req->function == READ_SGPIO_REGISTER) {
+		for (i = 0; i < req->register_count; i++)
+			req->read_write_data[i] = sgpio_resp->value[i];
+	}
+	ret = ADPT_IOCTL_CALL_SUCCESS;
+exit:
+	spin_lock_irq(&pm8001_ha->ioctl_lock);
+	pm8001_ha->ioctl_completion = NULL;
+	spin_unlock_irq(&pm8001_ha->ioctl_lock);
+	buffer.header.return_code = ret;
+	if (copy_to_user((void *)arg, (void *)&buffer,
+			sizeof(struct sgpio_buffer))) {
+		ret = ADPT_IOCTL_CALL_FAILED;
+	}
+	mutex_unlock(&pm8001_ha->ioctl_mutex);
+
+	return ret;
+}
+
 static int pm8001_ioctl_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
 		unsigned long arg)
 {
@@ -1172,6 +1242,9 @@ static long pm8001_ioctl(struct file *file,
 	case ADPT_IOCTL_GPIO:
 		ret = pm8001_gpio_ioctl(pm8001_ha, arg);
 		break;
+	case ADPT_IOCTL_SGPIO:
+		ret = pm8001_sgpio_ioctl(pm8001_ha, arg);
+		break;
 	case ADPT_IOCTL_GET_PHY_PROFILE:
 		ret = pm8001_ioctl_get_phy_profile(pm8001_ha, arg);
 		return ret;
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index 5be43b2672d4..b1be0bc065d5 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -68,6 +68,39 @@
 
 #define MAX_NUM_PHYS			16
 
+/************************************************************
+ * SGPIO Function and Register type
+ ************************************************************/
+#define READ_SGPIO_REGISTER			0x02
+#define WRITE_SGPIO_REGISTER			0x82
+
+#define SMP_FRAME_REQ				0x40
+#define SMP_FRAME_RESP				0x41
+
+#define SGPIO_CONFIG_REG			0x0
+#define SGPIO_DRIVE_BY_DRIVE_RECEIVE_REG	0x1
+#define SGPIO_GENERAL_PURPOSE_RECEIVE_REG	0x2
+#define SGPIO_DRIVE_BY_DRIVE_TRANSMIT_REG	0x3
+#define SGPIO_GENERAL_PURPOSE_TRANSMIT_REG	0x4
+
+/************************************************************
+ * SGPIO Function result
+ ************************************************************/
+#define SGPIO_COMMAND_SUCCESS				0x00
+#define SGPIO_CMD_ERROR_WRONG_FRAME_TYPE		0x01
+#define SGPIO_CMD_ERROR_WRONG_REG_TYPE			0x02
+#define SGPIO_CMD_ERROR_WRONG_REG_INDEX			0x03
+#define SGPIO_CMD_ERROR_WRONG_REG_COUNT			0x04
+#define SGPIO_CMD_ERROR_WRONG_FRAME_REG_TYPE		0x05
+#define SGPIO_CMD_ERROR_WRONG_FUNCTION			0x06
+#define SGPIO_CMD_ERROR_WRONG_FRAME_TYPE_REG_INDEX	0x19
+#define SGPIO_CMD_ERROR_WRONG_FRAME_TYPE_REG_CNT	0x81
+#define SGPIO_CMD_ERROR_WRONG_REG_TYPE_REG_INDEX	0x1A
+#define SGPIO_CMD_ERROR_WRONG_REG_TYPE_REG_COUNT	0x82
+#define SGPIO_CMD_ERROR_WRONG_REG_INDEX_REG_COUNT	0x83
+#define SGPIO_CMD_ERROR_WRONG_FRAME_REG_TYPE_REG_INDEX	0x1D
+#define SGPIO_CMD_ERROR_WRONG_ALL_HEADER_PARAMS		0x9D
+
 struct ioctl_header {
 	u32 io_controller_num;
 	u32 length;
@@ -104,6 +137,39 @@ struct pm8001_gpio {
 	u32	event_falling_edge;
 };
 
+#define MAX_SGPIO_REQ_PAYLOAD	12
+#define MAX_SGPIO_RESP_PAYLOAD	13
+
+struct read_write_req_resp {
+	u8	frame_type;	/* =0x40 */
+	u8	function;	/* 0x02 for read, 0x82 for write */
+	u8	register_type;
+	u8	register_index;
+	u8	register_count;
+	u8	function_result;
+	u32	read_write_data[MAX_SGPIO_RESP_PAYLOAD];
+};
+
+struct sgpio_cfg_0 {
+	u8	reserved;
+	u8	version:4;
+	u8	reserved1:4;
+	u8	gp_register_count:4;
+	u8	cfg_register_count:3;
+	u8	enable:1;
+	u8	supported_drive_cnt;
+};
+
+struct sgpio_cfg_1 {
+	u8	reserved;
+	u8	blink_gen_a:4;
+	u8	blink_gen_b:4;
+	u8	max_act_on:4;
+	u8	forced_act_off:4;
+	u8	stretch_act_on:4;
+	u8	stretch_act_off:4;
+};
+
 struct ioctl_info_buffer {
 	struct ioctl_header	header;
 	struct ioctl_drv_info	information;
@@ -114,6 +180,11 @@ struct gpio_buffer {
 	struct pm8001_gpio	gpio_payload;
 };
 
+struct sgpio_buffer {
+	struct ioctl_header		header;
+	struct read_write_req_resp	sgpio_req;
+};
+
 struct phy_profile {
 	char		phy_id;
 	unsigned int	phys:4;
@@ -143,6 +214,7 @@ struct phy_prof_resp {
 
 #define ADPT_IOCTL_INFO _IOR(ADPT_MAGIC_NUMBER, 0, struct ioctl_info_buffer *)
 #define ADPT_IOCTL_GPIO	_IOWR(ADPT_MAGIC_NUMBER, 1, struct  gpio_buffer *)
+#define ADPT_IOCTL_SGPIO _IOWR(ADPT_MAGIC_NUMBER, 2, struct sgpio_buffer *)
 #define ADPT_IOCTL_GET_PHY_PROFILE _IOWR(ADPT_MAGIC_NUMBER, 8, \
 		struct phy_profile*)
 #define ADPT_IOCTL_GET_PHY_ERR_CNT _IOWR(ADPT_MAGIC_NUMBER, 9, \
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2328ff1349ac..f9395d9fd530 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3666,6 +3666,49 @@ int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	return 0;
 }
 
+/**
+ *pm8001_sgpio_resp - pm8001 SGPIO response
+ *@pm8001_ha: HBA controller information
+ *@piomb: SGPIO payload
+ *Handles SGPIO response from HBA.
+ */
+
+int pm8001_sgpio_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
+{
+	u32 func_result;
+	u32 tag, i;
+	u32 value;
+	struct sgpio_ioctl_resp *sgpio_resp;
+	struct sgpio_reg_resp *registerRespPayload =
+		(struct sgpio_reg_resp *)(piomb + 4);
+
+	tag = le32_to_cpu(registerRespPayload->tag);
+	func_result = le32_to_cpu(registerRespPayload->func_result);
+	value = le32_to_cpu(registerRespPayload->value[0]);
+
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
+		"SGPIO func result = 0x%x tag %x value %x\n",
+		func_result, tag, value));
+
+	spin_lock(&pm8001_ha->ioctl_lock);
+	if (pm8001_ha->ioctl_completion != NULL) {
+		sgpio_resp = &pm8001_ha->sgpio_resp;
+		sgpio_resp->func_result = func_result;
+		PM8001_MSG_DBG(pm8001_ha,
+			pm8001_printk("SGPIO response value hexdump\n"));
+		for (i = 0; i < MAX_SGPIO_RESP_PAYLOAD; i++) {
+			sgpio_resp->value[i] =
+				le32_to_cpu(registerRespPayload->value[i]);
+			PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
+				"value[%d] = %08x\n", i, sgpio_resp->value[i]));
+		}
+		complete(pm8001_ha->ioctl_completion);
+	}
+	spin_unlock(&pm8001_ha->ioctl_lock);
+	pm8001_tag_free(pm8001_ha, tag);
+	return 0;
+}
+
 /**
  * fw_flash_update_resp - Response from FW for flash update command.
  * @pm8001_ha: our hba card information
@@ -4035,7 +4078,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
 	__le32 pHeader = *(__le32 *)piomb;
-	u8 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
+	u16 opc = (u8)((le32_to_cpu(pHeader)) & 0xFFF);
 
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("process_one_iomb:"));
 
@@ -4190,6 +4233,11 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("OPC_OUB_SAS_RE_INITIALIZE\n"));
 		break;
+	case OPC_OUB_SGPIO_RESP:
+		PM8001_MSG_DBG(pm8001_ha,
+			pm8001_printk("OPC_OUB_SGPIO RESPONSE\n"));
+		pm8001_sgpio_resp(pm8001_ha, piomb);
+		break;
 	default:
 		PM8001_DEVIO_DBG(pm8001_ha,
 			pm8001_printk("Unknown outbound Queue IOMB OPC = %x\n",
@@ -5136,6 +5184,88 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 
 }
 
+/**
+ *pm8001_setup_sgpio - Setup SGPIO configuration for SPC/SPCv controllers
+ *pm8001_ha - controller information
+ */
+int pm8001_setup_sgpio(struct pm8001_hba_info *pm8001_ha)
+{
+	struct sgpio_req payload;
+	struct sgpio_cfg_0 *cfg_0;
+	struct sgpio_cfg_1 *cfg_1;
+	int rc, index = 0, i;
+	u32 value = 0;
+	DECLARE_COMPLETION_ONSTACK(completion);
+
+	pm8001_ha->ioctl_completion = &completion;
+	payload.func_reg_index = ((index << 24) | (SGPIO_CONFIG_REG << 16)
+			| (WRITE_SGPIO_REGISTER << 8) | SMP_FRAME_REQ);
+	payload.count = 2;
+
+	cfg_0 = (struct sgpio_cfg_0 *)(&value);
+	cfg_0->enable = 0x1;
+	payload.value[0] = value;
+
+	/*Initialize GPIO CFG 1 register to default as per SFF-8485 spec*/
+	cfg_1 = (struct sgpio_cfg_1 *)(&value);
+	cfg_1->blink_gen_a	= 0;
+	cfg_1->blink_gen_b	= 0;
+	cfg_1->max_act_on	= 0x2;
+	cfg_1->forced_act_off	= 0x1;
+	cfg_1->stretch_act_on	= 0;
+	cfg_1->stretch_act_off	= 0;
+
+	payload.value[1] = value;
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("Setting up sgpio. index %x count %x\n",
+		payload.func_reg_index, payload.count));
+
+	mutex_lock(&pm8001_ha->ioctl_mutex);
+	pm8001_ha->ioctl_completion = &completion;
+	rc = PM8001_CHIP_DISP->sgpio_req(pm8001_ha, &payload);
+	if (rc) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("failed sgpio_req:%d\n", rc));
+		goto exit;
+	}
+	rc = wait_for_completion_timeout(&completion, msecs_to_jiffies(2000));
+	if (rc == 0) {
+		PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("failed sgpio_req timeout\n"));
+		rc = ADPT_IOCTL_CALL_TIMEOUT;
+		goto exit;
+	}
+	payload.func_reg_index = ((index << 24) |
+			(SGPIO_DRIVE_BY_DRIVE_TRANSMIT_REG << 16) |
+			(WRITE_SGPIO_REGISTER << 8) | SMP_FRAME_REQ);
+	payload.count = pm8001_ha->chip->n_phy/4;
+	value = 0xA0A0A0A0; //Activity=0x5, Locate=0, Error=0
+	for (i = 0; i < payload.count; i++)
+		payload.value[i] = value;
+	reinit_completion(&completion);
+	pm8001_ha->ioctl_completion = &completion;
+	rc = PM8001_CHIP_DISP->sgpio_req(pm8001_ha, &payload);
+	if (rc) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("failed sgpio_req:%d\n", rc));
+		goto exit;
+	}
+	rc = wait_for_completion_timeout(&completion, msecs_to_jiffies(2000));
+	if (rc == 0) {
+		PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("failed sgpio_req timeout\n"));
+		rc = ADPT_IOCTL_CALL_TIMEOUT;
+		goto exit;
+	}
+
+exit:
+	spin_lock(&pm8001_ha->ioctl_lock);
+	pm8001_ha->ioctl_completion = NULL;
+	spin_unlock(&pm8001_ha->ioctl_lock);
+	mutex_unlock(&pm8001_ha->ioctl_mutex);
+	return rc;
+}
+
 static int
 pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 {
@@ -5164,6 +5294,45 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
 
 }
 
+/**
+ * pm8001_chip_sgpio_req - support for SGPIO operation
+ * @pm8001_ha: our hba card information.
+ * @ioctl_payload: the payload for the SGPIO operation
+ */
+int pm8001_chip_sgpio_req(struct pm8001_hba_info *pm8001_ha,
+				struct sgpio_req *sgpio_payload)
+{
+	struct sgpio_reg_req payload;
+	struct inbound_queue_table *circularQ;
+	int rc, i;
+	u32 tag;
+	u32 opc = OPC_INB_SGPIO_REG;
+
+	memset(&payload, 0, sizeof(struct sgpio_reg_req));
+	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (rc)
+		return -1;
+
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+	payload.tag = cpu_to_le32(tag);
+	payload.func_reg_index = cpu_to_le32(sgpio_payload->func_reg_index);
+	payload.count = cpu_to_le32(sgpio_payload->count);
+
+	for (i = 0; i < sgpio_payload->count; i++)
+		payload.value[i] = cpu_to_le32(sgpio_payload->value[i]);
+
+	PM8001_MSG_DBG(pm8001_ha,
+		pm8001_printk("sgpio operation. tag %x index %x count %x\n",
+		tag, sgpio_payload->func_reg_index, sgpio_payload->count));
+
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
+	if (rc != 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return rc;
+}
+
 const struct pm8001_dispatch pm8001_8001_dispatch = {
 	.name			= "pmc8001",
 	.chip_init		= pm8001_chip_init,
@@ -5191,4 +5360,5 @@ const struct pm8001_dispatch pm8001_8001_dispatch = {
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
 	.sas_re_init_req	= pm8001_chip_sas_re_initialization,
+	.sgpio_req		= pm8001_chip_sgpio_req,
 };
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 6d91e2446542..aad2322467d2 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -82,6 +82,7 @@
 #define OPC_INB_GET_DEVICE_STATE		43	/* 0x02B */
 #define OPC_INB_SET_DEV_INFO			44	/* 0x02C */
 #define OPC_INB_SAS_RE_INITIALIZE		45	/* 0x02D */
+#define OPC_INB_SGPIO_REG			46	/* 0x02E */
 
 /* for Response Opcode of IOMB */
 #define OPC_OUB_ECHO				1	/* 0x001 */
@@ -120,6 +121,7 @@
 #define OPC_OUB_GET_DEVICE_STATE		39	/* 0x027 */
 #define OPC_OUB_SET_DEV_INFO			40	/* 0x028 */
 #define OPC_OUB_SAS_RE_INITIALIZE		41	/* 0x029 */
+#define OPC_OUB_SGPIO_RESP			2094	/* 0x82E */
 
 /* for phy start*/
 #define SPINHOLD_DISABLE		(0x00 << 14)
@@ -697,6 +699,18 @@ struct set_dev_state_resp {
 	u32		reserved[11];
 } __attribute__((packed, aligned(4)));
 
+struct sgpio_reg_req {
+	__le32		tag;
+	__le32		func_reg_index;
+	__le32		count;
+	__le32		value[12];
+} __packed __aligned(4);
+
+struct sgpio_reg_resp {
+	__le32		tag;
+	__le32		func_result;
+	__le32		value[13];
+} __packed __aligned(4);
 
 #define NDS_BITS 0x0F
 #define PDS_BITS 0xF0
@@ -922,6 +936,9 @@ struct set_dev_state_resp {
 #define MAIN_HDA_FLAGS_OFFSET		0x84/* DWORD 0x21 */
 #define MAIN_ANALOG_SETUP_OFFSET	0x88/* DWORD 0x22 */
 
+/*FATAL ERROR INTERRUPT bit definition*/
+#define MAIN_CFG_SGPIO_ENABLE		(0x1 << 2)
+
 /* Gereral Status Table offset - byte offset */
 #define GST_GSTLEN_MPIS_OFFSET		0x00
 #define GST_IQ_FREEZE_STATE0_OFFSET	0x04
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 6e2512aa5f6e..c8414f1b9652 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -122,6 +122,7 @@ static struct sas_domain_function_template pm8001_transport_ops = {
 	.lldd_I_T_nexus_reset   = pm8001_I_T_nexus_reset,
 	.lldd_lu_reset		= pm8001_lu_reset,
 	.lldd_query_task	= pm8001_query_task,
+	.lldd_write_gpio	= pm8001_write_sgpio,
 };
 
 /**
@@ -1110,6 +1111,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	if (pm8001_configure_phy_settings(pm8001_ha))
 		goto err_out_shost;
 
+	pm8001_setup_sgpio(pm8001_ha);
+
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc) {
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b7cbc312843e..1d03c62d8c99 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1361,3 +1361,40 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
 
+int pm8001_write_sgpio(struct sas_ha_struct *sas_ha, u8 reg_type,
+			u8 reg_index, u8 reg_count, u8 *write_data)
+{
+	struct pm8001_hba_info *pm8001_ha = sas_ha->lldd_ha;
+	struct sgpio_req payload;
+	u32 ret = 0, i, j, value;
+
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
+		"reg_type=%x, reg_index:%x, reg_count:%x\n",
+		reg_type, reg_index, reg_count));
+
+	mutex_lock(&pm8001_ha->ioctl_mutex);
+
+	payload.func_reg_index = cpu_to_le32((reg_index << 24) |
+		(reg_type << 16) | (WRITE_SGPIO_REGISTER << 8) |
+		SMP_FRAME_REQ);
+
+	payload.count = reg_count;
+
+	for (i = 0; i < reg_count; i++) {
+		value = 0;
+		for (j = 0; j < 4; j++) {
+			value |= (u32)(*write_data) << (24-(j*8));
+			write_data++;
+		}
+		payload.value[i] = value;
+		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
+			"payload value: %x\n", payload.value[i]));
+	}
+
+	ret = PM8001_CHIP_DISP->sgpio_req(pm8001_ha, &payload);
+	if (ret != 0)
+		ret = -1;
+
+	mutex_unlock(&pm8001_ha->ioctl_mutex);
+	return ret;
+}
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 8e442214c954..f95f4d714983 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -144,6 +144,17 @@ struct gpio_ioctl_resp {
 	u32	gpio_evt_fall;
 };
 
+struct sgpio_req {
+	u32	func_reg_index;
+	u32	count;
+	u32	value[MAX_SGPIO_REQ_PAYLOAD];
+};
+
+struct sgpio_ioctl_resp {
+	u32	func_result;
+	u32	value[MAX_SGPIO_RESP_PAYLOAD];
+};
+
 /* define task management IU */
 struct pm8001_tmf_task {
 	u8	tmf;
@@ -261,6 +272,8 @@ struct pm8001_dispatch {
 	int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
 	int (*gpio_req)(struct pm8001_hba_info *pm8001_ha,
 		struct pm8001_gpio *gpio_payload);
+	int (*sgpio_req)(struct pm8001_hba_info *pm8001_ha,
+		struct sgpio_req *sgpio_payload);
 	int (*get_phy_profile_req)(struct pm8001_hba_info *pm8001_ha,
 		int phy, int page);
 };
@@ -585,6 +598,7 @@ struct pm8001_hba_info {
 	struct completion	*ioctl_completion;
 	struct timer_list	ioctl_timer;
 	u32			ioctl_timer_expired;
+	struct			sgpio_ioctl_resp sgpio_resp;
 	struct	phy_prof_resp	phy_profile_resp;
 	u32			reset_in_progress;
 };
@@ -698,6 +712,8 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun);
 int pm8001_I_T_nexus_reset(struct domain_device *dev);
 int pm8001_I_T_nexus_event_handler(struct domain_device *dev);
 int pm8001_query_task(struct sas_task *task);
+int pm8001_write_sgpio(struct sas_ha_struct *sas_ha, u8 reg_type,
+		u8 reg_index, u8 reg_count, u8 *write_data);
 void pm8001_open_reject_retry(
 	struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task_to_close,
@@ -733,6 +749,8 @@ int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 				struct pm8001_device *pm8001_dev,
 				u8 flag, u32 task_tag, u32 cmd_tag);
 int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha, u32 device_id);
+int pm8001_chip_sgpio_req(struct pm8001_hba_info *pm8001_ha,
+		struct sgpio_req *sgpio_payload);
 void pm8001_chip_make_sg(struct scatterlist *scatter, int nr, void *prd);
 void pm8001_work_fn(struct work_struct *work);
 int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha,
@@ -754,6 +772,7 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba_info *pm8001_ha,
 							void *piomb);
 int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb);
 int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
+int pm8001_sgpio_resp(struct pm8001_hba_info *pm8001_ha, void *piomb);
 struct sas_task *pm8001_alloc_task(void);
 void pm8001_task_done(struct sas_task *task);
 void pm8001_free_task(struct sas_task *task);
@@ -761,6 +780,7 @@ void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag);
 struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
 					u32 device_id);
 int pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha);
+int pm8001_setup_sgpio(struct pm8001_hba_info *pm8001_ha);
 
 int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);
 void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 10a922e5a478..bbcdcff5d25b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4100,6 +4100,11 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			"OPC_OUB_SSP_COALESCED_COMP_RESP opcode:%x\n", opc));
 		ssp_coalesced_comp_resp(pm8001_ha, piomb);
 		break;
+	case OPC_OUB_SGPIO_RESP:
+		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
+			"OPC_OUB_SGPIO RESPONSE opcode: %x\n", opc));
+		pm8001_sgpio_resp(pm8001_ha, piomb);
+		break;
 	default:
 		PM8001_DEVIO_DBG(pm8001_ha, pm8001_printk(
 			"Unknown outbound Queue IOMB OPC = 0x%x\n", opc));
@@ -5170,5 +5175,6 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
 	.gpio_req		= pm80xx_chip_gpio_req,
+	.sgpio_req		= pm8001_chip_sgpio_req,
 	.get_phy_profile_req	= pm8001_chip_get_phy_profile,
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index fed193df93d6..2d7f67b1cd93 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1509,6 +1509,9 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define MAIN_MPI_ILA_RELEASE_TYPE	0xA4 /* DWORD 0x29 */
 #define MAIN_MPI_INACTIVE_FW_VERSION	0XB0 /* DWORD 0x2C */
 
+/*FATAL ERROR INTERRUPT bit definition*/
+#define MAIN_CFG_SGPIO_ENABLE		(0x1 << 2)
+
 /* Gereral Status Table offset - byte offset */
 #define GST_GSTLEN_MPIS_OFFSET		0x00
 #define GST_IQ_FREEZE_STATE0_OFFSET	0x04
-- 
2.16.3

