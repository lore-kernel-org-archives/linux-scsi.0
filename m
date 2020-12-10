Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A257C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3A723E24
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404152AbgLJUhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:37:45 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:55403 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389519AbgLJUhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632659; x=1639168659;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A0rltSlGzDj+/ei1w/c3iTnWvAxATxirAR4sUEBjpJw=;
  b=Yx2mjT+y8Fb1vCK4cr8LyPn+aYgRxcJZG7yOuyhqF1bfiWRseY5G4H1l
   1rf8ZOBOWbkDF4ZzS5Zs2+Rbr6aCG6Vao2rweCwYtiQTGLRjrzqjkucuy
   zGJwdaHvYfSy1/QZm4MUW7G2VRl2IGVX8l89N3eu6zTOdazWzbMZroezO
   Q3rPTfwyekoKgXLbC5mZM0i08Hi9cyag0hPCiPEaY0dnKd9LU4dEyiWsU
   AfQuC4giHK4EQdamahRk1E6Hsuo9GBFPfLsrSwspdVYUS21mRRp5vRgG0
   Lq7AOV7o/d/nm5qYm2COf25wlG2y4yYOE8WBInjRmww9IeDDU47WYBDL8
   A==;
IronPort-SDR: /vjYcCI4VZCkkPLJB6fq2KTgLe3PtU0duC7LExqUKdSDZyiyz2q30hUvLwyn38ntD0E2gw4oWf
 PLKK8ahwJaUgppLAXDn2S1uw9a5SjLYps4jzN4S1Ta9KYUwJ2KJYiysU7JGQhxcGl/7BbRO0H+
 1jCVOJYbHJd+zwkqS6h6Hs/cq8uryZM8jcMzaojmxjf2E+77ycZqoq4kcZzyY2HtuNp33bYwZG
 DwP+KlC2RbOe/1yttUnbyZYTjbSWFuGITqZ4gznztWRfiH3OxDxV/De6aXuRHwalSHdyGWrgJX
 /UM=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="36986837"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:36:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:36:23 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:36:22 -0700
Subject: [PATCH V3 21/25] smartpqi: add additional logging for LUN resets
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:36:22 -0600
Message-ID: <160763258244.26927.17723549050349595895.stgit@brunhilda>
In-Reply-To: <160763241302.26927.17487238067261230799.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

* Add additional logging to help in debugging issues
  with LUN resets.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |  125 +++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6b624413c8e6..1c51a59f1da6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -84,7 +84,7 @@ static void pqi_ofa_setup_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static void pqi_ofa_free_host_buffer(struct pqi_ctrl_info *ctrl_info);
 static int pqi_ofa_host_memory_update(struct pqi_ctrl_info *ctrl_info);
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, unsigned long timeout_secs);
+	struct pqi_scsi_dev *device, unsigned long timeout_msecs);
 
 /* for flags argument to pqi_submit_raid_request_synchronous() */
 #define PQI_SYNC_FLAGS_INTERRUPTABLE	0x1
@@ -335,11 +335,34 @@ static void pqi_wait_if_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
 	atomic_dec(&ctrl_info->num_blocked_threads);
 }
 
