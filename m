Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77283C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573EB20716
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 09:51:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EP8BlC1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgHNJux (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgHNJux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2020 05:50:53 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675E4C061384;
        Fri, 14 Aug 2020 02:50:50 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id o18so9292407eje.7;
        Fri, 14 Aug 2020 02:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Gn7ZCZ5XA2EnBwutA3QyCJrGM4TBiILm4xq3LoAVuYo=;
        b=EP8BlC1m7ESQb0LiRVBTSi0SfQyg8WF2mynv9loNY561Yhhf/D+Vue44DNz2XU2dQj
         yGO2RGEZWLDs5OXwwvBVj2guTv0LBMmo2yQiTrvbcUPAdwQjOekfzEF+XRZJaAkf0XVP
         cpBk5S51FoEw4jA4gMwB/1j6srRiAqSU326sYTKArupqKSW/lXTcxgYAAE9fKkTDwiEq
         rR0+Na7ShMdUjx5o+pss0trRqxNizRghuVc66f4YAY2dY9YHBEAFUmrVyfmHpFP7iP2e
         dD+nMtzTei4ogUv87/ZUSkJnkY5zB6luawHG2PXLV3mLZhPH6f7USdTmThoeASWnnJus
         wegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Gn7ZCZ5XA2EnBwutA3QyCJrGM4TBiILm4xq3LoAVuYo=;
        b=NvGQaun2SInAWrAokzN/zj23QO64schg/XJBl9dbKJDCt4c5tOdX0WFvKAQHM3CuKr
         oBpmmGqOoe8QnyU/2xrdigF2jNdAGf1mBeWC2jYPKKSoVNwe7HeaIgPz8K4rQW7ZBe6z
         Pp53t4Ag4Su58cjQN+PvAEVq0PyL9siE/rNIvfQm9DuN/q1ptTQd9pOEnfCVkAPbyTAC
         QZNczajrCajOtCmD/bGIHGsHSapp1plv979pfux8kqoepqHNMA62lL6uJW1qstkWA5x2
         G6SGZpNc231gzwfA6qxrHiQVIO9lbUxUBd1uGMnO6zKD3Cpql/SoaMhbl72lIkwsIJVP
         Ol5A==
X-Gm-Message-State: AOAM532cNDOwn5Qr1CwcY3yX2FqaF8Z4tUhKYu8vkU61H8fptznb2GoN
        kldHUufEkMtVqaoYLgMsV1M=
X-Google-Smtp-Source: ABdhPJy6TPJ0JmPMsLba/2+wJTbSyMIPCqnc0YtGr0uvrDO07C0Gp7Luo+rZVIWZ5tuyUVPLSVi7ig==
X-Received: by 2002:a17:906:15cc:: with SMTP id l12mr1643692ejd.7.1597398648848;
        Fri, 14 Aug 2020 02:50:48 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:8980:3d37:44c:d55b:5f94:2fc4])
        by smtp.gmail.com with ESMTPSA id r25sm6016448edy.93.2020.08.14.02.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 02:50:48 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] scsi: ufs: change ufshcd_comp_devman_upiu() to ufshcd_compose_devman_upiu()
Date:   Fri, 14 Aug 2020 11:50:33 +0200
Message-Id: <20200814095034.20709-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200814095034.20709-1-huobean@gmail.com>
References: <20200814095034.20709-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

ufshcd_comp_devman_upiu() alwasy make me confuse that it is a request
completion calling function. Change it to ufshcd_compose_devman_upiu().

Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f09cda7b21c..e3663b85e8ee 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2391,12 +2391,13 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_comp_devman_upiu - UFS Protocol Information Unit(UPIU)
+ * ufshcd_compose_devman_upiu - UFS Protocol Information Unit(UPIU)
  *			     for Device Management Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
  */
-static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
+				      struct ufshcd_lrb *lrbp)
 {
 	u8 upiu_flags;
 	int ret = 0;
@@ -2590,7 +2591,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
 	hba->dev_cmd.type = cmd_type;
 
-	return ufshcd_comp_devman_upiu(hba, lrbp);
+	return ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
 static int
-- 
2.17.1

