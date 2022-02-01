Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E01C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbiBAVsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:32 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38010 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiBAVsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752110; x=1675288110;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dPx9KQ8uxdEoym0zFezuZVm5BbPDYSZ52CTdf5DXXLg=;
  b=bZF1K9QT/IXP2RcyY0BmzT1JLdWeAAIlADb8HDVPj74bpPllKAoGCW+s
   iQAI/hCRG/uuD+B9H/hdwwNQph+G5kct7ariQzPRqwZ63+PP9xk/8Pv68
   QnkTQVRsxhxzZ957SpupjO5AQiNO5fVkmNZCyJUWeNytyPCyutkiQXyXI
   1WqAQ7HjoSFS90PDk14bztvmSa1I1LdoUY0QtyeIfkWqGF8jGAFziRqUP
   pUlJQ++ANQoXjGeg/V5h4sYxfoxBlIgoXsSZMKqhtrVjfmQvvk1s6ifOR
   HO+XOkTSsiWMNLTcp0RES1jKo25kbkBC7OzVVnCdce8mqZgQdORi2c+kJ
   w==;
IronPort-SDR: 1C+JTRzyaP7dGTYr5Qv500z0avFFKfBvmMGn+JMFjt1a5HribGuxVU8m0y/LnPfyb+Wkawm2d4
 wVtp3b/oBYGAlGbv59vVTyWK4qxmgZDCSaU144i6kqf+BUIZ9MdZDx7vbas50F9tVMfgtI2xFv
 boPaOZnspmTLp7zSniigCrJ70C4oywE3GRpUohDO2i3z84HwMtSEd8iiPFvYSZM/PvlVMD9BFs
 eQX72eTpW/B2YkClxPKWTqOr3vyelYF/X1mCoOln+IVW7t6cw/gXYj6RDINd+cV53ee7Zy28yV
 Pc/xUFpeWtlNY2RWtXnGLldI
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="147312681"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:29 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:28 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:28 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 4822670236E;
        Tue,  1 Feb 2022 15:48:28 -0600 (CST)
Subject: [PATCH 08/18] smartpqi: resolve delay issue with PQI_HZ value
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:28 -0600
Message-ID: <164375210825.440833.15510172447583227486.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microchip.com>

Change PQI_HZ to HZ.

PQI_HZ macro was set to 1000 when HZ value is less than 1000.
By default, PQI_HZ will result into a delay of 10 seconds(for kernel,
which has HZ = 100). So in this case when firmware raises an event,
rescan worker will be scheduled after a delay of (10 x PQI_HZ) = 100
seconds instead of 10 seconds.

Also driver uses PQI_HZ at many instances, which might result in some
other issues with respect to delay.

Align driver with our out-of-box driver for timeout values.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Balsundar P <balsundar.p@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    6 ------
 drivers/scsi/smartpqi/smartpqi_init.c |   32 ++++++++++++++++----------------
 drivers/scsi/smartpqi/smartpqi_sis.c  |    8 ++++----
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index f192745ee488..81ec5fbf570a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -96,12 +96,6 @@ struct pqi_ctrl_registers {
 	struct pqi_device_registers pqi_registers;	/* 4000h */
 };
 
-#if ((HZ) < 1000)
-#define PQI_HZ  1000
-#else
-#define PQI_HZ  (HZ)
-#endif
-
 #define PQI_DEVICE_REGISTERS_OFFSET	0x4000
 
 /* shutdown reasons for taking the controller offline */
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 075e41b5ceaa..b32a5a5a5c21 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -376,7 +376,7 @@ static inline void pqi_ctrl_wait_until_quiesced(struct pqi_ctrl_info *ctrl_info)
 
 	displayed_warning = false;
 	start_jiffies = jiffies;
