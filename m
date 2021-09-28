Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A38C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA9260551
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243339AbhI1X4Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:12981 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243311AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873283; x=1664409283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m2gGiF1cdcDtUhzT+AuFotiejxMqJpUYD6vix8pxcto=;
  b=c8gPAFP+Pj6H7Z/rGZOGgzirk0jYptBSt7a9ncfAW4rRhjCiV8cTOSV9
   gHi2Rz0/wgOJa9BlLZkcyxFUBrI7IJN6SlgVB2okMxMhzkr4ST5bUyy5e
   maLVu2wjfzA0KccrD0ZiGqab+hc3fbLC7kU6dPt6dp9+JrXjNR09+YU52
   XYTaE4GyKLuWGbCZX/Y7/5Lv/MINWP1N/MsED56nYdiVg4D4APdvldwrf
   Gg+2b9dTDHnW2sKFaGNQhAJPwXCGmhyFE3uFjEHrP+emRLCLQQUXt0SAh
   ZBgvhZSMUB3qCf81qh+LSMbYBelZCjBkqN8dLUfE9DQq/HGFgQ/s6JuMA
   w==;
IronPort-SDR: Zq7GM6b51oDMWEcUclpzvDSQpeQK0aJa/pfBORBfGEEaSOWoGpwkYHGpx4GJ6T7c2abxJ6rcHj
 qlqCZHKg+Nr+YKudxwaY3h6dB9LFUXaAQz2XMO6VYW7yH2k0860de22gqTMiTh/SV2IfpRZRvV
 PEqP5q3hOfbPfa5LTUGGXnuYNOWJyUEXMR1YFr9l78xvZ45clDVHKSlb79Vt/noOmXIAop5GaW
 js39UjRY6NXnW5Pu62Vqz4Z+Hvy/iGLKW2PqQNGt4O4jkRDUz3bPo1wJcTQ3whSF97THQFC36S
 zKBatR+yBWeJQUDTJ2J/HveM
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="70994974"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 71E9970287A; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 04/11] smartpqi: update LUN reset handler
Date:   Tue, 28 Sep 2021 18:54:35 -0500
Message-ID: <20210928235442.201875-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Enhance check for commands queued to the controller.
 - Add new function pqi_nonempty_inbound_queue_count that
   will wait for all I/O queued for submission to controller
   across all queue groups to drain. Add helper functions
   to obtain queue command counts for each queue group.
   These queues should drain quickly as they are already staged
   to be submitted down to the controller's IB queue.
Enhance check for outstanding command completion.
 - Update the count of outstanding commands while waiting.
   This value was not re-obtained and was potentially causing
   infinite wait for all completions.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 105 ++++++++++++++++----------
 1 file changed, 66 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b6ac4d607664..01330fd67500 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5799,64 +5799,91 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 	return rc;
 }
 
