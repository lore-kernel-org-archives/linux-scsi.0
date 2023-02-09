Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E89C636D6
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 18:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBIStX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 13:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBIStW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 13:49:22 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEE2166D5
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 10:49:21 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so3291535pjp.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 10:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AA3TtFoUkDaOmpqnOefM4T4Y/1FGhfr2BSh5XbxX96I=;
        b=IbH+T7im1cJTh67mtbWUJLbKDNnMSDNsTWuMfxhOYnagGA3lOpAzJTVj5Hl61I/YBt
         HTPHrekgfs3eYWgmGH2MP7mhHBokbITYNMEWyvwSba+4V/DQ4rSojFTyUvnzbXY9F3sv
         I/P4XBNrbxRVR/8cphZoSj2G/GWrLnu4sSXND3DAfzHSqwPb39IuJ1gC6X1bBYQWl+II
         T85ah7JfDMypmN6mWeKVpI05hHkiO5Udqgi2/j/cQDju7AG03YCF/jKLS7T078LZSgu6
         B0jXMSuzSX+YHhQ9vzJYZUt3YZR0o4hbgkt2s6XxhRNBQo2oL25VnncgI50CXS0TM9lL
         mXtA==
X-Gm-Message-State: AO0yUKV2XRAPeWmrHLkoX+vSFedLRrcRMw9kFuhgmzTxUGV1BXcVKQqc
        SWaxpUgNtpWq1IjrFeueOog=
X-Google-Smtp-Source: AK7set/kwrzT2PSaif/3UPr848rFuLV9nFPV7l9WcWWT6Eou+HEpurXHyFD0VYagtp5EfoQahnKxPA==
X-Received: by 2002:a05:6a21:99a9:b0:bf:ae32:5ea8 with SMTP id ve41-20020a056a2199a900b000bfae325ea8mr14229887pzb.11.1675968560534;
        Thu, 09 Feb 2023 10:49:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:15f5:48f5:6861:f3f6])
        by smtp.gmail.com with ESMTPSA id k14-20020aa790ce000000b0058bacd6c4e8sm1749162pfk.207.2023.02.09.10.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 10:49:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Joao Pinto <jpinto@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Eric Biggers <ebiggers@google.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Zhe Wang <zhe.wang1@unisoc.com>
Subject: [PATCH] scsi: ufs: Make the TC G210 driver dependent on CONFIG_OF
Date:   Thu,  9 Feb 2023 10:49:03 -0800
Message-Id: <20230209184914.2762172-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The TC G210 driver only supports devices declared in the device tree.
Hence make this driver dependent on CONFIG_OF. This patch fixes the
following compiler error:

drivers/ufs/host/tc-dwc-g210-pltfrm.c:36:34: error: ‘tc_dwc_g210_pltfm_match’ defined but not used [-Werror=unused-const-variable=]
   36 | static const struct of_device_id tc_dwc_g210_pltfm_match[] = {
      |

Cc: Joao Pinto <jpinto@synopsys.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index 139064e70a34..1cb28f9930dc 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -48,7 +48,7 @@ config SCSI_UFS_CDNS_PLATFORM
 
 config SCSI_UFS_DWC_TC_PLATFORM
 	tristate "DesignWare platform support using a G210 Test Chip"
-	depends on SCSI_UFSHCD_PLATFORM
+	depends on OF && SCSI_UFSHCD_PLATFORM
 	help
 	  Synopsys Test Chip is a PHY for prototyping purposes.
 
