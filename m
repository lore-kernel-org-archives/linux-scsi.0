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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225F9C47425
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 04:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D17AD20796
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 04:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KpjQqUxL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJBEFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 00:05:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D90C0613D0;
        Thu,  1 Oct 2020 21:05:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id x2so87047pjk.0;
        Thu, 01 Oct 2020 21:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sTYEmLXWJIioyZ/co56o+nUxOqE8kY5/J60GnsaHiOU=;
        b=KpjQqUxLPP2MRSHKXz4X2vC4E1c9J0CgafKn1SKlwxMB0k+5118uCtKtxYZ1BruTaE
         8OvXju6J/NS9mB33F1oTPNC2Em+/FDJCRtGMQryuXO7gdEx3WtDx2bw9H7r0Sgrl9052
         TJhD9aGS9wR5jYnv2toKoYwOuMAlwLoP0OKO17uL3FypsJ82d3Pj3XFvSHAtpVTbbsnz
         vw7IQC79IiT+1U/BfpnkeVJ1qvAkQvoJazt6PzI17sraHiSDVXQO/YQU7pwS/GTxZJ8a
         /mjiqIKY5yWY9tuBZLy5le+GLFIYAqHMrm/25gLtwdz1uJUybDP0bG/eVgJ1Gri1NqYM
         /Paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sTYEmLXWJIioyZ/co56o+nUxOqE8kY5/J60GnsaHiOU=;
        b=HXrFjrCuMvkHtOw3o2fxmtzhkQyvWg/yDZr76KIKufY+E7keHO55I5kay3qDZ9KMZs
         yOp7eQP+KF/yHn6G0XNxkXs6najOax4UAaWp0wknQk8yTzfT/bWInd2RqtQB29grMwvu
         1r6fmOwUxtXRPm3P7MgFsg2IeDDuvToe3Qk2OMQbhunTbUcgpPem6EdenzMcQrYj+v95
         Di9bw3To+y22OZtGF9Iaa1wCxJ15clZKCRtdJlW1aAGpRQoednGO59Gtq1jtYFrLuo/w
         GDBx055V9xFgYd4mtq/avSbZGVsaYx4R/iY089lx6RIJUXFGXh4MEhq1ZoSbZyhc1DVk
         se+g==
X-Gm-Message-State: AOAM531mTGX+CtZM7IPtqgZF1yU9+bmjfF9mb7JvpuVfX4gKwQrIwOWt
        4mjHEHi/n5YVIK2YK0w/ww==
X-Google-Smtp-Source: ABdhPJy1npxEfUikwf9i20JCwFFUR3MrbWn9PhSyUzBY4p2GXa4vrDxM1ptVzZ3cmfG+vEm857TuPw==
X-Received: by 2002:a17:90b:f83:: with SMTP id ft3mr636267pjb.234.1601611542628;
        Thu, 01 Oct 2020 21:05:42 -0700 (PDT)
Received: from localhost.localdomain ([47.242.140.181])
        by smtp.gmail.com with ESMTPSA id f4sm113203pfj.147.2020.10.01.21.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 21:05:41 -0700 (PDT)
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
Subject: [PATCH 2/2] scsi: ufs: Use memset to initialize variable in ufshcd_clear_keyslot
Date:   Fri,  2 Oct 2020 12:05:18 +0800
Message-Id: <20201002040518.1224-2-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201002040518.1224-1-shipujin.t@gmail.com>
References: <20201002040518.1224-1-shipujin.t@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang warns:

drivers/scsi/ufs/ufshcd-crypto.c:103:8: warning: missing braces around initializer [-Wmissing-braces]
  union ufs_crypto_cfg_entry cfg = { 0 };
        ^

Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 8fca2a40c517..bd439021ccce 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -103,6 +103,9 @@ static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
 	union ufs_crypto_cfg_entry cfg = { 0 };
+	union ufs_crypto_cfg_entry cfg;
+
+	memset(&cfg, 0, sizeof(cfg));
 
 	return ufshcd_program_key(hba, &cfg, slot);
 }
-- 
2.18.1

