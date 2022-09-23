Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4494C54EE9
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 01:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiIWBJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 21:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiIWBIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 21:08:35 -0400
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Sep 2022 18:08:33 PDT
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC411166E8
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 18:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1663895313; x=1695431313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=FIaFuBr0Oe9y1QivCx5pfsr3wrfD/ZEssLivgGj/3I0=;
  b=yqm+0+ywSbunGAVj4qk7VR7o9kWu0TmHVKrDMjrgtXuG+/6cLZbhypUv
   TxJ+SDBqvYsSoLW04O2Pzd6qEthm4VYc+SE5FxVeTPwszlCXlfQhQLU6j
   ly7yWZNy7cwdBFsPCHwtt+XeN8GMD3/T5CWW6bi12v6txcys/OPouYXMl
   g=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 22 Sep 2022 18:06:30 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 18:06:30 -0700
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 22 Sep 2022 18:06:29 -0700
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     <mani@kernel.org>, <quic_nguyenb@quicinc.com>,
        <quic_xiaosenh@quicinc.com>, <quic_cang@quicinc.com>,
        <quic_nitirawa@quicinc.com>, <quic_rampraka@quicinc.com>,
        <quic_richardp@quicinc.com>, <stanley.chu@mediatek.com>,
        <adrian.hunter@intel.com>, <bvanassche@acm.org>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH v1 03/16] ufs: core: Defer adding host to scsi if mcq is supported
Date:   Thu, 22 Sep 2022 18:05:10 -0700
Message-ID: <197a8bcca288f9c36586099aa07606ed3f067c9b.1663894792.git.quic_asutoshd@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1663894792.git.quic_asutoshd@quicinc.com>
References: <cover.1663894792.git.quic_asutoshd@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If MCQ support is present, then enabling it would need
reallocating tags and memory. It would also free up the
already allocated memory in Single Doorbell Mode.
So defer invoking scsi_add_host() until MCQ is configured.

Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Asutosh Das <quic_asutoshd@quicinc.com>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 24661fc..426867b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8184,6 +8184,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	int ret;
 	unsigned long flags;
 	ktime_t start = ktime_get();
+	struct Scsi_Host *host = hba->host;
 
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 
@@ -8218,6 +8219,14 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 		ret = ufshcd_device_params_init(hba);
 		if (ret)
 			goto out;
+
+		if (is_mcq_supported(hba)) {
+			ret = scsi_add_host(host, hba->dev);
+			if (ret) {
+				dev_err(hba->dev, "scsi_add_host failed\n");
+				goto out;
+			}
+		}
 	}
 
 	ufshcd_tune_unipro_params(hba);
@@ -9764,10 +9773,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		hba->is_irq_enabled = true;
 	}
 
-	err = scsi_add_host(host, hba->dev);
-	if (err) {
-		dev_err(hba->dev, "scsi_add_host failed\n");
-		goto out_disable;
+	if (!is_mcq_supported(hba)) {
+		err = scsi_add_host(host, hba->dev);
+		if (err) {
+			dev_err(hba->dev, "scsi_add_host failed\n");
+			goto out_disable;
+		}
 	}
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
-- 
2.7.4

