Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EE8C2BBC7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 09:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394FE20575
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 09:40:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="sYq5sJOi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgDMJk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 05:40:29 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:36861 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgDMJk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 05:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586770825; x=1618306825;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WbUYDhi0W3WsY0HC4FO8ZwDFutBwy5Q4GPQARzzZ+NE=;
  b=sYq5sJOiuga21EWC55WZVBlR9fhALDp3DKU80JI13UTzMKMgC6UaGpPf
   OwBPVEcMZuoFB1/OATxoFPTh71ssnAdKGkCHI0fkO1RS9lH0wFIsIEqRn
   bEHhDOr8gQxpJpJrGLziTTPUMojJQ7US3u74gN4roK6TNPvmfnU/IaR+F
   AoLMwmD4jnFB4soicc5SwA/6UQnsxmR5Rpz7enwwpi5dUAEju8BhGPgU4
   jBx39RPM180Wr8gPiN2hji2Pq1cg6sjSI3fXzcOHqmrhI/QhQmtYhkq85
   Mdcd/Lsq2wIahGzuiHkZjKn/1w3E9sQWRy2pCV9XjkikZNFb9oFcBTsPM
   w==;
IronPort-SDR: hZFsGSbi4hsYhzL9VmeMzvGdMI9RxzFq90BLBMuyLKRby+RG3UwURnmw1hRZxQHZ4sP1sCaX36
 +wj1KFx5exmV14JoisJe8mChflgk/DdGtbIgrOtdjvbVp/Rv9tDJZyI2I8iUzvUwxQarMHTthM
 86XSgE8PMUsG6U83kldCWujc2DD5Dd9EvebSjavSRCxxcSlm4gUjg1VxjuZfv+eeCE6QCyPcjl
 g2zKuCIPXBxx8Sm7uXZRhNsNidbbaMPJC+3sOc2fqNu209Xe25t3pNGvxLVUwU9Hfe0L4CaON3
 QAQ=
X-IronPort-AV: E=Sophos;i="5.72,378,1580799600"; 
   d="scan'208";a="8942548"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2020 02:40:25 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 13 Apr
 2020 02:40:24 -0700
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Mon, 13 Apr
 2020 02:40:24 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 3/3] pm80xx : Wait for PHY startup before draining libsas queue.
Date:   Mon, 13 Apr 2020 15:19:38 +0530
Message-ID: <20200413094938.6182-4-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200413094938.6182-1-deepak.ukey@microchip.com>
References: <20200413094938.6182-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: peter chang <dpf@google.com>

Until udev rolls out we can't proceed past module loading w/ device
discovery in progress because things like the init scripts only work
over the currently discovered block devices. The drivers for disk
controllers have various forms of 'barriers' to prevent this from
happening depending on their underlying support libraries.
The host's scan finish waits for the libsas queue to drain. However,
if the PHYs are still in the process of starting then the queue will
be empty. This means that we declare the scan finished before it has
even started. Here we wait for various events from the firmware-side,
and even though we disable staggered spinup we still pretend like
it's there.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: peter chang <dpf@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 36 +++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_defs.h |  6 ++--
 drivers/scsi/pm8001/pm8001_init.c | 25 +++++++++++++++
 drivers/scsi/pm8001/pm8001_sas.c  | 61 +++++++++++++++++++++++++++++++++--
 drivers/scsi/pm8001/pm8001_sas.h  |  3 ++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 67 ++++++++++++++++++++++++++++++++-------
 6 files changed, 181 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 3c9f42779dd0..eae629610a5f 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -88,6 +88,41 @@ static ssize_t controller_fatal_error_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(controller_fatal_error);
 
