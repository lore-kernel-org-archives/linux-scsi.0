Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E32C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705372073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgAQHKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:44 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10582 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQHKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:43 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: i8gDkUa7SVhx33ajHmp87AbnerleGrfG9iUpOCIVisIUkGLuzZPt70HYts8Q0Pxbb+1ggwOAW5
 Pi8p2K7peA1+9eQcuJP1aTgrz+ZMAAtC8UWlxpHOWje22kE6CugjOFwZImpTy+RpxwWXHVAHQ1
 2g6Y36OMvcz8iDM91fX3AjPQhHbyhvU4/pi8I5+od9XUlEEqUtggADSeiKpfO5+9C5VDZ4ZRrh
 jclZia84dCTMwet/FEApEaNbawHl65D0RVBvd597a1WVzRM/9Dnq+9cedURA82CNQqpJKxoJJI
 SEI=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="61358149"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:42 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:41 -0800
Received: from localhost (10.41.130.51) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:41 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 07/13] pm80xx : IOCTL functionality to get phy status.
Date:   Fri, 17 Jan 2020 12:49:17 +0530
Message-ID: <20200117071923.7445-8-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Added the IOCTL functionality for phy status so that management
utility can get the information like phy id, phy status, port id
and port status from driver using get phy profile command.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 90 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h | 23 +++++++++-
 drivers/scsi/pm8001/pm8001_sas.h |  7 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c | 68 ++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h |  1 +
 5 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 8091e78a04b0..eb64566b2274 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -41,6 +41,8 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_ctl.h"
+#include "pm80xx_hwi.h"
+
 int pm80xx_major = -1;
 
 /* scsi host attributes */
