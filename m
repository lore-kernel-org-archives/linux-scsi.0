Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEB3C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 20:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B73F060FF0
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 20:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhEQUw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 16:52:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237148AbhEQUwZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 May 2021 16:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621284668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qidodmYtOq/bVdiDmZy2oVcc1WKBd5gvipIegl/6mHQ=;
        b=HZ5h9zyLoLVHRR+srb6WiV7dIrY1IJB49oklwtAWKI5F7eZLKUtcLyTgU+DB6X6HaZCsxs
        aLbZdyip0r4VwNDoPY/uZQf9mYEIHjLSmK/PAO744kJsEuufcaC3Hz/7RywVwfkgJaCpoq
        M4y2eq/p6zpzvXg9tVActiIC6WCM4ew=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-Yey_11KTPH6PXUaR4Xyu6g-1; Mon, 17 May 2021 16:51:05 -0400
X-MC-Unique: Yey_11KTPH6PXUaR4Xyu6g-1
Received: by mail-qt1-f198.google.com with SMTP id g13-20020ac8580d0000b02901e117526d0fso6037242qtg.5
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 13:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qidodmYtOq/bVdiDmZy2oVcc1WKBd5gvipIegl/6mHQ=;
        b=GQgZBUdLywHYHv0yIvN4Bp7gP7qZXCfu37jjOgS116J+v/+ddlv/zoN3o5qAS1ShjB
         V9DeGby115kG3ZQ4juk5Nnd8M37xEfLld5PaY+g0An3ool/TaxRqE/SuEV73x3LFkmoY
         8w2wCx9Fiy7JeX7uQTXGQaNodVMdtlHBBE43Ub6jCxRkXJYIrGZPvDB9gMlbOTdnPewI
         90QvI3HXwy7/B4Wd0oa0mR/4RWgRveA6lHcICcGggLTRdutoM/7Uk5/zkOhBvFyvcfvp
         ARRnqOEWZnqEc13bWls3RjenCqHkTqFgB1mCvdqJV5iKKuep7v/JTqBPibf5P4dwZuVA
         Q3Lw==
X-Gm-Message-State: AOAM531Kxj9vhwG2zlCDYRDCJzaprxwPQxYF7pvUvPimWbNtojclRH8K
        /7668xa5cRAScLjiqtHFGwM2N+hxdyuQarK6Oe+35jC04Etq00LUPfv0U2u7IzMylT7wK1SY3KZ
        WZpdvFbQpOMKnGr8NaFGLLA==
X-Received: by 2002:ac8:7e8c:: with SMTP id w12mr1393763qtj.384.1621284664702;
        Mon, 17 May 2021 13:51:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf7r8oNdaJYHYWe0zaANVtHXBioBvnDbPzxB+JhLVOkDKrwobi/FReLeV6iQBIPNR96tGYoQ==
X-Received: by 2002:ac8:7e8c:: with SMTP id w12mr1393754qtj.384.1621284664537;
        Mon, 17 May 2021 13:51:04 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id f1sm11227045qkl.93.2021.05.17.13.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 13:51:04 -0700 (PDT)
From:   trix@redhat.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] [SCSI] aic7xxx: remove multiple definition of globals
Date:   Mon, 17 May 2021 13:50:57 -0700
Message-Id: <20210517205057.1850010-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

When building the aicasm with gcc 10.2 + gas 26.1
Multiple definitions of global variables cause these errors.

multiple definition of `args';
multiple definition of `yylineno';

args came from the expansion of
STAILQ_HEAD(macro_arg_list, macro_arg) args;

The definition of the macro_arg_list structure is needed.
The global variable 'args' is not, so delete.

yylineno is defined by flex, so defining it in bison/*.y
file is not needed, so delete.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y   | 1 -
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
index 924d55a8acbfc..65182ad9cdf82 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -58,7 +58,6 @@
 #include "aicasm_symbol.h"
 #include "aicasm_insformat.h"
 
-int yylineno;
 char *yyfilename;
 char stock_prefix[] = "aic_";
 char *prefix = stock_prefix;
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
index 7bf7fd5953ac9..ed3bdd43c2976 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.h
@@ -108,7 +108,7 @@ struct macro_arg {
 	regex_t	arg_regex;
 	char   *replacement_text;
 };
-STAILQ_HEAD(macro_arg_list, macro_arg) args;
+STAILQ_HEAD(macro_arg_list, macro_arg);
 
 struct macro_info {
 	struct macro_arg_list args;
-- 
2.26.3

