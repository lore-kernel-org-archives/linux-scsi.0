Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A16EC3A5A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76F1222CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733299AbfHVOL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:11:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4765 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733285AbfHVOL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 10:11:28 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 76CA169528A23CF9E8BA;
        Thu, 22 Aug 2019 22:11:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 22:11:16 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 4/4] scsi: bfa: remove set but not used variable 'pgoff'
Date:   Thu, 22 Aug 2019 22:17:46 +0800
Message-ID: <1566483466-120175-5-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566483466-120175-1-git-send-email-zhengbin13@huawei.com>
References: <1566483466-120175-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/bfa/bfa_ioc.c: In function bfa_iocpf_sm_fwcheck_entry:
drivers/scsi/bfa/bfa_ioc.c:712:27: warning: variable pgoff set but not used [-Wunused-but-set-variable]
drivers/scsi/bfa/bfa_ioc.c: In function bfa_ioc_fwver_get:
drivers/scsi/bfa/bfa_ioc.c:1451:13: warning: variable pgoff set but not used [-Wunused-but-set-variable]
drivers/scsi/bfa/bfa_ioc.c: In function bfa_ioc_fwsig_invalidate:
drivers/scsi/bfa/bfa_ioc.c:1673:13: warning: variable pgoff set but not used [-Wunused-but-set-variable]
drivers/scsi/bfa/bfa_ioc.c: In function bfa_ioc_download_fw:
drivers/scsi/bfa/bfa_ioc.c:1874:13: warning: variable pgoff set but not used [-Wunused-but-set-variable]
drivers/scsi/bfa/bfa_ioc.c: In function bfa_diag_memtest_done:
drivers/scsi/bfa/bfa_ioc.c:4774:13: warning: variable pgoff set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 93471d7..52d1624 100644
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
@@ -1661,8 +1659,7 @@ bfa_ioc_flash_fwver_cmp(struct bfa_ioc_s *ioc,
 bfa_status_t
 bfa_ioc_fwsig_invalidate(struct bfa_ioc_s *ioc)
 {
-
-	u32	pgnum, pgoff;
+	u32	pgnum;
 	u32	loff = 0;
 	enum bfi_ioc_state ioc_fwstate;

@@ -1671,7 +1668,6 @@ bfa_ioc_fwsig_invalidate(struct bfa_ioc_s *ioc)
 		return BFA_STATUS_ADAPTER_ENABLED;

 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);
 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);
 	bfa_mem_write(ioc->ioc_regs.smem_page_start, loff, BFA_IOC_FW_INV_SIGN);

@@ -1863,7 +1859,7 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,
 		    u32 boot_env)
 {
 	u32 *fwimg;
-	u32 pgnum, pgoff;
+	u32 pgnum;
 	u32 loff = 0;
 	u32 chunkno = 0;
 	u32 i;
@@ -1892,7 +1888,6 @@ bfa_ioc_download_fw(struct bfa_ioc_s *ioc, u32 boot_type,


 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);

 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);

@@ -4763,10 +4758,9 @@ bfa_diag_memtest_done(void *cbarg)
 	struct bfa_ioc_s  *ioc = diag->ioc;
 	struct bfa_diag_memtest_result *res = diag->result;
 	u32	loff = BFI_BOOT_MEMTEST_RES_ADDR;
-	u32	pgnum, pgoff, i;
+	u32	pgnum, i;

 	pgnum = PSS_SMEM_PGNUM(ioc->ioc_regs.smem_pg0, loff);
-	pgoff = PSS_SMEM_PGOFF(loff);

 	writel(pgnum, ioc->ioc_regs.host_page_num_fn);

--
2.7.4

