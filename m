Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B0DC2FC14
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351147AbjHQNNX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351386AbjHQNNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:13:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A603435A3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277956; x=1723813956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xPLqWVW3LXUCmsgID+4bsZSYOt8KXhfRmsqp5DXNcMs=;
  b=yXxZO6lDddN+t3cGa57TGxK9iI3tuGGc4u2qA03bf7QZXfJ2n656XokD
   g5o8n5QA2FDITkp26JcQK3UKq5efsYHGHpCrWD1gu+PyTRZA7cZrX4/NL
   7pFQcXlpZenzX+awyBI6ZqVF59hdaCUgAEjn5sxCxyK2qiwyeOveXbsNu
   L1DYbnBftpg1w8W+ErDKGyphrDpSvBos0BGjc6N464S26baln7JcUSfw/
   7GzQb1PF6BTsu/bB+P1sdnizVI5GFM/mj/SVYbC+dlQqD+klF9m/4uHGP
   3gqpWlKWHvq0rqSaK5PIkhokXE0lMBB2BglxM0Ddc4cFwjnPbnJHwR5Jy
   g==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="230249339"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:11:09 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:11:08 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 8/9] smartpqi: enhance error messages
Date:   Thu, 17 Aug 2023 08:12:31 -0500
Message-ID: <20230817131232.86754-9-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
In-Reply-To: <20230817131232.86754-1-don.brace@microchip.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>

Add more detail to some TMF messages.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a497a35431b2..cab44f1f6256 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6121,10 +6121,8 @@ static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
-		ctrl_info->scsi_host->host_no,
-		device->bus, device->target, lun,
-		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
+		"resetting scsi %d:%d:%d:%u SCSI cmd at %p due to cmd opcode 0x%02x\n",
+		ctrl_info->scsi_host->host_no, device->bus, device->target, lun, scmd, scsi_opcode);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
@@ -6178,18 +6176,20 @@ static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
 
 	shost = scmd->device->host;
 	ctrl_info = shost_to_hba(shost);
+	device = scmd->device->hostdata;
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"attempting TASK ABORT on SCSI cmd at %p\n", scmd);
+		"attempting TASK ABORT on scsi %d:%d:%d:%d for SCSI cmd at %p\n",
+		shost->host_no, device->bus, device->target, (int)scmd->device->lun, scmd);
 
 	if (cmpxchg(&scmd->host_scribble, PQI_NO_COMPLETION, (void *)&wait) == NULL) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"SCSI cmd at %p already completed\n", scmd);
+			"scsi %d:%d:%d:%d for SCSI cmd at %p already completed\n",
+			shost->host_no, device->bus, device->target, (int)scmd->device->lun, scmd);
 		scmd->result = DID_RESET << 16;
 		goto out;
 	}
 
-	device = scmd->device->hostdata;
 	tmf_work = &device->tmf_work[scmd->device->lun];
 
 	if (cmpxchg(&tmf_work->scmd, NULL, scmd) == NULL) {
@@ -6203,7 +6203,8 @@ static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
 	wait_for_completion(&wait);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"TASK ABORT on SCSI cmd at %p: SUCCESS\n", scmd);
+		"TASK ABORT on scsi %d:%d:%d:%d for SCSI cmd at %p: SUCCESS\n",
+		shost->host_no, device->bus, device->target, (int)scmd->device->lun, scmd);
 
 out:
 
-- 
2.42.0.rc2

