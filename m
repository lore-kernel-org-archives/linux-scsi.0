Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB10C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 10:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B89CE6196F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 10:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhCVKdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhCVKdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 06:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09BD6198F;
        Mon, 22 Mar 2021 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616409200;
        bh=vZjZtledyBAVNYPa/uqVGJzLjOm1nITjZZwPfO5QG8Q=;
        h=From:To:Cc:Subject:Date:From;
        b=kBmOtUx/qz6G4Z3dw8K5DJzeIoKlbR3KOr2I3wslkgxmczjIl1UecUakBjd8ji1ES
         QG/W8iXptL4U0ItCHqpeozcpe7EQaO/jr+FTu5uePZFRD78b/I3RmOM7+sDcOB/FXe
         pa/YYRcX16y7ttaeVm573bcNUJ5rvuRqIBQ48bwT9xiuMoY2SykumIBTgbZvcwLP5x
         djH1ROo9SckeSZRcJxdE/hcBbEWQceCkBwaLMUJ6AtvBZq+uu7TdEPX/21Zv5xEeaY
         rMaATyOqebJR7gy6RNThzCGmze2q9gONaRBY8B8x8CmoE2mgRCOBqCJxpyDVNLFQVu
         V3bdduYV/LUgA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mvsas: avoid -Wempty-body warning
Date:   Mon, 22 Mar 2021 11:33:09 +0100
Message-Id: <20210322103316.620694-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building with 'make W=1' shows a few harmless -Wempty-body warning for
the mvsas driver:

drivers/scsi/mvsas/mv_94xx.c: In function 'mvs_94xx_phy_reset':
drivers/scsi/mvsas/mv_94xx.c:278:63: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
  278 |                         mv_dprintk("phy hard reset failed.\n");
      |                                                               ^
drivers/scsi/mvsas/mv_sas.c: In function 'mvs_task_prep':
drivers/scsi/mvsas/mv_sas.c:723:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
  723 |                                 SAS_ADDR(dev->sas_addr));
      |                                                         ^

Change the empty dprintk() macros to no_printk(), which avoids this
warning and adds format string checking.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/mvsas/mv_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 327fdd5ee962..8ff976c9967e 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -40,7 +40,7 @@
 #define mv_dprintk(format, arg...)	\
 	printk(KERN_DEBUG"%s %d:" format, __FILE__, __LINE__, ## arg)
 #else
-#define mv_dprintk(format, arg...)
+#define mv_dprintk(format, arg...) no_printk(format, ## arg)
 #endif
 #define MV_MAX_U32			0xffffffff
 
-- 
2.29.2

