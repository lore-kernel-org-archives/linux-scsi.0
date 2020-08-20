Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C355C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B8C20758
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:06:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="es3bYe0H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHTSGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgHTSGG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 14:06:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B785CC061385;
        Thu, 20 Aug 2020 11:06:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u18so2528059wmc.3;
        Thu, 20 Aug 2020 11:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UE8eTpJz5Fvat023BgaJXhjynGfzhEeYBnx8EpQ2OAU=;
        b=es3bYe0HphdqUCL+9I1d1ALgqNpakWcvQviyZgkpOosoMsnTyYc8sbfdSnxN3ke+8Q
         zodhNvqFav+IeGS/pSlakqo0BxFXC8fnFI2OnMEF8ablaNavw7Yl5v2JEB4yeLDQi1uo
         sppEscZnUc5MU8C5R/zNdNgRKvTUWAR5l2xTyYZppzAPlp0OrapKXfU5kooi8IToy7Bv
         QVYG0Iin/IuRuR1BTATjJH27XRsCX6KKR88LwAVyEgfI0caRIGE17Q2FLgyLsKxvGw0b
         Ew9Ovr9K2mxABHCtBN3QPPeEwRaQPakVz5Wam9lBqrsy3jcwvA9Q/hJ5jOkTFPyJLREw
         QJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UE8eTpJz5Fvat023BgaJXhjynGfzhEeYBnx8EpQ2OAU=;
        b=bRa+I4oCjSIEi0m/wnAgsukalCuP+2ep+iGMRnCvIeX1X9f7sx49Tl2/deoZG4QVBM
         T58Be2luxnEnegkCh+zPc9XVLuGahRkMSQwyaLrc2EdEClHQQGwHre4QmjI3KVrn2yRu
         rJ3+9rHH3418mlI8o7C9QEnY6x06iIZ/eRENpLn230/DabNx7AMe/kHpjFmMBW3C/2hr
         RH93G+xGbHk3kMswi1iBBzVNWjiCpnrvPUyrH9PeEw2GTkgaTHEX91vP0skYnk3Ffvct
         VEZwKpARa7iIQ5KzWSmFg7BWAmXmbVTgdikYqD/28ih4nrQISxRNsOOHvGRCTXWxD+O/
         D95g==
X-Gm-Message-State: AOAM531RryLTIXnwGu20d9ru1XRO58hTymhhdCUJ16F3Hw0fdvXgiTj5
        tID8J5BUQuvP+o54UuMTUtI=
X-Google-Smtp-Source: ABdhPJxK/9AF8fMdEaGROWuYYTJXhO5IktHXn9xJSM11t5e971s7ZQEXtjTihTp3W8rNZ372Wo7tsw==
X-Received: by 2002:a1c:f402:: with SMTP id z2mr8573wma.87.1597946764455;
        Thu, 20 Aug 2020 11:06:04 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id l11sm5265778wme.11.2020.08.20.11.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 11:06:03 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alex Dewar <alex.dewar90@gmail.com>
Subject: [PATCH] scsi: mptfusion: Remove unnecessarily casts
Date:   Thu, 20 Aug 2020 19:05:51 +0100
Message-Id: <20200820180552.853289-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In a number of places, the value returned from pci_alloc_consistent() is
unnecessarily cast from void*. Remove these casts.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/message/fusion/mptbase.c | 6 +++---
 drivers/message/fusion/mptctl.c  | 5 ++---
 drivers/message/fusion/mptfc.c   | 8 ++++----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 9903e9660a38..e61f46fbe7f4 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4975,7 +4975,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	if (hdr.PageLength > 0) {
 		data_sz = hdr.PageLength * 4;
-		ppage0_alloc = (LANPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+		ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
 		rc = -ENOMEM;
 		if (ppage0_alloc) {
 			memset((u8 *)ppage0_alloc, 0, data_sz);
@@ -5021,7 +5021,7 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage1_alloc = (LANPage1_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
+	ppage1_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page1_dma);
 	if (ppage1_alloc) {
 		memset((u8 *)ppage1_alloc, 0, data_sz);
 		cfg.physAddr = page1_dma;
@@ -5322,7 +5322,7 @@ GetIoUnitPage2(MPT_ADAPTER *ioc)
 	/* Read the config page */
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage_alloc = (IOUnitPage2_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	ppage_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 	if (ppage_alloc) {
 		memset((u8 *)ppage_alloc, 0, data_sz);
 		cfg.physAddr = page_dma;
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 1074b882c57c..24aebad60366 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2593,7 +2593,7 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
        /* Get the data transfer speeds
         */
 	data_sz = ioc->spi_data.sdp0length * 4;
-	pg0_alloc = (SCSIDevicePage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	pg0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 	if (pg0_alloc) {
 		hdr.PageVersion = ioc->spi_data.sdp0version;
 		hdr.PageLength = data_sz;
@@ -2657,8 +2657,7 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 		/* Issue the second config page request */
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 		data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
-		pg3_alloc = (SCSIDevicePage3_t *) pci_alloc_consistent(
-							ioc->pcidev, data_sz, &page_dma);
+		pg3_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 		if (pg3_alloc) {
 			cfg.physAddr = page_dma;
 			cfg.pageAddr = (karg.hdr.channel << 8) | karg.hdr.id;
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 4314a3352b96..5abaadc4fc38 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -763,7 +763,7 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+	ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
 	if (ppage0_alloc) {
 
  try_again:
@@ -904,9 +904,9 @@ mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
 		if (data_sz < sizeof(FCPortPage1_t))
 			data_sz = sizeof(FCPortPage1_t);
 
-		page1_alloc = (FCPortPage1_t *) pci_alloc_consistent(ioc->pcidev,
-						data_sz,
-						&page1_dma);
+		page1_alloc = pci_alloc_consistent(ioc->pcidev,
+						   data_sz,
+						   &page1_dma);
 		if (!page1_alloc)
 			return -ENOMEM;
 	}
-- 
2.28.0

