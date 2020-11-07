Return-Path: <SRS0=6jMo=EN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73765C388F7
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 16:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203B8208E4
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 16:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W46BC3gM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgKGQwH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Nov 2020 11:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgKGQwG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2020 11:52:06 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9662C0613CF;
        Sat,  7 Nov 2020 08:52:06 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id k7so2442954plk.3;
        Sat, 07 Nov 2020 08:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wTHmZEswhZJSCKalkYaLwBa7H7/+qP0erahSehZXX2g=;
        b=W46BC3gMxIb24Z6kaaPXJLWYVl3ytwoXppeARNqlROC/ppgejtlwFdERGwzVfB/UFE
         H0RsRo8n/QmbJw1GpbabvufoBDOJjgV/SYrKUIR1ddCK3AvpWQQfEURORdBhKz3wsb/C
         DUsMEhuHuR4950ybbmWqDZ6eK3VPx5ORGVOQUFQoMXOJ+9wHfuSt7Cd4g/mjWIOGvXo7
         ni37iVbzw5G25ZE8MGeTyS0hSPwz5j+QijM4wvLvGo+NjDtUV8H7aD9+62CfUYbWCf58
         CVcg7jGA8XqJwKSdZnqmRbjg5THW6JxeZVyszL6RPeh48VS1MkcVOWCPYS//ruR7SGpH
         k20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wTHmZEswhZJSCKalkYaLwBa7H7/+qP0erahSehZXX2g=;
        b=iv4tWHRsHQVgy4RQ8FF3WanBxFiLf8GELKGUBBesn6hleNY/KWL/UwbX0aRY4wE1Dk
         YViL2Vc4GHkVc6JUPVCT9TZWhBzH0yTl3IgzAmOBzud7kMY4ev5ZFGj33/zFNYgTBywu
         VJcJ8i8HPxMlYFbA5/sW3BtH12w21Re0tJH0XCOFJvOepTQMVxwCoJFBYdifTy0HRvFY
         wniPMIHOeWT/qsoLoK6cIFjJYmtvngL24Z5VKgwsX7G0NhRjV0/9XLJm1NM/sWbGL36E
         Y6oPPrza1hSWQnVz6XYZzuQ4HoOZfJ6sbIJJGvJZbPBXLK6iXnjGBBfJgnI7BJ5Y2+j4
         41Sw==
X-Gm-Message-State: AOAM531enlHioSbCMsYtcMEtLxX4LQgM8aMOG8Y3ZUExBjlz6V8dIH+V
        taAQw7LIjHBQAZGMW3npAbQqZDJ5WANQ
X-Google-Smtp-Source: ABdhPJzVEutsRkevmiZEjdDb4pVKyF9HS/CHgWNQTX1h9tU9ep8PNEip0wYEOxVjJTWpzmy/if03SA==
X-Received: by 2002:a17:902:7681:b029:d6:42d5:6af3 with SMTP id m1-20020a1709027681b02900d642d56af3mr6087674pll.12.1604767926283;
        Sat, 07 Nov 2020 08:52:06 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id e7sm5642192pgj.19.2020.11.07.08.52.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Nov 2020 08:52:05 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] scsi: bnx2fc: fix comparison to bool warning
Date:   Sun,  8 Nov 2020 00:52:00 +0800
Message-Id: <1604767920-8361-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Fix the following coccicheck warning:

./drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2089:5-23: WARNING: Comparison to bool
./drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2187:5-23: WARNING: Comparison to bool

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 6890bbe04a8c..b612f5ea647e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2086,7 +2086,7 @@ static int __bnx2fc_disable(struct fcoe_ctlr *ctlr)
 {
 	struct bnx2fc_interface *interface = fcoe_ctlr_priv(ctlr);
 
-	if (interface->enabled == true) {
+	if (interface->enabled) {
 		if (!ctlr->lp) {
 			pr_err(PFX "__bnx2fc_disable: lport not found\n");
 			return -ENODEV;
@@ -2184,7 +2184,7 @@ static int __bnx2fc_enable(struct fcoe_ctlr *ctlr)
 	struct cnic_fc_npiv_tbl *npiv_tbl;
 	struct fc_lport *lport;
 
-	if (interface->enabled == false) {
+	if (!interface->enabled) {
 		if (!ctlr->lp) {
 			pr_err(PFX "__bnx2fc_enable: lport not found\n");
 			return -ENODEV;
-- 
2.20.0

