Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29677C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 06:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D111B2085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 06:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgLAGwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 01:52:33 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50828 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLAGwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 01:52:32 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id BD4322B6CF; Tue,  1 Dec 2020 01:51:51 -0500 (EST)
To:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Thomas Gleixner" <tglx@linutronix.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <58cf6feeaf5dae1ee0c78c1b25c00c73de15b087.1606805196.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/NCR5380: Remove in_interrupt() test
Date:   Tue, 01 Dec 2020 17:46:36 +1100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The in_interrupt() macro is deprecated. Also, it's usage in
NCR5380_poll_politely2() has long been redundant.

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201126132952.2287996-1-bigeasy@linutronix.de
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 462d911a89f2..6972e7ceb81a 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
 		cpu_relax();
 	} while (n--);
 
-	if (irqs_disabled() || in_interrupt())
+	/* Sleeping is not allowed when in atomic or interrupt contexts.
+	 * Callers in such contexts always disable local irqs.
+	 */
+	if (irqs_disabled())
 		return -ETIMEDOUT;
 
 	/* Repeatedly sleep for 1 ms until deadline */
-- 
2.26.2

