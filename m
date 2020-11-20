Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7C5C64E7B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5DB2242B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofi9Moy3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgKTSjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730750AbgKTSjQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:16 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4DF21D91;
        Fri, 20 Nov 2020 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897556;
        bh=xWKQqubZxI7RWKL+kiPBSEEZQn+E+gLxyfu/alAfCAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ofi9Moy32lw1FYCVs63zPkwu+28pepafs7ZHuRxCrNO1jivDoE+LsagdpGZHWYhqF
         K+PqPCuHIxrS3doYs1uSLvrhurWakzBbrsJqgYHCEjNRv1IbpfT0eXUEO0M7VKYmct
         0CAwV1VDbtboCtvyAFF+EBQASMRETgPAYudHMxxQ=
Date:   Fri, 20 Nov 2020 12:39:21 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 121/141] scsi: aha1740: Fix fall-through warnings for Clang
Message-ID: <e9fc10eb7d843e6f31e50400d428bd7a217684ac.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aha1740.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5a227c03895f..0dc831026e9e 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -152,6 +152,7 @@ static int aha1740_makecode(unchar *sense, unchar *status)
 					retval=DID_ERROR; /* It's an Overrun */
 				/* If not overrun, assume underrun and
 				 * ignore it! */
+				break;
 			case 0x00: /* No info, assume no error, should
 				    * not occur */
 				break;
-- 
2.27.0

