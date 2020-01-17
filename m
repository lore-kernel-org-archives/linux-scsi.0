Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAA7C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6D52073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgAQHKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:46 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:35630 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgAQHKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:45 -0500
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
IronPort-SDR: rfs8Y6iyCGUUbWvk1VeUvGBEQXhasAVu5g8Yxx34ZcBfrqd4B7xAx8Cfxl7OK+b3awW9YSWVZy
 jfrpRCN2Y/MkxueQUayKOPeKMtRKGlwsKcVkrHesun6ecyUZ7WzXpA9xYa0vint9Hu4d+pDQlk
 QjRhMnoIbGB//Gi2atYe828xS7K5R9uMTdvjdligQ9Grc5a1IjY0t7q/Kfx6pbOBp9JyqbwylI
 3TzwR2HKouNmS4O1wkaNUkoNxoIN2b8NhUK/NbHhjkwTB4/ARRHC6s2quHSGbnRCJnSuHOWWlR
 vTA=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="63598503"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:44 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:43 -0800
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:43 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 08/13] pm80xx : IOCTL functionality to get phy error.
Date:   Fri, 17 Jan 2020 12:49:18 +0530
Message-ID: <20200117071923.7445-9-deepak.ukey@microchip.com>
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

Added the IOCTL functionality for phy error so that management utility
can get the information like Invalid dword count, Disparity error count,
Loss of sync dword count, phy reset count from driver using get phy
profile command.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 54 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h | 12 +++++++++
 drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h |  1 +
 4 files changed, 81 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index eb64566b2274..7f45e114a31a 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -1026,6 +1026,57 @@ static int pm8001_ioctl_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
+static int pm8001_ioctl_get_phy_err(struct pm8001_hba_info *pm8001_ha,
+		unsigned long arg)
+{
+	struct phy_errcnt phy_err[MAX_NUM_PHYS];
+	DECLARE_COMPLETION_ONSTACK(completion);
+	unsigned long timeout = msecs_to_jiffies(2000);
+	u32 ret = 0, i;
+	int page_code = SAS_PHY_ERR_COUNTERS_PAGE;
+	/*6H card does not support phyerr*/
+	if (pm8001_ha->pdev->device == 0x8001 ||
+			pm8001_ha->pdev->device == 0x8081) {
+		return ADPT_IOCTL_CALL_INVALID_DEVICE;
+	}
+
+	mutex_lock(&pm8001_ha->ioctl_mutex);
+
+	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
+		pm8001_ha->ioctl_completion = &completion;
+		ret = PM8001_CHIP_DISP->get_phy_profile_req(pm8001_ha,
+				i, page_code);
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
+		memcpy((void *)&phy_err[i],
+			(void *)&pm8001_ha->phy_profile_resp,
+			sizeof(struct phy_errcnt));
+	}
+
+	if (copy_to_user((void *)arg, (void *)&phy_err,
+				sizeof(struct phy_errcnt) * (i))) {
+		PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("copy_to_user failed\n"));
+		ret = ADPT_IOCTL_CALL_FAILED;
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
@@ -1052,6 +1103,9 @@ static long pm8001_ioctl(struct file *file,
 	case ADPT_IOCTL_GET_PHY_PROFILE:
 		ret = pm8001_ioctl_get_phy_profile(pm8001_ha, arg);
 		return ret;
+	case ADPT_IOCTL_GET_PHY_ERR_CNT:
+		ret = pm8001_ioctl_get_phy_err(pm8001_ha, arg);
+		break;
 	default:
 		ret = ADPT_IOCTL_CALL_INVALID_CODE;
 	}
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index 226fab82845f..686ad69f0e0c 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -102,15 +102,27 @@ struct phy_profile {
 	unsigned int	reserved2:20;
 } __packed;
 
+struct phy_errcnt {
+	unsigned int  InvalidDword;
+	unsigned int  runningDisparityError;
+	unsigned int  codeViolation;
+	unsigned int  LossOfSyncDW;
+	unsigned int  phyResetProblem;
+	unsigned int  inboundCRCError;
+};
+
 struct phy_prof_resp {
 	union {
 		struct phy_profile status;
+		struct phy_errcnt errcnt;
 	} phy;
 };
 
 #define ADPT_IOCTL_INFO _IOR(ADPT_MAGIC_NUMBER, 0, struct ioctl_info_buffer *)
 #define ADPT_IOCTL_GET_PHY_PROFILE _IOWR(ADPT_MAGIC_NUMBER, 8, \
 		struct phy_profile*)
+#define ADPT_IOCTL_GET_PHY_ERR_CNT _IOWR(ADPT_MAGIC_NUMBER, 9, \
+		struct phy_err*)
 #define ADPT_MAGIC_NUMBER	'm'
 
 #endif /* PM8001_CTL_H_INCLUDED */
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 0a36c5d5e2c2..e8af262976d6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3690,6 +3690,7 @@ static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 {
 	u32 tag, page_code;
 	struct phy_profile *phy_profile, *phy_prof;
+	struct phy_errcnt *phy_err, *phy_err_cnt;
 	struct get_phy_profile_resp *pPayload =
 		(struct get_phy_profile_resp *)(piomb + 4);
 	u32 status = le32_to_cpu(pPayload->status);
@@ -3725,6 +3726,19 @@ static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 			phy_profile->nlr = le32_to_cpu(phy_prof->nlr);
 			phy_profile->port_id = le32_to_cpu(phy_prof->port_id);
 			phy_profile->prts = le32_to_cpu(phy_prof->prts);
+		} else if (page_code == SAS_PHY_ERR_COUNTERS_PAGE) {
+			phy_err =
+			(struct phy_errcnt *)&pm8001_ha->phy_profile_resp;
+			phy_err_cnt =
+			(struct phy_errcnt *)pPayload->ppc_specific_rsp;
+			phy_err->InvalidDword =
+			le32_to_cpu(phy_err_cnt->InvalidDword);
+			phy_err->runningDisparityError =
+			le32_to_cpu(phy_err_cnt->runningDisparityError);
+			phy_err->LossOfSyncDW =
+			le32_to_cpu(phy_err_cnt->LossOfSyncDW);
+			phy_err->phyResetProblem =
+			le32_to_cpu(phy_err_cnt->phyResetProblem);
 		}
 		complete(pm8001_ha->ioctl_completion);
 	}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 230877caeed4..b5119c5479da 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -175,6 +175,7 @@
 #define PHY_STOP_ERR_DEVICE_ATTACHED	0x1046
 
 /* phy_profile */
+#define SAS_PHY_ERR_COUNTERS_PAGE	0x01
 #define SAS_PHY_ANALOG_SETTINGS_PAGE	0x04
 #define SAS_PHY_GENERAL_STATUS_PAGE	0x05
 #define PHY_DWORD_LENGTH		0xC
-- 
2.16.3

