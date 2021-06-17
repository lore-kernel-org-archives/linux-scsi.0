Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98138C48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 07:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDE4613BF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 07:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhFQHjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 03:39:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37487 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhFQHjy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 03:39:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1ltmat-0006O8-Tu; Thu, 17 Jun 2021 07:37:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: iscsi: remove redundant continue statement
Date:   Thu, 17 Jun 2021 08:37:43 +0100
Message-Id: <20210617073743.151008-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The continue statement at the end of a for-loop has no effect,
remove it.

Addresses-Coverity: ("Continue has no effect")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0e7a7e82e028..6ee7ea4c27e0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -815,8 +815,6 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 		valid_chap_entries++;
 		if (valid_chap_entries == *num_entries)
 			break;
-		else
-			continue;
 	}
 	mutex_unlock(&ha->chap_sem);
 
-- 
2.31.1

