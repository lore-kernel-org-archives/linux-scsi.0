Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62396C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3874860E93
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhGXGld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbhGXGla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:41:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C168FC061575;
        Sat, 24 Jul 2021 00:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aaO/RG7ETPTozjVRyMmTHSz1TyzWleWhzBZUMG2OgzI=; b=tV8GUpi0nirECQ6DPjW/PIquLY
        EdFIfb5/PtoHDGXPGyWUj9txHuaA/QKl/7Em7W8LpNPA5Vd0zcGYBDNHhvRxNn5N/mnvZTVnBrmIc
        YPyPS4uj1wXhr4RGhfJib63wFYHf/6FfhjfAOb98J81KBskdXjOgRS9fXcBF+68Kgxf1shgXA84vf
        8DhoRy5QQxtDVBKNGo4uiH8JK9kb/PVCAmngOJG0z8l5cAI+w92E74LVJq2e26MSAzxTFezEi0O/Y
        6haFiMOw80E93YOh5Q1USP+g+THAKJs2u4uPvP5Q4VholyrNwSr/VzVz7x1FlxA6kOVg7aaNShc6h
        BUvaA1JA==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7ByS-00C4yP-Et; Sat, 24 Jul 2021 07:21:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 04/24] ch: consolidate compat ioctl handling
Date:   Sat, 24 Jul 2021 09:20:13 +0200
Message-Id: <20210724072033.1284840-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
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

