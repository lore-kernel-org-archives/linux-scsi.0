Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1DFC83003
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbjHXP4x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242339AbjHXP4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:56:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E682B19A3
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692892590; x=1724428590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KZo9+MGbXrfjspRD9qKBbxsUHQ4yPguUp809o+vfDkM=;
  b=Jtw4N5mF/fHYGvOhL4OWLTDLsNz5034cYbJvXX1Bf3407B/7vpJoqGxG
   gQajZWl58zYLOnAx+vkoYPRjGJ/rd0Rl2JPZSjZ73WhBTdxURhLe6IDJD
   qJHoM3MwZYwEgRutCj5NIJ6INVCDrdc0J1JunCz160tb1WIb1UCXJKohM
   AZFbf8/phfv1CCohxqKJMU7UDVUq//peUb+eT9vuSgOYtE9CsMofpSNl5
   hY0Ln4mLoOAPCfQlX/BwhSbLJdou2IAfdW9SmVSToMsZAth55ufjywyZ1
   D+C5lZhHxkqOUhWN0+vQf7wBRYpndyvZ0S1+Y0ASdQNZgj2oFjnmF5PzN
   A==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1149065"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2023 08:56:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 24 Aug 2023 08:56:18 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 24 Aug 2023 08:56:17 -0700
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
Subject: [PATCH v2 7/8] smartpqi: enhance error messages
Date:   Thu, 24 Aug 2023 10:58:11 -0500
Message-ID: <20230824155812.789913-8-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
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
index f1b393459f34..e288ba9af1a7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6358,10 +6358,8 @@ static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_
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
@@ -6415,18 +6413,20 @@ static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
 
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
@@ -6440,7 +6440,8 @@ static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
 	wait_for_completion(&wait);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"TASK ABORT on SCSI cmd at %p: SUCCESS\n", scmd);
+		"TASK ABORT on scsi %d:%d:%d:%d for SCSI cmd at %p: SUCCESS\n",
+		shost->host_no, device->bus, device->target, (int)scmd->device->lun, scmd);
 
 out:
 
-- 
2.42.0

