Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D17C43334
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiGFXfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiGFXfK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:10 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD0F2C67E;
        Wed,  6 Jul 2022 16:35:09 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7641CC06E7;
        Wed,  6 Jul 2022 23:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150509; bh=wEid/4p31uEfYV/Ls1d/d9euimuTb5BnMCIs9je5TBc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=OmBuakiZeFAF/2zlteeGUsQsx05sBdJc2/sDMjBa0ZPJup+E68KsJsVze2sKv5mau
         HJRcT9E9M3nQbOiHCio9s8KwUbDL4R3y+9zfE+yfBcVs1bYwnMP9/RFIihXza8jJXA
         1MLDswcg8VeWe44M0xVqfyPLreUnjEkN9NqxA8a8/fDPXMZ78/cH0Fro4CIDxKFx2T
         PiBoQYfritwGRxGOm/vxbRK4jiOJ5VNwztAyeGacx2BUmVA8y65P2y31KTORx4DR8a
         rM5Puvz4f8kFPCTcSa93A7pa87FgVslNWE+ZDKFWm3nzwR/LON3ioXnwfrU6wRY0AE
         xHgxv3+8CuMhQ==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id D5AA9A006F;
        Wed,  6 Jul 2022 23:35:07 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:07 -0700
Date:   Wed, 06 Jul 2022 16:35:07 -0700
Message-Id: <92ec6c71a200b42c1a70ba2054087da9715741c8.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 07/36] target: Don't do tmr_notify on empty aborted list
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

If there's no command to abort, just skip doing tmr_notify to an empty
list.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_tmr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 724ddabda488..718d985e4860 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -167,9 +167,6 @@ void core_tmr_abort_task(
 		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
 
-	if (dev->transport->tmr_notify)
-		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
-
 	printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %lld\n",
 			tmr->ref_task_tag);
 	tmr->response = TMR_FUNCTION_COMPLETE;
-- 
2.28.0

