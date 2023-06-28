Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5442C001B1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 17:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjF1RzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjF1Ryz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 13:54:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3A42681;
        Wed, 28 Jun 2023 10:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2247E6139D;
        Wed, 28 Jun 2023 17:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B536BC433C0;
        Wed, 28 Jun 2023 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974893;
        bh=plV4nM9kY1seEi2E6G5RifIXmBYxufGUPbUvfxDlnUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RmuxOHe4Dp8GBzik4q7A9/cuR8XTkx2C/8mmbApEAIa5ixksWpREBzzySrOS0TJ/o
         C0w3iZlSmyxGeZ6dKYfAVMGNoAiDsv515TZsDLeO69ZrB0onpnXLkBBl7RcenAcuri
         +FuXQLbEHdWN5WqE54VrsCAz/5C7+xbFSekpCyD+2Xx8qNQE8Guc3AY6JRLwj07BW2
         gy4Z5u8Az8XYuVEmSmlSwCsGQLn+ZFCpucxv0TlEF3AKvuM399EAb4TuYtGV8ZYhLE
         mov3A6XFmu1LUGwSsDlMzs1S1IpqXr5DFppJZjGAKEt0uAa2AYs5MIe+lk6lizC0pn
         tctk8Fk0j76bg==
Date:   Wed, 28 Jun 2023 11:55:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 04/10][next] scsi: aacraid: Replace one-element array with
 flexible-array member in struct user_sgmapraw
Message-ID: <4c2277b8aa3de8600c807ff8c995635f414161f9.1687974498.git.gustavoars@kernel.org>
References: <cover.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with flexible-array member in struct
user_sgmapraw.

This results in no differences in binary output.

Issue found with the help of Coccinelle and audited and fixed,
manually.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/ClangBuiltLinux/linux/issues/1851
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 2e1623344327..d1fc1ce2e36d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -532,7 +532,7 @@ struct sgmapraw {
 
 struct user_sgmapraw {
 	u32		  count;
-	struct user_sgentryraw sg[1];
+	struct user_sgentryraw sg[];
 };
 
 struct creation_info
-- 
2.34.1

