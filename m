Return-Path: <SRS0=ks1E=5A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C07C2BB1D
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04AE1206EB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Mar 2020 09:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgCOJmu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Mar 2020 05:42:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:58168 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728147AbgCOJmu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Mar 2020 05:42:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C1040AC91;
        Sun, 15 Mar 2020 09:42:47 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Don Brace <don.brace@microsemi.com>
Subject: [PATCH v2 8/8] scsi: smartpqi: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:42:41 +0100
Message-Id: <20200315094241.9086-9-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315094241.9086-1-tiwai@suse.de>
References: <20200315094241.9086-1-tiwai@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: no change

 drivers/scsi/smartpqi/smartpqi_init.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b7492568e02f..cd157f11eb22 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1614,28 +1614,28 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 		"%d:%d:", ctrl_info->scsi_host->host_no, device->bus);
 
 	if (device->target_lun_valid)
-		count += snprintf(buffer + count,
+		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			"%d:%d",
 			device->target,
 			device->lun);
 	else
-		count += snprintf(buffer + count,
+		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			"-:-");
 
 	if (pqi_is_logical_device(device))
-		count += snprintf(buffer + count,
+		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			" %08x%08x",
 			*((u32 *)&device->scsi3addr),
 			*((u32 *)&device->scsi3addr[4]));
 	else
-		count += snprintf(buffer + count,
+		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			" %016llx", device->sas_address);
 
-	count += snprintf(buffer + count, PQI_DEV_INFO_BUFFER_LENGTH - count,
+	count += scnprintf(buffer + count, PQI_DEV_INFO_BUFFER_LENGTH - count,
 		" %s %.8s %.16s ",
 		pqi_device_type(device),
 		device->vendor,
@@ -1643,19 +1643,19 @@ static void pqi_dev_info(struct pqi_ctrl_info *ctrl_info,
 
 	if (pqi_is_logical_device(device)) {
 		if (device->devtype == TYPE_DISK)
-			count += snprintf(buffer + count,
+			count += scnprintf(buffer + count,
 				PQI_DEV_INFO_BUFFER_LENGTH - count,
 				"SSDSmartPathCap%c En%c %-12s",
 				device->raid_bypass_configured ? '+' : '-',
 				device->raid_bypass_enabled ? '+' : '-',
 				pqi_raid_level_to_string(device->raid_level));
 	} else {
-		count += snprintf(buffer + count,
+		count += scnprintf(buffer + count,
 			PQI_DEV_INFO_BUFFER_LENGTH - count,
 			"AIO%c", device->aio_enabled ? '+' : '-');
 		if (device->devtype == TYPE_DISK ||
 			device->devtype == TYPE_ZBC)
-			count += snprintf(buffer + count,
+			count += scnprintf(buffer + count,
 				PQI_DEV_INFO_BUFFER_LENGTH - count,
 				" qd=%-6d", device->queue_depth);
 	}
@@ -6191,14 +6191,14 @@ static ssize_t pqi_lockup_action_show(struct device *dev,
 
 	for (i = 0; i < ARRAY_SIZE(pqi_lockup_actions); i++) {
 		if (pqi_lockup_actions[i].action == pqi_lockup_action)
-			count += snprintf(buffer + count, PAGE_SIZE - count,
+			count += scnprintf(buffer + count, PAGE_SIZE - count,
 				"[%s] ", pqi_lockup_actions[i].name);
 		else
-			count += snprintf(buffer + count, PAGE_SIZE - count,
+			count += scnprintf(buffer + count, PAGE_SIZE - count,
 				"%s ", pqi_lockup_actions[i].name);
 	}
 
-	count += snprintf(buffer + count, PAGE_SIZE - count, "\n");
+	count += scnprintf(buffer + count, PAGE_SIZE - count, "\n");
 
 	return count;
 }
-- 
2.16.4