+#define PQI_QUIESE_WARNING_TIMEOUT_SECS		10
+
 static inline void pqi_ctrl_wait_until_quiesced(struct pqi_ctrl_info *ctrl_info)
 {
+	unsigned long start_jiffies;
+	unsigned long warning_timeout;
+	bool displayed_warning;
+
+	displayed_warning = false;
+	start_jiffies = jiffies;
+	warning_timeout = (PQI_QUIESE_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
+
 	while (atomic_read(&ctrl_info->num_busy_threads) >
-		atomic_read(&ctrl_info->num_blocked_threads))
+		atomic_read(&ctrl_info->num_blocked_threads)) {
+		if (time_after(jiffies, warning_timeout)) {
+			dev_warn(&ctrl_info->pci_dev->dev,
+				"waiting %u seconds for driver activity to quiesce\n",
+				jiffies_to_msecs(jiffies - start_jiffies) / 1000);
+			displayed_warning = true;
+			warning_timeout = (PQI_QUIESE_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
+		}
 		usleep_range(1000, 2000);
+	}
+
+	if (displayed_warning)
+		dev_warn(&ctrl_info->pci_dev->dev,
+			"driver activity quiesced after waiting for %u seconds\n",
+			jiffies_to_msecs(jiffies - start_jiffies) / 1000);
 }
 
 static inline bool pqi_device_offline(struct pqi_scsi_dev *device)
@@ -1670,7 +1693,7 @@ static int pqi_add_device(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-#define PQI_PENDING_IO_TIMEOUT_SECS	20
+#define PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS	(20 * 1000)
 
 static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
 {
@@ -1678,7 +1701,8 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info, struct pqi
 
 	pqi_device_remove_start(device);
 
-	rc = pqi_device_wait_for_pending_io(ctrl_info, device, PQI_PENDING_IO_TIMEOUT_SECS);
+	rc = pqi_device_wait_for_pending_io(ctrl_info, device,
+		PQI_REMOVE_DEVICE_PENDING_IO_TIMEOUT_MSECS);
 	if (rc)
 		dev_err(&ctrl_info->pci_dev->dev,
 			"scsi %d:%d:%d:%d removing device with %d outstanding command(s)\n",
@@ -3070,7 +3094,7 @@ static void pqi_process_io_error(unsigned int iu_type,
 	}
 }
 
-static int pqi_interpret_task_management_response(
+static int pqi_interpret_task_management_response(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_task_management_response *response)
 {
 	int rc;
@@ -3088,6 +3112,10 @@ static int pqi_interpret_task_management_response(
 		break;
 	}
 
+	if (rc)
+		dev_err(&ctrl_info->pci_dev->dev,
+			"Task Management Function error: %d (response code: %u)\n", rc, response->response_code);
+
 	return rc;
 }
 
@@ -3156,9 +3184,8 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 				&((struct pqi_vendor_general_response *)response)->status);
 			break;
 		case PQI_RESPONSE_IU_TASK_MANAGEMENT:
-			io_request->status =
-				pqi_interpret_task_management_response(
-					(void *)response);
+			io_request->status = pqi_interpret_task_management_response(ctrl_info,
+				(void *)response);
 			break;
 		case PQI_RESPONSE_IU_AIO_PATH_DISABLED:
 			pqi_aio_path_disabled(io_request);
@@ -5862,24 +5889,37 @@ static void pqi_fail_io_queued_for_device(struct pqi_ctrl_info *ctrl_info,
 	}
 }
 
+#define PQI_PENDING_IO_WARNING_TIMEOUT_SECS	10
+
 static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device, unsigned long timeout_secs)
+	struct pqi_scsi_dev *device, unsigned long timeout_msecs)
 {
-	unsigned long timeout;
+	int cmds_outstanding;
+	unsigned long start_jiffies;
+	unsigned long warning_timeout;
+	unsigned long msecs_waiting;
 
+	start_jiffies = jiffies;
+	warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
 
-	timeout = (timeout_secs * PQI_HZ) + jiffies;
-
-	while (atomic_read(&device->scsi_cmds_outstanding)) {
+	while ((cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding)) > 0) {
 		pqi_check_ctrl_health(ctrl_info);
 		if (pqi_ctrl_offline(ctrl_info))
 			return -ENXIO;
-		if (timeout_secs != NO_TIMEOUT) {
-			if (time_after(jiffies, timeout)) {
-				dev_err(&ctrl_info->pci_dev->dev,
-					"timed out waiting for pending I/O\n");
-				return -ETIMEDOUT;
-			}
+		msecs_waiting = jiffies_to_msecs(jiffies - start_jiffies);
+		if (msecs_waiting > timeout_msecs) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"scsi %d:%d:%d:%d: timed out after %lu seconds waiting for %d outstanding command(s)\n",
+				ctrl_info->scsi_host->host_no, device->bus, device->target,
+				device->lun, msecs_waiting / 1000, cmds_outstanding);
+			return -ETIMEDOUT;
+		}
+		if (time_after(jiffies, warning_timeout)) {
+			dev_warn(&ctrl_info->pci_dev->dev,
+				"scsi %d:%d:%d:%d: waiting %lu seconds for %d outstanding command(s)\n",
+				ctrl_info->scsi_host->host_no, device->bus, device->target,
+				device->lun, msecs_waiting / 1000, cmds_outstanding);
+			warning_timeout = (PQI_PENDING_IO_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
 		}
 		usleep_range(1000, 2000);
 	}
@@ -5895,13 +5935,15 @@ static void pqi_lun_reset_complete(struct pqi_io_request *io_request,
 	complete(waiting);
 }
 
-#define PQI_LUN_RESET_TIMEOUT_SECS		30
 #define PQI_LUN_RESET_POLL_COMPLETION_SECS	10
 
 static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device, struct completion *wait)
 {
 	int rc;
+	unsigned int wait_secs;
+
+	wait_secs = 0;
 
 	while (1) {
 		if (wait_for_completion_io_timeout(wait,
@@ -5915,13 +5957,21 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 			rc = -ENXIO;
 			break;
 		}
+
+		wait_secs += PQI_LUN_RESET_POLL_COMPLETION_SECS;
+
+		dev_warn(&ctrl_info->pci_dev->dev,
+			"scsi %d:%d:%d:%d: waiting %u seconds for LUN reset to complete\n",
+			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun,
+			wait_secs);
 	}
 
 	return rc;
 }
 
-static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+#define PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS	30
+
+static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
 {
 	int rc;
 	struct pqi_io_request *io_request;
@@ -5943,8 +5993,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 		sizeof(request->lun_number));
 	request->task_management_function = SOP_TASK_MANAGEMENT_LUN_RESET;
 	if (ctrl_info->tmf_iu_timeout_supported)
-		put_unaligned_le16(PQI_LUN_RESET_TIMEOUT_SECS,
-					&request->timeout);
+		put_unaligned_le16(PQI_LUN_RESET_FIRMWARE_TIMEOUT_SECS, &request->timeout);
 
 	pqi_start_io(ctrl_info, &ctrl_info->queue_groups[PQI_DEFAULT_QUEUE_GROUP], RAID_PATH,
 		io_request);
@@ -5958,29 +6007,33 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 	return rc;
 }
 
