Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F352CC4727F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 06:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC00E206DD
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 06:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QA2icjrF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgJBGgC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 02:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgJBGgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 02:36:02 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053FFC0613D0;
        Thu,  1 Oct 2020 23:36:02 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gm14so245466pjb.2;
        Thu, 01 Oct 2020 23:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QLv+s4aQZnO25bRLQQ0YtqBKhSbu43FQOvF08k6VhKU=;
        b=QA2icjrFrzcnJXgrnaxsSDmBT2ig0yfsexzxXfKKU5UVxsd7JpeQ2svg29iNoT621I
         ZD9QtusLqJ3ODzVMq8Txwm3y6j69H6CRFX3ZIjWI+WmpLgHWC1jeWEcH7vWilPzmbvbF
         CYBj/kjQdmPvEtXwfNYeahkhCZ6aUsZZ3losSHi/ePePp+lN72fZQEQUvzmpD1200xpI
         ry8itehk+z2PLRG5obnCtG8pOIfc9xgAWYLzVZ0OWI6IPqqxOYhQSjNlVmFYW9BeejnL
         OedxKJNtYQGGWUNA5skLedA9ACzen6uevFglnTq49dQ+repk0jFpfWlsWwTQWmylMc1Y
         rvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QLv+s4aQZnO25bRLQQ0YtqBKhSbu43FQOvF08k6VhKU=;
        b=D5GgA31dw9VYvG6T1wQDipdbWFn84tbP4RjraG9CBMkJiwgdryrePW5ycniLP3B28e
         3/5XnulRk+0DvanT+Ws1xyIlaCQi2WD0h8fA+l8JdXOOdny0OolcemeP85p7xp0JrobV
         bGK4SK7ZSK22DJR6k2Ah1xT5wmjxEJCoM0319fH5GbOEo81DelPfGAeTLWAGaX7pvvf9
         Mv6N04AfWMy9o9IWSP/z17T3xRaj1HdNrPfy7l7DP7LlBZ1AatYryGzEt6btNtZFcO0P
         S2ggWeWcESiXFd4ZAkj9Q3eW3mCMQHlluDx9twxJXC8qz6ihrJuC/riZolR3UYYKAIJB
         r/Pw==
X-Gm-Message-State: AOAM5323usi+3BK+8z7VMeuskm3Skjfypashj8CUtfYcZo4ZrbGeTdFl
        EUH21f9nM7hxcmixj4QsjA==
X-Google-Smtp-Source: ABdhPJya7Va6AMgOvmi0MZDomfdwTDXoXeOLF5Zil833ReFbFPJhM6NZkrRgwvaXHKH7EUE4uN4c1A==
X-Received: by 2002:a17:90a:ea08:: with SMTP id w8mr1201059pjy.124.1601620561600;
        Thu, 01 Oct 2020 23:36:01 -0700 (PDT)
Received: from localhost.localdomain ([47.242.140.181])
        by smtp.gmail.com with ESMTPSA id r16sm532212pjo.19.2020.10.01.23.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 23:36:00 -0700 (PDT)
From:   Pujin Shi <shipujin.t@gmail.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hankinsea@gmail.com, shipujin.t@gmail.com
Subject: [PATCH v2] scsi: ufs: fix missing brace warning for old compilers
Date:   Fri,  2 Oct 2020 14:35:38 +0800
Message-Id: <20201002063538.1250-1-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For older versions of gcc, the array = {0}; will cause warnings:

drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_crypto_keyslot_program':
drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: missing braces around initializer [-Wmissing-braces]
  union ufs_crypto_cfg_entry cfg = { 0 };
        ^
drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: (near initialization for 'cfg.reg_val') [-Wmissing-braces]
drivers/scsi/ufs/ufshcd-crypto.c: In function 'ufshcd_clear_keyslot':
drivers/scsi/ufs/ufshcd-crypto.c:103:8: warning: missing braces around initializer [-Wmissing-braces]
  union ufs_crypto_cfg_entry cfg = { 0 };
        ^
2 warnings generated

Fixes: 70297a8ac7a7 ("scsi: ufs: UFS crypto API")
Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index d2edbd960ebf..07310b12a5dc 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -59,7 +59,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
 	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
 	int i;
 	int cap_idx = -1;
-	union ufs_crypto_cfg_entry cfg = { 0 };
+	union ufs_crypto_cfg_entry cfg = {};
 	int err;
 
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
@@ -100,7 +100,7 @@ static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
-	union ufs_crypto_cfg_entry cfg = { 0 };
+	union ufs_crypto_cfg_entry cfg = {};
 
 	return ufshcd_program_key(hba, &cfg, slot);
 }
-- 
2.18.1

