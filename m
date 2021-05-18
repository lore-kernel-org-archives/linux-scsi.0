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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B269FC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 13:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE9E6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 13:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349504AbhERNTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 09:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhERNTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 09:19:52 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1FCC061573;
        Tue, 18 May 2021 06:18:33 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b7so909793plg.0;
        Tue, 18 May 2021 06:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=db+i81oaJnqS/hNDj62vMgPodT5DS9VOJUhp6l/b6qc=;
        b=VBHgtNKexUwXXXOMp4zZcF8Rs7S0TxJ2MPoNFs+lhYCMI7tpE9DLBsebzzgmtYkhZl
         aLVIW4QuT+5BgYrbcTFIkLdCLXCPJQvM7F+YWMISGVSrSMsaYP9qum+kPoNSNiWezREb
         kwSfy9BLZbZLxJT7kwpawYCXlfBEgBL0kpNVdej/lF/QARYz4oHVSxQBFkTZTK427wsW
         TZlWbcClNY5lZ2fENRI2BFvb8lSl3oDLFJp0BQFQSVyFPEHp+gBeqjQxRXli4Ik6JR9n
         ah3Fs34aIDQGST1kbsFxht4jwdKMy+JcYlJxYVFNTZc8BXkpfxeNAF0v4CvGDLVIl2J6
         4wqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=db+i81oaJnqS/hNDj62vMgPodT5DS9VOJUhp6l/b6qc=;
        b=KIyouPbnMOs5/zxTciTkQ2t8OoxnCx9Ao1hOdNK3ggyv+lvmgIcDQOfX8qIH/XTwFF
         ga+wLGm6DShgEZgwKrruPHiN/HmB34Gt/ZFD6g2TgVtXuQgD0sL/RyTRr91JK/dxOosU
         R6xh8a6ktlOfDy+kTWD03/pQ8PjddImw0TBUlSUsZVen9QFTZcEnhvwmrRsoUayiFMoJ
         mbGJWJjOmt/6sYSQm5eCzMsOnLzIcjgmzj2rkthEEIatAXjM5vWVLK8sH+N3q9CCvSS5
         GDhsyKwrsx4CrnjnG+1/RSqmMI0DmDOxYRmAaxxG1Xtugo8KU5OoXMGHWfCn2TSJ43DG
         Cu2A==
X-Gm-Message-State: AOAM5335LabvYArSnglJ2cmwAINUex4zdp7VTSNPPuMO2G/fgOC0Lyk9
        zmL2rTpCrAxTeLME7yXpI+GHgcR+aE4RbRRNAoY=
X-Google-Smtp-Source: ABdhPJy1mcOissW029MvyEYLfMk/bt/BpgcFgjlGuUcufWga93NKMgt3dUfL3OA5tjt6pLfS7k6GUA==
X-Received: by 2002:a17:902:c104:b029:ef:836e:15d6 with SMTP id 4-20020a170902c104b02900ef836e15d6mr4626212pli.39.1621343912730;
        Tue, 18 May 2021 06:18:32 -0700 (PDT)
Received: from localhost.localdomain (host-219-71-67-82.dynamic.kbtelecom.net. [219.71.67.82])
        by smtp.gmail.com with ESMTPSA id y190sm7776782pfb.69.2021.05.18.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 06:18:32 -0700 (PDT)
From:   Wei Ming Chen <jj251510319013@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@armlinux.org.uk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Wei Ming Chen <jj251510319013@gmail.com>
Subject: [PATCH] scsi: fas216: Use fallthrough pseudo-keyword
Date:   Tue, 18 May 2021 21:18:23 +0800
Message-Id: <20210518131823.2586-1-jj251510319013@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace /* FALLTHROUGH */ comment with pseudo-keyword macro fallthrough[1]

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Wei Ming Chen <jj251510319013@gmail.com>
---
 drivers/scsi/arm/fas216.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2e687ce60753..9402cdce7cc5 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -1479,7 +1479,7 @@ static void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigne
 
 		if (msgqueue_msglength(&info->scsi.msgs) > 1)
 			fas216_cmd(info, CMD_SETATN);
-		/*FALLTHROUGH*/
+		fallthrough;
 
 	/*
 	 * Any          -> Message Out
-- 
2.25.1

