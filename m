Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D456AC28E85
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A3E64F79
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCQJNp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbhCQJNJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:09 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CB5C061762
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z2so1003625wrl.5
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IluqkSQMn8CKgpw5oiypEg9tUin6IKhqy/tdt7BWHLc=;
        b=yaC9Ui5M/Mnh0wAEIKT1N7sYEAlln2B+SYJlfs6ss6dUKqe/dbySB9lNTg+CFrc8Td
         i/opdyB7xjZOnZ6dC2ZffiCp/rEdUCS0jzpSdWpmPo9zVnRYXHSPz6emweQnGM5yt7Y+
         NjNUTblzvlkdMDcGFH2gyl9e6/R90cgTT/j6yaj+mscqX5DF0O9TVgO/2N8Yle9rn4TN
         DFFMLGTbVnrR7d2n7iQKjqZEyS2bXVGXxPefGQ8w6IEUJ1E8Sj671Pp5YY0SliGfJ+AW
         qmnv4fK6kHOMHLyUDBButQM7IUqAe+RURxvuM9maUGwSB0yGeGgOlfwCISKmxtz/r+cS
         Uccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IluqkSQMn8CKgpw5oiypEg9tUin6IKhqy/tdt7BWHLc=;
        b=LgCYNz4beoCy/5wEkRgBKwOQ4EwBNnQUk+mixVYR9pxv+v33BiuzadlX1rE+eEoRPi
         s54/sOqA6uVFQj8if89mRVWMdDK0hnmLxpZl3PSd4yV2P1psBHAajzwczg+E2HUPtBIL
         +dBn3+pLWH0yqT8l3DYOOAaMLgYHM3kCVCq+VFWIOZUm469cL+aU1fS2gZtqpp/eqPOd
         3cwNVESU6XwYGdUGaRwoMNUNar7EJK3uRY68iW5QpqF0wpEtQ/9/ot0kJ4g1B17eKDTK
         OCmaGRcRn65LhvZaWcopgKfXW4oZf2DQckP2WC1KvYCDx32kXYa7QpSZUOudj0CBT4TX
         JCsw==
X-Gm-Message-State: AOAM532fSDVsA6HrRt0fSUsMbAcuGb29Gvuv3MlwT3d+gaJZfIp/ZbPp
        rcVRSYkSio4yUPVZ7A8B/YFaUg==
X-Google-Smtp-Source: ABdhPJzcBOnX92Ww/rSQNUfeEl8qNufx2ENRJMJIzU3NsBsg4A/OTUyF1pfciffScxC8ysDuHANX6g==
X-Received: by 2002:adf:f948:: with SMTP id q8mr3333367wrr.296.1615972387660;
        Wed, 17 Mar 2021 02:13:07 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 27/36] scsi: isci: request: Fix doc-rot issue relating to 'ireq' param
Date:   Wed, 17 Mar 2021 09:12:21 +0000
Message-Id: <20210317091230.2912389-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/isci/request.c:496: warning: Function parameter or member 'ireq' not described in 'scu_sata_request_construct_task_context'
 drivers/scsi/isci/request.c:496: warning: Excess function parameter 'sci_req' description in 'scu_sata_request_construct_task_context'

Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 49ab2555c0cdf..593b38c59924a 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -481,7 +481,7 @@ static void scu_ssp_task_request_construct_task_context(struct isci_request *ire
  * scu_sata_request_construct_task_context()
  * This method is will fill in the SCU Task Context for any type of SATA
  *    request.  This is called from the various SATA constructors.
- * @sci_req: The general IO request object which is to be used in
+ * @ireq: The general IO request object which is to be used in
  *    constructing the SCU task context.
  * @task_context: The buffer pointer for the SCU task context which is being
  *    constructed.
-- 
2.27.0

