Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D02C07E9C
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166706108B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhGLJzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:55:31 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11619 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241707AbhGLJzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083558; x=1657619558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rOAe0RhkL99Hy07R1vj9oEvsLsHOix4kUohw4rsfT3A=;
  b=MjQtaTlHOGGPnOq5U2ztRAPtkQQ7cmHq2eDrYIxFqIerHvcERAhvkMDl
   75UPyX1N6Nz0zPYJG2klsXQ3peXPNKEqnDpze+Uti68YhYJPhEg6VItr1
   Enhyi6Er0Og0a71odesYXCsb1WOQs88fiRH96Yh+++cNobZ76X94/AaLI
   PZIDrf50V8NoHepiGpfTB7zMku2HojVGHUkl4/EOxQMqRwkN2di7H9bY8
   kl1+WpmrMGl52UogdjLaUNcKD0y4prKohvy2nrs3yTPjvyGgkpVQZSb4Y
   XaONfNNto96DDWSiKqnEbg5+V1yT7axlw8pCgKIatZbXHy3hebaaeJLLY
   w==;
IronPort-SDR: KFGxBPm4dZ723/UHTKGN00lAlsVfj5PJbU8E7R2EfZBqMOm0hMJqzgohtnfNr0idx9EzMel45w
 v8oT7du834yxN6Beuh8o+Ay1ioA6rgWuIjlh6CbTD1N62OrclSkD1kvr3wuCRPyNyR61M0gZff
 WM6ZHv4oyp80FLSjfE16w+E28EEvirgg8LzrWajkZcDky0lwWFE3DshYzgDOZcaJpj/AoDGfuy
 PF4LEVwDyWqlcig3/RVdDk+5Er/GbCrAtg2UcyjtGKOmzi03U2X56h+Ab1By3r0sprxm0zRzhS
 1oE=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="285877132"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:52:37 +0800
IronPort-SDR: Qt4j7cyHtg2zhjI8vVweFr+X13Z+UhbJrsEehkHoJBp5hNjFyN+XjBwpxGdcnxnT9E7OCtQabS
 W3M6SoWFKpAcSV+iQgh2DMRFZoFo2CRxZ+4/twDDKUTq6PaAUSl6A8pq7MdKZVF+oRVv7xLuPE
 V1/SCF1O5UB90InYRbPpakPgqboOAv99Vmet2pwAR6/y4oMUxL/q412aIJSX1xn5lFYweLxxy+
 3ZdEZmPpfcgnH5tQem/x3Om58TJQMwNeEbS7ViWP3yvhKsmPu9FZTqlIIMIq0W8sjjWWTVux++
 db3+f8wa9DZJCNhQIKxFRdpN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:30:44 -0700
IronPort-SDR: fFzlG+oPOV7zE1GBlC/R94YFHl3SI453Rp1o3PDce+T80NabfPwpoPk0vxMSK1DhSDzMGa+9bI
 O1A1/YvqVr5Cfo9WXZg8Ii2fEhCp9R1L6PgE1Ya5S3ZxO2UL3MXY5HqBXe0vOiBOpxfmX5skrV
 nV8bqW7tb3qpLFdWXHtI7fLQD6Yij16jIkuXd+8wt0qDbbFFn0cYHhBG59S0SZpzCRiuqiATe8
 rObX9GanDrDsCkIsey1TQS/xPztAaY5ycS2XSdD9OoJDLf6Yp/3mxwcF8wpn7q0U0+lOmBdVJc
 SwY=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:52:33 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v12 11/12] scsi: ufshpb: Add support for host control mode
Date:   Mon, 12 Jul 2021 12:50:38 +0300
Message-Id: <20210712095039.8093-12-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support devices that report they are using host control mode.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 17767ebf8bd0..b638a413bdb2 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2582,12 +2582,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
-		dev_err(hba->dev, "%s: host control mode is not supported.\n",
-			__func__);
-		hpb_dev_info->hpb_disabled = true;
-		return;
-	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
 	if ((version != HPB_SUPPORT_VERSION) &&
-- 
2.25.1

