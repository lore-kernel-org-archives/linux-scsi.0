Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73826C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3573664F8F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhCKUQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:16:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45786 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhCKUQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:16:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493814; x=1647029814;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rvQ03DwWK5lqAUHYZYaE7Irq1/iPGILgEBsvYLxadmI=;
  b=YXsS0M227hHR+oKHei93HYoHr/TnZ3B8+UuvEVWsZfMGkYhTf+Zn6Acc
   /orZ9uXH6PnJfV5go2UMnUkbXOxMsop6o5TvZey6zWZyFuLoibw4nNw29
   Tnl78PqMrlPqsXpUIPShmxNOD/foUDirDsmRWEKvMpijrZflmWdgQHd8C
   p53RmHUsp7w4jweesESz46inI3YqlMV46oXJxAAQs64GzNFHlChBbaB5x
   avx782vM3asKd6acTvvP0VXtqAKJcU+Nh4c215UjeBo2etVcReH2SV7vV
   aQMZkHTAt+gxhBQYrUkJq/9hMyi4YHLLdmn90+LXnHJVkI50lxwKpMs4N
   Q==;
IronPort-SDR: RFUoZWyO4/k3RBkq2aMvXIvYOrkCBjYfzKc2RseCpam2QLnea6cZnjXJSSoLfUbCRBWJqgKyq+
 3pLwKIj/aYTZo+59lQ2T0Ou6K2MhyqTPjrOPCIAFBMLe6dK9rRQO9FpL+3qCEFFjUKwoaJp+5/
 bONmHXtexJv62UGNaVl1rUPdlsIDJL6+1t+kOPHI/xVdztac89BJRxKweb+nHuZWjeSpRQJf8S
 EuJM0vU5hriQjXv/QvzXZiTlY5RsY1QXFXm5b7cdnIhrOSDJOAnVs5Zwh3dr4R0aDMIPDwi7IL
 6zM=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112406085"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:16:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:16:38 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:16:38 -0700
Subject: [PATCH V5 18/31] smartpqi: synchronize device resets with mutex
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:16:38 -0600
Message-ID: <161549379810.25025.10194117431886743795.stgit@brunhilda>
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

Synchronize device reset operations with a mutex.
 * Remove some flags used to check for device resets
   already in progress.
 * Allow only 1 reset operation at a time for the host.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |    1 -
 drivers/scsi/smartpqi/smartpqi_init.c |   48 +++++++++------------------------
 2 files changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index a18c1f9afb37..ba7d26364b84 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1295,7 +1295,6 @@ struct pqi_ctrl_info {
 	struct mutex	ofa_mutex; /* serialize ofa */
 	bool		controller_online;
 	bool		block_requests;
-	bool		block_device_reset;
 	bool		in_ofa;
 	bool		in_shutdown;
 	u8		inbound_spanning_supported : 1;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 41aa401e58eb..cc2b29a67ba0 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -247,12 +247,12 @@ static inline void pqi_save_ctrl_mode(struct pqi_ctrl_info *ctrl_info,
 
 static inline void pqi_ctrl_block_device_reset(struct pqi_ctrl_info *ctrl_info)
 {
-	ctrl_info->block_device_reset = true;
+	mutex_lock(&ctrl_info->lun_reset_mutex);
 }
 
-static inline bool pqi_device_reset_blocked(struct pqi_ctrl_info *ctrl_info)
+static inline void pqi_ctrl_unblock_device_reset(struct pqi_ctrl_info *ctrl_info)
 {
-	return ctrl_info->block_device_reset;
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
 }
 
 static inline bool pqi_ctrl_blocked(struct pqi_ctrl_info *ctrl_info)
@@ -297,16 +297,6 @@ static inline bool pqi_device_offline(struct pqi_scsi_dev *device)
 	return device->device_offline;
 }
 
-static inline void pqi_device_reset_start(struct pqi_scsi_dev *device)
-{
-	device->in_reset = true;
-}
-
-static inline void pqi_device_reset_done(struct pqi_scsi_dev *device)
-{
-	device->in_reset = false;
-}
-
 static inline bool pqi_device_in_reset(struct pqi_scsi_dev *device)
 {
 	return device->in_reset;
@@ -6098,7 +6088,7 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl_info,
 #define PQI_LUN_RESET_RETRY_INTERVAL_MSECS	10000
 #define PQI_LUN_RESET_PENDING_IO_TIMEOUT_SECS	120
 
-static int _pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
+static int pqi_lun_reset_with_retries(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
 	int rc;
@@ -6124,23 +6114,15 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
 {
 	int rc;
 
-	mutex_lock(&ctrl_info->lun_reset_mutex);
-
 	pqi_ctrl_block_requests(ctrl_info);
 	pqi_ctrl_wait_until_quiesced(ctrl_info);
 	pqi_fail_io_queued_for_device(ctrl_info, device);
 	rc = pqi_wait_until_inbound_queues_empty(ctrl_info);
-	pqi_device_reset_start(device);
-	pqi_ctrl_unblock_requests(ctrl_info);
-
 	if (rc)
 		rc = FAILED;
 	else
-		rc = _pqi_device_reset(ctrl_info, device);
-
-	pqi_device_reset_done(device);
-
-	mutex_unlock(&ctrl_info->lun_reset_mutex);
+		rc = pqi_lun_reset_with_retries(ctrl_info, device);
+	pqi_ctrl_unblock_requests(ctrl_info);
 
 	return rc;
 }
@@ -6156,29 +6138,25 @@ static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
 	ctrl_info = shost_to_hba(shost);
 	device = scmd->device->hostdata;
 
+	mutex_lock(&ctrl_info->lun_reset_mutex);
+
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%d\n",
 		shost->host_no, device->bus, device->target, device->lun);
 
 	pqi_check_ctrl_health(ctrl_info);
-	if (pqi_ctrl_offline(ctrl_info) ||
-		pqi_device_reset_blocked(ctrl_info)) {
+	if (pqi_ctrl_offline(ctrl_info))
 		rc = FAILED;
-		goto out;
-	}
-
-	pqi_wait_until_ofa_finished(ctrl_info);
-
-	atomic_inc(&ctrl_info->sync_cmds_outstanding);
-	rc = pqi_device_reset(ctrl_info, device);
-	atomic_dec(&ctrl_info->sync_cmds_outstanding);
+	else
+		rc = pqi_device_reset(ctrl_info, device);
 
-out:
 	dev_err(&ctrl_info->pci_dev->dev,
 		"reset of scsi %d:%d:%d:%d: %s\n",
 		shost->host_no, device->bus, device->target, device->lun,
 		rc == SUCCESS ? "SUCCESS" : "FAILED");
 
+	mutex_unlock(&ctrl_info->lun_reset_mutex);
+
 	return rc;
 }
 

