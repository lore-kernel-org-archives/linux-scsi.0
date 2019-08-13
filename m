Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B788C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F69620665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hI6o/EZt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfHMH0m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6JQhsPjZAx86P4wsmFB/eJa6y9P196Y+LSco+nWRdLc=; b=hI6o/EZtAtkyPieafDr4qTEYQe
        Itr+dNDRCDkZz37hTDvDRcG7GG9AaWbJa+IHVocTItuojLZBKNoS71dqMmpZC4E809UY0kKUaCdUb
        OCUlbuIbVcLK7gcFdGB/YRtN9OJMytsstuAN0H7vSJgpZH1Hs81041I3/L/q5Mk9bhlzDDcW2i9YD
        TBR3gc1Fwu5sPjkTeWd2xg05NQ/TKeE6LJaboae4fw18FfwndAjLg1YZyyfuXyYQqJ3RIeKNMxQ3+
        ojfz+HNqt8cFPW38DWSD5Bw7zuTgGHwPdcUQVrTcKM6epeSEGvrFDoFmPLcLOF6m51NK6GjfhBvR1
        4E0sSQPA==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCX-00070p-Rb; Tue, 13 Aug 2019 07:26:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/28] ia64: move the ROOT_DEV setup to common code
Date:   Tue, 13 Aug 2019 09:25:10 +0200
Message-Id: <20190813072514.23299-25-hch@lst.de>
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

I'm not sure how useful a platform default ROOT_DEV is these days,
but it pretty sure isn't machvec dependent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/dig/setup.c    | 9 ---------
 arch/ia64/kernel/setup.c | 9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/dig/setup.c b/arch/ia64/dig/setup.c
index cc14fdce6db6..0b1866d2462a 100644
--- a/arch/ia64/dig/setup.c
+++ b/arch/ia64/dig/setup.c
@@ -13,13 +13,11 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
-#include <linux/kdev_t.h>
 #include <linux/string.h>
 #include <linux/screen_info.h>
 #include <linux/console.h>
 #include <linux/timex.h>
 #include <linux/sched.h>
-#include <linux/root_dev.h>
 
 #include <asm/io.h>
 #include <asm/machvec.h>
@@ -30,13 +28,6 @@ dig_setup (char **cmdline_p)
 {
 	unsigned int orig_x, orig_y, num_cols, num_rows, font_height;
 
-	/*
-	 * Default to /dev/sda2.  This assumes that the EFI partition
-	 * is physical disk 1 partition 1 and the Linux root disk is
-	 * physical disk 1 partition 2.
-	 */
-	ROOT_DEV = Root_SDA2;		/* default to second partition on first drive */
-
 #ifdef CONFIG_SMP
 	init_smp_config();
 #endif
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 8d47836d932c..560f9833c665 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/console.h>
 #include <linux/delay.h>
 #include <linux/cpu.h>
+#include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/memblock.h>
 #include <linux/reboot.h>
@@ -41,6 +42,7 @@
 #include <linux/threads.h>
 #include <linux/screen_info.h>
 #include <linux/dmi.h>
+#include <linux/root_dev.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/efi.h>
@@ -599,6 +601,13 @@ setup_arch (char **cmdline_p)
 	if (!nomca)
 		ia64_mca_init();
 
+	/*
+	 * Default to /dev/sda2.  This assumes that the EFI partition
+	 * is physical disk 1 partition 1 and the Linux root disk is
+	 * physical disk 1 partition 2.
+	 */
+	ROOT_DEV = Root_SDA2;		/* default to second partition on first drive */
+
 	platform_setup(cmdline_p);
 	paging_init();
 
-- 
2.20.1

