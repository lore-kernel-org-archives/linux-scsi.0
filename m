Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC13C2BBCD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB39B23A1D
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 22:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbgLHWGD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 17:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730970AbgLHWFx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 17:05:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5B0C0613D6;
        Tue,  8 Dec 2020 14:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=90qZ4oIn+gz2WLWqYvJwbPXL4euB8Meabr4inku/c5o=; b=rPHha6d5sPjILfSsFOH2E8K2nO
        m1NzBijPMUme2Ir7PLexfqjaE79sYOrBX0hCF2sXzVGpEB6BKGcN4Od+qPGgDhI+vA8DEKvLkvLko
        PEvsCuicDJupcQBiq4EE5GbIeTmBGshhl+Llhf+PCqu7AF20Led4bYVicHKZVaxJHIAi5CllmGQGh
        YfmFJu2eMFU1VXo71R/xd+Mwx5d7gD8kNbNpWCNNqF5dnskuaoNIt5YDXw1buue93H3ncRGc2J+6b
        G9eMij5BAYPn4tFiMFrzRF4ko+SfmGjaPecrYR3IDTJVZGo0rZiMUcl0dnsAA3GcMw8TiVys4y84K
        XpNfsksQ==;
Received: from [2601:1c0:6280:3f0::1494] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kml6c-00055k-3t; Tue, 08 Dec 2020 22:05:10 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, Karen Xie <kxie@chelsio.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: cxgb4i: fix TLS dependency
Date:   Tue,  8 Dec 2020 14:05:05 -0800
Message-Id: <20201208220505.24488-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI_CXGB4_ISCSI selects CHELSIO_T4. The latter depends on
TLS || TLS=n, so since 'select' does not check dependencies of
the selected symbol, SCSI_CXGB4_ISCSI should also depend on
TLS || TLS=n.

This prevents the following kconfig warning and restricts
SCSI_CXGB4_ISCSI to 'm' whenever TLS=m.

WARNING: unmet direct dependencies detected for CHELSIO_T4
  Depends on [m]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_CHELSIO [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n) && (TLS [=m] || TLS [=m]=n)
  Selected by [y]:
  - SCSI_CXGB4_ISCSI [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI [=y] && INET [=y] && (IPV6 [=y] || IPV6 [=y]=n) && ETHERNET [=y]


Fixes: 7b36b6e03b0d ("[SCSI] cxgb4i v5: iscsi driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Karen Xie <kxie@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
Found in linux-next but applies to mainline as well.

I'm not sure about which commit ID to use in Fixes:.

 drivers/scsi/cxgbi/cxgb4i/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20201208.orig/drivers/scsi/cxgbi/cxgb4i/Kconfig
+++ linux-next-20201208/drivers/scsi/cxgbi/cxgb4i/Kconfig
@@ -4,6 +4,7 @@ config SCSI_CXGB4_ISCSI
 	depends on PCI && INET && (IPV6 || IPV6=n)
 	depends on THERMAL || !THERMAL
 	depends on ETHERNET
+	depends on TLS || TLS=n
 	select NET_VENDOR_CHELSIO
 	select CHELSIO_T4
 	select CHELSIO_LIB
