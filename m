Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D84C432C3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF93D64E62
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344206AbhCDAcu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbhCCOw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:52:28 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AC6C0610D4
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:46 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k66so6597479wmf.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lBd3mhum3iznaNqZKn6V0dfRsruKQEBvPHwSxnJLfOw=;
        b=TA2ez8f1+NR17l8Kjs4orjAaRYg+zV3POcSh9BRZj/iq+c5wSnTeqe5tUo3QL04/e9
         +CR9MwU87UNZP69kNmstRS90LeXzoR6cQbcN9QIi8KbxMwnlwX9geOH8iykT+OS6OiXW
         HhUGm8MrzFONvdUBzyQ0a3vpLk7TZHvHG/PHJ6HH+lYWPnn8m2/zRc0c+4wRRLWXeG1/
         qjyllCGCgHJ+8kc456nPvVo/p4UB4uI/yAz/wb6HcgDl9VedE5DL92TsUulu13GfnKRT
         Im+miH5KyuHozlU+1RLgYoU7jJR2rkCBuLJH9QUh30NQd9R0sAzpn4NdpQFUazIS3dlq
         RuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lBd3mhum3iznaNqZKn6V0dfRsruKQEBvPHwSxnJLfOw=;
        b=KVxF2hiWW1zLNGHrinu/lQ1OZJ8JUd4jk4bRweBNcvs0XqLpjsFJs/a6TNUIezgoiU
         RKBet+1acVC5ib1QQqXfzSMHOSJw/oQYbUClLDVkdEa+sWGSnHvPMU3RSShgOKlSPUge
         iu6hrUV4OfsbrRBGNwsuCkMxa/s39XKT+2h8wFBj8jiHWpfcJAt+R/mNV0hbRD3gBFkt
         i9bmOO98/76vILPjo0+uzwnRBJypkncGMr1LZp36lSIhgMX1qtFXe09kM3ehFW7CrtGf
         DotpEmndobscx97idchmpMnZq1o/bhc4L2vCNjj61GmKzOIkfWB4UhkEUI4hLVkgGIGd
         DPvg==
X-Gm-Message-State: AOAM533lKtZb5uDoh3WPee3NmuSqfBjGnbgylMwJMH3vX2tH79FEoAT7
        Ylw2RPTVcyxZ6NB4SVv1elYjHg==
X-Google-Smtp-Source: ABdhPJyoUpg+wabiSX2sgKaMiIAIZGMnh5GPtY5xy2cqfeln3gomca4nX0KM/2O9xjq8DEUaNKzUcw==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr9377894wmi.132.1614782865345;
        Wed, 03 Mar 2021 06:47:45 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:44 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 27/30] scsi: lpfc: lpfc_hbadisc: Fix incorrect naming of __lpfc_update_fcf_record()
Date:   Wed,  3 Mar 2021 14:46:28 +0000
Message-Id: <20210303144631.3175331-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_hbadisc.c:1505: warning: expecting prototype for lpfc_update_fcf_record(). Prototype was for __lpfc_update_fcf_record() instead

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 48ca4a612f801..15d6d88333c10 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1486,7 +1486,7 @@ lpfc_copy_fcf_record(struct lpfc_fcf_rec *fcf_rec,
 }
 
 /**
- * lpfc_update_fcf_record - Update driver fcf record
+ * __lpfc_update_fcf_record - Update driver fcf record
  * @phba: pointer to lpfc hba data structure.
  * @fcf_rec: pointer to driver fcf record.
  * @new_fcf_record: pointer to hba fcf record.
-- 
2.27.0

