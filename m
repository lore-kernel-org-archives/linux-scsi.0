Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE10C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C794216FD
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603748963;
	bh=Nvq9g1VsrRtH/7KgYfuC7lFsanC3Hay14Fh4Xg/+OL4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=DAxRNFRG6pfO4YRpGO4NJGfCCrPAESB/sdHqbPFwSWaAaZrqN0hthEvtxI7+ACKzY
	 N8xt/x9l7NQL5NNKN37KkrI8NiYUmodOqPQml1EXZBth5DWIewlImyQYuFRCU++nTH
	 2YXQmo8dNHjnZt5JktipdnQ1tgRbk09LDJKhIjzg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbgJZVtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390490AbgJZVtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 17:49:18 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E8C207E8;
        Mon, 26 Oct 2020 21:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603748958;
        bh=Nvq9g1VsrRtH/7KgYfuC7lFsanC3Hay14Fh4Xg/+OL4=;
        h=From:To:Cc:Subject:Date:From;
        b=j/rwS3W5+vHi3gGSlFgqQTtRWzdAGrNS62chXLqfXZ8ZBLFMuGoQ5PiS5gOlUya+b
         ub8/raxafqNZ57SHDOhJgUkfmntxWGV5KvYfWQXPeYV/f1syq5JSZpKDeWa0hLr/RT
         1uE6BtkBArdDUT8ngwxHE8axaszbVJm+X55KM9ek=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Robert Love <robert.w.love@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] libfc: fix enum-conversion warning
Date:   Mon, 26 Oct 2020 22:49:07 +0100
Message-Id: <20201026214911.3892701-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc -Wextra points out an assignment between two different
enum types:

drivers/scsi/libfc/fc_exch.c: In function 'fc_exch_setup_hdr':
../drivers/scsi/libfc/fc_exch.c:275:26: warning: implicit conversion from 'enum fc_class' to 'enum fc_sof' [-Wenum-conversion]

This seems to be intentional, as the same numeric values are
used here, so shut up the warning by adding an explicit cast.

Fixes: 42e9a92fe6a9 ("[SCSI] libfc: A modular Fibre Channel library")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/libfc/fc_exch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 91e680b53523..d71afae6191c 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -271,7 +271,7 @@ static void fc_exch_setup_hdr(struct fc_exch *ep, struct fc_frame *fp,
 
 	if (f_ctl & FC_FC_END_SEQ) {
 		fr_eof(fp) = FC_EOF_T;
-		if (fc_sof_needs_ack(ep->class))
+		if (fc_sof_needs_ack((enum fc_sof)ep->class))
 			fr_eof(fp) = FC_EOF_N;
 		/*
 		 * From F_CTL.
-- 
2.27.0