+/**
+ * phy_startup_timeout_show - per-phy discovery timeout
+ * @cdev: pointer to embedded class device
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read/write' shost attribute.
+ */
+static ssize_t phy_startup_timeout_show(struct device *cdev,
+	struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+
+	return snprintf(buf, PAGE_SIZE, "%08xh\n",
+		pm8001_ha->phy_startup_timeout / HZ);
+}
+
+static ssize_t phy_startup_timeout_store(struct device *cdev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	int val = 0;
+
+	if (kstrtoint(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	pm8001_ha->phy_startup_timeout = val * HZ;
+	return strlen(buf);
+}
+
+static DEVICE_ATTR_RW(phy_startup_timeout);
+
 /**
  * pm8001_ctl_fw_version_show - firmware version
  * @cdev: pointer to embedded class device
@@ -867,6 +902,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
 	&dev_attr_controller_fatal_error,
+	&dev_attr_phy_startup_timeout,
 	&dev_attr_fw_version,
 	&dev_attr_update_fw,
 	&dev_attr_aap_log,
diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index fd700ce5e80c..aaeabb2f2808 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -141,7 +141,9 @@ enum pm8001_hba_info_flags {
  */
 #define PHY_LINK_DISABLE	0x00
 #define PHY_LINK_DOWN		0x01
-#define PHY_STATE_LINK_UP_SPCV	0x2
-#define PHY_STATE_LINK_UP_SPC	0x1
+#define PHY_STATE_LINK_UP_SPCV	0x02
+#define PHY_STATE_LINK_UP_SPC	0x01
+#define PHY_STATE_LINK_RESET	0x03
+#define PHY_STATE_HARD_RESET	0x04
 
 #endif
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 6cbb8fa74456..560dd9c3f745 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -61,6 +61,30 @@ MODULE_PARM_DESC(staggered_spinup, "enable the staggered spinup feature.\n"
 		" 0/N: false\n"
 		" 1/Y: true\n");
 
+/* if nothing is detected, the PHYs will reset continuously once they
+ * are started. we don't have a good way of differentiating a trained
+ * but waiting-on-signature from one that's never going to train
+ * (nothing attached or dead drive), so we wait an possibly
+ * unreasonable amount of time. this is stuck in start_timeout, and
+ * checked in the host's scan_finished callback for PHYs that haven't
+ * yet come up.
+ *
+ * the timeout here was experimentally determined by looking at our
+ * current worst-case spin-up drive (seagate 8T) which has
+ * the most drive-to-drive variance, some issues coming up from the
+ * sleep state (randomly applied ~10s delay to non-data operations),
+ * and errors from IDENTIFY.
+ *
+ * NB: this a workaround to handle current lack of udev. once
+ * that's everywhere and dynamically dealing w/ device add/remove
+ * (step one doesn't deal w/ this later condition) then the patches
+ * can be removed.
+ */
+static ulong phy_startup_timeout = 60;
+module_param(phy_startup_timeout, ulong, 0644);
+MODULE_PARM_DESC(phy_startup_timeout_s,
+		" seconds to wait for discovery, per-PHY.");
+
 static struct scsi_transport_template *pm8001_stt;
 
 /**
@@ -493,6 +517,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = logging_level;
 	pm8001_ha->staggered_spinup = staggered_spinup;
+	pm8001_ha->phy_startup_timeout = phy_startup_timeout * HZ;
 	pm8001_ha->non_fatal_count = 0;
 	if (link_rate >= 1 && link_rate <= 15)
 		pm8001_ha->link_rate = (link_rate << 8);
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 806845203602..470fe4dd3b52 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -39,6 +39,7 @@
  */
 
 #include <linux/slab.h>
+#include "pm80xx_hwi.h"
 #include "pm8001_sas.h"
 
 /**
@@ -257,6 +258,54 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	return rc;
 }
 
+static int pm8001_update_phy_mask(struct pm8001_hba_info *pm8001_ha)
+{
+	struct phy_profile *profile = &pm8001_ha->phy_profile_resp.phy.status;
+	DECLARE_COMPLETION_ONSTACK(comp);
+	unsigned long timeout = msecs_to_jiffies(2000);
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
+		struct pm8001_phy *phy = pm8001_ha->phy + i;
+
+		if (pm8001_ha->phy_mask & (1 << i) && phy->phy_state) {
+			pm8001_ha->phyprofile_completion = &comp;
+			ret = PM8001_CHIP_DISP->get_phy_profile_req(pm8001_ha,
+				i, SAS_PHY_GENERAL_STATUS_PAGE);
+			if (ret != 0) {
+				pm8001_printk("get_phy_profile_req:%d:%d\n",
+					i, ret);
+				return ret;
+			}
+			timeout = wait_for_completion_timeout(&comp, timeout);
+			if (timeout == 0)
+				return ret;
+			PM8001_DISC_DBG(pm8001_ha,
+				pm8001_printk("phy_id:%d state:%x nlr:%d plr:%d\n",
+					i,
+					profile->phy_state,
+					profile->nlr, profile->plr));
+			switch (profile->phy_state) {
+			case PHY_STATE_LINK_UP_SPCV:
+			case PHY_STATE_LINK_RESET:
+			case PHY_STATE_HARD_RESET:
+				/* these are handled by mpi_hw_event() */
+				break;
+			case PHY_LINK_DOWN:
+				if (time_is_after_jiffies(phy->start_timeout))
+					break;
+				clear_bit(i, &pm8001_ha->phy_mask);
+				break;
+			default:
+				clear_bit(i, &pm8001_ha->phy_mask);
+				break;
+			}
+		}
+	}
+	return ret;
+}
+
 /**
   * pm8001_scan_start - we should enable all HBA phys by sending the phy_start
   * command to HBA.
@@ -273,6 +322,8 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 	if (pm8001_ha->chip_id == chip_8001)
 		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
 
+	pm8001_ha->phy_mask = 0;
+
 	if (pm8001_ha->pdev->device == 0x8001 ||
 		pm8001_ha->pdev->device == 0x8081 ||
 		(pm8001_ha->spinup_interval != 0)) {
@@ -304,11 +355,15 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = ha->lldd_ha;
 
-	/* give the phy enabling interrupt event time to come in (1s
-	* is empirically about all it takes) */
-	if (time < HZ)
+	/* Wait for PHY startup to finish */
+	PM8001_DISC_DBG(pm8001_ha,
+		pm8001_printk("mask:%lx\n", pm8001_ha->phy_mask));
+	if (pm8001_ha->phy_mask) {
+		pm8001_update_phy_mask(pm8001_ha);
 		return 0;
+	}
 
 	/* Wait for discovery to finish */
 	sas_drain_work(ha);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index df02c6cd116a..bb4f099a1723 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -283,6 +283,7 @@ struct pm8001_phy {
 	struct completion	*reset_completion;
 	bool			port_reset_status;
 	bool			reset_success;
+	unsigned long		start_timeout;
 };
 
 /* port reset status */
