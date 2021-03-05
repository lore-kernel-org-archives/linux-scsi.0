Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520C3C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 03:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF5264DCE
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 03:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCEDmx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 22:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCEDmw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 22:42:52 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C639C061574;
        Thu,  4 Mar 2021 19:42:52 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id o10so431741pgg.4;
        Thu, 04 Mar 2021 19:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+qBQKjutSWxXJ6pSYlQr+EDkhT2Em2x0QxBg+a/EYuI=;
        b=pVaKDMsr6wEuwyaEOj9+ZT07Q59+sxIm9o1HAuQk/3yhPxkQlwKwsPYlORzoK+X+op
         JSM/V7U5M4nni7BuaiK6mgvAMNKukvCyaVAH0kAPnz7vh15M/liI3nWGFpBio1LalFpO
         BvoRGP7rjbvU3QGUtyv9f4xH2PMCL+inVfTP3bgqPWs6MF/eFZg2nYxC/fNIb/Kvfqpp
         Nxkt3AE+T/90Mc/MjQWqlSljvLX47plvtc5G0zAq9uvmLnWA+iK8trwKWcP64mP5kSB9
         fKFEYYC/jB8EAs60R79dfrRRP9FP61X8YE1WRmllbRmNrUgekTXcAJI/uG29U4Tm544X
         kY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+qBQKjutSWxXJ6pSYlQr+EDkhT2Em2x0QxBg+a/EYuI=;
        b=mfE92uQaxW3BgXRuh6Qfpt+lULVSIFsicBQvVynfuE1ZarJUZ06gCPDTWmRGW09y3j
         4gasjCTACnAA3TMhbK4uauv0OoGXaFb4nKMzvR0n7363NbgvPSEjj3lBAzDy3AUHkEMN
         32q2cMrRWa38c4w/DlkMpaz3UlREiNOWQqim5h/NDMitWNX/VCuJbMr+SuV/jfqnZwXY
         4rURRjRYi3YSGawYZTVZVmQgLnT6n0LvyBGIbtRgXx78ZptuJFj6OHkzAs+4oFL7U/DE
         VNUrZjbLxj5lLOKQPuCghjwHb+KFNC6/grXER8lFZeWJOhXbgANm+vCmRUNDKF7CcF86
         UQQQ==
X-Gm-Message-State: AOAM532yXVB9Kcc1b14+i9LUAz/DwTXnxDo8TGkubabvynTBmLIkVeyE
        ZfejS4ayJqpZsFxDYucjrB8=
X-Google-Smtp-Source: ABdhPJzPNtwGnze95Z1X10OgXitHd/27HUFl/1OL6MjkG1Zh4lr5Bo+Fg8RWSbP1PvF2+oHhFww6mQ==
X-Received: by 2002:a63:580d:: with SMTP id m13mr6495298pgb.342.1614915771884;
        Thu, 04 Mar 2021 19:42:51 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id w128sm743572pfw.86.2021.03.04.19.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 19:42:51 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: wd719x: fix error return code of wd719x_pci_probe()
Date:   Thu,  4 Mar 2021 19:42:44 -0800
Message-Id: <20210305034244.6338-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When dma_set_mask() or pci_iomap() fails, no error return code of 
wd719x_pci_probe() is assigned.
To fix this bug, err is assigned with -EIO as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/wd719x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index edc8a139a60d..a334e3c9de45 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -902,6 +902,7 @@ static int wd719x_pci_probe(struct pci_dev *pdev, const struct pci_device_id *d)
 	if (err)
 		goto fail;
 
+	err = -EIO;
 	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		dev_warn(&pdev->dev, "Unable to set 32-bit DMA mask\n");
 		goto disable_device;
@@ -922,6 +923,7 @@ static int wd719x_pci_probe(struct pci_dev *pdev, const struct pci_device_id *d)
 		goto release_region;
 
 	wd = shost_priv(sh);
+	err = -EIO;
 	wd->base = pci_iomap(pdev, 0, 0);
 	if (!wd->base)
 		goto free_host;
-- 
2.17.1

