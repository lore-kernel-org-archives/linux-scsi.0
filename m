Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EFBC4320A
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 13:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DD58610FC
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 13:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhHGNro (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 09:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbhHGNrm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 09:47:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766BAC0613CF;
        Sat,  7 Aug 2021 06:47:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a8so20890285pjk.4;
        Sat, 07 Aug 2021 06:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZMFTuQL4XCv0rc6vS643hPfckJse4ED4dcB9MFxryLI=;
        b=HSSjpVcOrBSkXxvrGMNszf1jTujgdJsnJypdiKYbb45gl3/tFrtk0oL+9RUiC3RZ8q
         m4StoJLry5Q043GaW7MMiZCfujNN6jwoFLLN3NT/yykYh0kM7kNsNb/85NBpy++xpfQ6
         62k3kL1029qP8Ftx4tWDe12kMEwBdnJN/zJSHfWTvt39MZ3DrFdLIeLh+OuvnKHmh/Gz
         b9OE+rsTmPNk/icz/UKMWm1/cB0bnx7OaGVyjOnZ1emLdLRbJ5MntCctBIizFYkgNs29
         AtIGl6kFgYACRh3+/j1kQaqgUWItnWLOviMz1eEHWOMLHuT2OQcSJPwoCqMfeE/l+gr4
         w82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZMFTuQL4XCv0rc6vS643hPfckJse4ED4dcB9MFxryLI=;
        b=GTe78ELVdXrlPF//QJJW72mg8zQhXaYqnwDU6LB+hWedcML6MxPHhyb9wX1buZEDk7
         3GeKO5YARmtyrkZV+3a34O6H53hDGGrIWoJYalBUF6LC62VHmCcAd7TJANF1C3lva1VB
         ZmLf0qUM+ymvR8yJ55NZBSJgelPCQBDH7ZNL3Hsjwmj4qVXSmAs849qtC/OwEzArjPkL
         gJ1lVWfgEyMeynU2k5S4IdinJwgd8euGVoaXWsunzkomnQmIiyZXdgqPP30B4uIw4J9q
         GCGL5xXPz4LL2BIqN1Sq7w5dQqqv4OZUrcwzPVCE0BFFXnLCsZL8YUHVdsfAQgo2pNK6
         fBVw==
X-Gm-Message-State: AOAM533tNbVsxWdy42kAM/EiOeveXMwushiflZyNij0WwYiNtucfQm2n
        O+1AQW/Zo6fZFocwgs/mWYI=
X-Google-Smtp-Source: ABdhPJwKf7wveW3mv3Hsx+FRzuBF07e9vF3DKGLpwloGVQheIxNqEXH+yvWW5sAOI/DbjgNJvFnMpw==
X-Received: by 2002:a62:e50c:0:b029:2f9:b9b1:d44f with SMTP id n12-20020a62e50c0000b02902f9b9b1d44fmr15981967pff.42.1628344043999;
        Sat, 07 Aug 2021 06:47:23 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.87])
        by smtp.gmail.com with ESMTPSA id bj6sm15849521pjb.53.2021.08.07.06.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 06:47:23 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()
Date:   Sat,  7 Aug 2021 06:46:51 -0700
Message-Id: <20210807134651.245436-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The return value of transport_kmap_data_sg() is assigned to the variable
buf:
  buf = transport_kmap_data_sg(cmd);

And then it is checked:
  if (!buf) {

This indicates that buf can be NULL. However, it is dereferenced in the
following statements:
  if (!(buf[3] & 0x80))
    buf[3] |= 0x80;
  if (!(buf[2] & 0x80))
	buf[2] |= 0x80;

To fix these possible null-pointer dereferences, dereference buf only when
it is not NULL.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/target/target_core_pscsi.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 2629d2ef3970..560815729182 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -620,14 +620,14 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
 			buf = transport_kmap_data_sg(cmd);
 			if (!buf) {
 				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
-			}
-
-			if (cdb[0] == MODE_SENSE_10) {
-				if (!(buf[3] & 0x80))
-					buf[3] |= 0x80;
 			} else {
-				if (!(buf[2] & 0x80))
-					buf[2] |= 0x80;
+				if (cdb[0] == MODE_SENSE_10) {
+					if (!(buf[3] & 0x80))
+						buf[3] |= 0x80;
+				} else {
+					if (!(buf[2] & 0x80))
+						buf[2] |= 0x80;
+				}
 			}
 
 			transport_kunmap_data_sg(cmd);
-- 
2.25.1