@@ -579,6 +580,8 @@ struct pm8001_hba_info {
 	int			phy_head;
 	int			phy_tail;
 	spinlock_t		phy_q_lock;
+	unsigned long		phy_mask;
+	u32			phy_startup_timeout;
 };
 
 struct pm8001_work {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 0040bb4e1b71..190a7351c1e8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -80,18 +80,26 @@ void pm8001_spinup_timedout(struct timer_list *t)
 		if (i++ >= pm8001_ha->spinup_group && pm8001_ha->spinup_group)
 			break;
 
-		if (pm8001_ha->phy_head == -1 || pm8001_ha->reset_in_progress)
-			break; /* No phys to spinup */
-
-		phy_id = pm8001_ha->phy_up[pm8001_ha->phy_head];
-		/* Processed phy id, make it invalid 0xff for
-		 * checking repeated phy ups
-		 */
-		pm8001_ha->phy_up[pm8001_ha->phy_head] = 0xff;
-		if (pm8001_ha->phy_head == pm8001_ha->phy_tail) {
-			pm8001_ha->phy_head = pm8001_ha->phy_tail = -1;
+		if (pm8001_ha->phy_head == -1 ||
+				pm8001_ha->reset_in_progress) {
+			/* No phys to spinup or timeout */
+			if (pm8001_ha->phy_mask) {
+				pm8001_printk("spinup timeout phy_mask:%lx\n",
+					pm8001_ha->phy_mask);
+				pm8001_ha->phy_mask = 0;
+			}
+			break;
 		} else {
-			pm8001_ha->phy_head =
+			phy_id = pm8001_ha->phy_up[pm8001_ha->phy_head];
+			/* Processed phy id, make it invalid 0xff for
+			 * checking repeated phy ups
+			 */
+			pm8001_ha->phy_up[pm8001_ha->phy_head] = 0xff;
+			if (pm8001_ha->phy_head == pm8001_ha->phy_tail)
+				pm8001_ha->phy_head =
+					pm8001_ha->phy_tail = -1;
+			else
+				pm8001_ha->phy_head =
 				(pm8001_ha->phy_head+1) % PM8001_MAX_PHYS;
 		}
 
@@ -3584,8 +3592,10 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		phy->enable_completion = NULL;
 	}
 
-	return 0;
+	if (!phy->phy_state)
+		clear_bit(phy_id, &pm8001_ha->phy_mask);
 
+	return 0;
 }
 
 /**
@@ -3646,6 +3656,36 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_printk("portid:%d phyid:%d event:0x%x status:0x%x\n",
 				port_id, phy_id, eventType, status));
 
+	switch (eventType) {
+		/* the PHY has completed startup and possibly queued
+		 * stuff to the libsas side, so we no longer have to
+		 * track that it is in the middle of doing something
+		 * that libsas doesn't know about.
+		 */
+	case HW_EVENT_SAS_PHY_UP:
+	case HW_EVENT_SATA_PHY_UP:
+	case HW_EVENT_PHY_DOWN:
+	case HW_EVENT_PORT_INVALID:
+	case HW_EVENT_BROADCAST_CHANGE:
+	case HW_EVENT_PHY_ERROR:
+	case HW_EVENT_HARD_RESET_RECEIVED:
+	case HW_EVENT_ID_FRAME_TIMEOUT:
+	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
+	case HW_EVENT_PORT_RESET_TIMER_TMO:
+	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
+	case HW_EVENT_PORT_RECOVER:
+		clear_bit(phy_id, &pm8001_ha->phy_mask);
+		break;
+		/* we may have already gotten the response from the
+		 * PHY, but if the PHY was powered off then this event
+		 * signals that there is more in-flight and we have
+		 * restarted the the spinup timer.
+		 */
+	case HW_EVENT_SATA_SPINUP_HOLD:
+		set_bit(phy_id, &pm8001_ha->phy_mask);
+		break;
+	}
+
 	switch (eventType) {
 
 	case HW_EVENT_SAS_PHY_UP:
@@ -4976,6 +5016,9 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
+	set_bit(phy_id, &pm8001_ha->phy_mask);
+	pm8001_ha->phy[phy_id].start_timeout =
+		jiffies + pm8001_ha->phy_startup_timeout;
 
 	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_ENABLE |
 			LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
-- 
2.16.3

