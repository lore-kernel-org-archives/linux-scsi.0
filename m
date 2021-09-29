Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CD23C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB82E60FE8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 02:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbhI2C75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 22:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243259AbhI2C74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 22:59:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BBCC06161C
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 19:58:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z130-20020a256588000000b005b6b4594129so1647300ybb.15
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 19:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PTk7CRK/HQADhQF5VUqQC8XprgCR1zpob8HW4s35WX8=;
        b=CBgSgxQgnM/7g4yz8Y5GTD4EgqtVkRV5NJTvB8ejEV8KbuFkyDuV+q45kYynEbLIKY
         PZLCnEcJDkpKDsLVpUwDXo7YrD2urBILt6ocegEarc71xt+1XdhWlxvRg2A/jMnrYKPt
         +jOfqK7pHglcb8vYkR7LH+th3hBXKpqvYPiCufuB546EQvFW7FL9QrHltow3dwnAC0Q/
         4QG1r2m5fWR4RwHVuKtl8EjzSplbuyY6+QIJ+M6GmH0KQsYu1/2s622zIT0PNKuui+yH
         s/LxQ0DsKROy7V/jMPkf9ZXzih5ZhRl7LepCqGamCFDR9XuR0lP2fceVtmhGm+FdW6fr
         dhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PTk7CRK/HQADhQF5VUqQC8XprgCR1zpob8HW4s35WX8=;
        b=XmQoUQ1NhbLRMQOcpuo20j4YCoGF0xVYmZvhMfSr09lcxT874Ly7rBwTDiU8vbb2SX
         ZYV8Kz6aZ87ew4c3bNQmx2iXz2uTk1KwQwYdOHtp5IE28e3YGvt44czn4FhriQgBa7Sw
         aVCin40DARinzHQ99xI3k5xnaDlc9UnZDw09+ampUx3XIZn4CnZ/8QuBVhBFld5uxRuU
         S+Ip5WRvxhJDGKEB85SxjnV7UuKC4zIFAVi5ONedIh0YafR0NqAGeQsSYyiXI3HsX8uc
         NsTnBEhCXKLxmTa5pfuaUgsj1auSOD/l2YytZLOh1fRWeyAgna5v+XXCna+Ha5rucZg1
         hUTA==
X-Gm-Message-State: AOAM533XyiG6I2Z60eVtHhQf4tlS2SP8Dft3lTZBNbK1t7kNcshywgQh
        7j+El2YoxN/Vqme8ooxjRosw1x2+eH/wPQ==
X-Google-Smtp-Source: ABdhPJy1j04EGreYLfdCfWOfVSiaCTMWRKNnrPflzNO2D37Sh9Aqec6RGJ5Dxgr5RqrrbApmOLRrST1kfJqb0g==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:77ed:dda5:c808:3802])
 (user=ipylypiv job=sendgmr) by 2002:a25:ac8c:: with SMTP id
 x12mr10849667ybi.360.1632884295684; Tue, 28 Sep 2021 19:58:15 -0700 (PDT)
Date:   Tue, 28 Sep 2021 19:58:07 -0700
Message-Id: <20210929025807.646589-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 1/2] scsi: pm80xx: Replace open coded check with dev_is_expander()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a follow up cleanup to the commit 924a3541eab0 ("scsi: libsas:
aic94xx: hisi_sas: mvsas: pm8001: Use dev_is_expander()")

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 3 +--
 drivers/scsi/pm8001/pm80xx_hwi.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 63690508313b..b73d286bea60 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4476,8 +4476,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		if (pm8001_dev->dev_type == SAS_SATA_DEV)
 			stp_sspsmp_sata = 0x00; /* stp*/
 		else if (pm8001_dev->dev_type == SAS_END_DEVICE ||
-			pm8001_dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-			pm8001_dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
 	if (parent_dev && dev_is_expander(parent_dev->dev_type))
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6ffe17b849ae..778b5fce876b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4825,8 +4825,7 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		if (pm8001_dev->dev_type == SAS_SATA_DEV)
 			stp_sspsmp_sata = 0x00; /* stp*/
 		else if (pm8001_dev->dev_type == SAS_END_DEVICE ||
-			pm8001_dev->dev_type == SAS_EDGE_EXPANDER_DEVICE ||
-			pm8001_dev->dev_type == SAS_FANOUT_EXPANDER_DEVICE)
+			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
 	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-- 
2.33.0.685.g46640cef36-goog

