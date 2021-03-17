Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD0DC2BA2B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D33B164F30
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhCQJNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhCQJNN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:13:13 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEA1C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:13 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k8so1006096wrc.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qZ7whSvid6Pc3xtKuqRZT/9oZ2iuDHT7pBFCqGUvkpY=;
        b=r1SRHSkYIwyEfqsq1wyBuRYYAgpRk5Sc8j6/XO7RQoR88xSQS+2pccnHAiXSUyUePC
         k+2ERUT63Dg5OVo3KcFE04zGcdoui5LVqz7jJ0iV3u0SwENiQWc4QvTXyPj1gubsv2f2
         XK+94NY3vk0d68kIBp1iLX8YgS0JWlbTKxgnI/eZmznFw6g58oDeIR32aEgP1rLrApLt
         +khv26cStuAufRAjNlImMvBWXmOZEHLz3q4nFaShCJJDX0KTYC8dfCVpKLWJgUpNN4XC
         4fqAnReU1aLl6jrN6Bfv1fynWtML/i2RJVjqv43lvl9ggNWDGCPA0x7SUKa+/lGQ/yO3
         +mzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qZ7whSvid6Pc3xtKuqRZT/9oZ2iuDHT7pBFCqGUvkpY=;
        b=UIx+iLbt+EGd5rtqXAD9zuj5y21qKVUagX03Edh04V6VJODsJsECzWu9eNnlo2Casb
         JaXbXSr94TY81+2EMELyTtuqWzBKhl/YrRpJIrBw8BVMHD/LxGyOHH2CTKAslOOLQxti
         Kt70c2AQBKCMSoQ9j7T2cRdmXnCanJN0IA7PuBoKBUyTonlzEPD8nwkkM5d2VojZaPNY
         rnV/gT2fcWlu/qlI48CMl7IKk0TVZrPRK+cK9J+nd2j+837UOJV7cFKnNERcXWccfjYz
         TeqXp37GxE2KA8Kvg90jATOFDBmdwQRtoi+pAw+4NH2fyPkH9rGpgiJYpID0+ixHZlNV
         7F+Q==
X-Gm-Message-State: AOAM531cquPV9GWHs3qUdgWpLuBY/VtVPSiypoPFjWXkCbsxpJxhTwLc
        S4R44fQ380udezqK7NaoIlo01/pp8G/nWA==
X-Google-Smtp-Source: ABdhPJwNIHLF7R6FsY/PyfuMJ6IgEnQzJ3ODYLqiR4aB1hX0XocL01mKbckFvANubQtpk+U0GKrB9Q==
X-Received: by 2002:a05:6000:23c:: with SMTP id l28mr3408383wrz.251.1615972392244;
        Wed, 17 Mar 2021 02:13:12 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:13:11 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 32/36] scsi: cxlflash: superpipe: Fix a few misnaming issues
Date:   Wed, 17 Mar 2021 09:12:26 +0000
Message-Id: <20210317091230.2912389-33-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/cxlflash/superpipe.c:38: warning: Function parameter or member 'release' not described in 'marshal_rele_to_resize'
 drivers/scsi/cxlflash/superpipe.c:38: warning: Excess function parameter 'rele' description in 'marshal_rele_to_resize'
 drivers/scsi/cxlflash/superpipe.c:51: warning: Function parameter or member 'release' not described in 'marshal_det_to_rele'
 drivers/scsi/cxlflash/superpipe.c:51: warning: Excess function parameter 'rele' description in 'marshal_det_to_rele'
 drivers/scsi/cxlflash/superpipe.c:528: warning: expecting prototype for rhte_format1(). Prototype was for rht_format1() instead

Cc: "Manoj N. Kumar" <manoj@linux.ibm.com>
Cc: "Matthew R. Ochs" <mrochs@linux.ibm.com>
Cc: Uma Krishnan <ukrishn@linux.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/cxlflash/superpipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 5dddf67dfa24a..ee11ec340654a 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -30,7 +30,7 @@ struct cxlflash_global global;
 
 /**
  * marshal_rele_to_resize() - translate release to resize structure
- * @rele:	Source structure from which to translate/copy.
+ * @release:	Source structure from which to translate/copy.
  * @resize:	Destination structure for the translate/copy.
  */
 static void marshal_rele_to_resize(struct dk_cxlflash_release *release,
@@ -44,7 +44,7 @@ static void marshal_rele_to_resize(struct dk_cxlflash_release *release,
 /**
  * marshal_det_to_rele() - translate detach to release structure
  * @detach:	Destination structure for the translate/copy.
- * @rele:	Source structure from which to translate/copy.
+ * @release:	Source structure from which to translate/copy.
  */
 static void marshal_det_to_rele(struct dk_cxlflash_detach *detach,
 				struct dk_cxlflash_release *release)
@@ -517,7 +517,7 @@ void rhte_checkin(struct ctx_info *ctxi,
 }
 
 /**
- * rhte_format1() - populates a RHTE for format 1
+ * rht_format1() - populates a RHTE for format 1
  * @rhte:	RHTE to populate.
  * @lun_id:	LUN ID of LUN associated with RHTE.
  * @perm:	Desired permissions for RHTE.
-- 
2.27.0

