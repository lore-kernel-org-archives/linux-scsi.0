Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57482C48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 06:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFD6610A1
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 06:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhFQGd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 02:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhFQGdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Jun 2021 02:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75B786113E;
        Thu, 17 Jun 2021 06:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623911508;
        bh=YILoBGVrZQOZ4FbylM8RJobU8kGORYQY+xjqKdy/rOs=;
        h=From:To:Cc:Subject:Date:From;
        b=Jst4nC2b4C+0qKz1peyabKj43TC9wpNJa44uk2miXSvvXpYq5HIpGJfu1J3SWNUwn
         SKD4eGi0EONzsrj0g6TgFBsmC4xF+zq2J/C2AvOZvzSTQk2IFF8Ljk8tq1eJBTDCd1
         EXt21ZWOr7SUJOyGrm5WxG6ITXsqohrKGZT5p8oM4Rkz3yR0YULWpl0I/mIhuVYSg4
         D4TMGNNgfGK84bSCAwF9lCMeXcOtSSkR9Rd65OQ6haTCBOeLzhDKkpAF6QxcMABbqS
         /kytz6FUnaSATLhvYE+LGpJsa27ioCMwnhd3z7CHLEIaSJyNXB5byaJz4iU6Kjr0bi
         s+joS2Nk+lFGw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] scsi: elx: efct: Eliminate unnecessary boolean check in efct_hw_command_cancel()
Date:   Wed, 16 Jun 2021 23:31:23 -0700
Message-Id: <20210617063123.21239-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang warns:

drivers/scsi/elx/efct/efct_hw.c:1523:17: warning: address of array
'ctx->buf' will always evaluate to 'true' [-Wpointer-bool-conversion]
                              (!ctx->buf ? U32_MAX : *((u32 *)ctx->buf)));
                               ~~~~~~^~~

buf is an array in the middle of a struct so deferencing it is not a
problem as long as ctx is not NULL. Eliminate the check, which fixes the
warning.

Fixes: 580c0255e4ef ("scsi: elx: efct: RQ buffer, memory pool allocation and deallocation APIs")
Link: https://github.com/ClangBuiltLinux/linux/issues/1398
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/elx/efct/efct_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index ce4736c41564..5b508d49e5a5 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1519,8 +1519,7 @@ efct_hw_command_cancel(struct efct_hw *hw)
 				       struct efct_command_ctx, list_entry);
 
 		efc_log_debug(hw->os, "hung command %08x\n",
-			      !ctx ? U32_MAX :
-			      (!ctx->buf ? U32_MAX : *((u32 *)ctx->buf)));
+			      !ctx ? U32_MAX : *((u32 *)ctx->buf));
 		spin_unlock_irqrestore(&hw->cmd_lock, flags);
 		rc = efct_hw_command_process(hw, -1, mqe, SLI4_BMBX_SIZE);
 		spin_lock_irqsave(&hw->cmd_lock, flags);

base-commit: ebc076b3eddc807729bd81f7bc48e798a3ddc477
-- 
2.32.0.93.g670b81a890

