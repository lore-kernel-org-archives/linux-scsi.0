Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B70C433F2
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F3F22B43
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:26:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bW8Vzj2E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgGWM0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbgGWMZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:15 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65C5C0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:14 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so830460wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cf+NSCEl4l8fm6ZX+HEQTyPPFg3UkwN755ooy1CCQaI=;
        b=bW8Vzj2EJhdja/ubPDqRLsVuqa538TxXzPjSDWyOLPJlJlKHSuLh0e8AQTVjAQOsWj
         5iY5rXElIn/muLPp4tHPfoqmOi7EMVbreljiZjBCUM0G8aeiKacpa3jkFA/pydW+IbP8
         ihoL5Oih3uKUPrfWJo8Yb+dhthAzlM2nNUJlV0kogpD9ZPBThJV2+5S/uhGFAW8e6rvM
         drfBYTLbauHSb/LyA5UqaSOFajg5EzUiRifrWDiTxOJrqPUz04zLbLgoQVdmhmyL77Lh
         6BpAfFg72ip+akmWhstJvvvQJ3KnRqXZzTHmcVh92g8GSSYz9hfEmtoOMikayWkuv6BD
         GrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cf+NSCEl4l8fm6ZX+HEQTyPPFg3UkwN755ooy1CCQaI=;
        b=kOQSHsCeeh5e1kCmGckNB0fQSUSYXUr5StcOa/lj8o9rtw8ASR37yYgQ+E8rMmJfBV
         BbDsX1WIQiz2H29dLW9ktCeEnkZ2uaStVeD/ScflSp6RnBqwZAOYEL1hJYebidUlR5OD
         K1Bp77aYPToZSaIz4qtuxZ5nYiSZrQnmuunNXtyKI25HfPYvSqRpX3kDxIqNnZQrM325
         Ka5yck7FXEYhTIfgoGJzCOd9dTrlc+N9nMWcgQa6FreYMlXJBMeR+dIm0Wi3/6RLLimh
         hEqHa2gOlgfug2cZ7STZvKNkQWXY5bWNkT/m9pNatoiEK23+2zQFcO0aKIbZS9pFsxzi
         7DZA==
X-Gm-Message-State: AOAM533+mC4sKkjctIlS6RWCjmCvlehNK0ZUGYB5gyW0yCiryoWB8baF
        a33gxBOeJTtVxPAQ1ftzoLcr+Q==
X-Google-Smtp-Source: ABdhPJxsnzHZiVUbnFjEJ5JYLdPuSU74e+dTLAPlg1MC2TgRbgk9mlshAJM1+n1kD9SuPzUxOE43SQ==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr4176892wmj.73.1595507113681;
        Thu, 23 Jul 2020 05:25:13 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 20/40] scsi: bfa: bfa_ioc: Remove a few unused variables 'pgoff' and 't'
Date:   Thu, 23 Jul 2020 13:24:26 +0100
Message-Id: <20200723122446.1329773-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_ioc.c: In function ‘bfa_iocpf_sm_fwcheck_entry’:
 drivers/scsi/bfa/bfa_ioc.c:704:27: warning: variable ‘pgoff’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/bfa/bfa_ioc.c: In function ‘bfa_ioc_fwver_get’:
 drivers/scsi/bfa/bfa_ioc.c:1443:13: warning: variable ‘pgoff’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/bfa/bfa_ioc.c: In function ‘bfa_ioc_fwsig_invalidate’:
 drivers/scsi/bfa/bfa_ioc.c:1665:13: warning: variable ‘pgoff’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/bfa/bfa_ioc.c: In function ‘bfa_ioc_download_fw’:
 drivers/scsi/bfa/bfa_ioc.c:1866:13: warning: variable ‘pgoff’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/bfa/bfa_ioc.c: In function ‘bfa_diag_memtest_done’:
 drivers/scsi/bfa/bfa_ioc.c:4766:13: warning: variable ‘pgoff’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/bfa/bfa_ioc.c: In function ‘bfa_flash_fifo_flush’:
 drivers/scsi/bfa/bfa_ioc.c:6787:6: warning: variable ‘t’ set but not used [-Wunused-but-set-variable]

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_ioc.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 93471d7c61d05..3ce281a02d5bb 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -701,7 +701,7 @@ static void
 bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 {
 	struct bfi_ioc_image_hdr_s	fwhdr;
-	u32	r32, fwstate, pgnum, pgoff, loff = 0;
+	u32	r32, fwstate, pgnum, loff = 0;
 	int	i;
 
 	/*
@@ -731,7 +731,6 @@ bfa_iocpf_sm_fwcheck_entry(struct bfa_iocpf_s *iocpf)
 	 * Clear fwver hdr
 	 */
 	pgnum = PSS_SMEM_PGNUM(iocpf->ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, iocpf->ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32); i++) {
@@ -1440,13 +1439,12 @@ bfa_ioc_lpu_stop(struct bfa_ioc_s *ioc)
 void
 bfa_ioc_fwver_get(struct bfa_ioc_s *ioc, struct bfi_ioc_image_hdr_s *fwhdr)
 {
-	u32	pgnum, pgoff;
+	u32	pgnum;
 	u32	loff = 0;
 	int		i;
 	u32	*fwsig = (u32 *) fwhdr;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < (sizeof(struct bfi_ioc_image_hdr_s) / sizeof(u32));
@@ -1662,7 +1660,7 @@ bfa_status_t
 bfa_ioc_fwsig_invalidate(struct bfa_ioc_s *ioc)
 {
 
-	u32	pgnum, pgoff;
+	u32	pgnum;
 	u32	loff = 0;
 	enum bfi_ioc_state ioc_fwstate;
 
@@ -1671,7 +1669,6 @@ bfa_ioc_fwsig_invalidate(struct bfa_ioc_s *ioc)
 		return BFA_STATUS_ADAPTER_ENABLED;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 	bfa_mem_write(ioc->ioc_regs.smem_page_start, loff, BFA_IOC_FW_INV_SIGN);
 
@@ -1863,7 +1860,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		    u32 boot_env)
 {
 	u32 *fwimg;
-	u32 pgnum, pgoff;
+	u32 pgnum;
 	u32 loff = 0;
 	u32 chunkno = 0;
 	u32 i;
@@ -1892,8 +1889,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
-
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < fwimg_size; i++) {
@@ -4763,11 +4758,9 @@ bfa_diag_memtest_done(void *cbarg)
 	struct bfa_ioc_s  *ioc = diag->ioc;
 	struct bfa_diag_memtest_result *res = diag->result;
 	u32	loff = BFI_BOOT_MEMTEST_RES_ADDR;
-	u32	pgnum, pgoff, i;
+	u32	pgnum, i;
 
 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
-
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 
 	for (i = 0; i < (sizeof(struct bfa_diag_memtest_result) /
@@ -6784,7 +6777,6 @@ static u32
 bfa_flash_fifo_flush(void __iomem *pci_bar)
 {
 	u32 i;
-	u32 t;
 	union bfa_flash_dev_status_reg_u dev_status;
 
 	dev_status.i = readl(pci_bar + FLI_DEV_STATUS_REG);
@@ -6794,7 +6786,7 @@ bfa_flash_fifo_flush(void __iomem *pci_bar)
 
 	/* fifo counter in terms of words */
 	for (i = 0; i < dev_status.r.fifo_cnt; i++)
-		t = readl(pci_bar + FLI_RDDATA_REG);
+		readl(pci_bar + FLI_RDDATA_REG);
 
 	/*
 	 * Check the device status. It may take some time.
-- 
2.25.1

