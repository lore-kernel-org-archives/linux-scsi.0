Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B39AC2D0D0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68181206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfLXEl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:26 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4204 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLXElY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:24 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: C2Izv2l4CpIyUqRtjdKB7YbPDApl3CIkoRHRoJl/vCqqZQSTPjjanKABCt1rBvFfSilRVPFa3M
 lpGE7hwxv3u5C3NbkDFB9nphqy3O57BKhK4BIpzZcgxmIZZzw0ncPNx6yz02NXSGMc3IknPSc1
 orHA+H8XjpOuinKqT/0MYubOsYCe4k4uzxmYX0QGnundCOHNxYygrYhw3i9nXp2Ovo4xidOaO4
 B+JTrMi7i8V41GY0gRMwTLfH/SLc/6c9twmrzK0TxoM8DA3XuSLI/gC31kFAMlpREbydKcIZpO
 3LQ=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="61418520"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:41:22 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:41:21 -0800
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:41:21 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 12/12] pm80xx : IOCTL functionality for TWI device.
Date:   Tue, 24 Dec 2019 10:11:43 +0530
Message-ID: <20191224044143.8178-13-deepak.ukey@microchip.com>
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

From: Viswas G <Viswas.G@microchip.com>

Added the IOCTL functionality for TWI device.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Yu Zheng <yuuzheng@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 133 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |  23 +++++++
 drivers/scsi/pm8001/pm8001_hwi.c  | 113 ++++++++++++++++++++++++++------
 drivers/scsi/pm8001/pm8001_hwi.h  |   1 +
 drivers/scsi/pm8001/pm8001_init.c |  10 +++
 drivers/scsi/pm8001/pm8001_sas.h  |  13 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  |  41 ++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h  |   1 +
 8 files changed, 314 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 63bd2a384d2e..ed791de44217 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1124,6 +1124,126 @@ static long pm8001_sgpio_ioctl(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
+static int icotl_twi_wr_request(int twi_wr,
+			struct pm8001_hba_info *pm8001_ha, unsigned long arg)
+{
+	int ret = 0;
+	unsigned char *buf;
+	int bus;
+	int addr;
+	bool addr_mode_7bit = true;
+	int rd_size = 0;
+	int wr_size = 0;
+	int offset = 0;
+	bool direct_addr  = true;
+	struct twi_ioctl_payload *twi_ioctl;
+
+	twi_ioctl = kmalloc(sizeof(struct twi_ioctl_payload), GFP_KERNEL);
+	if (!twi_ioctl) {
+		PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("Failed to allocate ioctl\n"));
+		return -ENOMEM;
+	}
+	ret = copy_from_user(twi_ioctl, (u8 *)arg, sizeof(*twi_ioctl));
+	if (ret) {
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("Failed to get ioctl args\n"));
+		return -EIO;
+	}
+
+	bus = twi_ioctl->bus;
+	addr = twi_ioctl->addr;
+
+	switch (twi_wr) {
+	case TW_WRITE:
+		wr_size = twi_ioctl->wr_size;
+		/* first 1K read/write is not possible,
+		 * from 2k we have customer specific seeprom
+		 */
+		offset = twi_ioctl->offset;
+		if (wr_size > 48)
+			direct_addr = false;
+		buf = kzalloc(wr_size, GFP_KERNEL);
+
+		if (buf == NULL) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("No Memory for write\n"));
+			return -ENOMEM;
+		}
+		ret = copy_from_user(buf, (u8 *)twi_ioctl->buf, wr_size);
+		if (!ret) {
+			ret = pm80xx_twi_wr_request(pm8001_ha, bus, addr,
+				addr_mode_7bit, rd_size, wr_size, offset,
+				direct_addr, buf);
+		} else {
+			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+				("Failed to get data from buffer\n"));
+			return -EIO;
+		}
+		kfree(buf);
+		break;
+	case TW_READ:
+		rd_size = twi_ioctl->rd_size;
+		offset = twi_ioctl->offset;
+		if (rd_size > 48)
+			direct_addr = false;
+		buf = kzalloc(rd_size, GFP_KERNEL);
+		if (buf == NULL) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("No Memory for read\n"));
+			return -ENOMEM;
+		}
+		ret = pm80xx_twi_wr_request(pm8001_ha, bus, addr,
+			addr_mode_7bit, rd_size, wr_size, offset,
+			direct_addr, buf);
+		if (!ret) {
+			ret = copy_to_user((u8 *)twi_ioctl->buf, buf, rd_size);
+			kfree(buf);
+		} else {
+			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+				("pm80xx_twi_wr_request failed !!!\n"));
+			return -EIO;
+		}
+		break;
+	case TW_WRITE_READ:
+		rd_size = twi_ioctl->rd_size;
+		wr_size = twi_ioctl->wr_size;
+		offset = twi_ioctl->offset;
+		if (wr_size > 48 || rd_size > 48)
+			direct_addr = false;
+		buf = kzalloc(max_t(int, wr_size, rd_size), GFP_KERNEL);
+		if (buf == NULL) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("No Memory for read\n"));
+			return -ENOMEM;
+		}
+		ret = copy_from_user(buf, (u8 *)twi_ioctl->buf, wr_size);
+		if (!ret) {
+			ret = pm80xx_twi_wr_request(pm8001_ha, bus, addr,
+				addr_mode_7bit, rd_size, wr_size, offset,
+				direct_addr, buf);
+			if (!ret)
+				ret = copy_to_user((u8 *)twi_ioctl->buf,
+					buf, rd_size);
+			else {
+				PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+				("Failed to copy data to read buffer\n"));
+				ret = -EIO;
+			}
+		} else {
+			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+				("Failed to get data from write buffer\n"));
+			return -ENOMEM;
+		}
+		break;
+	default:
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+			("Invalid twi operation\n"));
+		return -EINVAL;
+	}
+	return ret;
+}
+
 static int pm8001_ioctl_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
 		unsigned long arg)
 {
@@ -1277,6 +1397,7 @@ static long pm8001_ioctl(struct file *file,
 	u32 ret = -EACCES;
 	struct pm8001_hba_info *pm8001_ha;
 	struct ioctl_header header;
+	u8 twi_wr = 0;
 
 	pm8001_ha = file->private_data;
 
@@ -1296,6 +1417,18 @@ static long pm8001_ioctl(struct file *file,
 	case ADPT_IOCTL_GET_PHY_ERR_CNT:
 		ret = pm8001_ioctl_get_phy_err(pm8001_ha, arg);
 		break;
+	case ADPT_IOCTL_TWI_WRITE:
+		twi_wr = 0x01;
+		ret = icotl_twi_wr_request(twi_wr, pm8001_ha, arg);
+		return ret;
+	case ADPT_IOCTL_TWI_READ:
+		twi_wr = 0x02;
+		ret = icotl_twi_wr_request(twi_wr, pm8001_ha, arg);
+		return ret;
+	case ADPT_IOCTL_TWI_WRITE_READ:
+		twi_wr = 0x03;
+		ret = icotl_twi_wr_request(twi_wr, pm8001_ha, arg);
+		return ret;
 	default:
 		ret = ADPT_IOCTL_CALL_INVALID_CODE;
 	}
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index b1be0bc065d5..57bf597aa9c3 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -101,6 +101,26 @@
 #define SGPIO_CMD_ERROR_WRONG_FRAME_REG_TYPE_REG_INDEX	0x1D
 #define SGPIO_CMD_ERROR_WRONG_ALL_HEADER_PARAMS		0x9D
 
+#define TWI_SEEPROM_BUS_NUMBER	0
+#define TWI_SEEPROM_DEV_ADDR	0xa0
+#define TWI_SEEPROM_READ_SIZE	1024
+#define TWI_SEEPROM_WRITE_SIZE	1024
+
+#define TW_IOCTL_STATUS_SUCCESS		0
+#define TW_IOCTL_STATUS_FAILURE		1
+#define TW_IOCTL_STATUS_WRONG_ADDR	0xA
+
+struct twi_ioctl_payload {
+	u32	bus;
+	u32	addr;
+	u32	rd_size;
+	u32	wr_size;
+	u32	offset;
+	u8	addr_mode;
+	u8	*buf;
+	u32	status;
+};
+
 struct ioctl_header {
 	u32 io_controller_num;
 	u32 length;
@@ -219,6 +239,9 @@ struct phy_prof_resp {
 		struct phy_profile*)
 #define ADPT_IOCTL_GET_PHY_ERR_CNT _IOWR(ADPT_MAGIC_NUMBER, 9, \
 		struct phy_err*)
+#define ADPT_IOCTL_TWI_READ _IOR('m', 10, char *)
+#define ADPT_IOCTL_TWI_WRITE _IOW('m', 11, char *)
+#define ADPT_IOCTL_TWI_WRITE_READ _IOWR('m', 12, char *)
 #define ADPT_MAGIC_NUMBER	'm'
 
 #endif /* PM8001_CTL_H_INCLUDED */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 16dc7a92ad68..0736c4b8cf7b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3152,13 +3152,34 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 tag = le32_to_cpu(pPayload->tag);
 	struct pm8001_ccb_info *ccb = &pm8001_ha->ccb_info[tag];
 	u32 dlen_status = le32_to_cpu(pPayload->dlen_status);
-	complete(pm8001_ha->nvmd_completion);
-	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
+	u32 *nvmd_data_addr;
+	u32 ir_tds_bn_dps_das_nvm =
+		le32_to_cpu(pPayload->ir_tda_bn_dps_das_nvm);
+	int tw_wr = (ir_tds_bn_dps_das_nvm & TR_MASK) >> 29;
+	struct fw_control_ex	*fw_control_context;
+
+	fw_control_context = ccb->fw_control_context;
 	if ((dlen_status & NVMD_STAT) != 0) {
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Set nvm data error!\n"));
+		complete(pm8001_ha->nvmd_completion);
 		return;
 	}
+
+	if ((ir_tds_bn_dps_das_nvm & NVMD_TYPE) == TWI_DEVICE) {
+		if (tw_wr == TW_READ || tw_wr == TW_WRITE_READ) {
+			if (ir_tds_bn_dps_das_nvm & IPMode) {
+				nvmd_data_addr =
+				pm8001_ha->memoryMap.region[NVMD].virt_ptr;
+			} else {
+				nvmd_data_addr = pPayload->nvm_data;
+			}
+			memcpy(fw_control_context->usrAddr, nvmd_data_addr,
+				fw_control_context->len);
+		}
+	}
+	complete(pm8001_ha->nvmd_completion);
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
@@ -3223,11 +3244,11 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	memcpy(fw_control_context->usrAddr,
 		pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		fw_control_context->len);
+	complete(pm8001_ha->nvmd_completion);
 	kfree(ccb->fw_control_context);
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
-	complete(pm8001_ha->nvmd_completion);
 }
 
 int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
@@ -4856,12 +4877,17 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 
 	switch (nvmd_type) {
 	case TWI_DEVICE: {
-		u32 twi_addr, twi_page_size;
-		twi_addr = 0xa8;
-		twi_page_size = 2;
+		u32 twi_addr, twi_page_size, twi_addr_size, twi_busno;
+
+		twi_addr = pm8001_ha->twi_address;
+		twi_page_size = pm8001_ha->twi_page_size;
+		twi_addr_size = 1;
+		twi_busno = 0;
 
 		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | twi_addr << 16 |
-			twi_page_size << 8 | TWI_DEVICE);
+				twi_busno << 12 | twi_page_size << 8 |
+				twi_addr_size << 4 | TWI_DEVICE);
+		nvmd_req.vpd_offset = cpu_to_le32(ioctl_payload->offset);
 		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->rd_length);
 		nvmd_req.resp_addr_hi =
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
@@ -4936,32 +4962,77 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 	if (!fw_control_context)
 		return -ENOMEM;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-	memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
