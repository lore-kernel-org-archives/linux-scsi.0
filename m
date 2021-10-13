Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FEFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 14:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8072610FB
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 14:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbhJMO1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:27:05 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:40591 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbhJMO1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 10:27:04 -0400
Received: from fcoe-test11.asicdesigners.com (fcoe-test11.blr.asicdesigners.com [10.193.185.180])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 19DEOtN3014285;
        Wed, 13 Oct 2021 07:24:56 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        varun@chelsio.com
Subject: [PATCH] scsi: target: cxgbit: increase max DataSegmentLength
Date:   Wed, 13 Oct 2021 19:54:47 +0530
Message-Id: <1634135087-4996-1-git-send-email-varun@chelsio.com>
X-Mailer: git-send-email 2.0.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current value of max DataSegmentLength is 8K, T5/T6 adapters supports
max DataSegmentLength upto 16K, so increase max DataSegmentLength.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index bd37f2a..c6678dc 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -33,11 +33,18 @@ static void cxgbit_set_mdsl(struct cxgbit_device *cdev)
 	struct cxgb4_lld_info *lldi = &cdev->lldi;
 	u32 mdsl;
 
-#define ULP2_MAX_PKT_LEN 16224
-#define ISCSI_PDU_NONPAYLOAD_LEN 312
-	mdsl = min_t(u32, lldi->iscsi_iolen - ISCSI_PDU_NONPAYLOAD_LEN,
-		     ULP2_MAX_PKT_LEN - ISCSI_PDU_NONPAYLOAD_LEN);
-	mdsl = min_t(u32, mdsl, 8192);
+#define CXGBIT_T5_MAX_PDU_LEN 16224
+#define CXGBIT_PDU_NONPAYLOAD_LEN 312 /* 48(BHS) + 256(AHS) + 8(Digest) */
+	if (is_t5(lldi->adapter_type)) {
+		mdsl = min_t(u32, lldi->iscsi_iolen - CXGBIT_PDU_NONPAYLOAD_LEN,
+			     CXGBIT_T5_MAX_PDU_LEN - CXGBIT_PDU_NONPAYLOAD_LEN);
+	} else {
+		mdsl = lldi->iscsi_iolen - CXGBIT_PDU_NONPAYLOAD_LEN;
+		mdsl = min(mdsl, 16384U);
+	}
+
+	mdsl = round_down(mdsl, 4);
+	mdsl = min_t(u32, mdsl, 4 * PAGE_SIZE);
 	mdsl = min_t(u32, mdsl, (MAX_SKB_FRAGS - 1) * PAGE_SIZE);
 
 	cdev->mdsl = mdsl;
-- 
2.0.2

