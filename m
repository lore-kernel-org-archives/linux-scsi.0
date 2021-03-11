Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A5FC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC88764F87
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhCKUR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:17:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:49181 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhCKURQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:17:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493836; x=1647029836;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KpAG3Jb+x6SVjX5aCksDXfgX/uHDLF7yGWHnkkBrOtk=;
  b=D1LeoWBMpif6ApfzGr+ZU6o5Ps7767heqXuLZKMgWh4tcjsb+zMif4vO
   n3X9Z+8rvUw5sXKbIrxVxNG+/BomtauSBotGg7fnh++vljgt+IAHQgm0b
   6tgB/ZJRViGiRBbhdRvanF0CQbjgLZPuFytumXLOaY3VFWKt/Ilouavwz
   mO6bns3szJnMjB5z33L5tnx+ED/LaKfJAJ2mbfLjSjtsYR8GvKVOKDfCt
   2JYOOpdeIcMkNQwjbOhjXSyiN+YBCY5+m+KgGIXpXJDRYrBfz+IOy5syh
   OkyOx2tpt9kMPw5AwIUsmimYYihTOaWBZ3b/OuqJuTprfCu+G5cxRJE/r
   Q==;
IronPort-SDR: kCGWhIgR259lz00vJa0PuP1KsTqMga0jZrThF7PjRjIES2YnfjUFKfy/wN6ZlPKil6G7U9Y8NX
 0p/lpzXoqfBKywVk8OtkfbUhtOJ0uGGPbxLLMZ20rYPviuPK2mms1H0t1GcFWDibCt0vCCk3l0
 JXhYGfaCdcg5vYrB5MYC48dsdxCZs9BOCb97JClFNqxWNsn7pFsKHELiaAeIel6D5bC1Y7wXl3
 +R5/D5cRPUVC0W72rZpNU79yo8F3wpwPJQ5+AuaFYS/LYJSesenJOj8YuBMZcc/pIpyJmoxq5f
 0B8=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="118559118"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:02 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:01 -0700
Subject: [PATCH V5 22/31] smartpqi: update device scan operations
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:01 -0600
Message-ID: <161549382157.25025.16054784597622125373.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microchip.com>

Change return type from EINPROGRESS to EBUSY to signal
applications to retry a REGNEWD if the driver cannot
process the REGNEWD. Events such as:
 * OFA.
 * Suspend.
 * Shutdown.

Return EINPROGRESS if a scan is currently running.
 * Prevents applications from immediately retrying
   REGNEWD.

Schedule a new REGNEWD if system low on memory.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 89b6972a21f6..9f6ab2f4144f 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2312,21 +2312,27 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 
 static int pqi_scan_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
-	int rc = 0;
+	int rc;
+	int mutex_acquired;
 
 	if (pqi_ctrl_offline(ctrl_info))
 		return -ENXIO;
 
-	if (!mutex_trylock(&ctrl_info->scan_mutex)) {
+	mutex_acquired = mutex_trylock(&ctrl_info->scan_mutex);
+
+	if (!mutex_acquired) {
+		if (pqi_ctrl_scan_blocked(ctrl_info))
+			return -EBUSY;
 		pqi_schedule_rescan_worker_delayed(ctrl_info);
-		rc = -EINPROGRESS;
-	} else {
-		rc = pqi_update_scsi_devices(ctrl_info);
-		if (rc)
-			pqi_schedule_rescan_worker_delayed(ctrl_info);
-		mutex_unlock(&ctrl_info->scan_mutex);
+		return -EINPROGRESS;
 	}
 
+	rc = pqi_update_scsi_devices(ctrl_info);
+	if (rc && !pqi_ctrl_scan_blocked(ctrl_info))
+		pqi_schedule_rescan_worker_delayed(ctrl_info);
+
+	mutex_unlock(&ctrl_info->scan_mutex);
+
 	return rc;
 }
 

