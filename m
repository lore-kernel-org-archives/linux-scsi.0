Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7636BC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53AF160E93
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhGXGmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbhGXGmp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:42:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B74C061575;
        Sat, 24 Jul 2021 00:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fIp02btCq11Nrj00v1d9+1I27UV0UwMXTNQS/y1V4cA=; b=gbtDa8d39utsS6Y/LY6MBf4YiP
        CkWvWAjSlHKmtswws1va2E03x4ZIJidDSC5rM5At6Du8EIQqFLDsc3K2BoKblpDnB4vZbEnngor3j
        sOtfCXjfJRO0c9Lnr6uTo4ESFbE2rKxIF5CBiGqhrwim6DTd2FVSrcybP01wfk9k+j90IbaP+DHuE
        2vL/u/WVJfEcfnQv2xvBxjwHYxorbIEpULydePv6Dus2urkZ1TmCQwwW3QcNJaPfpMOdG5F+De/mI
        Vp0sL/rKnsyIzU82hYrpm/2TaCbNPUkvZXNdWTwy0ThVsPeImbDvJGxw3WNs6PaKL5kE+aCyvFDHY
        CoZC7Vsg==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7Bzf-00C54T-Br; Sat, 24 Jul 2021 07:22:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 07/24] st: simplify ioctl handling
Date:   Sat, 24 Jul 2021 09:20:16 +0200
Message-Id: <20210724072033.1284840-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Merge st_ioctl_common into st_ioctl and streamline the invocation
of the common ioctl helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/st.c | 78 ++++++++++++++++++-----------------------------
 1 file changed, 29 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c3fee73e018e..9274f665bc0f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3499,8 +3499,9 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 
 /* The ioctl command */
-static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user *p)
+static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
+	void __user *p = (void __user *)arg;
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
 	unsigned int blk;
@@ -3820,73 +3821,52 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
 		goto out;
 	}
 	mutex_unlock(&STp->lock);
+
 	switch (cmd_in) {
-		case SCSI_IOCTL_STOP_UNIT:
-			/* unload */
-			retval = scsi_ioctl(STp->device, cmd_in, p);
-			if (!retval) {
-				STp->rew_at_close = 0;
-				STp->ready = ST_NO_TAPE;
-			}
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+		break;
+	case SG_IO:
+	case SCSI_IOCTL_SEND_COMMAND:
+	case CDROM_SEND_PACKET:
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		fallthrough;
+	default:
+		retval = scsi_cmd_ioctl(STp->disk->queue, STp->disk,
+					file->f_mode, cmd_in, p);
+		if (retval != -ENOTTY)
 			return retval;
+		break;
+	}
 
-		case SCSI_IOCTL_GET_IDLUN:
-		case SCSI_IOCTL_GET_BUS_NUMBER:
-			break;
-
-		default:
-			if ((cmd_in == SG_IO ||
-			     cmd_in == SCSI_IOCTL_SEND_COMMAND ||
-			     cmd_in == CDROM_SEND_PACKET) &&
-			    !capable(CAP_SYS_RAWIO))
-				i = -EPERM;
-			else
-				i = scsi_cmd_ioctl(STp->disk->queue, STp->disk,
-						   file->f_mode, cmd_in, p);
-			if (i != -ENOTTY)
-				return i;
-			break;
+	retval = scsi_ioctl(STp->device, cmd_in, p);
+	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
+		/* unload */
+		STp->rew_at_close = 0;
+		STp->ready = ST_NO_TAPE;
 	}
-	return -ENOTTY;
+	return retval;
 
  out:
 	mutex_unlock(&STp->lock);
 	return retval;
 }
 
-static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
-{
-	void __user *p = (void __user *)arg;
-	struct scsi_tape *STp = file->private_data;
-	int ret;
-
-	ret = st_ioctl_common(file, cmd_in, p);
-	if (ret != -ENOTTY)
-		return ret;
-
-	return scsi_ioctl(STp->device, cmd_in, p);
-}
-
 #ifdef CONFIG_COMPAT
 static long st_compat_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
-	void __user *p = compat_ptr(arg);
-	struct scsi_tape *STp = file->private_data;
-	int ret;
-
 	/* argument conversion is handled using put_user_mtpos/put_user_mtget */
 	switch (cmd_in) {
 	case MTIOCPOS32:
-		return st_ioctl_common(file, MTIOCPOS, p);
+		cmd_in = MTIOCPOS;
+		break;
 	case MTIOCGET32:
-		return st_ioctl_common(file, MTIOCGET, p);
+		cmd_in = MTIOCGET;
+		break;
 	}
 
-	ret = st_ioctl_common(file, cmd_in, p);
-	if (ret != -ENOTTY)
-		return ret;
-
-	return scsi_ioctl(STp->device, cmd_in, p);
+	return st_ioctl(file, cmd_in, arg);
 }
 #endif
 
-- 
2.30.2

