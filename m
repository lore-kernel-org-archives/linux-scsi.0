Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EEDC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27806610CA
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhGLFyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:54:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4476C0613DD;
        Sun, 11 Jul 2021 22:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Mc4kzsddl5jI+8u+KHD+pFdxRKq5aWco4v9ZNhn1tgU=; b=rb1aTtbYQRQJXaHE8laLHrkhyA
        7t3vjDW5G8aD46g+ZrjhZDx/BVjfU2JMDoKPRaG0OlLuvmEcU415oq+PFl1VGg9XkLt0utChSW/wI
        Bfvm6Zum+l0StP82bO2aAkq1ajb2wWP85Lbx9uNvCTLa+qjDwNzSxwaGznBb3iU+Y+wJGi5OhtDe4
        X/w6bkEp9CWLPtJXwm58enuQww/AenUNKQktxXnHm9hdv8Ave3B8Ilz+HLo3UL3P62LPytpLSz/39
        55X7lkq+ZDQ2QsEDDH6RZoLZEdga3+wJKMnLSulm/y/dWPxEeAxpk8qBx879Sh0rjZEqcNFMfw/CF
        quVa+6Tg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2opj-00Gv6R-66; Mon, 12 Jul 2021 05:50:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 05/24] cg: consolidate compat ioctl handling
Date:   Mon, 12 Jul 2021 07:47:57 +0200
Message-Id: <20210712054816.4147559-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge the native and compat ioctl handlers into a single one using
in_compat_syscall().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sg.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 91e2221bbb0d..0a6655bad5a4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1166,28 +1166,11 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	if (ret != -ENOIOCTLCMD)
 		return ret;
 
+	if (in_compat_syscall())
+		return scsi_compat_ioctl(sdp->device, cmd_in, p);
 	return scsi_ioctl(sdp->device, cmd_in, p);
 }
 
-#ifdef CONFIG_COMPAT
-static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
-{
-	void __user *p = compat_ptr(arg);
-	Sg_device *sdp;
-	Sg_fd *sfp;
-	int ret;
-
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
-		return -ENXIO;
-
-	ret = sg_ioctl_common(filp, sdp, sfp, cmd_in, p);
-	if (ret != -ENOIOCTLCMD)
-		return ret;
-
-	return scsi_compat_ioctl(sdp->device, cmd_in, p);
-}
-#endif
-
 static __poll_t
 sg_poll(struct file *filp, poll_table * wait)
 {
@@ -1441,9 +1424,7 @@ static const struct file_operations sg_fops = {
 	.write = sg_write,
 	.poll = sg_poll,
 	.unlocked_ioctl = sg_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = sg_compat_ioctl,
-#endif
+	.compat_ioctl = compat_ptr_ioctl,
 	.open = sg_open,
 	.mmap = sg_mmap,
 	.release = sg_release,
-- 
2.30.2

