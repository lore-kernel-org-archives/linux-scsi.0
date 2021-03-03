Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9981FC43603
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72AA664E62
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355625AbhCDAcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359481AbhCCOsg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:36 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B7C0613AA
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:18 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id 7so23991447wrz.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gGrr9T7NomFeuiTH4lgL2Bpnb+NGOdMtM4BXDpHgTNU=;
        b=xkcY0dECP581NNSgUwVihjJSM6/h+SZYYMJ0ZakPWJeLpf2+EFMp471iI8sFQUBPe6
         kP/YQsFS1cRv8DHlqXuG+F2kBmMdye1VPNqDt0/MW2u7xwtFWUTkdp0tFuGTCJh2/mA3
         mhx8GhyWZxMVJz50WUnQbr06OoS9cjTADgiP7AAmyh92XbHwZYaompYG2LAvuHJetfoe
         13htKb0UJ7QPQJezKv11jPeMMnWy/P7CU+cvPIhbPHG2G+cvw+O65i1xeZeWHOBEVOx7
         WzEEKGB959vWbTOJzmoEq6V1lF0zINFxSkITJPVnM4xzilGthJUw0PoBUOpHOtJDJyZp
         qqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gGrr9T7NomFeuiTH4lgL2Bpnb+NGOdMtM4BXDpHgTNU=;
        b=n9vTtPIvATUoVMfZckNz68VyHHN00En3oYUcaZCj/kesFZBFD1qGh5+P3n5oKaQq4i
         NKJRQv7RQ/6ncxvCZ8egLOt5J1cmgkbG/iGx1LDht9Awu+DkQD0majolDil9os/rdd0Q
         jzlL8oziNCQ0MDZ3Y9YPl1v+kgCg0RZb6D3TaH2L6JKeS4dsqIhy4xtmQnK96De1b/D0
         MJZGe26x8T8O2ZpPQOfuZGmw4YBFHQZNjWhOyEEVT7JIGB41gO+KXTgePjajplzYE0+o
         fkxx4z8DyPtxxGv3Wh/SCVfyZ42K2x+Gu/9ODULd79ggZIzR/PiyzyWqi9VknDHZjQPQ
         FjxQ==
X-Gm-Message-State: AOAM531KH+oTqCIsRWH7nrxisMfu6I6ww0EjvDNoIiXigewvJwIEVaRL
        QRsyDpPFtugkL8OdgIZ9WxXr3Q==
X-Google-Smtp-Source: ABdhPJw6jTNXLQqEabROh13Z9vvXRfzv0RD4iGLhlsh6uyIdkRDhebVScqDZgnGZ65QDWI4dNUdD2g==
X-Received: by 2002:adf:d1ce:: with SMTP id b14mr27614718wrd.126.1614782836318;
        Wed, 03 Mar 2021 06:47:16 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:15 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/30] scsi: qla4xxx: ql4_os: Fix formatting issues - missing '-' and '_'
Date:   Wed,  3 Mar 2021 14:46:13 +0000
Message-Id: <20210303144631.3175331-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_os.c:631: warning: expecting prototype for qla4xxx_create chap_list(). Prototype was for qla4xxx_create_chap_list() instead
 drivers/scsi/qla4xxx/ql4_os.c:9643: warning: expecting prototype for gets called if(). Prototype was for qla4xxx_pci_mmio_enabled() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7bd9a4a04ad5d..597a64d91fe92 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -618,7 +618,7 @@ static umode_t qla4_attr_is_visible(int param_type, int param)
 }
 
 /**
- * qla4xxx_create chap_list - Create CHAP list from FLASH
+ * qla4xxx_create_chap_list - Create CHAP list from FLASH
  * @ha: pointer to adapter structure
  *
  * Read flash and make a list of CHAP entries, during login when a CHAP entry
@@ -9633,7 +9633,7 @@ qla4xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 }
 
 /**
- * qla4xxx_pci_mmio_enabled() gets called if
+ * qla4xxx_pci_mmio_enabled() - gets called if
  * qla4xxx_pci_error_detected() returns PCI_ERS_RESULT_CAN_RECOVER
  * and read/write to the device still works.
  * @pdev: PCI device pointer
-- 
2.27.0

