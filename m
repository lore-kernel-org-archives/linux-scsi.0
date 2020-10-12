Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18206C43457
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 05:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73522078A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 05:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgJLFOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 01:14:38 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:37211 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgJLFOf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 01:14:35 -0400
IronPort-SDR: CXK3T12kw6aPJluuEY5kpy0LhY6x2/ekUjEaHcqzWXgFVHVhClI7M1VG4Cjn/IiahEh4JW7yDP
 pa8Ynb2FCBJjJjzFHJBQtBvYNBIN13QXYR1W4QB0K51NNQ4QDyVz/635cG0QKJbmBYCx5Xon6h
 FCfG8GKMtw627zMi4+WZQj5rpnHb7TmeYI7zwDUSay3rBpPUzsEOdf7l0BpJDqABOBo2kpxfBY
 vwFOCQQW3091fo7Y2jMVeyaflU6rlLIEswCoqnelxRpPzFZI0C/CdtxZbTqtsrIkdKhMGK8Ycl
 fNQ=
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="89863716"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 22:14:34 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sun, 11 Oct
 2020 22:14:33 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.99) by
 avmbx3.microsemi.net (10.100.34.33) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Sun, 11 Oct 2020 22:14:33 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id 1FF8040047;
        Sun, 11 Oct 2020 22:14:33 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        <Viswas.G@microchip.com>,
        "peter chang --cc=yuuzheng @ google . com" <dpf@google.com>,
        <vishakhavc@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 4/4] pm80xx: make pm8001_mpi_set_nvmd_resp free of race condition
Date:   Mon, 12 Oct 2020 10:54:15 +0530
Message-ID: <20201012052415.18963-5-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201012052415.18963-1-Viswas.G@microchip.com.com>
References: <20201012052415.18963-1-Viswas.G@microchip.com.com>
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

