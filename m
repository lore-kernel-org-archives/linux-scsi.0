Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17CB9C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 11:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B6E61A35
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 11:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhCYLe6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 07:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhCYLcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Mar 2021 07:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76A0B61A6D;
        Thu, 25 Mar 2021 11:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671706;
        bh=n4iikduJr3E2uYXSqu/KflvPTpitcM1eQRiszzlfXh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUV51nwrIP0NdkbJEdqr27GLGgQhPtHXh5bRfMsXjGVO4C14H1uzKYmZQBiK+cJJ/
         bhi2JvTKrxLW1bxrKedBsirZjohyEt9PedjHZDJ9xWGgLAlk329BBNpEns3PhFiC/e
         uSdrVzD2K5+CMcaaLZESpH4oK0v2rjYoOQYgqllO9XIINXFa0fOUefNQhGOb7dJ7X9
         PHQrjbNhMJvUhhd7MN08BOzJmLwEPhTclRRSO2BZDUJumVjVLTEGZM9x5FxMumkc7a
         iA0cDOQv5V6bT9tJXe3efFJHr8cbA0lWmOs3lDjE9jfjiLWiqZka9A0ScIpK/TFLTS
         k7lAaVrXbA09w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/13] scsi: qla2xxx: Fix broken #endif placement
Date:   Thu, 25 Mar 2021 07:28:09 -0400
Message-Id: <20210325112814.1928637-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112814.1928637-1-sashal@kernel.org>
References: <20210325112814.1928637-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 5999b9e5b1f8a2f5417b755130919b3ac96f5550 ]

Only half of the file is under include guard because terminating #endif
is placed too early.

Link: https://lore.kernel.org/r/YE4snvoW1SuwcXAn@localhost.localdomain
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 07ea4fcf4f88..983ec09da650 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -112,7 +112,6 @@
 	(min(1270, ((ql) > 0) ? (QLA_TGT_DATASEGS_PER_CMD_24XX + \
 		QLA_TGT_DATASEGS_PER_CONT_24XX*((ql) - 1)) : 0))
 #endif
-#endif
 
 #define GET_TARGET_ID(ha, iocb) ((HAS_EXTENDED_IDS(ha))			\
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
@@ -323,6 +322,7 @@ struct ctio_to_2xxx {
 #ifndef CTIO_RET_TYPE
 #define CTIO_RET_TYPE	0x17		/* CTIO return entry */
 #define ATIO_TYPE7 0x06 /* Accept target I/O entry for 24xx */
+#endif
 
 struct fcp_hdr {
 	uint8_t  r_ctl;
-- 
2.30.1

