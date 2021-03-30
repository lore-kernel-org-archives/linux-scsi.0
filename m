Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72EFEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28A136198F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhC3GbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:31:09 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15336 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhC3Gal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085841; x=1648621841;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=W51wzmRePBUy3pERnC7O8SeOyMTaWfk18Dq09z9+xC4=;
  b=hVzNOvhL0fzijUJ6cYhPeDTvwn7yW2faKcSu4uyCd7wEjkOBumdZbJ9U
   jtX9XKRTcyAh+jwpIRRjyAlasBZVJG+9OTG6Ep4ueEBOh8lxhNWsi2690
   pBLmE5ALyNC4Qh08vJa3A5vCEQmpuH2VEodckS00i7pYS9eNkF560w6ql
   T8yVrc6ujGIuEgGOWrc92fPXnO3sWFIpMRivwAP/hTL0WHJwImav0K+DI
   VfkkIQGIbNL5I3QvetrF8RT1EZ2SGBIohJLPhqepbMjAVMv6nMK5NyFaK
   ZQsR1D5bLo/wpB/YN5fsttxr402Y4yX0SacDwBV/P8jsFAX0Qf/v3K9oq
   g==;
IronPort-SDR: kmjWwOqVxFzqz4kyNWBmZbfZTaBTQOJRhJCMKN5zBTrVxWnq+AsKw1xQTOMMZr1iEIox94QDtO
 TPqdNoHCGKnHVPJ6iB7UgDgm8fbBMz/0pdDWyiWS8BQ5G5KxT+eEXzrDpmYOCfFw060cmM7naI
 Y59J/8TGEPVi61cQ6LLZ+uXBxVCUSJe65Qv9YdUtEyRkS2N6IidaU5iMruptDfJwBk2cFvLb6u
 UraLEe5TjIE4ComGFguc9j5UBB0TlagqjIGk55wQFwem6g9UrWgAO9sSF05yw3Ku3HIvVw136n
 l3o=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="114635640"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:40 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:39 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 5/7] pm80xx: Completing pending IO after fatal error
Date:   Tue, 30 Mar 2021 12:10:06 +0530
Message-ID: <20210330064008.9666-6-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210330064008.9666-1-Viswas.G@microchip.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ruksar Devadi <Ruksar.devadi@microchip.com>

When controller runs into fatal error, IOs get stuck with no response,
handler event is defined to complete the pending IOs
(SAS task and internal task) and also perform the cleanup for the
drives.

Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 66 ++++++++++++++++++++++++++++++++++++----
 drivers/scsi/pm8001/pm8001_hwi.h |  1 +
 drivers/scsi/pm8001/pm8001_sas.c |  2 +-
 drivers/scsi/pm8001/pm8001_sas.h |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.h |  1 +
 6 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 49bf2f70a470..4e0ce044ac69 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1499,12 +1499,14 @@ void pm8001_work_fn(struct work_struct *work)
 	 * was cancelled. This nullification happens when the device
 	 * goes away.
 	 */
