Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D789AC11F67
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 09:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C567361396
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 09:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhGNJVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 05:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbhGNJU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 05:20:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD8EC061765
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:18:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h7-20020a5b0a870000b029054c59edf217so1829728ybq.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FcI/RIY6fqkfvACcmmOBOBRj9VFnw/wDoj5wb2ryU84=;
        b=TNW6CpKuyM53R38THHQO0l30/FsZ9YikSCaulyuCOpmdp6eXcsXkoxcbkYcVlTa3HD
         x5q6GlfQUimHaaisAjdfphUOz0/lKnbvGxdC7Oi6oP5BWmA7oqA7E3vm+QLuu6KygR9u
         7yXW9+luCs5FgL4y1khvw0TU3nzvQa7VivWYxwQur9hapOKYRW2OkZubYBaudJiGGbWS
         bKx9ntWf5faubfJyRLuMSGX8nYX+mPHREiJSDZsAXBBYqLWVPb5DwY/88NJsaN3WrC5W
         9r2Hm467OjHp1bMdchvb14u00iAstp/YVlY8woschlERs0/4VVpFxu1lpj9OrCNU+r2e
         +4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FcI/RIY6fqkfvACcmmOBOBRj9VFnw/wDoj5wb2ryU84=;
        b=A/4rr7RpG8r9VKpXB0uZ3n7Hce7yWIaCwG8PnkIxL9dEBOi7gx29qw493H5bwEi/KI
         EZSXcSd0utE417UlxIv/iAVIvjYgL5o+20m2XAtmaks2lS9GpeiR6E+4XRNK+NwKFRRh
         O1XYe2rEihTa2aYuFTS7GBgMxOwSir5QIMb0cF5ezNenBbwYrM834VnyyGFY9RmqBJxj
         +FbfXejWkzVblHMTsAee6pqgPBMXadSUBmtT7hMtItLT4pz7GGBr6fzsGpwxRUn9qbay
         ZhEPWcoMwJ//QcKKtpSA07XsZ6/h4NwcvEnDLEh+EWNz3M/xhuLz+lijRWbxwXXLc+YD
         +9Hg==
X-Gm-Message-State: AOAM53259K0K3c2GAnuLRI9kpvIz+j+BvJbrMU2IGYZjKsbziLkbTNwx
        EAVtOV7elsgUJBuSfKdooNqJ9cO4
X-Google-Smtp-Source: ABdhPJwQumiJEuoqIwwwDHzc73CCuMQCDncvnVhvq5UA/X4SUeW+Mf62MlhxfQh8V4UyJqwzttHAa/vVQw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:c569:463c:c488:ac2])
 (user=morbo job=sendgmr) by 2002:a25:7355:: with SMTP id o82mr11572449ybc.471.1626254286988;
 Wed, 14 Jul 2021 02:18:06 -0700 (PDT)
Date:   Wed, 14 Jul 2021 02:17:47 -0700
In-Reply-To: <20210714091747.2814370-1-morbo@google.com>
Message-Id: <20210714091747.2814370-4-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 3/3] scsi: qla2xxx: remove unused variable 'status'
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the clang build warning:

  drivers/scsi/qla2xxx/qla_nx.c:2209:6: error: variable 'status' set but not used [-Werror,-Wunused-but-set-variable]
        int status = 0;

Signed-off-by: Bill Wendling <morbo@google.com>
---
 drivers/scsi/qla2xxx/qla_nx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 615e44af1ca6..11aad97dfca8 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2166,7 +2166,6 @@ qla82xx_poll(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_82xx __iomem *reg;
-	int status = 0;
 	uint32_t stat;
 	uint32_t host_int = 0;
 	uint16_t mb[8];
@@ -2195,7 +2194,6 @@ qla82xx_poll(int irq, void *dev_id)
 		case 0x10:
 		case 0x11:
 			qla82xx_mbx_completion(vha, MSW(stat));
-			status |= MBX_INTERRUPT;
 			break;
 		case 0x12:
 			mb[0] = MSW(stat);
-- 
2.32.0.93.g670b81a890-goog

