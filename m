Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BF2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiGFXfV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbiGFXfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:18 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BB62CC94;
        Wed,  6 Jul 2022 16:35:15 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 93311C06EA;
        Wed,  6 Jul 2022 23:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150515; bh=y5pkndQX80vQNmjBBzzMFVHmPJ3i9shoyXSIzhTSt24=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=hfDSR4OwLzKLLJttZbBBiDN+z5hI7kpwzzGubE7bCql0wZIekiBM3tXeJmvEcxMAt
         CfCsg0Esf1dG3FAFKJCas2zSIaVg6usJgyOM7RhOALtswmBnS2N7RdZhmxSFKJ3Fcs
         CrrTQr0Uv3Ekwt5u12ORwxi+l1XHXPRUp2NIv1gmlPrPVIONBSMBetKk+J2YIjhe8B
         3d0zHOxl/WUbdgDNBm/JcjfGlYuxIqgHD9WtD1eyjCQJ5dhECBUu1vk5p5XrSp3bCc
         ZQZWYfznHqlzQsDKCwlGJFZpjzlvbjmrEj2z+E/yPj7nC7/XwZbaPbSVXbohyR/H0z
         MGVdoC90O8cQg==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 5742AA0096;
        Wed,  6 Jul 2022 23:35:14 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:14 -0700
Date:   Wed, 06 Jul 2022 16:35:14 -0700
Message-Id: <5b89eee29b74fbafaa9df34ca3f6170d1cfc5728.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 08/36] target: Refactor core_tmr_abort_task
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

Minor refactoring of core_tmr_abort_task to avoid duplicate code. No
functional change here.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_tmr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 718d985e4860..3e73f60319d5 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -158,15 +158,13 @@ void core_tmr_abort_task(
 			list_del_init(&se_cmd->state_list);
 			target_put_cmd_and_wait(se_cmd);
 
-			pr_err("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu\n",
-			       ref_tag);
-			tmr->response = TMR_FUNCTION_COMPLETE;
 			atomic_long_inc(&dev->aborts_complete);
-			return;
+			goto exit;
 		}
 		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
 
+exit:
 	printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %lld\n",
 			tmr->ref_task_tag);
 	tmr->response = TMR_FUNCTION_COMPLETE;
-- 
2.28.0

