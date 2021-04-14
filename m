Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A73AC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9ECD61019
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhDNWjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbhDNWjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 18:39:35 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3252AC061574;
        Wed, 14 Apr 2021 15:39:13 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 9449592009E; Thu, 15 Apr 2021 00:39:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 90EC192009C;
        Thu, 15 Apr 2021 00:39:12 +0200 (CEST)
Date:   Thu, 15 Apr 2021 00:39:12 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] scsi: BusLogic: Avoid unbounded `vsprintf' use
In-Reply-To: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104141521190.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
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
`vsnprintf' rather than `vsprintf'.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
---
 drivers/scsi/BusLogic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

linux-buslogic-vsnprintf.diff
Index: linux-macro-ide/drivers/scsi/BusLogic.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/BusLogic.c
+++ linux-macro-ide/drivers/scsi/BusLogic.c
@@ -3588,7 +3588,7 @@ static void blogic_msg(enum blogic_msgle
 	int len = 0;
 
 	va_start(args, adapter);
-	len = vsprintf(buf, fmt, args);
+	len = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	if (msglevel == BLOGIC_ANNOUNCE_LEVEL) {
 		static int msglines = 0;