-		&ioctl_payload->func_specific,
-		ioctl_payload->wr_length);
+	if (nvmd_type != TWI_DEVICE) {
+		memcpy(pm8001_ha->memoryMap.region[NVMD].virt_ptr,
+			&ioctl_payload->func_specific,
+			ioctl_payload->wr_length);
+	}
 	memset(&nvmd_req, 0, sizeof(nvmd_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc) {
 		kfree(fw_control_context);
-		return -EBUSY;
+		return rc;
 	}
 	ccb = &pm8001_ha->ccb_info[tag];
 	ccb->fw_control_context = fw_control_context;
 	ccb->ccb_tag = tag;
 	nvmd_req.tag = cpu_to_le32(tag);
+
 	switch (nvmd_type) {
 	case TWI_DEVICE: {
-		u32 twi_addr, twi_page_size;
-		twi_addr = 0xa8;
-		twi_page_size = 2;
+		u32 twi_addr, twi_page_size, twi_addr_size, twi_busno;
+		u32 addr_mode;
+		u8 *nvmd_data_addr;
+		u8 tr = 0, d_len = 0;
+		u32 ipdl = 0;//indirect data payload len
+		u32 tr_dl = 0; //twi read data len
+
+		addr_mode = (ioctl_payload->twi_direct_addr == true) ?
+			0 : IPMode;
+		if (ioctl_payload->rd_length) {
+			tr_dl = ioctl_payload->rd_length;
+			fw_control_context->usrAddr =
+				(u8 *)ioctl_payload->func_specific;
+			fw_control_context->len = ioctl_payload->rd_length;
+			tr = TW_READ;
+		}
+		if (ioctl_payload->wr_length) {
+			if (addr_mode  == 0) {
+				d_len = ioctl_payload->wr_length;
+				nvmd_data_addr =  (u8 *)&(nvmd_req.reserved[0]);
+			} else	{
+				ipdl = ioctl_payload->wr_length;
+				nvmd_data_addr =
+				pm8001_ha->memoryMap.region[NVMD].virt_ptr;
+			}
+			memcpy(nvmd_data_addr, ioctl_payload->func_specific,
+					ioctl_payload->wr_length);
+			tr = TW_WRITE;
+		}
+		if (ioctl_payload->wr_length && ioctl_payload->rd_length)
+			tr = TW_WRITE_READ;
+		twi_addr = ioctl_payload->twi_addr;
+		if (twi_addr == TWI_SEEPROM_DEV_ADDR)
+			tr = 0;//Reserved for SEEPROM access ,as by fw
+		twi_page_size = 0;
+		twi_addr_size = 1;
+		twi_busno = ioctl_payload->bus;
 		nvmd_req.reserved[0] = cpu_to_le32(0xFEDCBA98);
-		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | twi_addr << 16 |
-			twi_page_size << 8 | TWI_DEVICE);
-		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->wr_length);
-		nvmd_req.resp_addr_hi =
-		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
-		nvmd_req.resp_addr_lo =
-		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);
+		nvmd_req.len_ir_vpdd = cpu_to_le32(addr_mode | (tr << 29) |
+				twi_addr << 16 | twi_busno << 12 |
+				twi_page_size << 8 | twi_addr_size << 4 |
+				TWI_DEVICE);
+		nvmd_req.vpd_offset = cpu_to_le32(d_len  << 24 |
+				ioctl_payload->offset);
+		nvmd_req.resp_len = cpu_to_le32(ipdl);
+
+		if (addr_mode == IPMode) {
+			nvmd_req.resp_addr_hi = cpu_to_le32
+			(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
+			nvmd_req.resp_addr_lo = cpu_to_le32
+			(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);
+		}
+		nvmd_req.tr_dl = cpu_to_le32(tr_dl);
 		break;
 	}
 	case C_SEEPROM:
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index aad2322467d2..98e9ea6a4d6e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -634,6 +634,7 @@ struct set_nvm_data_req {
 	__le32	resp_addr_hi;
 	__le32	resp_len;
 	u32	reserved1;
+	__le32	tr_dl;
 } __attribute__((packed, aligned(4)));
 
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 6e037638656d..61fb9f622a5d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -55,6 +55,14 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
 		" 4: Link rate 6.0G\n"
 		" 8: Link rate 12.0G\n");
 
