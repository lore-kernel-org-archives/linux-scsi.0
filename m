Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B994CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C25464F18
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCQJN0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhCQJMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:54 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB429C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b9so999260wrt.8
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+TrWWm0u4bkRuEOT45xP86ethIB2XLy+WRaBoR2YJ+Y=;
        b=VIU7VFuz5FaJXnrl9FYPf3rxVYPBQWgLnoJoYBjIu9hzCiLb2B7JVy56eYs6thk9pp
         nh8uALrJCoQWEGtoLIqMttVd2Gsig45UXefS1V8Dz6B4oPieaTqX8td379g90niYUFbJ
         goG0QarAtS3jmh6e5kQmM+C6LHSBySWO7ovtr3QSVC21mDhxEIgSFY7Uzb0GMeb5Vt51
         K1zcE86PVNtkzSMJjp0c1Ba/1iClc4t/qBAVz5PPxLKbMZPJp0Elc2TonTJREObJc3Hi
         JFngZUqZhXxF8RS+wR8kjCNsZi7mfDYTaQDlgCnkV6bAsIsEvcMnSRdzBJdcjFI7Pbb8
         As0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+TrWWm0u4bkRuEOT45xP86ethIB2XLy+WRaBoR2YJ+Y=;
        b=CX/iw3fbl580spI6XhT/EhHg3dGl1Tcoif9pg6OXR9uF9TtDK+h7/CbKn6FiZjjRLT
         SQEBjuDeuw3GIHLpV5nAdor09EUwUebaH/IUHvOax6tGukKdzgAIHufEusPIRQqdJFT1
         T+ZcyBeItMjplQv3oExKK3zIvW0IUCeg/zqTSbcGrhrJKhQdMIZB4f0iveTjMkW2QWpX
         iqWvsd6EJzbgFFIl5Ae50DZr5hmPFfFMKQhAXWqiR+xyUlyh82nKHarLwl4VGD7FjXaE
         59fe77wGFnMoTcnyqLgMBLoB+gTYVQG4/bDhi4OSvoXOQVej+dnuhMamjfUx2o3vs0Sm
         ZNUA==
X-Gm-Message-State: AOAM531zEddhxkGQ840e0yrpNoPveQBuV8CyLXf1BrVfY6CvuxVaG2nN
        OerhJKWYpu0jmuxghO6kS7R/FA==
X-Google-Smtp-Source: ABdhPJwBBf2pDosK0iW19obpUhKOTMSrb6xpMCOntwaCTpUr7GR90px+cj4jvKue9GwRILV9AXevtQ==
X-Received: by 2002:adf:e7cf:: with SMTP id e15mr3375157wrn.346.1615972372441;
        Wed, 17 Mar 2021 02:12:52 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 12/36] scsi: myrs: Add missing ':' to make the kernel-doc checker happy
Date:   Wed, 17 Mar 2021 09:12:06 +0000
Message-Id: <20210317091230.2912389-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/myrs.c:1965: warning: Function parameter or member 'dev' not described in 'myrs_is_raid'
 drivers/scsi/myrs.c:1978: warning: Function parameter or member 'dev' not described in 'myrs_get_resync'
 drivers/scsi/myrs.c:2002: warning: Function parameter or member 'dev' not described in 'myrs_get_state'

Cc: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux GmbH <hare@suse.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/myrs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 48e399f057d5c..588c0de006b02 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1958,7 +1958,7 @@ static struct myrs_hba *myrs_alloc_host(struct pci_dev *pdev,
 
 /**
  * myrs_is_raid - return boolean indicating device is raid volume
- * @dev the device struct object
+ * @dev: the device struct object
  */
 static int
 myrs_is_raid(struct device *dev)
@@ -1971,7 +1971,7 @@ myrs_is_raid(struct device *dev)
 
 /**
  * myrs_get_resync - get raid volume resync percent complete
- * @dev the device struct object
+ * @dev: the device struct object
  */
 static void
 myrs_get_resync(struct device *dev)
@@ -1995,7 +1995,7 @@ myrs_get_resync(struct device *dev)
 
 /**
  * myrs_get_state - get raid volume status
- * @dev the device struct object
+ * @dev: the device struct object
  */
 static void
 myrs_get_state(struct device *dev)
-- 
2.27.0

