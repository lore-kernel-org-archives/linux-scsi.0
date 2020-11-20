Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372D8C2D0E4
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB4382415A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 18:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzfnJv48"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgKTSjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbgKTSjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:10 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE27821D91;
        Fri, 20 Nov 2020 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897549;
        bh=5czwBWlX+NOIZ/hDmGXvsib6oKR4rr0f/d+IvUNt/A8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KzfnJv48skZ4PoaPEUPu1nMYoJ8yEuy5tDARACqCt5J0CaiRd0SXCDbaKSRFFSrRG
         gw7wz1EOVQniE7reHeMovOPc2tW5z3tK65s+fjI3CQ0jXWPNHrHDedsUnXW3EX2s+4
         sJKlCSIBjik9qxC5It997iQ9+fvtYkLz9EBI+poY=
Date:   Fri, 20 Nov 2020 12:39:15 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 120/141] scsi: aacraid: Fix fall-through warnings for Clang
Message-ID: <e4e25e57964a69f7173f868ff93df9d6d08f360f.1605896060.git.gustavoars@kernel.org>
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
 drivers/scsi/aacraid/commsup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index b99ca1b0c553..0ae0d1fa2b50 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1448,6 +1448,7 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 				break;
 			}
 			scsi_rescan_device(&device->sdev_gendev);
+			break;
 
 		default:
 			break;
-- 
2.27.0