-#define PQI_LUN_RESET_RETRIES			3
-#define PQI_LUN_RESET_RETRY_INTERVAL_MSECS	10000
-#define PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS	120
+#define PQI_LUN_RESET_RETRIES				3
+#define PQI_LUN_RESET_RETRY_INTERVAL_MSECS		(10 * 1000)
+#define PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS		(10 * 60 * 1000)
+#define PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS	(2 * 60 * 1000)
 
-static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_scsi_dev *device)
+static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device)
 {
-	int rc;
+	int reset_rc;
+	int wait_rc;
 	unsigned int retries;
-	unsigned long timeout_secs;
+	unsigned long timeout_msecs;
 
 	for (retries = 0;;) {
-		rc = pqi_lun_reset(ctrl_info, device);
-		if (rc == 0 || ++retries > PQI_LUN_RESET_RETRIES)
+		reset_rc = pqi_lun_reset(ctrl_info, device);
+		if (reset_rc == 0 || ++retries > PQI_LUN_RESET_RETRIES)
 			break;
 		msleep(PQI_LUN_RESET_RETRY_INTERVAL_MSECS);
 	}
 
-	timeout_secs = rc ? PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS : NO_TIMEOUT;
+	timeout_msecs = reset_rc ? PQI_LUN_RESET_FAILED_PENDING_IO_TIMEOUT_MSECS :
+		PQI_LUN_RESET_PENDING_IO_TIMEOUT_MSECS;
 
-	rc |= pqi_device_wait_for_pending_io(ctrl_info, device, timeout_secs);
+	wait_rc = pqi_device_wait_for_pending_io(ctrl_info, device, timeout_msecs);
+	if (wait_rc && reset_rc == 0)
+		reset_rc = wait_rc;
 
-	return rc == 0 ? SUCCESS : FAILED;
+	return reset_rc == 0 ? SUCCESS : FAILED;
 }
 
 static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,

