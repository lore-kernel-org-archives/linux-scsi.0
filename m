Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC44DC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 18:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43D7613D5
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 18:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhDTSCZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 14:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbhDTSCY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 14:02:24 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1000C06174A;
        Tue, 20 Apr 2021 11:01:52 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 481BB92009E; Tue, 20 Apr 2021 20:01:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4161092009B;
        Tue, 20 Apr 2021 20:01:52 +0200 (CEST)
Date:   Tue, 20 Apr 2021 20:01:52 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] scsi: BusLogic: Avoid unbounded `vsprintf' use
In-Reply-To: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104201939390.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Existing `blogic_msg' invocations do not appear to overrun its internal 
buffer of a fixed length of 100, which would cause stack corruption, but 
it's easy to miss with possible further updates and a fix is cheap in 
performance terms, so limit the output produced into the buffer by using 
`vscnprintf' rather than `vsprintf'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
Changes from v1:

- use `vscnprintf' instead of `vsnprintf' for the correct character count.
---
 drivers/scsi/BusLogic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

linux-buslogic-vscnprintf.diff
Index: linux-macro-ide/drivers/scsi/BusLogic.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/BusLogic.c
+++ linux-macro-ide/drivers/scsi/BusLogic.c
@@ -3588,7 +3588,7 @@ static void blogic_msg(enum blogic_msgle
 	int len = 0;
 
 	va_start(args, adapter);
-	len = vsprintf(buf, fmt, args);
+	len = vscnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
 		static int msglines = 0;
