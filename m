Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB58EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbiCaWj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242611AbiCaWjy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:54 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE112013FE
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:38:06 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id x31so909317pfh.9
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xG0p7SuhY9zlTkA4dq7XtGhKxBi5xwr7Gs908aJhbY0=;
        b=GmTpNn7j443rWTaBrn2a+Xm8Mf57rugyql/sfQKQl41BnT++TTrkQWKpwtBkgTqIpx
         gXC0S9lJV2Y6X2zLTQCnh/ymk8VQzQp28U3pzZN/o/kX9RTJLmtt05uLjQGP9u/Qyp72
         jGLm02c9aDhwP9xh3QachIhVEkb9a1SD7fT4QIrQHgXoteo5Vse17VXjXpzAc8gpwJIT
         mfnQAi1ViKm2GxmpgAojEGaa+8MUoMrjXZn3xqaRP+XG5HRvQ0FANlGRoM19Nt/IZe+E
         cGPSeOTj4LQRiyiBxTPUS6a65DzPC5fQioTuB6hLIAjw64DH15g79YpBfsYKHRKAUuII
         guTQ==
X-Gm-Message-State: AOAM532tcX9NAi7etLLDCX8hwo2BTrEKoARCM+zZpOHs2Tis9j8Z1uA1
        Vhfot9wdffQvoXN1h3nZ5ACzpvN1JEk=
X-Google-Smtp-Source: ABdhPJxuERGHz2RKZOggLr0rAsVDqJNy1HTJhLuSsXzIKHP1+GPfm1WPNGLdbDJcLoLY1+uHFuw6fA==
X-Received: by 2002:a63:e617:0:b0:382:9ad9:d829 with SMTP id g23-20020a63e617000000b003829ad9d829mr12471144pgh.553.1648766286166;
        Thu, 31 Mar 2022 15:38:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:38:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dov Levenglick <dovl@codeaurora.org>
Subject: [PATCH 22/29] scsi: ufs: qcom: Fix ufs_qcom_resume()
Date:   Thu, 31 Mar 2022 15:34:17 -0700
Message-Id: <20220331223424.1054715-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clearing hba->is_sys_suspended if ufs_qcom_resume() succeeds is wrong. That
variable must only be cleared if all actions involved in a resume succeed.
Hence remove the statement that clears hba->is_sys_suspended from
ufs_qcom_resume().

Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f24210652fe9..808dae751527 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -640,12 +640,7 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			return err;
 	}
 
-	err = ufs_qcom_ice_resume(host);
-	if (err)
-		return err;
-
-	hba->is_sys_suspended = false;
-	return 0;
+	return ufs_qcom_ice_resume(host);
 }
 
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
