Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D53DC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 02:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68CA320737
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 02:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598407906;
	bh=HAPyHSYdrWDMJRZSgbFs1C4ak3kvY9PCeWzhwqR77iE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=01a8+k8nXiQhTNoZx33TKptrYLqeP+uGcJfJ4Xf3aH1wnuzKiu74W4q6HF4CVSAVI
	 WsrTh6uoo9wCqpfVmQg+jvlAT/1rvOdCp/pngzzkUnLUuSb8qVhi1/rRC28k9YTtuX
	 sZd/WZ+IGqAeeciiCTPukWa9t3cpPPb1dFR95Bdk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHZCLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 22:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHZCLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 22:11:43 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49DE72074A;
        Wed, 26 Aug 2020 02:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598407903;
        bh=HAPyHSYdrWDMJRZSgbFs1C4ak3kvY9PCeWzhwqR77iE=;
        h=From:To:Cc:Subject:Date:From;
        b=rIgtm+BhgGZoyQWl6IN8ereInFJVPnceF0V0pjtuwJvC+llEl8NgzcAM9kVtrmfsU
         vwfgTGr9l5XR9K9mmoZmUqA+BUCT8kKb35j7HQZgmiX+QI0R0zu1ILXNNJ2MmVkaBt
         nxJPodsK41VdFEgwtuMUCTtwaMihGOqDY4Ic++qs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH] scsi: ufs: make ufshcd_print_trs() consider UFSHCD_QUIRK_PRDT_BYTE_GRAN
Date:   Tue, 25 Aug 2020 19:10:40 -0700
Message-Id: <20200826021040.152148-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Fix ufshcd_print_trs() to consider UFSHCD_QUIRK_PRDT_BYTE_GRAN when
using utp_transfer_req_desc::prd_table_length, so that it doesn't treat
the number of bytes as the number of entries.

Originally from Kiwoong Kim
(https://lkml.kernel.org/r/20200218233115.8185-1-kwmad.kim@samsung.com).

Fixes: 26f968d7de82 ("scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk")
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1d157ff58d817..316b861305eae 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -474,6 +474,9 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 
 		prdt_length = le16_to_cpu(
 			lrbp->utr_descriptor_ptr->prd_table_length);
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
+			prdt_length /= sizeof(struct ufshcd_sg_entry);
+
 		dev_err(hba->dev,
 			"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
 			tag, prdt_length,
-- 
2.28.0

