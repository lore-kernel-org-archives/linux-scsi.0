Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B25C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0962078B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jRYy5lBl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgGIRqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbgGIRqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5197BC08C5CE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z13so3293305wrw.5
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z87wYd9sTBTgWM4PfTqIXybXjZhO9Ay2HDdpb30MaC4=;
        b=jRYy5lBldTck93hbAO3wZOubSpIDvgxm3p1B5mF4K1ZUKb6VnlFqm/ru/Al4l+4Cp6
         OfVsOsS549wwYMyKyt46/ZPKciS+cIHAYULljGRITq61EvjFy3fScyXk8bVuVG3k+h/y
         uZhg8NaPwvGFFwT3L3XsoExEgiFYFAp71MrF65x1/NttAniy2EUVaGlP0QPsNKl3Z7Td
         eNndREpoHeiexDIf8YAnVnHJjNu5eZZxycDg0ixlToq/M94/6xP5pJ7xMaDJHiE+6Dq/
         r1lXHBi3y26nN2Q7Wg8WF2049yUL9eWi6Ao2dodogn55PmiaLKxuFqltNGNBZLuCBbAS
         zQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z87wYd9sTBTgWM4PfTqIXybXjZhO9Ay2HDdpb30MaC4=;
        b=enqc3KWe50eeU0eFJHl5J6+Sr++KBnB0cmS6XKsrjKtdqGj1VVDFFrhYDDh1X8XAe/
         ZR6FzqGjiq4D7l7SJZCLNE5l23PuSr82HFV5N7FVnW8xKS6rfRP0EFufKdM8c3NYtx6D
         lz/dpL2JuGFiv15lZyLvMj/kQuIIHGXuchtWLrB1qhkZTajcvv+hVAAblY6wLqYwSp6A
         io9PpW1cQ/9PWGtN1+nArLC7tr9XkOH1qHFrCFVPt2ucEu6opVEod0W5ONDFrYXLY3mm
         mMYiHrENAxQo/JbIQph3TQtVzV5Eg4DQNBLTDj4Iu0pTygN+cpmKaMKeAFSwHw15bNij
         30ig==
X-Gm-Message-State: AOAM531Pk6/TK2t0RukSubcCsKbSrGChGMd0IOlnrJ+NY6ptw5naC4sL
        Aj9wdtw3WZ3zGfXe7DLYKqpZtA==
X-Google-Smtp-Source: ABdhPJw74IIpxGu451wZhiSLooPNuUzLwpOCg3k0jbl/8Kuhol8fCf1eck9BWLR34bAFfo6cdNGNKQ==
X-Received: by 2002:adf:ef89:: with SMTP id d9mr68461569wro.124.1594316762040;
        Thu, 09 Jul 2020 10:46:02 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 03/24] scsi: aacraid: dpcsup: Fix logical bug when !DBG
Date:   Thu,  9 Jul 2020 18:45:35 +0100
Message-Id: <20200709174556.7651-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When DBG is not enabled FIB_COUNTER_INCREMENT() results in an
empty statement, leaving the contents of if() and else() empty.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/dpcsup.c: In function ‘aac_response_normal’:
 drivers/scsi/aacraid/dpcsup.c:105:50: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 105 | FIB_COUNTER_INCREMENT(aac_config.AsyncRecved);
 | ^
 drivers/scsi/aacraid/dpcsup.c: In function ‘aac_intr_normal’:
 drivers/scsi/aacraid/dpcsup.c:411:30: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
 411 | aac_config.AsyncRecved);
 | ^

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/dpcsup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index a557aa629827e..25ebb94368f2c 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -99,10 +99,11 @@ unsigned int aac_response_normal(struct aac_queue * q)
 		}
 		if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected | Async)) 
 		{
-	        	if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected))
+			if (hwfib->header.XferState & cpu_to_le32(NoResponseExpected)) {
 				FIB_COUNTER_INCREMENT(aac_config.NoResponseRecved);
-			else 
+			} else {
 				FIB_COUNTER_INCREMENT(aac_config.AsyncRecved);
+			}
 			/*
 			 *	NOTE:  we cannot touch the fib after this
 			 *	    call, because it may have been deallocated.
@@ -403,12 +404,13 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 			if (hwfib->header.XferState &
 				cpu_to_le32(NoResponseExpected | Async)) {
 				if (hwfib->header.XferState & cpu_to_le32(
-					NoResponseExpected))
+					NoResponseExpected)) {
 					FIB_COUNTER_INCREMENT(
 						aac_config.NoResponseRecved);
-				else
+				} else {
 					FIB_COUNTER_INCREMENT(
 						aac_config.AsyncRecved);
+				}
 				start_callback = 1;
 			} else {
 				unsigned long flagv;
-- 
2.25.1