@@ -939,6 +941,91 @@ static long pm8001_info_ioctl(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
+static int pm8001_ioctl_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
+		unsigned long arg)
+{
+	struct phy_profile phy_prof[MAX_NUM_PHYS];
+	int nphys;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	unsigned long timeout = msecs_to_jiffies(2000);
+	u32 ret = 0, i;
+	int page_code = SAS_PHY_GENERAL_STATUS_PAGE;
+
+	if (pm8001_ha->pdev->device == 0x8001 ||
+				pm8001_ha->pdev->device == 0x8081) {
+		return ADPT_IOCTL_CALL_INVALID_DEVICE;
+	}
+
+	if (copy_from_user(&phy_prof[0], (struct phy_profile *)arg,
+				sizeof(struct phy_profile))) {
+		PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("copy_from_user failed\n"));
+		return ADPT_IOCTL_CALL_FAILED;
+	}
+
+	mutex_lock(&pm8001_ha->ioctl_mutex);
+	nphys = phy_prof[0].phy_id;
+	if (nphys == -1) {
+		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
+			pm8001_ha->ioctl_completion = &completion;
+			ret = PM8001_CHIP_DISP->get_phy_profile_req(pm8001_ha,
+								i, page_code);
+			if (ret != 0) {
+				PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+					"Get phy profile request failed\n"));
+				ret = ADPT_IOCTL_CALL_FAILED;
+				goto exit;
+			}
+			timeout = wait_for_completion_timeout(&completion,
+					timeout);
+			if (timeout == 0) {
+				ret = ADPT_IOCTL_CALL_FAILED;
+				goto exit;
+			}
+			memcpy((void *)&phy_prof[i],
+				(void *)&pm8001_ha->phy_profile_resp,
+				sizeof(struct phy_profile));
+		}
+
+		if (copy_to_user((void *)arg, (void *)&phy_prof,
+				sizeof(struct phy_profile) * (i))) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("copy_to_user failed\n"));
+			ret = ADPT_IOCTL_CALL_FAILED;
+		}
+	} else {
+		pm8001_ha->ioctl_completion = &completion;
+		ret = PM8001_CHIP_DISP->get_phy_profile_req(pm8001_ha,
+							nphys, page_code);
+		if (ret != 0) {
+			PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+				"Get phy profile request failed\n"));
+			ret = ADPT_IOCTL_CALL_FAILED;
+			goto exit;
+		}
+		timeout = wait_for_completion_timeout(&completion,
+				timeout);
+		if (timeout == 0) {
+			ret = ADPT_IOCTL_CALL_FAILED;
+			goto exit;
+		}
+
+		if (copy_to_user((void *)arg,
+				(void *)&pm8001_ha->phy_profile_resp,
+				sizeof(struct phy_profile))) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("copy_to_user failed\n"));
+			ret = ADPT_IOCTL_CALL_FAILED;
+		}
+	}
+exit:
+	spin_lock_irq(&pm8001_ha->ioctl_lock);
+	pm8001_ha->ioctl_completion = NULL;
+	spin_unlock_irq(&pm8001_ha->ioctl_lock);
+	mutex_unlock(&pm8001_ha->ioctl_mutex);
+	return ret;
+}
+
 /**
  *	pm8001_ioctl - pm8001 configuration request
  *	@inode: inode of device
@@ -962,6 +1049,9 @@ static long pm8001_ioctl(struct file *file,
 	case ADPT_IOCTL_INFO:
 		ret = pm8001_info_ioctl(pm8001_ha, arg);
 		break;
+	case ADPT_IOCTL_GET_PHY_PROFILE:
+		ret = pm8001_ioctl_get_phy_profile(pm8001_ha, arg);
+		return ret;
 	default:
 		ret = ADPT_IOCTL_CALL_INVALID_CODE;
 	}
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index f0f8b1deae27..226fab82845f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -63,6 +63,9 @@
 #define ADPT_IOCTL_CALL_SUCCESS		0x00
 #define ADPT_IOCTL_CALL_FAILED		0x01
 #define ADPT_IOCTL_CALL_INVALID_CODE	0x03
+#define ADPT_IOCTL_CALL_INVALID_DEVICE	0x04
+
+#define MAX_NUM_PHYS			16
 
 struct ioctl_header {
 	u32 io_controller_num;
@@ -88,8 +91,26 @@ struct ioctl_info_buffer {
 	struct ioctl_drv_info	information;
 };
 
-#define ADPT_IOCTL_INFO _IOR(ADPT_MAGIC_NUMBER, 0, struct ioctl_info_buffer *)
+struct phy_profile {
+	char		phy_id;
+	unsigned int	phys:4;
+	unsigned int	nlr:4;
+	unsigned int	plr:4;
+	unsigned int	reserved1:12;
+	unsigned char	port_id;
+	unsigned int	prts:4;
+	unsigned int	reserved2:20;
+} __packed;
 
+struct phy_prof_resp {
+	union {
+		struct phy_profile status;
+	} phy;
+};
+
+#define ADPT_IOCTL_INFO _IOR(ADPT_MAGIC_NUMBER, 0, struct ioctl_info_buffer *)
+#define ADPT_IOCTL_GET_PHY_PROFILE _IOWR(ADPT_MAGIC_NUMBER, 8, \
+		struct phy_profile*)
 #define ADPT_MAGIC_NUMBER	'm'
 
 #endif /* PM8001_CTL_H_INCLUDED */
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 479aac34d7cc..87d676810a18 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -56,6 +56,7 @@
 #include <scsi/sas_ata.h>
 #include <linux/atomic.h>
 #include "pm8001_defs.h"
+#include "pm8001_ctl.h"
 
 #define DRV_NAME		"pm80xx"
 #define DRV_VERSION		"0.1.39"
@@ -246,6 +247,8 @@ struct pm8001_dispatch {
 	int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,
 		u32 state);
 	int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
