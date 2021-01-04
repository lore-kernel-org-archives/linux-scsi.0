Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CAEC4332E
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D2D205CA
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbhADQAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:00:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728276AbhADQAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38033224D4;
        Mon,  4 Jan 2021 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775997;
        bh=w9ADJ7ntWksPmduVRPlLqtVyPk6nB5N/EXcp17a0jlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=If6i0WQV+8z8YkKqYNa6WNxWaNNu8+b8sKnN826e9DvKuPAj+K2/7h9U3fjYDUgu1
         eBdV3e6kbo5qVTgYxIOZQIEPJ53J0ZKcC6GN0zUSMRiwHzWsrbfZVnLI2cD8YwIA7s
         oIc2WJSKK798WJ1komasozcHfLb+KmSyXUmATe0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karen Xie <kxie@chelsio.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.4 24/47] scsi: cxgb4i: Fix TLS dependency
Date:   Mon,  4 Jan 2021 16:57:23 +0100
Message-Id: <20210104155706.909767529@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit cb5253198f10a4cd79b7523c581e6173c7d49ddb upstream.

SCSI_CXGB4_ISCSI selects CHELSIO_T4. The latter depends on TLS || TLS=n, so
since 'select' does not check dependencies of the selected symbol,
SCSI_CXGB4_ISCSI should also depend on TLS || TLS=n.

This prevents the following kconfig warning and restricts SCSI_CXGB4_ISCSI
to 'm' whenever TLS=m.

WARNING: unmet direct dependencies detected for CHELSIO_T4
  Depends on [m]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_CHELSIO [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n) && (TLS [=m] || TLS [=m]=n)
  Selected by [y]:
  - SCSI_CXGB4_ISCSI [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI [=y] && INET [=y] && (IPV6 [=y] || IPV6 [=y]=n) && ETHERNET [=y]

Link: https://lore.kernel.org/r/20201208220505.24488-1-rdunlap@infradead.org
Fixes: 7b36b6e03b0d ("[SCSI] cxgb4i v5: iscsi driver")
Cc: Karen Xie <kxie@chelsio.com>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/cxgbi/cxgb4i/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
+++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
@@ -4,6 +4,7 @@ config SCSI_CXGB4_ISCSI
 	depends on PCI && INET && (IPV6 || IPV6=n)
 	depends on THERMAL || !THERMAL
 	depends on ETHERNET
+	depends on TLS || TLS=n
 	select NET_VENDOR_CHELSIO
 	select CHELSIO_T4
 	select CHELSIO_LIB


