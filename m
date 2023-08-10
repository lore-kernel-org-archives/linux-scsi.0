Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C400C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 14:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbjHJOWt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbjHJOWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 10:22:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4252702;
        Thu, 10 Aug 2023 07:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82E0865DAF;
        Thu, 10 Aug 2023 14:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51790C433C7;
        Thu, 10 Aug 2023 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691677350;
        bh=ISbGQKHWjQZRyYhsqJ9yc7rqseEvmVUOesxoBZWtIsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgJUvBkBXyee745Ct1M5KdVyUKUZNJiAgNiUIGplaDMu2hMFn8v/IM4F5l6sK6+ZY
         +KImntCYp3KZQbqAwAKy0JpVtMe3OO3Hnv/fzz8gMkFobUsGQF7zSFUSgW/Z3FdS9i
         Z6LTo1bD8FcXaTxhBMINfstRZX7W6SIQNZtg4hvoW75adjwzvxUJ+pifLLdx+lsKah
         kKxHR3metr5beZSndYM4n7R56mZRCX0AEyKcXkYZI8uYU+p9b7vTjQbDDZjV6LejkK
         tgvClsudO87hSCxrrVxjTVJbrLIFid2e4wBjLf9gcSVwaElMkXV1hT0kipCLbL6Orm
         9sxezx7zj7e0Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 11/17] scsi: gvp11: remove unused gvp11_setup() function
Date:   Thu, 10 Aug 2023 16:19:29 +0200
Message-Id: <20230810141947.1236730-12-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230810141947.1236730-1-arnd@kernel.org>
References: <20230810141947.1236730-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This function has no declaration, which causes a warning:

drivers/scsi/gvp11.c:53:6: error: no previous prototype for 'gvp11_setup' [-Werror=missing-prototypes]

Since there is also no caller, just remove the function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/gvp11.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index d2eddad099a2b..0420bfe9bd42d 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -50,11 +50,6 @@ static irqreturn_t gvp11_intr(int irq, void *data)
 
 static int gvp11_xfer_mask = 0;
 
-void gvp11_setup(char *str, int *ints)
-{
-	gvp11_xfer_mask = ints[1];
-}
-
 static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 {
 	struct scsi_pointer *scsi_pointer = WD33C93_scsi_pointer(cmd);
-- 
2.39.2

