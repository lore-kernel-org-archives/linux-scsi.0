Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE93C11F69
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 01:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563336146B
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 01:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbhGABFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhGABFL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 21:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345BF61424;
        Thu,  1 Jul 2021 01:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625101361;
        bh=Yp8BSeFifNak/V4yD3XLj7SBJV07Sgz+CTLQxoTGev0=;
        h=Date:From:To:Cc:Subject:From;
        b=AweWU/a2cdDgsBiGICVvIkPnOXeE/C51P5/trS+ts4+zE5bOXZvBjBIY4NtnmMbwv
         fk/gmyCP2gHTVrpTlwZW9Jcg3JE8aIgJQCVpn0WVfvSU9MVwc487hDGSw3jwSqhbE1
         k5N/VNAo5CLJbI7LOUI8Gcp6xG1RCSXzAEYBFeMoww3l072Oc3aerjwl6quWSLmSgY
         wvPy+ZOfgsctGBPPVCoYEyifTaU94jqyRq5OsMK/tFdfnjuJ+YRpulxH+Jma7HPdx9
         uSkuwLtRSha6Ls5LE+EvHxeJCb1obAqTtqIqTezIJGxPA5Eor0DWS6gB93IwBiZWA9
         jkW6ZD6ghQs1w==
Date:   Wed, 30 Jun 2021 20:04:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: aic94xx: Fix fall-through warning for Clang
Message-ID: <20210701010433.GA57746@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a
warning by explicitly adding a fallthrough; statement.

Notice that this seems to be a Duff device for performance[1]. So,
although the code looks a bit _funny_, I didn't want to refactor
or modify it beyond merely adding a fallthrough marking, which
might be the least disruptive way to fix this issue.

[1] https://www.drdobbs.com/a-reusable-duff-device/184406208

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 7 in linux-next(20210630). This is one of those last
      remaining warnings. :)

 drivers/scsi/aic94xx/aic94xx_sds.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 297a66770260..46815e65f7a4 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -718,10 +718,12 @@ static void *asd_find_ll_by_id(void * const start, const u8 id0, const u8 id1)
 	do {
 		switch (id1) {
 		default:
-			if (el->id1 == id1)
+			if (el->id1 == id1) {
+			fallthrough;
 		case 0xFF:
 				if (el->id0 == id0)
 					return el;
+			}
 		}
 		el = start + le16_to_cpu(el->next);
 	} while (el != start);
-- 
2.27.0