-static int pqi_wait_until_queued_io_drained(struct pqi_ctrl_info *ctrl_info,
-	struct pqi_queue_group *queue_group)
+static unsigned int pqi_queued_io_count(struct pqi_ctrl_info *ctrl_info)
 {
+	unsigned int i;
 	unsigned int path;
 	unsigned long flags;
-	bool list_is_empty;
+	unsigned int queued_io_count;
+	struct pqi_queue_group *queue_group;
+	struct pqi_io_request *io_request;
 
-	for (path = 0; path < 2; path++) {
-		while (1) {
-			spin_lock_irqsave(
-				&queue_group->submit_lock[path], flags);
-			list_is_empty =
-				list_empty(&queue_group->request_list[path]);
-			spin_unlock_irqrestore(
-				&queue_group->submit_lock[path], flags);
-			if (list_is_empty)
-				break;
-			pqi_check_ctrl_health(ctrl_info);
-			if (pqi_ctrl_offline(ctrl_info))
-				return -ENXIO;
-			usleep_range(1000, 2000);
+	queued_io_count = 0;
+
+	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
+		queue_group = &ctrl_info->queue_groups[i];
+		for (path = 0; path < 2; path++) {
+			spin_lock_irqsave(&queue_group->submit_lock[path], flags);
+			list_for_each_entry(io_request, &queue_group->request_list[path], request_list_entry)
+				queued_io_count++;
+			spin_unlock_irqrestore(&queue_group->submit_lock[path], flags);
 		}
 	}
 
-	return 0;
+	return queued_io_count;
 }
 
-static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
+static unsigned int pqi_nonempty_inbound_queue_count(struct pqi_ctrl_info *ctrl_info)
 {
-	int rc;
 	unsigned int i;
 	unsigned int path;
+	unsigned int nonempty_inbound_queue_count;
 	struct pqi_queue_group *queue_group;
 	pqi_index_t iq_pi;
 	pqi_index_t iq_ci;
 
+	nonempty_inbound_queue_count = 0;
+
 	for (i = 0; i < ctrl_info->num_queue_groups; i++) {
 		queue_group = &ctrl_info->queue_groups[i];
-
-		rc = pqi_wait_until_queued_io_drained(ctrl_info, queue_group);
-		if (rc)
-			return rc;
-
 		for (path = 0; path < 2; path++) {
 			iq_pi = queue_group->iq_pi_copy[path];
+			iq_ci = readl(queue_group->iq_ci[path]);
+			if (iq_ci != iq_pi)
+				nonempty_inbound_queue_count++;
+		}
+	}
 
-			while (1) {
-				iq_ci = readl(queue_group->iq_ci[path]);
-				if (iq_ci == iq_pi)
-					break;
-				pqi_check_ctrl_health(ctrl_info);
-				if (pqi_ctrl_offline(ctrl_info))
-					return -ENXIO;
-				usleep_range(1000, 2000);
-			}
+	return nonempty_inbound_queue_count;
+}
+
+#define PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS	10
+
+static int pqi_wait_until_inbound_queues_empty(struct pqi_ctrl_info *ctrl_info)
+{
+	unsigned long start_jiffies;
+	unsigned long warning_timeout;
+	unsigned int queued_io_count;
+	unsigned int nonempty_inbound_queue_count;
+	bool displayed_warning;
+
+	displayed_warning = false;
+	start_jiffies = jiffies;
+	warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * PQI_HZ) + start_jiffies;
+
+	while (1) {
+		queued_io_count = pqi_queued_io_count(ctrl_info);
+		nonempty_inbound_queue_count = pqi_nonempty_inbound_queue_count(ctrl_info);
+		if (queued_io_count == 0 && nonempty_inbound_queue_count == 0)
+			break;
+		pqi_check_ctrl_health(ctrl_info);
+		if (pqi_ctrl_offline(ctrl_info))
+			return -ENXIO;
+		if (time_after(jiffies, warning_timeout)) {
+			dev_warn(&ctrl_info->pci_dev->dev,
+				"waiting %u seconds for queued I/O to drain (queued I/O count: %u; non-empty inbound queue count: %u)\n",
+				jiffies_to_msecs(jiffies - start_jiffies) / 1000, queued_io_count, nonempty_inbound_queue_count);
+			displayed_warning = true;
+			warning_timeout = (PQI_INBOUND_QUEUES_NONEMPTY_WARNING_TIMEOUT_SECS * PQI_HZ) + jiffies;
 		}
+		usleep_range(1000, 2000);
 	}
 
+	if (displayed_warning)
+		dev_warn(&ctrl_info->pci_dev->dev,
+			"queued I/O drained after waiting for %u seconds\n",
+			jiffies_to_msecs(jiffies - start_jiffies) / 1000);
+
 	return 0;
 }
 
@@ -5922,7 +5949,7 @@ static int pqi_device_wait_for_pending_io(struct pqi_ctrl_info *ctrl_info,
 		if (pqi_ctrl_offline(ctrl_info))
 			return -ENXIO;
 		msecs_waiting = jiffies_to_msecs(jiffies - start_jiffies);
-		if (msecs_waiting > timeout_msecs) {
+		if (msecs_waiting >= timeout_msecs) {
 			dev_err(&ctrl_info->pci_dev->dev,
 				"scsi %d:%d:%d:%d: timed out after %lu seconds waiting for %d outstanding command(s)\n",
 				ctrl_info->scsi_host->host_no, device->bus, device->target,
@@ -5957,6 +5984,7 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 {
 	int rc;
 	unsigned int wait_secs;
+	int cmds_outstanding;
 
 	wait_secs = 0;
 
@@ -5974,11 +6002,10 @@ static int pqi_wait_for_lun_reset_completion(struct pqi_ctrl_info *ctrl_info,
 		}
 
 		wait_secs += PQI_LUN_RESET_POLL_COMPLETION_SECS;
-
+		cmds_outstanding = atomic_read(&device->scsi_cmds_outstanding);
 		dev_warn(&ctrl_info->pci_dev->dev,
-			"scsi %d:%d:%d:%d: waiting %u seconds for LUN reset to complete\n",
-			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun,
-			wait_secs);
+			"scsi %d:%d:%d:%d: waiting %u seconds for LUN reset to complete (%d command(s) outstanding)\n",
+			ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun, wait_secs, cmds_outstanding);
 	}
 
 	return rc;
-- 
2.28.0.rc1.9.ge7ae437ac1