+static ulong twi_address = 0xa0;
+module_param(twi_address, ulong, 0644);
+MODULE_PARM_DESC(twi_address, "set the address of twi device.");
+
+static ulong twi_page_size;
+module_param(twi_page_size, ulong, 0644);
+MODULE_PARM_DESC(twi_page_size, "set the page size of twi device.");
+
 static struct scsi_transport_template *pm8001_stt;
 
 /**
@@ -484,6 +492,8 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->shost = shost;
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = logging_level;
+	pm8001_ha->twi_address = twi_address;
+	pm8001_ha->twi_page_size = twi_page_size;
 	pm8001_ha->non_fatal_count = 0;
 	if (link_rate >= 1 && link_rate <= 15)
 		pm8001_ha->link_rate = (link_rate << 8);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 917a17f4d595..45128f89aebe 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -169,6 +169,9 @@ struct pm8001_ioctl_payload {
 	u16	id;
 	u32	wr_length;
 	u32	rd_length;
+	bool	twi_direct_addr;
+	u8	bus;
+	u8	twi_addr;
 	u8	*func_specific;
 };
 
@@ -586,6 +589,8 @@ struct pm8001_hba_info {
 #endif
 	u32			logging_level;
 	u32			link_rate;
+	u32			twi_address;
+	u32			twi_page_size;
 	u32			fw_status;
 	u32			smp_exp_mode;
 	bool			controller_fatal_error;
@@ -650,6 +655,11 @@ struct pm8001_fw_image_header {
 #define DS_IN_ERROR				0x04
 #define DS_NON_OPERATIONAL			0x07
 
+#define TR_MASK			0x60000000
+#define TW_WRITE		0x01
+#define TW_READ			0x02
+#define TW_WRITE_READ		0x03
+
 /**
  * brief param structure for firmware flash update.
  */
