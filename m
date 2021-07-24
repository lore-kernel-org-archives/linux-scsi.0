Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97AFC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF2160E91
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhGXGm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbhGXGm3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:42:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4513C061575;
        Sat, 24 Jul 2021 00:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YfBxH8I8lqKoGMQnJBdhLg1NEJoFazTlCZ5JGHA0+0Y=; b=NOpoNcEBdeti6Q/yoC2pA1OpsM
        wJlyp/3P2WozIQYWUL0rr3EFvTZUjDIYgymmg0OC8jdbtnYeM7B/V9EiD2xgnFLofit+TgYisMLjC
        na/AKNEH7la3CHzzePA05/cVSWIemxsSKej4CoObCd5sYe8/e723uXCGo4Pcg+5/kY0Cxswd6n5l7
        x1SpMQcLj0c37GZjWEEBksIzLmtCm86LZ2kNbiXKfx/TgZhP4eeD1vWIDC79A3w7TbH0PrKxCO6TA
        KnFPgY3WCuB/elYuSbcu/YURMn5dM+C+T6JNeN7IvyrZtBaR1QUVeMDap8QYtkBEdwOL80ZdanJ15
        IOj3vDhg==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7BzD-00C52g-4k; Sat, 24 Jul 2021 07:22:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 06/24] scsi: remove scsi_compat_ioctl
Date:   Sat, 24 Jul 2021 09:20:15 +0200
Message-Id: <20210724072033.1284840-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just handle the compat case in scsi_ioctl using in_compat_syscall().

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c         |  2 --
 drivers/scsi/scsi_ioctl.c | 60 +++++++++++++--------------------------
 drivers/scsi/sd.c         |  2 --
 drivers/scsi/sg.c         |  3 --
 drivers/scsi/sr.c         |  5 +---
 drivers/scsi/st.c         |  2 +-
 include/scsi/scsi_ioctl.h |  1 -
 7 files changed, 22 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index e89f226cae5c..87df8cd880e0 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -877,8 +877,6 @@ static long ch_ioctl(struct file *file,
 	}
 
 	default:
-		if (in_compat_syscall())
-			return scsi_compat_ioctl(ch->device, cmd, argp);
 		return scsi_ioctl(ch->device, cmd, argp);
 
 	}
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 0d13610cd6bf..7b2e3cc85e66 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -189,8 +189,17 @@ static int scsi_ioctl_get_pci(struct scsi_device *sdev, void __user *arg)
 		? -EFAULT: 0;
 }
 
-
-static int scsi_ioctl_common(struct scsi_device *sdev, int cmd, void __user *arg)
+/**
+ * scsi_ioctl - Dispatch ioctl to scsi device
+ * @sdev: scsi device receiving ioctl
+ * @cmd: which ioctl is it
+ * @arg: data associated with ioctl
+ *
+ * Description: The scsi_ioctl() function differs from most ioctls in that it
+ * does not take a major/minor number as the dev field.  Rather, it takes
+ * a pointer to a &struct scsi_device.
+ */
+int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	char scsi_cmd[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sense_hdr;
@@ -258,48 +267,19 @@ static int scsi_ioctl_common(struct scsi_device *sdev, int cmd, void __user *arg
 	case SG_SCSI_RESET:
 		return scsi_ioctl_reset(sdev, arg);
 	}
-	return -ENOIOCTLCMD;
-}
-
-/**
- * scsi_ioctl - Dispatch ioctl to scsi device
- * @sdev: scsi device receiving ioctl
- * @cmd: which ioctl is it
- * @arg: data associated with ioctl
- *
- * Description: The scsi_ioctl() function differs from most ioctls in that it
- * does not take a major/minor number as the dev field.  Rather, it takes
- * a pointer to a &struct scsi_device.
- */
-int scsi_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
-{
-	int ret = scsi_ioctl_common(sdev, cmd, arg);
-
-	if (ret != -ENOIOCTLCMD)
-		return ret;
-
-	if (sdev->host->hostt->ioctl)
-		return sdev->host->hostt->ioctl(sdev, cmd, arg);
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL(scsi_ioctl);
 
 #ifdef CONFIG_COMPAT
-int scsi_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
-{
-	int ret = scsi_ioctl_common(sdev, cmd, arg);
-
-	if (ret != -ENOIOCTLCMD)
-		return ret;
-
-	if (sdev->host->hostt->compat_ioctl)
+	if (in_compat_syscall()) {
+		if (!sdev->host->hostt->compat_ioctl)
+			return -EINVAL;
 		return sdev->host->hostt->compat_ioctl(sdev, cmd, arg);
-
-	return ret;
-}
-EXPORT_SYMBOL(scsi_compat_ioctl);
+	}
 #endif
+	if (!sdev->host->hostt->ioctl)
+		return -EINVAL;
+	return sdev->host->hostt->ioctl(sdev, cmd, arg);
+}
+EXPORT_SYMBOL(scsi_ioctl);
 
 /*
  * We can process a reset even when a device isn't fully operable.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fc06ccb12cc..6323768e0502 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1587,8 +1587,6 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 			return error;
 	}
 
-	if (in_compat_syscall())
-		return scsi_compat_ioctl(sdp, cmd, p);
 	return scsi_ioctl(sdp, cmd, p);
 }
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0a6655bad5a4..c3562c2d0dca 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1165,9 +1165,6 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	ret = sg_ioctl_common(filp, sdp, sfp, cmd_in, p);
 	if (ret != -ENOIOCTLCMD)
 		return ret;
-
-	if (in_compat_syscall())
-		return scsi_compat_ioctl(sdp->device, cmd_in, p);
 	return scsi_ioctl(sdp->device, cmd_in, p);
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index b34f06924659..c5e163a659d2 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -584,10 +584,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			goto put;
 	}
 
-	if (in_compat_syscall())
-		ret = scsi_compat_ioctl(sdev, cmd, argp);
-	else
-		ret = scsi_ioctl(sdev, cmd, argp);
+	ret = scsi_ioctl(sdev, cmd, argp);
 
 put:
 	scsi_autopm_put_device(sdev);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c6f14540ae03..c3fee73e018e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3886,7 +3886,7 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd_in, unsigned lon
 	if (ret != -ENOTTY)
 		return ret;
 
-	return scsi_compat_ioctl(STp->device, cmd_in, p);
+	return scsi_ioctl(STp->device, cmd_in, p);
 }
 #endif
 
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
index b465799f4d2d..cdb3ba3451e7 100644
--- a/include/scsi/scsi_ioctl.h
+++ b/include/scsi/scsi_ioctl.h
@@ -44,7 +44,6 @@ typedef struct scsi_fctargaddress {
 int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
 		int cmd, bool ndelay);
 extern int scsi_ioctl(struct scsi_device *, int, void __user *);
-extern int scsi_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg);
 
 #endif /* __KERNEL__ */
 #endif /* _SCSI_IOCTL_H */
-- 
2.30.2

