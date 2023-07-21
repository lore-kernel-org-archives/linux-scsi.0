Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0014EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjGUQKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjGUQKf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7E2D50;
        Fri, 21 Jul 2023 09:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 290F361D3B;
        Fri, 21 Jul 2023 16:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4F6C433C7;
        Fri, 21 Jul 2023 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689955818;
        bh=vD2UdR3jMEEOkodAiRKY3xxWGdTLV7U/m5MX9FM43T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUdqQo9XCO5IbpkCXY6k9LT9n0Tqx1QvTi17Vzyu7+1rL0Yft5Y2peUWRlRLy4pez
         xo2Py2Mla/t/sfevCUTaCyjwF0QGIc5CdGzrk7QGD5bMA9JerRi9J5PWzbggTzXiPt
         ntf64P08PcVJu0x+svlVLQX+qfpEMsf8PKIWwibM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Paul Gazzillo <paul@pgazz.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 040/292] scsi: ufs: ufs-mediatek: Add dependency for RESET_CONTROLLER
Date:   Fri, 21 Jul 2023 18:02:29 +0200
Message-ID: <20230721160530.526290612@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 89f7ef7f2b23b2a7b8ce346c23161916eae5b15c ]

When RESET_CONTROLLER is not set, kconfig complains about missing
dependencies for RESET_TI_SYSCON, so add the missing dependency just as is
done above for SCSI_UFS_QCOM.

Silences this kconfig warning:

WARNING: unmet direct dependencies detected for RESET_TI_SYSCON
  Depends on [n]: RESET_CONTROLLER [=n] && HAS_IOMEM [=y]
  Selected by [m]:
  - SCSI_UFS_MEDIATEK [=m] && SCSI_UFSHCD [=y] && SCSI_UFSHCD_PLATFORM [=y] && ARCH_MEDIATEK [=y]

Fixes: de48898d0cb6 ("scsi: ufs-mediatek: Create reset control device_link")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: lore.kernel.org/r/202306020859.1wHg9AaT-lkp@intel.com
Link: https://lore.kernel.org/r/20230701052348.28046-1-rdunlap@infradead.org
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Paul Gazzillo <paul@pgazz.com>
Cc: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 8793e34335806..f11e98c9e6652 100644
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
-- 
2.39.2



