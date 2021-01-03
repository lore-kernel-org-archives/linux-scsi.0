Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3C7C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 14:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAFF220C56
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 14:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbhACOCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 09:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbhACOCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Jan 2021 09:02:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F04C20DD4;
        Sun,  3 Jan 2021 14:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609682496;
        bh=uUni1/Aqw9CBQn9Kex9LuQx8WFY9zqEj+5DF5sCkPKU=;
        h=From:To:Cc:Subject:Date:From;
        b=Q++ihx9m/buJ6ab1NZY0gl95lUr2f/n3xg1b25LhzX2JPlM3wHE1dvl65Jbwt9w4H
         YXMEnIeBqhtjsIs6kku0AOFp+T+4Q/vcLiNJvcSqrJ9SPOddDFzVaZX1us9GI0QghC
         ENk2ql5AZpHnny2SdAn+7qzPJcinFxWtvVp7OGmCvE6UCMmXRsYE3zQZFtbvwEoi+Y
         /GiCQrKf57ZKN8FSRa5p+U2RbtSnpQ/dbIDh3CpunkuPKObSVHqvS1GkTQLwYfymMq
         xEhxk3AmGrQps3tCCtUs+0mjOTpadT/uY88DZ/VS9DNPAaQnNsPLCS9slaq1x+NyYo
         3H7T/a3Qnz6vA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Karen Xie <kxie@chelsio.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Seewald <tseewald@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4: fix TLS dependencies again
Date:   Sun,  3 Jan 2021 15:01:26 +0100
Message-Id: <20210103140132.3866665-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A previous patch tried to avoid a build failure, but missed one case
that Kconfig warns about:

WARNING: unmet direct dependencies detected for CHELSIO_T4
  Depends on [m]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_CHELSIO [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n) && (TLS [=m] || TLS [=m]=n)
  Selected by [y]:
  - SCSI_CXGB4_ISCSI [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI [=y] && INET [=y] && (IPV6 [=y] || IPV6 [=y]=n) && ETHERNET [=y]
x86_64-linux-ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in function `cxgb_select_queue':
cxgb4_main.c:(.text+0xf5df): undefined reference to `tls_validate_xmit_skb'

When any of the dependencies of CHELSIO_T4 are not met, then
SCSI_CXGB4_ISCSI must not 'select' it either.

Fix it by mirroring the network driver dependencies on the iscsi
driver. A more invasive but also more reliable alternative would
be to use 'depends on CHELSIO_T4' instead.

Fixes: 659fbdcf2f14 ("cxgb4: Fix build failure when CONFIG_TLS=m")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/cxgbi/cxgb4i/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig b/drivers/scsi/cxgbi/cxgb4i/Kconfig
index 8b0deece9758..2af88a55fbca 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
+++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config SCSI_CXGB4_ISCSI
 	tristate "Chelsio T4 iSCSI support"
-	depends on PCI && INET && (IPV6 || IPV6=n)
+	depends on PCI && INET && (IPV6 || IPV6=n) && (TLS || TLS=n)
 	depends on THERMAL || !THERMAL
 	depends on ETHERNET
 	depends on TLS || TLS=n
-- 
2.29.2

