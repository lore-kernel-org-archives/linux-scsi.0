Return-Path: <SRS0=LfzD=YC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E6FECE58D
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 15:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0523A2053B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Oct 2019 15:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbfJIPLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:11:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:54260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729865AbfJIPLh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Oct 2019 11:11:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9CDCAC93;
        Wed,  9 Oct 2019 15:11:35 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE
Date:   Wed,  9 Oct 2019 17:11:28 +0200
Message-Id: <20191009151128.32411-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When building a kernel with SCSI_SNI_53C710 enabled, Kconfig warns:

WARNING: unmet direct dependencies detected for 53C700_LE_ON_BE
  Depends on [n]: SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_LASI700 [=n]
  Selected by [y]:
  - SCSI_SNI_53C710 [=y] && SCSI_LOWLEVEL [=y] && SNI_RM [=y] && SCSI [=y]

Add the missing depends SCSI_SNI_53C710 to 53C700_LE_ON_BE to fix it.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1b92f3c19ff3..90cf4691b8c3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -898,7 +898,7 @@ config SCSI_SNI_53C710
 
 config 53C700_LE_ON_BE
 	bool
-	depends on SCSI_LASI700
+	depends on SCSI_LASI700 || SCSI_SNI_53C710
 	default y
 
 config SCSI_STEX
-- 
2.16.4

