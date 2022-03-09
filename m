Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981FCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 21:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiCIV0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiCIV0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 16:26:36 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CDDC1D;
        Wed,  9 Mar 2022 13:25:36 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id l10so2144696wmb.0;
        Wed, 09 Mar 2022 13:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6KjkEqs6nfY8SyVTKb71+0492kgEVv08yBN4Vf8F9c=;
        b=npZMITQ0h7Cxml4W5J3Vxp64os2biBMdDuRrN4qXAOIXOiY54XPUQHmGwyz0FqCOdA
         2jY9T8EeLufJPBAPygp2D2ilLnvhJB0pFrQ9fmvfoZ/3n9Mm/XcgYkR9KfODeciYuKnE
         MPGExWPW++ncM0/LxuXV92GO8XcsU3dgp/6d6A9i66hCsD+icGZVdOlOFjFgcsNE1dSY
         aDCG2ax6bc6si6cVHBNDkmHwrvulBS747WNclrPDV5fEhbabYXWMGiUVVJxdCUmXIxXT
         ZKqjDokElzyq6UfJGvlNUuTy7zwF9f1BtDePN0pcyupqm2P4jcBEF5KGeLic0WV7pTfi
         LBIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g6KjkEqs6nfY8SyVTKb71+0492kgEVv08yBN4Vf8F9c=;
        b=KvScrzIG5ElFwPthzdnHzwzFLl1k2IyDWTFw2Rqmt/ETWVNq736sy0YoWjrQlRZZsd
         YjDHbTqBleS5HviHWiddEOMY5xNKe5fDOXusICTyK1cRVIq/pCuY9XA4yNjYVn+wcm6q
         KPCVmJGWu56RJ6T3l+ZyD1B1ikzIbOiyg8i9v2+RWAho5227GQEol2pscyU6mw2RAH3p
         uWflGUVc0sl7jzFDrSamlyzog0ZYX78kCn10IslMAvIi81uhhdAoj0Rhl1XNxlWl1M5u
         RNuiehuJEYElTHbYccUvTV3sUzSC2mLV4FKIQn6Ja7pIMZLYnHGtvUHJEqj6w3YF765T
         WTHA==
X-Gm-Message-State: AOAM532TUBrRvonQ5tUREO8OsAULEsgApa+5GERbdVSf1RsUEzv7YprT
        FZrrEqWafx0RKNIgIVcbuKptkX53aGs=
X-Google-Smtp-Source: ABdhPJyZ3VyOCIprRGLbGIUjwQ5IMWFzSeUQ2UMVdVm3W3thKPHa24j3249olGoaZJJki4zRANcCpA==
X-Received: by 2002:a05:600c:214a:b0:385:9c42:848 with SMTP id v10-20020a05600c214a00b003859c420848mr1072824wml.176.1646861135093;
        Wed, 09 Mar 2022 13:25:35 -0800 (PST)
Received: from monster.fritz.box (dyndsl-085-016-033-210.ewe-ip-backbone.de. [85.16.33.210])
        by smtp.gmail.com with ESMTPSA id k13-20020a7bc40d000000b00381890032dfsm5891053wmi.1.2022.03.09.13.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 13:25:34 -0800 (PST)
From:   Alexey Galakhov <agalakhov@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
        Alexey Galakhov <agalakhov@gmail.com>
Subject: [PATCH] scsi: mvsas: Add PCI ID of RocketRaid 2640
Date:   Wed,  9 Mar 2022 22:25:35 +0100
Message-Id: <20220309212535.402987-1-agalakhov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The HighPoint RocketRaid 2640 is a low-cost SAS controller
based on Marvell chip. The chip in question was already
supported by the kernel, just the PCI ID of this particular board
was missing.

Signed-off-by: Alexey Galakhov <agalakhov@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f18dd9703595..5c25354662ce 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -646,6 +646,7 @@ static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
 	{ PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },
+	{ PCI_VDEVICE(TTI, 0x2640), chip_6440 },
 	{ PCI_VDEVICE(TTI, 0x2710), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2720), chip_9480 },
 	{ PCI_VDEVICE(TTI, 0x2721), chip_9480 },
-- 
2.35.1

