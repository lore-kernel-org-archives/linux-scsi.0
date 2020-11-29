Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157BBC64E7D
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Nov 2020 07:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFE892080C
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Nov 2020 07:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZPB8gs+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgK2HKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 02:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgK2HKH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 02:10:07 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5DAC0613D2;
        Sat, 28 Nov 2020 23:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=XGiZtuFXhffjIPHQFyxIbbqLATdmM5dzCSY80BXYd1A=; b=ZPB8gs+4Ildl17Ejd8/kuFd20Z
        mja/GjvdqANlS67CC0vUP7IZlpWuKSbrnC/ovCE4VL0LXwS/SBEExmubky8UpXXPUTuifSSWe+jGc
        f7/gDeaaPIeGvpdJoyL4sa7Yi/deqq0pg6fQPwnjHCyoqa2T3GBtgzxcZ2nL20UE55uyRXGQck4SN
        a5UdntAqum4pS1Qw6kx991/V8wUYyjSsxxvo3uMx/9Og6Tz3ymeh147pnGrePPNLiPoAh52/7IxxT
        zIeS09dShtEU05UIP5VEsNPKffdUdRlZab0bO0LIKt54RRwnrQwTfSYKzwgGM/tRMO2Yiam222kZx
        XWJGWakw==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjGpl-0000Ly-QQ; Sun, 29 Nov 2020 07:09:23 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: bnx2i: requires MMU
Date:   Sat, 28 Nov 2020 23:09:16 -0800
Message-Id: <20201129070916.3919-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI_BNX2_ISCSI kconfig symbol selects CNIC and CNIC selects UIO,
which depends on MMU.
Since 'select' does not follow dependency chains, add the same MMU
dependency to SCSI_BNX2_ISCSI.

Quietens this kconfig warning:

WARNING: unmet direct dependencies detected for CNIC
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n) && MMU [=n]
  Selected by [m]:
  - SCSI_BNX2_ISCSI [=m] && SCSI_LOWLEVEL [=y] && SCSI [=y] && NET [=y] && PCI [=y] && (IPV6 [=m] || IPV6 [=m]=n)

Fixes: cf4e6363859d ("[SCSI] bnx2i: Add bnx2i iSCSI driver.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-scsi@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/bnx2i/Kconfig            |    1 +
 1 file changed, 1 insertions(+)

--- linux-next-20201125.orig/drivers/scsi/bnx2i/Kconfig
+++ linux-next-20201125/drivers/scsi/bnx2i/Kconfig
@@ -4,6 +4,7 @@ config SCSI_BNX2_ISCSI
 	depends on NET
 	depends on PCI
 	depends on (IPV6 || IPV6=n)
+	depends on MMU
 	select SCSI_ISCSI_ATTRS
 	select NETDEVICES
 	select ETHERNET
