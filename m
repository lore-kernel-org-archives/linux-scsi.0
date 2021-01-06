Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E91C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 04:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F1822DD3
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 04:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbhAFEJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 23:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbhAFEJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 23:09:13 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D65C06134C;
        Tue,  5 Jan 2021 20:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QmLa+cOqR50EfOgT1iDBdhgkPcXU0BbBKqzGFV1+yh0=; b=iqTu3tJUwi8MhGfkmMPILJ2hPK
        G3XfewN8EVwkzzX47bOtxA6MOlq2W7b8lID2UIABuciFIIUcSiCXrIsEOpVE+9U658kTgCm1CKy74
        qa4LHW1sOKLDJ8JK58yDDTdPVCGhVtSNDzAZcCU8/6v1ICEHeGGilG4uqfg2/Nl/gHFTVrFUBQjCY
        QWeWD9caaa4MPsqburQ+KWkbeedNRu00fy8RrNCt8R3kczMJ5hpCZHoBL5GWrybp3os9nBu9UT48Q
        d+7F1Kbc5nfWlxQdD22Frp40UShCaSTGZQkmSCUkLmq89BWbwrNLfA5fKq1zfSd4nxC2hiHJBtwnn
        Rwzq/kKQ==;
Received: from [2601:1c0:6280:3f0::64ea] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kx07Y-0006DE-GN; Wed, 06 Jan 2021 04:08:29 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM
Date:   Tue,  5 Jan 2021 20:08:22 -0800
Message-Id: <20210106040822.933-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Building ufshcd-pltfrm.c on arch/s390/ has a linker error since
S390 does not support IOMEM, so add a dependency on HAS_IOMEM.

s390-linux-ld: drivers/scsi/ufs/ufshcd-pltfrm.o: in function `ufshcd_pltfrm_init':
ufshcd-pltfrm.c:(.text+0x38e): undefined reference to `devm_platform_ioremap_resource'

where that devm_ function is inside an #ifdef CONFIG_HAS_IOMEM/#endif block.

Fixes: 03b1781aa978 ("[SCSI] ufs: Add Platform glue driver for ufshcd")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202101031125.ZEFCUiKi-lkp@intel.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org
---
This not a COMPILE_TEST build. The 0day bot was reporting tons of
S390 build errors for iomem-related function usage, so now S390 does
not allow COMPILE_TEST, and any iomem-related build errors on S390
should be fixed AFAIK.

 drivers/scsi/ufs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-511-rc2.orig/drivers/scsi/ufs/Kconfig
+++ lnx-511-rc2/drivers/scsi/ufs/Kconfig
@@ -72,6 +72,7 @@ config SCSI_UFS_DWC_TC_PCI
 config SCSI_UFSHCD_PLATFORM
 	tristate "Platform bus based UFS Controller support"
 	depends on SCSI_UFSHCD
+	depends on HAS_IOMEM
 	help
 	This selects the UFS host controller support. Select this if
 	you have an UFS controller on Platform bus.
