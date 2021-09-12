Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC10C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 21:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 066BD610A3
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 21:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhILV7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 17:59:17 -0400
Received: from tartarus.angband.pl ([51.83.246.204]:39918 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbhILV7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 17:59:15 -0400
Received: from 89-73-149-240.dynamic.chello.pl ([89.73.149.240] helo=barad-dur.angband.pl)
        by tartarus.angband.pl with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mPX5I-00C2fR-5Y; Sun, 12 Sep 2021 23:32:22 +0200
Received: from [2a02:a31c:8245:f980::4] (helo=valinor.angband.pl)
        by barad-dur.angband.pl with esmtp (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mPX5H-0003DS-9s; Sun, 12 Sep 2021 23:32:19 +0200
Received: from kilobyte by valinor.angband.pl with local (Exim 4.95-RC2)
        (envelope-from <kilobyte@valinor.angband.pl>)
        id 1mPX5G-0003Ai-24;
        Sun, 12 Sep 2021 23:32:18 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Adam Borowski <kilobyte@angband.pl>
Date:   Sun, 12 Sep 2021 23:32:12 +0200
Message-Id: <20210912213212.12169-3-kilobyte@angband.pl>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210912213212.12169-1-kilobyte@angband.pl>
References: <20210912213212.12169-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 89.73.149.240
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH 3/3] scsi: aic7xxx: post-edit includes in generated code
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We rename the files in the very line prior...

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/scsi/aic7xxx/aicasm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index 635a2d52dc37..8f354c9b0c9d 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -69,6 +69,7 @@ $(OUTDIR)/aicasm_gram.c $(OUTDIR)/aicasm_gram.h: aicasm_gram.y
 	$(YACC) $(YFLAGS) -b $(<:.y=) $<
 	mv $(<:.y=).tab.c $(OUTDIR)/$(<:.y=.c)
 	mv $(<:.y=).tab.h $(OUTDIR)/$(<:.y=.h)
+	sed -i 's/\.tab\././' $(OUTDIR)/$(<:.y=.c)
 
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
@@ -78,6 +79,7 @@ $(OUTDIR)/aicasm_macro_gram.c $(OUTDIR)/aicasm_macro_gram.h: aicasm_macro_gram.y
 	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
 	mv $(<:.y=).tab.c $(OUTDIR)/$(<:.y=.c)
 	mv $(<:.y=).tab.h $(OUTDIR)/$(<:.y=.h)
+	sed -i 's/\.tab\././' $(OUTDIR)/$(<:.y=.c)
 
 $(OUTDIR)/aicasm_scan.c: aicasm_scan.l
 	$(LEX) $(LFLAGS) -o $@ $<
-- 
2.33.0