-	warning_timeout = (PQI_QUIESCE_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
+	warning_timeout = (PQI_QUIESCE_WARNING_TIMEOUT_SECS * HZ) + start_jiffies;
 
 	while (atomic_read(&ctrl_info->num_busy_threads) >
 		atomic_read(&ctrl_info->num_blocked_threads)) {
@@ -385,7 +385,7 @@ static inline void pqi_ctrl_wait_until_quiesced(struct pqi_ctrl_info *ctrl_info)
 				"waiting %u seconds for driver activity to quiesce\n",
 				jiffies_to_msecs(jiffies - start_jiffies) / 1000);
 			displayed_warning = true;
-			warning_timeout = (PQI_QUIESCE_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
+			warning_timeout = (PQI_QUIESCE_WARNING_TIMEOUT_SECS * HZ) + jiffies;
 		}
 		usleep_range(1000, 2000);
 	}
@@ -462,7 +462,7 @@ static inline void pqi_schedule_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 	pqi_schedule_rescan_worker_with_delay(ctrl_info, 0);
 }
 
-#define PQI_RESCAN_WORK_DELAY	(10 * PQI_HZ)
+#define PQI_RESCAN_WORK_DELAY	(10 * HZ)
 
 static inline void pqi_schedule_rescan_worker_delayed(struct pqi_ctrl_info *ctrl_info)
 {
@@ -1038,7 +1038,7 @@ static int pqi_write_current_time_to_host_wellness(
 	return rc;
 }
 
-#define PQI_UPDATE_TIME_WORK_INTERVAL	(24UL * 60 * 60 * PQI_HZ)
+#define PQI_UPDATE_TIME_WORK_INTERVAL	(24UL * 60 * 60 * HZ)
 
 static void pqi_update_time_worker(struct work_struct *work)
 {
@@ -3045,7 +3045,7 @@ static int pqi_wait_for_pqi_mode_ready(struct pqi_ctrl_info *ctrl_info)
 	u8 status;
 
 	pqi_registers = ctrl_info->pqi_registers;
-	timeout = (PQI_MODE_READY_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	timeout = (PQI_MODE_READY_TIMEOUT_SECS * HZ) + jiffies;
 
 	while (1) {
 		signature = readq(&pqi_registers->signature);
@@ -3539,7 +3539,7 @@ static enum pqi_soft_reset_status pqi_poll_for_soft_reset_status(
 	u8 status;
 	unsigned long timeout;
 
-	timeout = (PQI_SOFT_RESET_STATUS_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	timeout = (PQI_SOFT_RESET_STATUS_TIMEOUT_SECS * HZ) + jiffies;
 
 	while (1) {
 		status = pqi_read_soft_reset_status(ctrl_info);
@@ -3717,7 +3717,7 @@ static void pqi_event_worker(struct work_struct *work)
 	pqi_ctrl_unbusy(ctrl_info);
 }
 
-#define PQI_HEARTBEAT_TIMER_INTERVAL	(10 * PQI_HZ)
+#define PQI_HEARTBEAT_TIMER_INTERVAL	(10 * HZ)
 
 static void pqi_heartbeat_timer_handler(struct timer_list *t)
 {
@@ -4264,7 +4264,7 @@ static int pqi_alloc_admin_queues(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
-#define PQI_ADMIN_QUEUE_CREATE_TIMEOUT_JIFFIES		PQI_HZ
+#define PQI_ADMIN_QUEUE_CREATE_TIMEOUT_JIFFIES		HZ
 #define PQI_ADMIN_QUEUE_CREATE_POLL_INTERVAL_MSECS	1
 
 static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
@@ -4358,7 +4358,7 @@ static int pqi_poll_for_admin_response(struct pqi_ctrl_info *ctrl_info,
 	admin_queues = &ctrl_info->admin_queues;
 	oq_ci = admin_queues->oq_ci_copy;
 
-	timeout = (PQI_ADMIN_REQUEST_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	timeout = (PQI_ADMIN_REQUEST_TIMEOUT_SECS * HZ) + jiffies;
 
 	while (1) {
 		oq_pi = readl(admin_queues->oq_pi);
@@ -4473,7 +4473,7 @@ static int pqi_wait_for_completion_io(struct pqi_ctrl_info *ctrl_info,
 
 	while (1) {
 		if (wait_for_completion_io_timeout(wait,
-			PQI_WAIT_FOR_COMPLETION_IO_TIMEOUT_SECS * PQI_HZ)) {
+			PQI_WAIT_FOR_COMPLETION_IO_TIMEOUT_SECS * HZ)) {
 			rc = 0;
 			break;
 		}
@@ -6065,7 +6065,7 @@ static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
 
 	displayed_warning = false;
 	start_jiffies = jiffies;
-	warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
+	warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * HZ) + start_jiffies;
 
 	while (1) {
 		queued_io_count = pqi_queued_io_count(ctrl_info);
@@ -6080,7 +6080,7 @@ static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
 				"waiting %u seconds for queued I/O to drain (queued I/O count: %u; non-empty inbound queue count: %u)\n",
 				jiffies_to_msecs(jiffies - start_jiffies) / 1000, queued_io_count, nonempty_inbound_queue_count);
 			displayed_warning = true;
-			warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
+			warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * HZ) + jiffies;
 		}
 		usleep_range(1000, 2000);
 	}
@@ -6148,7 +6148,7 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 	unsigned long msecs_waiting;
 
 	start_jiffies = jiffies;
-	warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
+	warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * HZ) + start_jiffies;
 
 	while ((cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding)) > 0) {
 		pqi_check_ctrl_health(ctrl_info);
@@ -6167,7 +6167,7 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 				"scsi %d:%d:%d:%d: waiting %lu seconds for %d outstanding command(s)\n",
 				ctrl_info->scsi_host->host_no, device->bus, device->target,
 				device->lun, msecs_waiting / 1000, cmds_outstanding);
-			warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
+			warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * HZ) + jiffies;
 		}
 		usleep_range(1000, 2000);
 	}
@@ -6196,7 +6196,7 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 
 	while (1) {
 		if (wait_for_completion_io_timeout(wait,
-			PQI_LUN_RESET_POLL_COMPLETION_SECS * PQI_HZ)) {
+			PQI_LUN_RESET_POLL_COMPLETION_SECS * HZ)) {
 			rc = 0;
 			break;
 		}
@@ -7994,7 +7994,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 				return rc;
 		}
 		sis_soft_reset(ctrl_info);
-		msleep(PQI_POST_RESET_DELAY_SECS * PQI_HZ);
+		ssleep(PQI_POST_RESET_DELAY_SECS);
 	} else {
 		rc = pqi_force_sis_mode(ctrl_info);
 		if (rc)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index d66eb8ea161c..e176a1a0534d 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -92,7 +92,7 @@ static int sis_wait_for_ctrl_ready_with_timeout(struct pqi_ctrl_info *ctrl_info,
 	unsigned long timeout;
 	u32 status;
 
-	timeout = (timeout_secs * PQI_HZ) + jiffies;
+	timeout = (timeout_secs * HZ) + jiffies;
 
 	while (1) {
 		status = readl(&ctrl_info->registers->sis_firmware_status);
@@ -209,7 +209,7 @@ static int sis_send_sync_cmd(struct pqi_ctrl_info *ctrl_info,
 	 * the top of the loop in order to give the controller time to start
 	 * processing the command before we start polling.
 	 */
-	timeout = (SIS_CMD_COMPLETE_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	timeout = (SIS_CMD_COMPLETE_TIMEOUT_SECS * HZ) + jiffies;
 	while (1) {
 		msleep(SIS_CMD_COMPLETE_POLL_INTERVAL_MSECS);
 		doorbell = readl(&registers->sis_ctrl_to_host_doorbell);
@@ -355,7 +355,7 @@ static int sis_wait_for_doorbell_bit_to_clear(
 	u32 doorbell_register;
 	unsigned long timeout;
 
-	timeout = (SIS_DOORBELL_BIT_CLEAR_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	timeout = (SIS_DOORBELL_BIT_CLEAR_TIMEOUT_SECS * HZ) + jiffies;
 
 	while (1) {
 		doorbell_register =
@@ -452,7 +452,7 @@ int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
 	enum sis_fw_triage_status status;
 	unsigned long timeout;
 
-	timeout = (SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS * PQI_HZ) + jiffies;
+	timeout = (SIS_FW_TRIAGE_STATUS_TIMEOUT_SECS * HZ) + jiffies;
 	while (1) {
 		status = sis_read_firmware_triage_status(ctrl_info);
 		if (status == FW_TRIAGE_COND_INVALID) {


