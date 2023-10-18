Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B98CDB47E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjJRR6E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344716AbjJRR5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:57:47 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3C3D61;
        Wed, 18 Oct 2023 10:57:40 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6cd0964a994so481996a34.0;
        Wed, 18 Oct 2023 10:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651860; x=1698256660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BSMTtopnpnoVFRhHmUt+zlCmNcQ7/eLzIQS1hLfLLj0=;
        b=Q/WDLEoayRxaPF+2+7p9H97FaITlZ1LQ/EdiUTNSYBeziOfKWonP8YR7DyYuVeHfLl
         83ut7AmPl07O86OuSP3lmcpqLCpEZd5EUfSHWqmCj6xufgM65EV6+qgwoklhiczRFgri
         P2v7wGr+LGMdo5AanisZ3jsDoEjavpL40KYql40zZ8vzy6B8GVZJXEN6oZgg7uZHqPjD
         QZW3aoQuFLb5mO0DaphVqQZd+99PYKAIQY7nydrfF/M/ET7xFdE2vFGRM57LPTM9iSkO
         4q5V66uWlBxDUNOwRGgrHb28rVmKbFOOy0WvII3SSzIz1si/nemnwT7Da2TrTumbS4Hq
         0aew==
X-Gm-Message-State: AOJu0YzaVUPhf6yTb0e3MCCXAH6DuVqIJUTql6ghwUJv47cJh+YlV/CS
        hZa+y1pdf0sZE8aiK159N+I=
X-Google-Smtp-Source: AGHT+IHs5W+Ov+53lF41ZQq4E0YEOZHaed5S3JFQx6klUUVo+9s2Do5fmUG/HZ2Dxn7ULE8mPFLwlw==
X-Received: by 2002:a05:6830:2691:b0:6bf:2d48:f064 with SMTP id l17-20020a056830269100b006bf2d48f064mr7417403otu.13.1697651859925;
        Wed, 18 Oct 2023 10:57:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:57:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v13 16/18] scsi: ufs: Simplify ufshcd_auto_hibern8_update()
Date:   Wed, 18 Oct 2023 10:54:38 -0700
Message-ID: <20231018175602.2148415-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calls to ufshcd_auto_hibern8_update() are already serialized: this
function is either called if user space software is not running
(preparing to suspend) or from a single sysfs store callback function.
Kernfs serializes sysfs .store() callbacks.

No functionality is changed. This patch makes the next patch in this
series easier to read.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3718fbe51b9..3fc33794ce1f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4315,21 +4315,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
-	unsigned long flags;
-	bool update = false;
+	const u32 cur_ahit = READ_ONCE(hba->ahit);
 
-	if (!ufshcd_is_auto_hibern8_supported(hba))
+	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
 		return 0;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit != ahit) {
-		hba->ahit = ahit;
-		update = true;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	WRITE_ONCE(hba->ahit, ahit);
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_configure_auto_hibern8(hba);
