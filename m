Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243C8C00A89
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 05:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA00A221F8
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 05:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgJ3F7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 01:59:25 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57054 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3F7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 01:59:24 -0400
IronPort-SDR: TFXeAGa83PKk0IwRLQhLecHN8qN9yC3McoVzVJ3meK+pDr5St/a1FbfkoTw8dHdPS/yT53n1RV
 8crpVMwsmXn0MK6NZND1S1iUetap/8YX/Pe/VFTEP+GXFkjB6sFD6jzEkOgiS2ZfNwV+e60cbR
 ysbkhJLABXsAdbJYYYxl3ADGePCCj+LbjSLMe5+35T7h9VtwO0mTINmtAKfoVTouKY0063e5Dh
 GzZIVaK7TGDQnvuNOVfxwPHo07aacuCzPMvEy3/HsUSmlE042lVmQ4YJsjcDGQptHROhXaLc0M
 czU=
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="94481997"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Oct 2020 22:59:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 22:59:23 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 29 Oct 2020 22:59:23 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V2 4/4] pm80xx: make pm8001_mpi_set_nvmd_resp free of race condition
Date:   Fri, 30 Oct 2020 11:39:13 +0530
Message-ID: <20201030060913.14886-5-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201030060913.14886-1-Viswas.G@microchip.com.com>
References: <20201030060913.14886-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: yuuzheng <yuuzheng@google.com>

The use-after-free or null-pointer error occurs when the 251-byte
response data are copied from IOMB buffer to response message
buffer in function mp8001_mpi_set_nvmd_resp. pm8001_mpi_set_nvmd_resp
is a function to process the response of command set_nvmd_data_resp.
After sending the command set_nvmd_data, the caller begins to sleep by
calling wait_for_complete() and wait for the wake-up from calling
complete() in pm8001_mpi_set_nvmd_resp. In the current code,
the memcpy for response message buffer occurs after calling complete().
So, it is not protected by the use of wait_for_completion() and
complete().

Due to unexpected events (e.g., interrupt), if response buffer gets
freed before memcpy, the use-after-free error will occur.
To fix it, the complete() should be called after memcpy.

Signed-off-by: yuuzheng <yuuzheng@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 9e9a546da959..2054c2b03d92 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3279,10 +3279,15 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_ha->memoryMap.region[NVMD].virt_ptr,
 		fw_control_context->len);
 	kfree(ccb->fw_control_context);
+	/* To avoid race condition, complete should be
+	 * called after the message is copied to
+	 * fw_control_context->usrAddr
+	 */
+	complete(pm8001_ha->nvmd_completion);
+	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("Set nvm data complete!\n"));
 	ccb->task = NULL;
 	ccb->ccb_tag = 0xFFFFFFFF;
 	pm8001_tag_free(pm8001_ha, tag);
-	complete(pm8001_ha->nvmd_completion);
 }
 
 int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
-- 
2.16.3

