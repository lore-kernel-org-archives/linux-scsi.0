Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC87AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870BD64FBB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhCJUD1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:03:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51834 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhCJUCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406574; x=1646942574;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8fiBwG9ti4KLv8PHrGsrIeqyhIRXYGCm3GCGpL2j37I=;
  b=lNeLsuwvI/gTLtWZrYA40ag46Yuas9eq+RCg3wyW4Snz3AQp1swVhbNB
   +pDsfg7acph76gSKzU4VKP0WAcx1pChiW6yiDeq/deghmF0qqViipYGUN
   s6tlmkXszZa906lPR1/UghWMTwakBU4z0sIh2LQfbgwwkEeFR8HKgRsoB
   jDkBVapGpfD5fCrmQ16X1ykCh6cKM+FTVXTjCgvmykY0MhCjJ469YsJmy
   vG+wv3KG94mPN43V08bfRTO4zdE6ZhlTlnxefQR8cjZhmYIupMmgLmoa0
   uiPAm8/VRCsNn1zF3CYf9Xo8lyRzoOjna8SQfnGYQPu/F9iV7p20VQGaE
   Q==;
IronPort-SDR: FsBvY6b1hHY8SSkKwVm0iMvs3s/cIvIvlKtUSE0fdRA2JB502lF9eh0qepvqT4U8GE7LTnQh86
 OiYapxst33wQIabJnzZ67+xi5Y0ryMAxgjlJ5YL6Xm3CecRPFDGlAQ/BiXRUhT28Seo4jXiKeg
 xzCzrZhqpOJ+RBC8opQsGSBaSQD+684RskCSLaGEwjKCf8cFp7WV7iz1/tV6WUUS3xiAIsLJhQ
 DbmBXk4fW4WhUpOWuHEsBvvKXW0feFr93yLPYq/WBgGTPKUD8tR64Wz4CM5STgFk9du+z5MRLJ
 OmQ=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="47022547"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:54 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:53 -0700
Subject: [PATCH V4 22/31] smartpqi: update device scan operations
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:53 -0600
Message-ID: <161540657353.19430.13538289799386366212.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
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
index 235be3165006..fe764237f689 100644
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
 

