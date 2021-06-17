Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CF2C49361
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 06:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B8260FEA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 06:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhFQGTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 02:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhFQGTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Jun 2021 02:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22CE561245;
        Thu, 17 Jun 2021 06:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623910663;
        bh=Iej6rNHKIHWDbxNC0dw+JtSIrT0pe3am0Zc+QTlD5+Q=;
        h=From:To:Cc:Subject:Date:From;
        b=TxPXXdmGtKAuOPEwHE9jTELtT4aA1F8zUarhx9Pj3gpNcTCo64+tl2E1c5s3KiOGP
         +DwGVg4JqKyEP4udJPKGQMNcI4Wgl0PddA3CYpF2fskJE59I8XqZ1KleocqIQICyj4
         StANrJCP5SfqPpbkJkdiQOZiuenYMMiSzPRS7EJFIg5srnOzWtgCNBpvfHlnsBlITs
         gvm9bjduCSbuLk0yEu2+wuZEMZc659a5KVdeDy+H7IBP/9Xz3lMQEDpfTaBKvmo+az
         ERuSFOohARgk80ZEgWXvr6O51MoYMzBQuaR/b5youIi/N8VSEXe/NsftxIpDA56GzI
         lqQKmPp8C/vZA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] scsi: elx: efct: Do not use id uninitialized in efct_lio_setup_session()
Date:   Wed, 16 Jun 2021 23:17:21 -0700
Message-Id: <20210617061721.2405511-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang warns:

drivers/scsi/elx/efct/efct_lio.c:1216:24: warning: variable 'id' is
uninitialized when used here [-Wuninitialized]
                      se_sess, node, id);
                                     ^~

Shuffle the debug print after id's initialization so that the actual
value is printed.

Fixes: 692e5d73a811 ("scsi: elx: efct: LIO backend interface routines")
Link: https://github.com/ClangBuiltLinux/linux/issues/1397
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/scsi/elx/efct/efct_lio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index e1bab2b17e4d..b7d69ff29c09 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1212,12 +1212,12 @@ static void efct_lio_setup_session(struct work_struct *work)
 		return;
 	}
 
-	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
-		      se_sess, node, id);
-
 	tgt_node = node->tgt_node;
 	id = (u64) tgt_node->port_fc_id << 32 | tgt_node->node_fc_id;
 
+	efc_log_debug(efct, "new initiator sess=%p node=%p id: %llx\n",
+		      se_sess, node, id);
+
 	if (xa_err(xa_store(&efct->lookup, id, tgt_node, GFP_KERNEL)))
 		efc_log_err(efct, "Node lookup store failed\n");
 

base-commit: ebc076b3eddc807729bd81f7bc48e798a3ddc477
-- 
2.32.0.93.g670b81a890

