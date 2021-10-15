Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FBAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 243EF6115C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 13:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhJONSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 09:18:20 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:59482 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234701AbhJONSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 09:18:18 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19FBeijF017156;
        Fri, 15 Oct 2021 13:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=eIA1sZqyZ8h65Z37L7HA5IsLkhh3NOnbBnYV1AxHV68=;
 b=ehXH5CNxuWG8aFLOhdGFIfqH75mk2GDuks8gYAalVEYvXp0Ttg9szhr27njzl6awVKzz
 pEDoehaVtY61+HBay/CX2oYLdASxUlBYg/IU3reK2ANA9p+QkGZDvKmSlSExDdsDaNA9
 y6MCbuCIVS7/qRxI42JzUXym1kEUkdoU0MXzcA01BFsx4by+A5JrZBOtfn+d0gxAIIJD
 o205tWd3136+q/cjpv+GitX3LbaMKqFz3dSf6Y1nOARh296TunLhL8IWbEJsoNpaF6Qf
 coZa8ikqyJ5bKPEnvSP7N7qIAzmCR4i5LMAvYM8FxPydZcRuKWFbNyX+U2fWjkSetLyF Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bph1bysft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 13:16:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19FDAbqj124785;
        Fri, 15 Oct 2021 13:15:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bkyxwva8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Oct 2021 13:15:58 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19FDFvAF140872;
        Fri, 15 Oct 2021 13:15:57 GMT
Received: from t460.home (dhcp-10-175-9-30.vpn.oracle.com [10.175.9.30])
        by aserp3030.oracle.com with ESMTP id 3bkyxwva5g-1;
        Fri, 15 Oct 2021 13:15:57 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] scsi: libiscsi: select CRYPTO_HASH for ISCSI_TCP
Date:   Fri, 15 Oct 2021 15:11:15 +0200
Message-Id: <20211015131115.12720-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: jbTmhyyAuOtWN8vXrnML-2n52vzeZvZe
X-Proofpoint-GUID: jbTmhyyAuOtWN8vXrnML-2n52vzeZvZe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following build/link error by adding a dependency on CRYPTO_HASH:

  ld: drivers/scsi/libiscsi_tcp.o: in function `iscsi_tcp_dgst_header':
  libiscsi_tcp.c:(.text+0x237): undefined reference to `crypto_ahash_digest'
  ld: drivers/scsi/libiscsi_tcp.o: in function `iscsi_tcp_segment_done':
  libiscsi_tcp.c:(.text+0x1325): undefined reference to `crypto_ahash_final'

Fixes: 5d6ac29b9ebf2 ("iscsi_tcp: Use ahash")
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 6e3a04107bb65..09764f3c42447 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -290,6 +290,7 @@ config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"
 	depends on SCSI && INET
 	select CRYPTO
+	select CRYPTO_HASH
 	select CRYPTO_MD5
 	select CRYPTO_CRC32C
 	select SCSI_ISCSI_ATTRS
-- 
2.23.0.718.g5ad94255a8

