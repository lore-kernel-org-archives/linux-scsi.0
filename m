Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A99C7EE23
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 02:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjFBCkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jun 2023 22:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjFBCkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2023 22:40:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C49192;
        Thu,  1 Jun 2023 19:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=1kfkyBbEKK9syFELZldrmIs3ddT+2K6uKGsn6AiWLI8=; b=q24oCbf+6Mf6aqjEWKffDVkv58
        7XPpD+wuDZJJrPfhH6+uv3Lya5UIX8RUyUkeB+gNt1PUXLf1t2sI/MSY8u2kluimZrNhnBS41+duC
        7iYMzmjIDsIMPc601LDQ8bsBRI2rmRqNlQq7AZcKfoRE8WvSMz504Wqg5mhYZkv90py+6j/VsG8Or
        ITzIRyQ0JRAOL46nKmuuhXKnTX6mG5FAafSCLIL+OfvdwemegY1yGTAWKWgZPHy/vi5TxxirlMP9p
        N2bj27ja61VPazB7YZsznS5hJSgNQKAihEl6ym4Sb2Biv3R1ibLjgwsC0p07iyiYnw7lZIcxGP6Mf
        R+GoQJ/w==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q4uhq-005WXd-2l;
        Fri, 02 Jun 2023 02:39:58 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Paul Gazzillo <paul@pgazz.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: ufs-mediatek: add dependency for RESET_CONTROLLER
Date:   Thu,  1 Jun 2023 19:39:57 -0700
Message-Id: <20230602023957.9187-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When RESET_CONTROLLER is not set, kconfig complains about missing
dependencies for RESET_TI_SYSCON, so add the missing dependency
just as is done above for SCSI_UFS_QCOM.

Silences this kconfig warning:

WARNING: unmet direct dependencies detected for RESET_TI_SYSCON
  Depends on [n]: RESET_CONTROLLER [=n] && HAS_IOMEM [=y]
  Selected by [m]:
  - SCSI_UFS_MEDIATEK [=m] && SCSI_UFSHCD [=y] && SCSI_UFSHCD_PLATFORM [=y] && ARCH_MEDIATEK [=y]

Fixes: de48898d0cb6 ("scsi: ufs-mediatek: Create reset control device_link")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202306020859.1wHg9AaT-lkp@intel.com
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Paul Gazzillo <paul@pgazz.com>
Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/ufs/host/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -- a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -72,6 +72,7 @@ config SCSI_UFS_QCOM
 config SCSI_UFS_MEDIATEK
 	tristate "Mediatek specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
+	depends on RESET_CONTROLLER
 	select PHY_MTK_UFS
 	select RESET_TI_SYSCON
 	help
