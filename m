Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADB1C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2DB66124B
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 21:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhI1Vns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 17:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbhI1Vnr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 17:43:47 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B964C06161C;
        Tue, 28 Sep 2021 14:42:07 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o19so186694wms.1;
        Tue, 28 Sep 2021 14:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZ9KGhrhLcywAqK/S5yjVM8wp4L0WP/cHm0W4+6MMRU=;
        b=b3v+iwc6wkcXK4Vnf+Zj2EXrBQh+AFeAWwx7UriFfTjpbsG7S3aLdqPw+C5tdpVfMA
         eO9ZNYx2C3CXAmfMgVG0l9N6enfm2rX09bGaYQKVw5+fbsJx7R7I92VA07ENdjmueN+j
         /SOEtXZNF9hSdvRbGU96sVwdYoLM2tOWYsLXWaGdrEF2OwKyUolrd8BAEiN5fF92cj5n
         zLJxGgJSLj9cXOUd3kJIVu230btixa2emXuqySkNkYjQtMjDFwJRKaJBojbIj78tkfvj
         ls2B67IhoXiKX+Utd3vCNBjncFQ4mVktT4D5U4fyqFBA1dczggh+lrm1to8GaDYdGZ7j
         2lFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZ9KGhrhLcywAqK/S5yjVM8wp4L0WP/cHm0W4+6MMRU=;
        b=PP1GjCmj5jyuOSFSHlmkuIUw6mT7wWC45eVqn97XFubNotsw3eIVn/tBLC+UqsPkKO
         xlqHOeeWOa8VKSRXsp3ERZtdE7GNicF+t6GNq+eo2d2wDtS57RSda68qv52H/gGuyRyL
         sFDAHOgwyPNLU46sKYF4ZBeROPhARapwv8W4n9/s2ePd+/zLrH1D176eKSyY41b2yY6x
         rAVjflYF3aAGv7jWrZA2FlO0IK6eotRzrIFIgWWUD01AU6aYoEc9fisXyGpJ94R77RyW
         bpdcLMr8jICnt2eebsTYffM/3SMh4yf5AuXDuXBXQv5UPE1yNsdVphIGIcXoA6izVJ3H
         wPAg==
X-Gm-Message-State: AOAM5309XVYheUD1qtEDduO5R6ggOFIbbUebbDL5H2E9xOC7hQf0ScoC
        9+PhiZn9wvl2/hzSL6siGNk=
X-Google-Smtp-Source: ABdhPJzqp1CNYh+ZsAyrQJpzzAAq7h/52GiuX2kpjknLzFAXdNAnPju9buoXIlBe4ns44VsS4MvmjA==
X-Received: by 2002:a7b:c959:: with SMTP id i25mr7017290wml.55.1632865326196;
        Tue, 28 Sep 2021 14:42:06 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cfe07139628ae9da1147.dip0.t-ipconnect.de. [2003:e9:4717:cfe0:7139:628a:e9da:1147])
        by smtp.gmail.com with ESMTPSA id m4sm314147wrx.81.2021.09.28.14.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 14:42:06 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufs: core: Fix a non-constant function argument name
Date:   Tue, 28 Sep 2021 23:41:50 +0200
Message-Id: <20210928214150.779202-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928214150.779202-1-huobean@gmail.com>
References: <20210928214150.779202-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since commit 568dd9959611 ("scsi: ufs: Rename the second
ufshcd_probe_hba() argument"), the second ufshcd_probe_hba()
argument has been changed to init_dev_params.

Fixes: 568dd9959611 ("scsi: ufs: Rename the second ufshcd_probe_hba() argument")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index debef631c89a..081092418e2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -225,7 +225,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
-- 
2.25.1

