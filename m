Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D9BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiGFXfH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiGFXfF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:35:05 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE452C675;
        Wed,  6 Jul 2022 16:35:04 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 00405C06E7;
        Wed,  6 Jul 2022 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150504; bh=9/FurYrjR5WH7mu1sEESAafuqAzMvL/raaE9Kmb++Vc=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=PGkKVS8vpUflYIb9uZp8SJTOoD4EBUTHgYjqOdY8UelMM3Br82ht6c8nOHCun3/tX
         BBmIxZMtuvGAhn0aqwuvttgE+/J0ZjdfVPe1WHRlr04QdJ2y4tWK1EQOjweW+U9Ivb
         8WaryRfHvVFYjwyKMRRbfHyHB6XBnZkof4bZLHpdDJoYwW+IcUFqlylWAf3xT6ET8b
         2niObggOxe0R9hpy/5kRPzwKCkHDz7cWw8xffeJdJqy7AUC3lFL1/z47Anc6yUJbg6
         Ygf2w2ZbQJHc+pmjrtVQw7oJClE2ozEC5DXmYYAxmBkJUvyCerZb+hGduwFEZxU3ir
         3+f299ayhIZJA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id B6C13A0065;
        Wed,  6 Jul 2022 23:35:01 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:35:01 -0700
Date:   Wed, 06 Jul 2022 16:35:01 -0700
Message-Id: <d25dbd79f4234f5b0d7574cc1ba02e42e3537d81.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 06/36] target: Return Function Complete
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to SAM-4 r14 section 7.2, for ABORT TASK function, a response
of FUNCTION COMPLETE shall indicate that the command was aborted or was
not in the task set. Currently we respond with TASK DOES NOT EXIST when
there's no command in the task set. Fix the response to FUNCTION
COMPLETE instead.

Fixes: 3d28934aaae5 ("target: Add TMR_ABORT_TASK task management support")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_tmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2af80d0998bf..724ddabda488 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -170,9 +170,9 @@ void core_tmr_abort_task(
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
 
-	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
+	printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %lld\n",
 			tmr->ref_task_tag);
-	tmr->response = TMR_TASK_DOES_NOT_EXIST;
+	tmr->response = TMR_FUNCTION_COMPLETE;
 	atomic_long_inc(&dev->aborts_no_task);
 }
 
-- 
2.28.0

