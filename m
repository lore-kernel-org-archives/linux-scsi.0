Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65128C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44657610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhGLFxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhGLFxa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:53:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42989C0613DD;
        Sun, 11 Jul 2021 22:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aaO/RG7ETPTozjVRyMmTHSz1TyzWleWhzBZUMG2OgzI=; b=RjyPxdeyBWnF0CC/JgDmiyAx5G
        3UeibjlFWCLGbny1f62jvICH7m1/gwnJXUKYr24LGfastsEcoy6Q0Cnw9hn1MIRqep/W0Dj3vbrCf
        LBLYatW/caeAlemb5m7tTS6+laVjiu7XLNXMFJ8nINFvgFfWhnkbt5C9cs78myc4Q1B5uSkeUGVNb
        SItRooSUkdxNTPYSjm7QeH0kJsHNCtrHGn49Jd+Ar6cS629W/7efKnCT/2ykq9P3KhDGPta7XeMpu
        bUNTcLVa8ZODAhH//B3tqn2Cb063NeQAtaMA8sk7T46XBn9xXT/PE72l8jqFyctIkHjRNayXvKktz
        7cDHWskw==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2op9-00Gv4O-UD; Mon, 12 Jul 2021 05:50:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 04/24] ch: consolidate compat ioctl handling
Date:   Mon, 12 Jul 2021 07:47:56 +0200
Message-Id: <20210712054816.4147559-5-hch@lst.de>
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
 drivers/scsi/ch.c | 73 ++++++++++++++---------------------------------
 1 file changed, 22 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fc7197abfcdf..e89f226cae5c 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -618,6 +618,12 @@ ch_checkrange(scsi_changer *ch, unsigned int type, unsigned int unit)
 	return 0;
 }
 
+struct changer_element_status32 {
+	int		ces_type;
+	compat_uptr_t	ces_data;
+};
+#define CHIOGSTATUS32  _IOW('c', 8,struct changer_element_status32)
+
 static long ch_ioctl(struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -748,7 +754,20 @@ static long ch_ioctl(struct file *file,
 
 		return ch_gstatus(ch, ces.ces_type, ces.ces_data);
 	}
+#ifdef CONFIG_COMPAT
+	case CHIOGSTATUS32:
+	{
+		struct changer_element_status32 ces32;
+
+		if (copy_from_user(&ces32, argp, sizeof (ces32)))
+			return -EFAULT;
+		if (ces32.ces_type < 0 || ces32.ces_type >= CH_TYPES)
+			return -EINVAL;
 
+		return ch_gstatus(ch, ces32.ces_type,
+				  compat_ptr(ces32.ces_data));
+	}
+#endif
 	case CHIOGELEM:
 	{
 		struct changer_get_element cge;
@@ -858,59 +877,13 @@ static long ch_ioctl(struct file *file,
 	}
 
 	default:
+		if (in_compat_syscall())
+			return scsi_compat_ioctl(ch->device, cmd, argp);
 		return scsi_ioctl(ch->device, cmd, argp);
 
 	}
 }
 
-#ifdef CONFIG_COMPAT
-
-struct changer_element_status32 {
-	int		ces_type;
-	compat_uptr_t	ces_data;
-};
-#define CHIOGSTATUS32  _IOW('c', 8,struct changer_element_status32)
-
-static long ch_ioctl_compat(struct file * file,
-			    unsigned int cmd, unsigned long arg)
-{
-	scsi_changer *ch = file->private_data;
-	int retval = scsi_ioctl_block_when_processing_errors(ch->device, cmd,
-							file->f_flags & O_NDELAY);
-	if (retval)
-		return retval;
-
-	switch (cmd) {
-	case CHIOGPARAMS:
-	case CHIOGVPARAMS:
-	case CHIOPOSITION:
-	case CHIOMOVE:
-	case CHIOEXCHANGE:
-	case CHIOGELEM:
-	case CHIOINITELEM:
-	case CHIOSVOLTAG:
-		/* compatible */
-		return ch_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
-	case CHIOGSTATUS32:
-	{
-		struct changer_element_status32 ces32;
-		unsigned char __user *data;
-
-		if (copy_from_user(&ces32, (void __user *)arg, sizeof (ces32)))
-			return -EFAULT;
-		if (ces32.ces_type < 0 || ces32.ces_type >= CH_TYPES)
-			return -EINVAL;
-
-		data = compat_ptr(ces32.ces_data);
-		return ch_gstatus(ch, ces32.ces_type, data);
-	}
-	default:
-		return scsi_compat_ioctl(ch->device, cmd, compat_ptr(arg));
-
-	}
-}
-#endif
-
 /* ------------------------------------------------------------------------ */
 
 static int ch_probe(struct device *dev)
@@ -1015,9 +988,7 @@ static const struct file_operations changer_fops = {
 	.open		= ch_open,
 	.release	= ch_release,
 	.unlocked_ioctl	= ch_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ch_ioctl_compat,
-#endif
+	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
 };
 
-- 
2.30.2

