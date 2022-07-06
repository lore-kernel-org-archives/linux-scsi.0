Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA34C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiGFXet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiGFXep (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:34:45 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30C02C661;
        Wed,  6 Jul 2022 16:34:44 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 812B54077F;
        Wed,  6 Jul 2022 23:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150484; bh=S4G9ZIAPaz/eAlg/Un4EY6UluBtJfBD5gweu6q/WYTk=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=PYiMOGPPx4YSAqjYbG4rcXFtlKROGGmf0C4LSuTQQfgeujpL0BamXmQIcRNa8v2cC
         Z1Y5gyOiYBvPfsqz93ySWKu7aaCp6jIMsCCZeRbgahKRKAUMOQvGBPZ7f4tmFTVjHh
         aBuq6RuBarpLeHg8/CcSNAwBb6mr7B8xO3iGbqjvBFVy12NuvJnZ8sNjbCPprL5Sls
         Be2XMnV3P0Hw9chNud9fnVtxiOsHtyAbCazmc9DP9BFNyahfkGcddzvsoiLlDBd1SR
         mCvp/fTooG+TcoA3WQ9P/Z+eViFS1FWVxolsv3eoxTSHh1VaSb5y4Qn4DtE+m66bDa
         Dn2wQ2elRA5TA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 02321A0096;
        Wed,  6 Jul 2022 23:34:42 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:34:42 -0700
Date:   Wed, 06 Jul 2022 16:34:42 -0700
Message-Id: <0af951cacb921def80b5dfbc0ca82b39b1ecd1cc.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 03/36] target: Don't drain empty list
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the preempt_and_abort_list is NULL, don't attempt to drain it.
Otherwise, it may lead to invalid access.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_tmr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..7a7e24069ba7 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -383,9 +383,11 @@ int core_tmr_lun_reset(
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
 		dev->transport->name, tas);
 
-	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
-	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
-				preempt_and_abort_list);
+	if (preempt_and_abort_list) {
+		core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
+		core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
+					  preempt_and_abort_list);
+	}
 
 	/*
 	 * Clear any legacy SPC-2 reservation when called during
-- 
2.28.0

