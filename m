Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5206FC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0D7207AF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgL3Et1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Dec 2020 23:49:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26778 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgL3Et1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2020 23:49:27 -0500
IronPort-SDR: qT8roKITPsvzVL2jqgoksnr6WwPL3zvggXj7pbjox1ZjV9pZnT1OEmsEny2PyWNT90UffjFyzJ
 mx8oItkfMegSmMJMViNvYREYIa1aHk/QeaF4VnGFmjLXnUim0qo9wBS5p2a0cTSV/ZE2+uYR0/
 YUN4sCkT9+xOZCrnqKRB24Tvq0toK07PHW6uvkDwQDGnmriorGyHL8YuCgBTQkXRYNKwxuJFqd
 CaRVnp01psB7yyHMNDrRo7skt1McfCwTaR2zOSJ4Uuy04jGanoM7xRVFf+/ZtDfdSkzow7ZpvJ
 WCc=
X-IronPort-AV: E=Sophos;i="5.78,460,1599548400"; 
   d="scan'208";a="109308278"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Dec 2020 21:47:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 21:47:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 29 Dec 2020 21:47:49 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 2/8] pm80xx: check fatal error
Date:   Wed, 30 Dec 2020 10:27:37 +0530
Message-ID: <20201230045743.14694-3-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201230045743.14694-1-Viswas.G@microchip.com.com>
References: <20201230045743.14694-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: akshatzen <akshatzen@google.com>

When controller runs into fatal error, commands which expect
response get stuck due to no response. If the controller is
in fatal error state, abort request issued to the controller
gets hung too. Hence we should fail it without trying.

Signed-off-by: akshatzen <akshatzen@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  1 +
 drivers/scsi/pm8001/pm8001_sas.c |  9 +++++++++
 drivers/scsi/pm8001/pm8001_sas.h |  2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm80xx_hwi.h | 13 +++++++++++++
 5 files changed, 61 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c8d4d87c5473..f147193d67bd 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4998,4 +4998,5 @@ const struct pm8001_dispatch pm8001_8001_dispatch = {
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
 	.sas_re_init_req	= pm8001_chip_sas_re_initialization,
+	.fatal_errors		= pm80xx_fatal_errors,
 };
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index d1e9dba2ef19..f8d142f9b9ad 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1183,12 +1183,21 @@ int pm8001_abort_task(struct sas_task *task)
 	int rc = TMF_RESP_FUNC_FAILED, ret;
 	u32 phy_id;
 	struct sas_task_slow slow_task;
+
 	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return TMF_RESP_FUNC_FAILED;
+
 	dev = task->dev;
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	phy_id = pm8001_dev->attached_phy;
+
+	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
+		// If the controller is seeing fatal errors
+		// abort task will not get a response from the controller
+		return TMF_RESP_FUNC_FAILED;
+	}
+
 	ret = pm8001_find_tag(task, &tag);
 	if (ret == 0) {
 		pm8001_info(pm8001_ha, "no tag for task:%p\n", task);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index f2c8cbad3853..039ed91e9841 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -215,6 +215,7 @@ struct pm8001_dispatch {
 	int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,
 		u32 state);
 	int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
+	int (*fatal_errors)(struct pm8001_hba_info *pm8001_ha);
 };
 
 struct pm8001_chip_info {
@@ -725,6 +726,7 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
 ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 		struct device_attribute *attr, char *buf);
 ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
+int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
 /* ctl shared API */
 extern struct device_attribute *pm8001_host_attrs[];
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 9c4b8b374ab8..86a3d483749c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1525,6 +1525,41 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	return 0;
 }
 
+/**
+ * pm80xx_fatal_errors - returns non zero *ONLY* when fatal errors
+ * @pm8001_ha: our hba card information
+ *
+ * Fatal errors are recoverable only after a host reboot.
+ */
+int
+pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
+{
+	int ret = 0;
+	u32 scratch_pad_rsvd0 = pm8001_cr32(pm8001_ha, 0,
+					MSGU_HOST_SCRATCH_PAD_6);
+	u32 scratch_pad_rsvd1 = pm8001_cr32(pm8001_ha, 0,
+					MSGU_HOST_SCRATCH_PAD_7);
+	u32 scratch_pad1 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
+	u32 scratch_pad2 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_2);
+	u32 scratch_pad3 = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3);
+
+	if (pm8001_ha->chip_id != chip_8006 &&
+			pm8001_ha->chip_id != chip_8074 &&
+			pm8001_ha->chip_id != chip_8076) {
+		return 0;
+	}
+
+	if (MSGU_SCRATCHPAD1_STATE_FATAL_ERROR(scratch_pad1)) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			"Fatal error SCRATCHPAD1 = 0x%x SCRATCHPAD2 = 0x%x SCRATCHPAD3 = 0x%x SCRATCHPAD_RSVD0 = 0x%x SCRATCHPAD_RSVD1 = 0x%x\n",
+				scratch_pad1, scratch_pad2, scratch_pad3,
+				scratch_pad_rsvd0, scratch_pad_rsvd1);
+		ret = 1;
+	}
+
+	return ret;
+}
+
 /**
  * pm8001_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
  * the FW register status to the originated status.
@@ -4959,4 +4994,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.set_nvmd_req		= pm8001_chip_set_nvmd_req,
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
+	.fatal_errors		= pm80xx_fatal_errors,
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 2b6b52551968..2c8e85cfdbc4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1368,6 +1368,19 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define MSGU_HOST_SCRATCH_PAD_6			0x6C
 #define MSGU_HOST_SCRATCH_PAD_7			0x70
 
+#define MSGU_SCRATCHPAD1_RAAE_STATE_ERR(x) ((x & 0x3) == 0x2)
+#define MSGU_SCRATCHPAD1_ILA_STATE_ERR(x) (((x >> 2) & 0x3) == 0x2)
+#define MSGU_SCRATCHPAD1_BOOTLDR_STATE_ERR(x) ((((x >> 4) & 0x7) == 0x7) || \
+						(((x >> 4) & 0x7) == 0x4))
+#define MSGU_SCRATCHPAD1_IOP0_STATE_ERR(x) (((x >> 10) & 0x3) == 0x2)
+#define MSGU_SCRATCHPAD1_IOP1_STATE_ERR(x) (((x >> 12) & 0x3) == 0x2)
+#define MSGU_SCRATCHPAD1_STATE_FATAL_ERROR(x)  \
+			(MSGU_SCRATCHPAD1_RAAE_STATE_ERR(x) ||      \
+			 MSGU_SCRATCHPAD1_ILA_STATE_ERR(x) ||       \
+			 MSGU_SCRATCHPAD1_BOOTLDR_STATE_ERR(x) ||   \
+			 MSGU_SCRATCHPAD1_IOP0_STATE_ERR(x) ||      \
+			 MSGU_SCRATCHPAD1_IOP1_STATE_ERR(x))
+
 /* bit definition for ODMR register */
 #define ODMR_MASK_ALL			0xFFFFFFFF/* mask all
 					interrupt vector */
-- 
2.16.3

