Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514CDC3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 23:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiLAXLG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Dec 2022 18:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLAXKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2022 18:10:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EF0BF656
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 15:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669936140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BtaH/R2U9H/FSCFeNcuszPREFemDGP9fQpdb/KT1ZL4=;
        b=iS9QIA0NoHrNEmxnkrx8RMEYZRasgwABiPvgRDiDN73fYYitKyOjm6DJKxF/3d9CxvjkTS
        MwR+C1qBhZf880BnPr9N7jssCD7MnrJQrKrZ2wxB7Lck3ZFKD3q/h5yJ6AkFC4MU4YFuD6
        +/9DHtFzKN0TDQstf7rzDPdBOno7S6A=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-530-fm9BobqRNIiEim_kPc8wKA-1; Thu, 01 Dec 2022 18:08:58 -0500
X-MC-Unique: fm9BobqRNIiEim_kPc8wKA-1
Received: by mail-ot1-f72.google.com with SMTP id g68-20020a9d12ca000000b0066e6dfe3685so1484783otg.7
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 15:08:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtaH/R2U9H/FSCFeNcuszPREFemDGP9fQpdb/KT1ZL4=;
        b=54jsukq2xS5f+h9+GIZzan3a5UYeziyJQ0Il4eY4AgnhIxud69Q4iPRG8hsP6lqAaO
         7mU4zn2cuNMo9txTE2HoYm2H10O/0pBeL3GAdwvQZdEnO1OR48IQcRDHaXvb7p+RbX3H
         oJgMX4ttoj+2wUNwWkTM0b0IYh9n2le5otpVE3OmH3hRz5GyLWY4JQsFeZbdd8P6O+gq
         ehWju0dhEgES0p/ysvWTRVeUwZnME3mryCDZjZ+S8GQNRDoOZHJu+CBi6wjiULNyWIP2
         gKDQcmVk1+LreHc3MjhNEdge7cuiWbG/budCgRViWbb49d2rhr9QY5INbEWaHxDWPUmQ
         NE6Q==
X-Gm-Message-State: ANoB5pmoFGMgCOKcRg5NOTW2cRmEKDM6qAFRORX45H+yzZH1i+AwHfzW
        cU1Z8jT2Qr1ly2Zu039PvNdr3YNljZNU41jH8F2clsJZ95yIX9zS0YV9G8cEKsG38x37XiDFi58
        dCj9KWXiEelo0ScPm4julaQ==
X-Received: by 2002:a9d:5e0f:0:b0:662:2458:3ef7 with SMTP id d15-20020a9d5e0f000000b0066224583ef7mr34467967oti.150.1669936138146;
        Thu, 01 Dec 2022 15:08:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4FWPZZankvHjzPShxqKODxxCGji+P/F1OE5U+lA5qQYWnteysMV+IlrH+/g7Gxh0abel9IMg==
X-Received: by 2002:a9d:5e0f:0:b0:662:2458:3ef7 with SMTP id d15-20020a9d5e0f000000b0066224583ef7mr34467958oti.150.1669936137925;
        Thu, 01 Dec 2022 15:08:57 -0800 (PST)
Received: from halaney-x13s.redhat.com ([2600:1700:1ff0:d0e0::41])
        by smtp.gmail.com with ESMTPSA id y22-20020a4ade16000000b0049fb2a96de4sm2320393oot.0.2022.12.01.15.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:08:57 -0800 (PST)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     andersson@kernel.org
Cc:     agross@kernel.org, konrad.dybcio@linaro.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, p.zabel@pengutronix.de,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 4/4] scsi: ufs: ufs-qcom: Use dev_err() where possible
Date:   Thu,  1 Dec 2022 17:08:10 -0600
Message-Id: <20221201230810.1019834-5-ahalaney@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221201230810.1019834-1-ahalaney@redhat.com>
References: <20221201230810.1019834-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dev_err() statements are better to use than pr_err(), so switch to
those.

In a similar vein, the check on the dev_req_params pointer here is
not needed, the two places this function is called never pass in a
NULL pointer, so instead of using dev_err() there just remove it.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---
 drivers/ufs/host/ufs-qcom.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index b1fcff1fad0c..4350c44a6fc7 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -680,12 +680,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 	struct ufs_dev_params ufs_qcom_cap;
 	int ret = 0;
 
-	if (!dev_req_params) {
-		pr_err("%s: incoming dev_req_params is NULL\n", __func__);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	switch (status) {
 	case PRE_CHANGE:
 		ufshcd_init_pwr_dev_param(&ufs_qcom_cap);
@@ -709,7 +703,7 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 					       dev_max_params,
 					       dev_req_params);
 		if (ret) {
-			pr_err("%s: failed to determine capabilities\n",
+			dev_err(hba->dev, "%s: failed to determine capabilities\n",
 					__func__);
 			goto out;
 		}
-- 
2.38.1