@@ -796,6 +806,9 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 		struct device_attribute *attr, char *buf);
 ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
+int pm80xx_twi_wr_request(struct pm8001_hba_info *pm8001_ha, int bus, int addr,
+		bool addr_mode_7bit, int rd_size, int wr_size,
+		int offset, bool direct_addr, unsigned char *buf);
 /* ctl shared API */
 extern struct device_attribute *pm8001_host_attrs[];
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4923660304aa..453202ee4d80 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -46,6 +46,47 @@
 #define SMP_DIRECT 1
 #define SMP_INDIRECT 2
 
+int pm80xx_twi_wr_request(struct pm8001_hba_info *pm8001_ha, int bus, int addr,
+			bool addr_mode_7bit, int rd_size, int wr_size,
+			int offset, bool direct_addr, unsigned char *buf)
+{
+	struct pm8001_ioctl_payload *payload;
+	u8 *ioctlbuffer = NULL;
+	int length, ret;
+	DECLARE_COMPLETION_ONSTACK(completion);
+
+	if ((wr_size > 48 || rd_size > 48) && direct_addr == true) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk
+		("Direct addressing mode used if payload size < 48\n"));
+		return -EINVAL;
+	}
+
+	length = sizeof(*payload);
+	ioctlbuffer = kzalloc(length, GFP_KERNEL);
+	if (!ioctlbuffer)
+		return -ENOMEM;
+	payload = (struct pm8001_ioctl_payload *)ioctlbuffer;
+
+	pm8001_ha->nvmd_completion = &completion;
+	payload->minor_function = 0;
+
+	payload->rd_length = rd_size;
+	payload->wr_length = wr_size;
+	payload->bus = bus;
+	payload->twi_addr = addr;
+	payload->twi_direct_addr = direct_addr;
+	payload->offset = offset;
+
+	payload->func_specific = buf;
+
+	ret = PM8001_CHIP_DISP->set_nvmd_req(pm8001_ha, payload);
+
+	wait_for_completion(&completion);
+
+	kfree(ioctlbuffer);
+
+	return ret;
+}
 
 int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 2d7f67b1cd93..ba49d0abd6f4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -966,6 +966,7 @@ struct set_nvm_data_req {
 	__le32	resp_addr_hi;
 	__le32	resp_len;
 	u32	reserved1[17];
+	__le32	tr_dl;
 } __attribute__((packed, aligned(4)));
 
 /**
-- 
2.16.3

