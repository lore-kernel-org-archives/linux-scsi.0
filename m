Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_DIGITS,FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D904C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14713610FC
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhEaRWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 13:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhEaRVv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 13:21:51 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AB8C06135D;
        Mon, 31 May 2021 08:37:38 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 6so8579766pgk.5;
        Mon, 31 May 2021 08:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YWggVXdnRquifL9/XQ7A1rwSATVVaZDpBuuzR8KgOIA=;
        b=bG6ubn342OMxLyaPeuwmfF2u/OMxTcoT+sYJlLLQ79jezBNF5CMewJYAC8sBwWAA4g
         DFFze21FT1dZkEWAplVBoKUNtIkC5atjr4Fl8DbbBbCmWTXnHkosOdgzxe3Zp6fABsZ+
         n+WlrHyUaG+fALdc2YPc3lFSrLwwJVQY7KzqaaddNu6UrZhzwhYvlsxWMAsak33Jvh49
         WGDaj/STupZCr+XAJUnm4H8RM3My8l0imC36ZrX20Yvwab1XwxonoIJF76/Bw8t9mIPI
         CcOAVxy/i4voDVDUOVD/d3alORmVQuBJC3mjA3ITLu7TzcYC7JhHiXrd12r72KDIKr3f
         zNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YWggVXdnRquifL9/XQ7A1rwSATVVaZDpBuuzR8KgOIA=;
        b=Afe20AG69YBgtVmvot5UTc3/nSmJ9u+S8BluW130OmXFIEBKzwMOymliw5JOKFbhqB
         GadGnUnH05zgtOFP+WTMlTv07/TkXO+88VXdXPaGxggK849HfiLGy53zOapoQe0RjNiH
         o8Azv8GLs9JbiXesa+5rjbkGfKY1hx7w2408HePR56bxU23JDqinz0xuAEHGvs4v5a9t
         vcZC4bhruRa+pwMNTVIPBGletl+RPhhpJoHLIv0z6Wmd/mqKChvLrPoFhXFfLcFqBHyG
         q3Or3OGuhowyaeiF6Z5exInLtIGrCP+4/QAueQyLqf2aQZ8/RwPW4CJIlwDqQtwAzZpM
         bIbQ==
X-Gm-Message-State: AOAM531sXEotu+X+AfN49LHVlXko44+HHWx3ZyV7knoGAxoQjnFjqVeC
        TOQNHVYJ7hB1qr6im/BZCXJ0Of1dmFt3l4Kl
X-Google-Smtp-Source: ABdhPJwqQaHzxp9hDoy5UejzPtg3Au1UT6XsGczk63F+ShYa7WGhmA64LAzduQsBj+cGi+CIpMSZiA==
X-Received: by 2002:a63:3c0c:: with SMTP id j12mr7299517pga.377.1622475457423;
        Mon, 31 May 2021 08:37:37 -0700 (PDT)
Received: from localhost.localdomain (host-219-71-67-82.dynamic.kbtelecom.net. [219.71.67.82])
        by smtp.gmail.com with ESMTPSA id q23sm12252748pgj.61.2021.05.31.08.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 08:37:37 -0700 (PDT)
From:   Wei Ming Chen <jj251510319013@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com,
        Wei Ming Chen <jj251510319013@gmail.com>
Subject: [PATCH] scsi: libsas: Use fallthrough pseudo-keyword
Date:   Mon, 31 May 2021 23:37:24 +0800
Message-Id: <20210531153724.3149-1-jj251510319013@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace /* Fall through */ comment with pseudo-keyword macro fallthrough[1]

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Wei Ming Chen <jj251510319013@gmail.com>
---
 drivers/scsi/libsas/sas_discover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 9f5068f3bcfb..dd205414e505 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -461,7 +461,7 @@ static void sas_discover_domain(struct work_struct *work)
 		break;
 #else
 		pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
-		/* Fall through */
+		fallthrough;
 #endif
 		/* Fall through - only for the #else condition above. */
 	default:
-- 
2.25.1