-	pm8001_dev = pw->data; /* Most stash device structure */
-	if ((pm8001_dev == NULL)
-	 || ((pw->handler != IO_XFER_ERROR_BREAK)
-	  && (pm8001_dev->dev_type == SAS_PHY_UNUSED))) {
-		kfree(pw);
-		return;
+	if (pw->handler != IO_FATAL_ERROR) {
+		pm8001_dev = pw->data; /* Most stash device structure */
+		if ((pm8001_dev == NULL)
+		 || ((pw->handler != IO_XFER_ERROR_BREAK)
+			 && (pm8001_dev->dev_type == SAS_PHY_UNUSED))) {
+			kfree(pw);
+			return;
+		}
 	}
 
 	switch (pw->handler) {
@@ -1668,6 +1670,58 @@ void pm8001_work_fn(struct work_struct *work)
 		dev = pm8001_dev->sas_device;
 		pm8001_I_T_nexus_reset(dev);
 		break;
+	case IO_FATAL_ERROR:
+	{
+		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
+		struct pm8001_ccb_info *ccb;
+		struct task_status_struct *ts;
+		struct sas_task *task;
+		int i;
+		u32 tag, device_id;
+
+		for (i = 0; ccb = NULL, i < PM8001_MAX_CCB; i++) {
+			ccb = &pm8001_ha->ccb_info[i];
+			task = ccb->task;
+			ts = &task->task_status;
+			tag = ccb->ccb_tag;
+			/* check if tag is NULL */
+			if (!tag) {
+				pm8001_dbg(pm8001_ha, FAIL,
+					"tag Null\n");
+				continue;
+			}
+			if (task != NULL) {
+				dev = task->dev;
+				if (!dev) {
+					pm8001_dbg(pm8001_ha, FAIL,
+						"dev is NULL\n");
+					continue;
+				}
+				/*complete sas task and update to top layer */
+				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				ts->resp = SAS_TASK_COMPLETE;
+				task->task_done(task);
+			} else if (tag != 0xFFFFFFFF) {
+				/* complete the internal commands/non-sas task */
+				pm8001_dev = ccb->device;
+				if (pm8001_dev->dcompletion) {
+					complete(pm8001_dev->dcompletion);
+					pm8001_dev->dcompletion = NULL;
+				}
+				complete(pm8001_ha->nvmd_completion);
+				pm8001_tag_free(pm8001_ha, tag);
+			}
+		}
+		/* Deregsiter all the device ids  */
+		for (i = 0; i < PM8001_MAX_DEVICES; i++) {
+			pm8001_dev = &pm8001_ha->devices[i];
+			device_id = pm8001_dev->device_id;
+			if (device_id) {
+				PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+				pm8001_free_dev(pm8001_dev);
+			}
+		}
+	}	break;
 	}
 	kfree(pw);
 }
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index 6d91e2446542..d1f3aa93325b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -805,6 +805,7 @@ struct set_dev_state_resp {
 #define IO_ABORT_IN_PROGRESS				0x40
 #define IO_ABORT_DELAYED				0x41
 #define IO_INVALID_LENGTH				0x42
+#define IO_FATAL_ERROR					0x51
 
 /* WARNING: This error code must always be the last number.
  * If you add error code, modify this code also
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a98d4496ff8b..edec599ac641 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -590,7 +590,7 @@ struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
 	return NULL;
 }
 
-static void pm8001_free_dev(struct pm8001_device *pm8001_dev)
+void pm8001_free_dev(struct pm8001_device *pm8001_dev)
 {
 	u32 id = pm8001_dev->id;
 	memset(pm8001_dev, 0, sizeof(*pm8001_dev));
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 039ed91e9841..36cd37c8c29a 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -727,6 +727,7 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 		struct device_attribute *attr, char *buf);
 ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
+void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
 extern struct device_attribute *pm8001_host_attrs[];
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 84315560e8e1..1aa3a499c85a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4126,6 +4126,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 			pm8001_dbg(pm8001_ha, FAIL,
 				   "Firmware Fatal error! Regval:0x%x\n",
 				   regval);
+			pm8001_handle_event(pm8001_ha, NULL, IO_FATAL_ERROR);
 			print_scratchpad_registers(pm8001_ha);
 			return ret;
 		}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 2c8e85cfdbc4..c7e5d93bea92 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1272,6 +1272,7 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_OPEN_COLLIDE	0x47
 #define IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS_PATHWAY_BLOCKED	0x48
 #define IO_DS_INVALID					0x49
+#define IO_FATAL_ERROR					0x51
 /* WARNING: the value is not contiguous from here */
 #define IO_XFER_ERR_LAST_PIO_DATAIN_CRC_ERR	0x52
 #define IO_XFER_DMA_ACTIVATE_TIMEOUT		0x53
-- 
2.16.3

