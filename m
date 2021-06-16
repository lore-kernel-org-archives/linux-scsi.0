Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6D7C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 17:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABE1613B9
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 17:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhFPRGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 13:06:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48305 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhFPRGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 13:06:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1ltYxO-0006KD-6q; Wed, 16 Jun 2021 17:04:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: elx: libefc: Fix less than zero comparison of a unsigned int
Date:   Wed, 16 Jun 2021 18:04:01 +0100
Message-Id: <20210616170401.15831-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of the u32 variable rc to less than zero always
false because it is unsigned. Fix this by making it an int.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 202bfdffae27 ("scsi: elx: libefc: FC node ELS and state handling")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/elx/libefc/efc_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
index 31a688bce6e9..725ca2a23fb2 100644
--- a/drivers/scsi/elx/libefc/efc_device.c
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -15,7 +15,7 @@
 void
 efc_d_send_prli_rsp(struct efc_node *node, u16 ox_id)
 {
-	u32 rc = EFC_SCSI_CALL_COMPLETE;
+	int rc = EFC_SCSI_CALL_COMPLETE;
 	struct efc *efc = node->efc;
 
 	node->ls_acc_oxid = ox_id;
-- 
2.31.1

