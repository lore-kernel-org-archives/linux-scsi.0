Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BC3C47096
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 02:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA8F6140C
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 02:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhFDC22 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDC22 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Jun 2021 22:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D533610A8;
        Fri,  4 Jun 2021 02:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622773602;
        bh=acDwWtEoCKvilUayeWvf1cy0VgeYKf2X7ilmeSX1lz8=;
        h=Date:From:To:Cc:Subject:From;
        b=ow8FHUlcFRFhIYt0rj3oaTyb7IZmmpkJzwxZoHgdp1SZVG+z5lBtNO/jOGJpf/bVk
         amIIJlTtCxqTL+RpiqmtS9w9I6Bjonj/Zzcs28w1eR0DiZ8DrOoD+tM/TYlxhp1Pi4
         hGM4/MDb8AC0DETFFWovXzYIEahXvKKURVFjNNBjD6eh9g9aobgoKMu0Q5Wu1Jh4Ks
         HtrtEyjITdP0m0fXLK1U5+KrmmnWhx+Xhr4fE/OikEi+je22FWGZZqQnVnBIu4xZjz
         +jGlw6K+6VKKqq4qwu0TncNzT5skORaQ+hKYldbUXpMr1oqqYwsDqcF1EJeNYPOKm0
         xtZsSj0GgCZqQ==
Date:   Thu, 3 Jun 2021 21:27:52 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] scsi: NCR5380: Fix fall-through warning for Clang
Message-ID: <20210604022752.GA168289@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix
a fall-through warning by replacing a /* fallthrough */ comment
with the new pseudo-keyword macro fallthrough;

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 22 in linux-next. This is one of those last remaining
      warnings.

 drivers/scsi/NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 8aa964cd54df..3baadd068768 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1816,7 +1816,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				switch (tmp) {
 				case ABORT:
 					set_host_byte(cmd, DID_ABORT);
-					/* fallthrough */
+					fallthrough;
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */
 					sink = 1;
-- 
2.27.0

