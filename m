Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD0AC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 717F420665
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 07:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o9Di8nWf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfHMH0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:26:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfHMH0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Aug 2019 03:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=syc1i0kIUfmohaKb5nXsvH1L085afSRAKLqCpOR88wY=; b=o9Di8nWfb5AOzXNWWRsZpzN3Ze
        HYpOHK8TNembuyTy+WJsnmWXS7PMGPFn7UPWHmmvLHoes/O322V28lGAzDzeAbmr8Vn1gajsZqLvC
        9prQZ1JQ4tTN6HeVn4IcwJ/9kjppBjVdfEYF1jTYLteQbM6wr47iFUEmtYUbEaBgD1IP2GxzBixVx
        43r0wecBOMgM+oaX2+6ZBR8gdc1hd+JyOhYJHoinzSWdh/4SswqLZxCsejfEyErVswBFtTO97/v50
        ZmmT/Ftkk84v4k4l9pRlEjzSEHAdgSm97Y4nQvfyudmBmIfMgN/jKf+zPCwefvzW2IcizasZZX2Zr
        4VQPw+DQ==;
Received: from [2001:4bb8:180:1ec3:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hxRCb-00074w-18; Tue, 13 Aug 2019 07:26:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Mike Travis <mike.travis@hpe.com>,
        Dimitri Sivanich <sivanich@hpe.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/28] ia64: move the screen_info setup to common code
Date:   Tue, 13 Aug 2019 09:25:11 +0200
Message-Id: <20190813072514.23299-26-hch@lst.de>
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

There is nothing really platform specific about setting about the
screen_info from the ia64_boot_param structure, so move it from the
dig machvec to common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/ia64/dig/setup.c    | 30 ------------------------------
 arch/ia64/kernel/setup.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/ia64/dig/setup.c b/arch/ia64/dig/setup.c
index 0b1866d2462a..ca8be4617b2e 100644
--- a/arch/ia64/dig/setup.c
+++ b/arch/ia64/dig/setup.c
@@ -26,37 +26,7 @@
 void __init
 dig_setup (char **cmdline_p)
 {
-	unsigned int orig_x, orig_y, num_cols, num_rows, font_height;
-
 #ifdef CONFIG_SMP
 	init_smp_config();
 #endif
-
-	memset(&screen_info, 0, sizeof(screen_info));
-
-	if (!ia64_boot_param->console_info.num_rows
-	    || !ia64_boot_param->console_info.num_cols)
-	{
-		printk(KERN_WARNING "dig_setup: warning: invalid screen-info, guessing 80x25\n");
-		orig_x = 0;
-		orig_y = 0;
-		num_cols = 80;
-		num_rows = 25;
-		font_height = 16;
-	} else {
-		orig_x = ia64_boot_param->console_info.orig_x;
-		orig_y = ia64_boot_param->console_info.orig_y;
-		num_cols = ia64_boot_param->console_info.num_cols;
-		num_rows = ia64_boot_param->console_info.num_rows;
-		font_height = 400 / num_rows;
-	}
-
-	screen_info.orig_x = orig_x;
-	screen_info.orig_y = orig_y;
-	screen_info.orig_video_cols  = num_cols;
-	screen_info.orig_video_lines = num_rows;
-	screen_info.orig_video_points = font_height;
-	screen_info.orig_video_mode = 3;	/* XXX fake */
-	screen_info.orig_video_isVGA = 1;	/* XXX fake */
-	screen_info.orig_video_ega_bx = 3;	/* XXX fake */
 }
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 560f9833c665..65d07c60f12d 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -469,6 +469,39 @@ early_console_setup (char *cmdline)
 	return -1;
 }
 
+static void __init
+screen_info_setup(void)
+{
+	unsigned int orig_x, orig_y, num_cols, num_rows, font_height;
+
+	memset(&screen_info, 0, sizeof(screen_info));
+
+	if (!ia64_boot_param->console_info.num_rows ||
+	    !ia64_boot_param->console_info.num_cols) {
+		printk(KERN_WARNING "invalid screen-info, guessing 80x25\n");
+		orig_x = 0;
+		orig_y = 0;
+		num_cols = 80;
+		num_rows = 25;
+		font_height = 16;
+	} else {
+		orig_x = ia64_boot_param->console_info.orig_x;
+		orig_y = ia64_boot_param->console_info.orig_y;
+		num_cols = ia64_boot_param->console_info.num_cols;
+		num_rows = ia64_boot_param->console_info.num_rows;
+		font_height = 400 / num_rows;
+	}
+
+	screen_info.orig_x = orig_x;
+	screen_info.orig_y = orig_y;
+	screen_info.orig_video_cols  = num_cols;
+	screen_info.orig_video_lines = num_rows;
+	screen_info.orig_video_points = font_height;
+	screen_info.orig_video_mode = 3;	/* XXX fake */
+	screen_info.orig_video_isVGA = 1;	/* XXX fake */
+	screen_info.orig_video_ega_bx = 3;	/* XXX fake */
+}
+
 static inline void
 mark_bsp_online (void)
 {
@@ -609,6 +642,7 @@ setup_arch (char **cmdline_p)
 	ROOT_DEV = Root_SDA2;		/* default to second partition on first drive */
 
 	platform_setup(cmdline_p);
+	screen_info_setup();
 	paging_init();
 
 	clear_sched_clock_stable();
-- 
2.20.1

