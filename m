Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B721C4332D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E386F64FDA
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhCJUC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:02:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22697 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCJUCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406564; x=1646942564;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ytkq6WYFuz/ihrjgk8wi9CACuo76ryTlIoz+BX6/xgE=;
  b=pubkQq1gKfXWJTESKzahzBfSdIIpfZcTDWCzOw3QJvDMc9BM4kVAlV2t
   8r/PV7mZAigCCl5geRrxkwrg7FC4vCCAmNqotkg9ljcluDgGCnI0Ascbw
   z5g9M2wMdw2JrDSmkceiuuXiHQmGXFW2Q0Bcw1d5rHCVBJOrJRd5+qd3N
   lC/B/QIrjBYiL2cOBGkdOzJaj9076YjXn4n2/8E8tx1nCVhJ+cQdDE8N+
   sniARmLvgqKy25S983UvPF1/wS9kDVDYenToKdQ1QHpQRkVCOcitsNKhK
   G66qwVHlQsMaYIwgomxbFO2KnHeIXW67BMC14B13nwz5U9gGqjFD1fzrc
   w==;
IronPort-SDR: qiZzi2ziP82CWhN28U0ESU56fGPXQygozZKVfsDPd3+Vm97PlFX7mHRlTjrGyIPoVvWPYxldPA
 frx2A3gKUB7y+BHSUM2I/lp0uMfGk0dJJWX49ZgK5yAl5PoPnawoeEdgoJ9Eb2Vx5TBA6qUpix
 2+edUBaVVg9R+M1lUS06ocmelvUiy5J5YWrm09+ZO1gUl0gTkw0lhTo2IGvAlWxc8GBMnJi6hj
 53WWn67NhCdE4Ii0L45rqPdSBcsPZqd20LM+f1ohR3Mtbf2F1MD5bz7VmbJ3/4yPJ1dgPwjDSP
 dpU=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="118389655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:02:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:02:30 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:02:30 -0700
Subject: [PATCH V4 18/31] smartpqi: synchronize device resets with mutex
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:02:30 -0600
Message-ID: <161540655014.19430.15578541158427051985.stgit@brunhilda>
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
index f1f90c21045d..7436df0d55f2 100644
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
 

