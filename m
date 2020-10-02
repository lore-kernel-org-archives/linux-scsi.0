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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DEFC4727D
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 04:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B1520780
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 04:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="POG1/SCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJBEFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 00:05:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79A2C0613D0;
        Thu,  1 Oct 2020 21:05:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h23so68563pjv.5;
        Thu, 01 Oct 2020 21:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qjTTmIDjemMC6Cb4Y0veXp5VpbkkdAJ8TRa758oYHTY=;
        b=POG1/SCaynBC+MY5oa6IzObg44yTsyXi3ADE+6W1ylKn+rMfbTxFAHetrEjepBXVf+
         OGYq/pQqF+c+cBsQrpo4zVnKw0ySLk5Qe/TgeJdcpHZkusYh/hvICwYMpb+RDAkh7fhw
         CET/S19RffTKlXyl0Q/CRGlx0HDm//0B5+cMY4rGxXZ8tg53UG7ZDlZYGMMOiKySJV+7
         9FHOc/3LqVHv4ED7adNd2ffAkLjzZT6ys9AbxzPYlVdQqz7ifpvGcsn2abyHGAZ07Cwf
         TkM1NamNJA/nSfGDhTaY/KpX4bXTlBEW4veAkKuDthG8RJoZBbV6KQfyx/bAVQRdVr/x
         5xVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qjTTmIDjemMC6Cb4Y0veXp5VpbkkdAJ8TRa758oYHTY=;
        b=KYu3zz9n103Qm3wdUQZFrpRPDjfkpkMrGx/F39TF1EPv7t9OQGVc2XWT5Fia1vDRgG
         zWg4wgQIOULMqtFEZ4sSempgecVvOZjsVpBUmYl+hSvtJ9p7HDL4hY3zraU7g4AOhn8Z
         hxxElTqmKJvDDue/Rb+A98Qi+Q65fJTy6Hlwt0J9AcIZcThRHQpoi3+XTHYmk0pU08na
         kuh0xNW+oqDjRGllQ+HOnn7Me0witug1M0kdSjps4+D+zQtPvQbN0EOcKu7IuAvM1w/V
         JoOY8pHZTXSyev2eQB3eSW6x+StUt1MhMOISMQle9f0tpCox86FGRlVP9/V7SInMhS6X
         m54Q==
X-Gm-Message-State: AOAM532KeZKuPypF9y4D1TSb19koFvrGRWEchQS/PM2qP0sdv1rktg2+
        QE2Ra5z7AHbPg0kflIernw==
X-Google-Smtp-Source: ABdhPJzCf6x9ivIHDW9Jag8t+RnJLIvwkttNodBugHwtNFier0lBI7SsQ+zxTTMNWWNdbdHH86lKuQ==
X-Received: by 2002:a17:90b:4204:: with SMTP id iw4mr623648pjb.175.1601611536312;
        Thu, 01 Oct 2020 21:05:36 -0700 (PDT)
Received: from localhost.localdomain ([47.242.140.181])
        by smtp.gmail.com with ESMTPSA id f4sm113203pfj.147.2020.10.01.21.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 21:05:35 -0700 (PDT)
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
Subject: [PATCH 1/2] scsi: ufs: Use memset to initialize variable in ufshcd_crypto_keyslot_program
Date:   Fri,  2 Oct 2020 12:05:17 +0800
Message-Id: <20201002040518.1224-1-shipujin.t@gmail.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clang warns:

drivers/scsi/ufs/ufshcd-crypto.c:62:8: warning: missing braces around initializer [-Wmissing-braces]
  union ufs_crypto_cfg_entry cfg = { 0 };
        ^

Signed-off-by: Pujin Shi <shipujin.t@gmail.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index d2edbd960ebf..8fca2a40c517 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -59,9 +59,11 @@ static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
 	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
 	int i;
 	int cap_idx = -1;
-	union ufs_crypto_cfg_entry cfg = { 0 };
+	union ufs_crypto_cfg_entry cfg;
 	int err;
 
+	memset(&cfg, 0, sizeof(cfg));
+
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
 	for (i = 0; i < hba->crypto_capabilities.num_crypto_cap; i++) {
 		if (ccap_array[i].algorithm_id == alg->ufs_alg &&
-- 
2.18.1

