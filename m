Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55555C197BF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21A3722D2C
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgLFKOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgLFKOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 05:14:33 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE2DC061A4F;
        Sun,  6 Dec 2020 02:13:53 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id ga15so15171113ejb.4;
        Sun, 06 Dec 2020 02:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4lmzD54k4CKdINLObL10PwNDFGT6vmjyRLOn35UKtU=;
        b=DT7nIKZH7mwI2974LkZPcCGsV9GDVIFqz8+nXqL5jADRAn5vrbkHttYu+t8Hou7HLU
         fwBeFWCUMwFbDSdca8FDJxqq0LO4uYbbbGQoNVfIWspTQEejiSIywDjs1gwjqSye7Isp
         Ac/f5Ab5Ih5hRdZnkAJLzLWn0buPx2Yu3AlqqZMHE2mAf92QAx4HGFzOjI8xiWAvOzPH
         6z2AH5kOm78MLPVi8azPrnhSf0ChqLcRMpW11Kev1yMLBmOSIDFDNN5WiOkvvM1pjbbx
         /CpfpKziaPDxk50XqnEeVIqzoCwe7ghyYbOzonVpCmm1O1qa3y0fPfYG/aCXeE9Adnha
         +fPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z4lmzD54k4CKdINLObL10PwNDFGT6vmjyRLOn35UKtU=;
        b=Nmsa8ts8Anav5W/pbucmVocBKw7BxlsEss2jK/fW14YsuaNabNMGgZflWGhmAaSo42
         a/lNv8Z6jd4PM2ywMCeFSAHiaVI8C5RrEfMBu6hxcic5lSY6VWftKnSj44Xx8Z2+gQ+1
         2LEnPDCIpX5EkkB7htuTQpXK9Grq1DhtBpqHuq4pM12b8g/B+ixcMPiaRivrFPVLdxex
         +ZM2cUlw1pVEGnViUTUtakKorE+J9ImkSCPUtrGp9UBZ3R3nFEAp3hiblqniT30ManOh
         rWqLgVfBGHYi8pnjoKKaSoBM176Op9rLISuqjwTWW5QbfYdISKFPgIgAKUsxIpXzRJz6
         ml6Q==
X-Gm-Message-State: AOAM533S1kimj7gFSMbupxZVoClut2+bG9rEwmyhyHEwjGdEHZBnejfg
        EX8mTxc7Y+9rGDftaJ7z0z0=
X-Google-Smtp-Source: ABdhPJwsqqa+FsK75vBtEoP7Sr4daPDl0Sjg5fgwq4kMCYD5RPzvl/uG0lDDRNRO/ee3WY6Qv9nCZA==
X-Received: by 2002:a17:906:b307:: with SMTP id n7mr14412264ejz.102.1607249631225;
        Sun, 06 Dec 2020 02:13:51 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id f24sm7701919ejf.117.2020.12.06.02.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 02:13:50 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Sun,  6 Dec 2020 11:13:35 +0100
Message-Id: <20201206101335.3418-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206101335.3418-1-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

USFHCD supports WriteBooster "LU dedicated buffer” mode and
“shared buffer” mode both, so changes the comment in the
function ufshcd_wb_probe().

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da38d760944b..ceb562accc39 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7171,10 +7171,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		goto wb_disabled;
 
 	/*
-	 * WB may be supported but not configured while provisioning.
-	 * The spec says, in dedicated wb buffer mode,
-	 * a max of 1 lun would have wb buffer configured.
-	 * Now only shared buffer mode is supported.
+	 * WB may be supported but not configured while provisioning. The spec
+	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
+	 * buffer configured.
 	 */
 	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
-- 
2.17.1

