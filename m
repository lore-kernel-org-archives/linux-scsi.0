Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BC7C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D99060E96
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhGXGwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhGXGwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:52:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF9EC061575;
        Sat, 24 Jul 2021 00:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Ud73Xpsv5Lfzshj5+YozwC/cI4eDG/Y1VxhRLmCSMAA=; b=cQOuLLOQOJFl7Vz20VutJhT2tp
        QZ16BuchRizDGaMZ4guiPLAZj5wHJUpP4mmhFMqt+5UU6shCw7bcwrxg8iGZcA7fP1dxu5I+h20+i
        nBsxy05xLnEJ+zk3DhCCQa1ZVbp8NG6VDxx1NQdYk3pie1E23ROc5omEe72xNx/e7xsR7MN+DKQf2
        2gpqHJdnPp2eplyuKlEzbmAfHg7i9coOWHCzp42eET80NNs2CHpminmiWT9UQSPLWwZZDlYeYrhhp
        SBgZ7lfwhS485cX345jdVCweb3cto+UwcpckRALW+b+tqAN4nbTor2A0sv5DNKYojluIjvYwFasck
        2TDUt61A==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C97-00C5an-KW; Sat, 24 Jul 2021 07:32:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 22/24] scsi: factor SCSI_IOCTL_GET_IDLUN handling into a helper
Date:   Sat, 24 Jul 2021 09:20:31 +0200
Message-Id: <20210724072033.1284840-23-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split the SCSI_IOCTL_GET_IDLUN handler from the main scsi_ioctl routine.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 31136e2bd21d..98a529131084 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -218,6 +218,20 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
+static int scsi_get_idlun(struct scsi_device *sdev, void __user *argp)
+{
+	struct scsi_idlun v = {
+		.dev_id = (sdev->id & 0xff) +
+			((sdev->lun & 0xff) << 8) +
+			((sdev->channel & 0xff) << 16) +
+			((sdev->host->host_no & 0xff) << 24),
+		.host_unique_id = sdev->host->unique_id
+	};
+	if (copy_to_user(argp, &v, sizeof(struct scsi_idlun)))
+		return -EFAULT;
+	return 0;
+}
+
 static int scsi_send_start_stop(struct scsi_device *sdev, int data)
 {
 	u8 cdb[MAX_COMMAND_SIZE] = { };
@@ -921,18 +935,8 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 		return scsi_send_start_stop(sdev, 3);
 	case CDROMEJECT:
 		return scsi_send_start_stop(sdev, 2);
-	case SCSI_IOCTL_GET_IDLUN: {
-		struct scsi_idlun v = {
-			.dev_id = (sdev->id & 0xff)
-				 + ((sdev->lun & 0xff) << 8)
-				 + ((sdev->channel & 0xff) << 16)
-				 + ((sdev->host->host_no & 0xff) << 24),
-			.host_unique_id = sdev->host->unique_id
-		};
-		if (copy_to_user(arg, &v, sizeof(struct scsi_idlun)))
-			return -EFAULT;
-		return 0;
-	}
+	case SCSI_IOCTL_GET_IDLUN:
+		return scsi_get_idlun(sdev, arg);
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		return put_user(sdev->host->host_no, (int __user *)arg);
 	case SCSI_IOCTL_PROBE_HOST:
-- 
2.30.2

