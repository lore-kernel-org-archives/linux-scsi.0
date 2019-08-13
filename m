Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705A7C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4576520842
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D1oIymfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfHMH0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56566 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbfHMH0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=35Wov8xFMRqPypDnINHOhGjn1zV2YlFcYXBEGdDF8FY=; b=D1oIymfJL+GLsXY9L33m81Dx88
        rXlxlzKY/RU9MPxLwHlBcnCaZwsWPaADpHA920JRPva5sACCppVFLmOVUVGeqMC2gyHhT7SYiEQ+W
        gPSjJdssM6Qmmapb9bt2TDr9WjFBkU2Xt8Dz3rU59XT+S4HiQWpJBzmCHgImLP5d/f3ZESPfUJm3t
        F/r2UJcE2imqBGeALOvpl/yrOqqvu4bPTl2rH1xyG4oyfcK5xPi/lbmhh4TgBh9Fm4TunT5RT9Qa0
        C+h7sfYsWJJtqEE4kTeZSTOVqzG4ZJbWPT4K2yk63YpseKtLIDTejBfT4lDEFiD6QEobmKiDVMSob
        wJss1V+w==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCk-0007Fc-Uo; Tue, 13 Aug 2019 07:26:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 28/28] genirq: remove the is_affinity_mask_valid hook
Date:   Tue, 13 Aug 2019 09:25:14 +0200
Message-Id: <20190813072514.23299-29-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813072514.23299-1-hch@lst.de>
References: <20190813072514.23299-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This override was only used by the ia64 SGI SN2 platform, which is
gone now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/irq/proc.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index da9addb8d655..cfc4f088a0e7 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -100,10 +100,6 @@ static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-#ifndef is_affinity_mask_valid
-#define is_affinity_mask_valid(val) 1
-#endif
-
 int no_irq_affinity;
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
@@ -136,11 +132,6 @@ static ssize_t write_irq_affinity(int type, struct file *file,
 	if (err)
 		goto free_cpumask;
 
-	if (!is_affinity_mask_valid(new_value)) {
-		err = -EINVAL;
-		goto free_cpumask;
-	}
-
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
@@ -232,11 +223,6 @@ static ssize_t default_affinity_write(struct file *file,
 	if (err)
 		goto out;
 
-	if (!is_affinity_mask_valid(new_value)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
-- 
2.20.1

