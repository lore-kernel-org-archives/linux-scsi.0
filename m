Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E73C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 22:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8946B61247
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 22:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhKKW1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 17:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhKKW1x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 17:27:53 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612ABC061766;
        Thu, 11 Nov 2021 14:25:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id b12so12243749wrh.4;
        Thu, 11 Nov 2021 14:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dMzoSyWno7mdbpvq4tnJoWRLW2QIxJHtPam10oagPHc=;
        b=oshCuRzcfnAMeLENrOI64L4SWzyFl9B+ctgKnS21/ztDq0fPkGtRi0ii+mruShXlPB
         Ws8aiVdNF8QTcshbQd0tthwLK3XnVdXWpkWeK1oopCt5mRMvpLuZ4GpjwX0lXBITo99J
         JijfZ5nazN8r29rzFeutY5kMFXYH5jgxa92ieaenAoBta2Wvw+WXiVr4RE1z5pd/qweS
         /8aQpRo2OyK5l6Uq2rEZvwyt+07cLSUhMKoLaH7ZfKiguGIN6N326lwt7azqXKQbs47J
         kcS/EthpzFPNWQfQXW2zIdxCLc/ztrszTisHo9ja2zmt8mZn0XdbwAvpJR9oV6Xxd7SP
         5APQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dMzoSyWno7mdbpvq4tnJoWRLW2QIxJHtPam10oagPHc=;
        b=Mat/ovQuRp1w/cm4k5XFsu6IaRtEmaIuNRQQkaV3iFtCpWTrEN62gVZqic1miMD3cL
         K2ALYVrOxFfZ48d4RzjWn1E4vUa6GIpWU4ovI/OmCLd9K9XlfctmYgU04RZapS4rel1A
         bDJjnQmIZyGx58vvGX/kPM6E6JdBSbY3Z8JuOK7AyGDAcy6YgqjwzlTl4WvFKDMwiFzU
         eBy75yZu/ZCEvrXiqpGZhsYScGFYzK9N2pWgWpU7/t5QxwRitBon8as98nPDIAdJAS7/
         wsdxYO6Cp48CYRWnr9dWj4mncH3lXzHclI+uzCh5oVoGavOFjXTyXxHT1UBPFUWpPDek
         4bug==
X-Gm-Message-State: AOAM53064lYmiDimCDnWx318owx8qVHG3UQGJsd00mDyo1Rma1K1spaC
        I9zUGhdZrDIFxtLsnam4vaA=
X-Google-Smtp-Source: ABdhPJwg86aOojT/HNffsFbTShq1Zs6HPayDIGbTVP0M/+qHlnZajbVIonZindaBMmSobBZmXhSvhQ==
X-Received: by 2002:adf:ee04:: with SMTP id y4mr12725660wrn.0.1636669502082;
        Thu, 11 Nov 2021 14:25:02 -0800 (PST)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c9d060ca6c640270b431.dip0.t-ipconnect.de. [2003:e9:4719:c9d0:60ca:6c64:270:b431])
        by smtp.gmail.com with ESMTPSA id l16sm4160828wmq.46.2021.11.11.14.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 14:25:01 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v1] scsi: ufs: ufshpb: Fix sparse warning in ufshpb_set_hpb_read_to_upiu()
Date:   Thu, 11 Nov 2021 23:24:52 +0100
Message-Id: <20211111222452.384089-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch is to fix the following sparse warnings in ufshpb_set_hpb_read_to_upiu():

sparse warnings: (new ones prefixed by >>)
drivers/scsi/ufs/ufshpb.c:335:27: sparse: sparse: cast from restricted __be64
drivers/scsi/ufs/ufshpb.c:335:25: sparse: expected restricted __be64 [usertype] ppn_tmp
drivers/scsi/ufs/ufshpb.c:335:25: sparse: got unsigned long long [usertype]

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/scsi/ufs/ufshpb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index a86d0cc50de2..5c8bb6dcc559 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -331,7 +331,7 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	cdb[0] = UFSHPB_READ;
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ)
-		ppn_tmp = swab64(ppn);
+		ppn_tmp = (__force __be64)swab64((__force u64)ppn);
 
 	/* ppn value is stored as big-endian in the host memory */
 	memcpy(&cdb[6], &ppn_tmp, sizeof(__be64));
-- 
2.25.1

