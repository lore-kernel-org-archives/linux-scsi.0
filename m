Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58932C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Feb 2021 19:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F8564DBA
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Feb 2021 19:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBMTZW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Feb 2021 14:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMTZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Feb 2021 14:25:21 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007C3C061574;
        Sat, 13 Feb 2021 11:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FZmTWkQpPPUjaypmE2NG1hSiBy9OhkCuVXbI21b0Gy0=; b=XzSFkSNazb/c2JqWMPG557BDnj
        XMxC43oU97id9L/waWzw5ux2v830SxpFU2ytTUCx2Yx/SNMMYihLVEnGud4EY6/HphmTj4++3rco3
        RINLuB6j+cbSLxmHFDWoVOHSSXjvHhJPoK3oD5mdjxrJckaKfN0BIzMrWT5erBH/Te/SyGLzWAN4e
        bmv8BULeCtibT6Gg+DdJxhw18o9bThyGmF/fsDvR9uVBhCZYUJCHi/i0Dy7LDa3xev3Rx2PcXLJIf
        yP+x43MIsXKHQVr6vUjGNXF24cEWtFwF66n7vOjFiLdHZM8+Lfc3KhsWqT2xL8V1cp9xjQ1qp9H7P
        p9tERYEg==;
Received: from [2601:1c0:6280:3f0::1d53] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lB0Ww-0004x7-LH; Sat, 13 Feb 2021 19:24:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] SCSI: bnx2fc: fix Kconfig warning & CNIC build errors
Date:   Sat, 13 Feb 2021 11:24:28 -0800
Message-Id: <20210213192428.22537-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CNIC depends on MMU, but since 'select' does not follow any
dependency chains, SCSI_BNX2X_FCOE also needs to depend on MMU,
so that erroneous configs are not generated, which cause build
errors in cnic.

WARNING: unmet direct dependencies detected for CNIC
  Depends on [n]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_BROADCOM [=y] && PCI [=y] && (IPV6 [=n] || IPV6 [=n]=n) && MMU [=n]
  Selected by [y]:
  - SCSI_BNX2X_FCOE [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI [=y] && (IPV6 [=n] || IPV6 [=n]=n) && LIBFC [=y] && LIBFCOE [=y]


riscv64-linux-ld: drivers/net/ethernet/broadcom/cnic.o: in function `.L154':
cnic.c:(.text+0x1094): undefined reference to `uio_event_notify'
riscv64-linux-ld: cnic.c:(.text+0x10bc): undefined reference to `uio_event_notify'
riscv64-linux-ld: drivers/net/ethernet/broadcom/cnic.o: in function `.L1442':
cnic.c:(.text+0x96a8): undefined reference to `__uio_register_device'
riscv64-linux-ld: drivers/net/ethernet/broadcom/cnic.o: in function `.L0 ':
cnic.c:(.text.unlikely+0x68): undefined reference to `uio_unregister_device'

Fixes: 853e2bd2103a ("[SCSI] bnx2fc: Broadcom FCoE offload driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/bnx2fc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20210212.orig/drivers/scsi/bnx2fc/Kconfig
+++ linux-next-20210212/drivers/scsi/bnx2fc/Kconfig
@@ -5,6 +5,7 @@ config SCSI_BNX2X_FCOE
 	depends on (IPV6 || IPV6=n)
 	depends on LIBFC
 	depends on LIBFCOE
+	depends on MMU
 	select NETDEVICES
 	select ETHERNET
 	select NET_VENDOR_BROADCOM
