Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCF2C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 11:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9988F610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 11:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhE0Lz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 07:55:29 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2063 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhE0Lz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 07:55:28 -0400
Received: from dggeml715-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FrR1V40RNzWpFP;
        Thu, 27 May 2021 19:49:18 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggeml715-chm.china.huawei.com (10.3.17.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 27 May 2021 19:53:53 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 19:53:53 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: mpt3sas: Remove the repeated declaration
Date:   Thu, 27 May 2021 19:53:45 +0800
Message-ID: <1622116425-27023-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Variable 'mpt3sas_transport_template' is declared twice, so remove the
repeated declaration.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 98558d9c8c2d..af94934ede6c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1933,7 +1933,6 @@ void mpt3sas_transport_update_links(struct MPT3SAS_ADAPTER *ioc,
 	u64 sas_address, u16 handle, u8 phy_number, u8 link_rate,
 	struct hba_port *port);
 extern struct sas_function_template mpt3sas_transport_functions;
-extern struct scsi_transport_template *mpt3sas_transport_template;
 void
 mpt3sas_transport_del_phy_from_an_existing_port(struct MPT3SAS_ADAPTER *ioc,
 	struct _sas_node *sas_node, struct _sas_phy *mpt3sas_phy);
-- 
2.7.4

