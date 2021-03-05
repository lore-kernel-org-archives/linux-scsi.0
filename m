Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D74C433E9
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 08:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEEB465015
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 08:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCEIsD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 03:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhCEIr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 03:47:27 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9B0C061574;
        Fri,  5 Mar 2021 00:47:27 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d12so1594708pfo.7;
        Fri, 05 Mar 2021 00:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iXKUWbmSLel/CjieMrQtXA0OopXZ8i0L9q59UfEsA0s=;
        b=skX3ruyx3cB6ZanqDYCAHTQzs+jzI4cnVjOOexKNwYf5usKc8EbUNNMoJGI/3KR7dC
         +9QnguEddejP6D60EtKXdYKgHejnXZbHHZOiyUq7hpdpmp2Pcfu8xpWSQsBQ0Ng/Knq3
         PEQBDGsOz5ZQXdQb0pWHw5602hr7ICNobyzdDnWBJrED/bMVbEQsEd2n/sdwi21QqB5Y
         +9KGQaQ1U6G7pD8qqZLVrRruFbHIQLfHKr9I8Izse9DoPMUbsNsw5N2NJXsCIihUanjO
         Z45AjsJ5j6Wz3vxsdsNKigadJUpyDq+sAMWwv6GFEhyjre5ZuecAWkaamN46wMqbVdXK
         8KQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iXKUWbmSLel/CjieMrQtXA0OopXZ8i0L9q59UfEsA0s=;
        b=rdcQaao0XBNbN5ZMTMQ0nozXei4CGBBc1QZQDJTQg2bQXdfbzYf1axGFmAHwDykLCo
         Legjo3j2qEKmi+n/ngLszPQnVsgnpqKsHOaSzCJ9iZlwmESTjx2jFkyc3kLtJ1bJfji9
         oKeylA4iWdAVnj8k7rqRBtsEbZ0aeu4aij4lU5ds/bvc7IE3iGdSixNkCP9ntnwdstYS
         mGNC0LIi0Do6UYY93gAxWUuHqsUhzAbTQUJY3+H09zgLizhtYM9Vft06sVXZLzOaWXNe
         JxXgfQ293gOceq6CViYtzVAOK/zhzu1UKHtVmZloBrr7Eh3V6w9eyzOuS8lm5e44vYlD
         mtJw==
X-Gm-Message-State: AOAM530ff83v2p49ikmBx1KznedcZEJVaciEnfaUJd5iX1ejBkwv4j+j
        sbfYMHcNDXejE6JonaPmtEE=
X-Google-Smtp-Source: ABdhPJy7+djtqogavZnlVRBFra1BNaxIq3rv16L8ZDRVEHRYdhxWaAozpsxz4/f+Csk+HDM8H8S8Rw==
X-Received: by 2002:a05:6a00:886:b029:1ed:b546:6d1f with SMTP id q6-20020a056a000886b02901edb5466d1fmr8202804pfj.22.1614934047345;
        Fri, 05 Mar 2021 00:47:27 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id js16sm1664393pjb.21.2021.03.05.00.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 00:47:26 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        tomas.winkler@intel.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: ufs: fix error return code of ufshcd_populate_vreg()
Date:   Fri,  5 Mar 2021 00:47:18 -0800
Message-Id: <20210305084718.12108-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When np is NULL or of_parse_phandle() returns NULL, no error return code
of ufshcd_populate_vreg() is assigned.
To fix this bug, ret is assigned with -EINVAL or -ENOENT as error return
code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 1a69949a4ea1..9f11c416a919 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -113,6 +113,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 
 	if (!np) {
 		dev_err(dev, "%s: non DT initialization\n", __func__);
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -120,6 +121,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	if (!of_parse_phandle(np, prop_name, 0)) {
 		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
 				__func__, prop_name);
+		ret = -ENOENT;
 		goto out;
 	}
 
-- 
2.17.1