+	int (*get_phy_profile_req)(struct pm8001_hba_info *pm8001_ha,
+		int phy, int page);
 };
 
 struct pm8001_chip_info {
@@ -560,6 +563,10 @@ struct pm8001_hba_info {
 	bool			controller_fatal_error;
 	const struct firmware 	*fw_image;
 	struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
+	spinlock_t		ioctl_lock;
+	struct mutex		ioctl_mutex;
+	struct completion	*ioctl_completion;
+	struct	phy_prof_resp	phy_profile_resp;
 	u32			reset_in_progress;
 };
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 37b82d7aa3d7..0a36c5d5e2c2 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3688,9 +3688,48 @@ static int mpi_get_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
+	u32 tag, page_code;
+	struct phy_profile *phy_profile, *phy_prof;
+	struct get_phy_profile_resp *pPayload =
+		(struct get_phy_profile_resp *)(piomb + 4);
+	u32 status = le32_to_cpu(pPayload->status);
+
+	page_code = (u8)((pPayload->ppc_phyid & 0xFF00) >> 8);
+
 	PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk(" pm80xx_addition_functionality\n"));
 
+	if (status) {
+		/* status is FAILED */
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"mpiGetPhyProfileReq failed  with status 0x%08x\n",
+			status));
+	}
+
+	tag = le32_to_cpu(pPayload->tag);
+
+	spin_lock(&pm8001_ha->ioctl_lock);
+	if (pm8001_ha->ioctl_completion != NULL) {
+		if (status) {
+			/* signal fail status */
+			memset(&pm8001_ha->phy_profile_resp, 0xff,
+				sizeof(pm8001_ha->phy_profile_resp));
+		} else if (page_code == SAS_PHY_GENERAL_STATUS_PAGE) {
+			phy_profile =
+			(struct phy_profile *)&pm8001_ha->phy_profile_resp;
+			phy_prof =
+			(struct phy_profile *)pPayload->ppc_specific_rsp;
+			phy_profile->phy_id = le32_to_cpu(phy_prof->phy_id);
+			phy_profile->phys = le32_to_cpu(phy_prof->phys);
+			phy_profile->plr = le32_to_cpu(phy_prof->plr);
+			phy_profile->nlr = le32_to_cpu(phy_prof->nlr);
+			phy_profile->port_id = le32_to_cpu(phy_prof->port_id);
+			phy_profile->prts = le32_to_cpu(phy_prof->prts);
+		}
+		complete(pm8001_ha->ioctl_completion);
+	}
+	spin_unlock(&pm8001_ha->ioctl_lock);
+	pm8001_tag_free(pm8001_ha, tag);
 	return 0;
 }
 
@@ -4883,6 +4922,34 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
+int pm8001_chip_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
+		int phy_id, int page_code)
+{
+
+	u32 tag;
+	struct get_phy_profile_req payload;
+	struct inbound_queue_table *circularQ;
+	int rc, ppc_phyid;
+	u32 opc = OPC_INB_GET_PHY_PROFILE;
+
+	memset(&payload, 0, sizeof(payload));
+
+	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (rc)
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
+
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+
+	payload.tag = cpu_to_le32(tag);
+	ppc_phyid = (page_code & 0xFF)  << 8 | (phy_id & 0xFF);
+	payload.ppc_phyid = cpu_to_le32(ppc_phyid);
+
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
+
+	return rc;
+}
+
 void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 	u32 operation, u32 phyid, u32 length, u32 *buf)
 {
@@ -4983,4 +5050,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.set_nvmd_req		= pm8001_chip_set_nvmd_req,
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
+	.get_phy_profile_req	= pm8001_chip_get_phy_profile,
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 701951a0f715..230877caeed4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -176,6 +176,7 @@
 
 /* phy_profile */
 #define SAS_PHY_ANALOG_SETTINGS_PAGE	0x04
+#define SAS_PHY_GENERAL_STATUS_PAGE	0x05
 #define PHY_DWORD_LENGTH		0xC
 
 /* Thermal related */
-- 
2.16.3

