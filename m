Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EE7C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A2E610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhGLGAU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 02:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhGLGAU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 02:00:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB16C0613DD;
        Sun, 11 Jul 2021 22:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=w3IYqz575tRQLRh9Gha/TFE54Xi5FhxKTStfDOfe7Bc=; b=tvrS4otZExn9yy3wJRG2IROS5E
        nC9MPeb3JA0PTZatCigXMl+answ7rQmy4QLnpNOLEEaYPRsKgezybcE+VAw5C50ku17lWf3WrZKkv
        xQiEBi8VVJq6dICdGKzPnNGBVO82ZL9pTCh2UPfA2OoQBeQIiK2gh20cytbZZTCMJma7N29jJeRY1
        Bu5qNLrNOGQ02WGe+UpdadQ5uHyCRAdgUyyVkErUfVhDoO+DaX8NoE21HgWQRUL6N3ylrMmeWKuAO
        O5LQ3828XyLJaKM9NdCTySCXu+6apmp4Ju92T2Dte+AJKE3yQSkM+c9+ABz4/d5IU4MljxrBOCsAs
        avpelCJg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ovu-00GvY7-Jk; Mon, 12 Jul 2021 05:56:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 21/24] scsi: consolidate the START STOP UNIT handling
Date:   Mon, 12 Jul 2021 07:48:13 +0200
Message-Id: <20210712054816.4147559-22-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out a helper for the various flavors of START STOP UNIT
command ioctls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 48 ++++++++-------------------------------
 1 file changed, 10 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 3d4311a78383..f6f16edecc67 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -218,31 +218,14 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
-/* Send basic block requests */
-static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
-			      int cmd, int data)
+static int scsi_send_start_stop(struct scsi_device *sdev, int data)
 {
-	struct request *rq;
-	int err;
-
-	rq = blk_get_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(rq))
-		return PTR_ERR(rq);
-	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
-	scsi_req(rq)->cmd[0] = cmd;
-	scsi_req(rq)->cmd[4] = data;
-	scsi_req(rq)->cmd_len = 6;
-	blk_execute_rq(bd_disk, rq, 0);
-	err = scsi_req(rq)->result ? -EIO : 0;
-	blk_put_request(rq);
+	char cdb[MAX_COMMAND_SIZE] = { };
 
-	return err;
-}
-
-static inline int blk_send_start_stop(struct request_queue *q,
-				      struct gendisk *bd_disk, int data)
-{
-	return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);
+	cdb[0] = START_STOP;
+	cdb[4] = data;
+	return ioctl_internal_command(sdev, cdb, START_STOP_TIMEOUT,
+				      NORMAL_RETRIES);
 }
 
 bool scsi_cmd_allowed(unsigned char *cmd, fmode_t mode)
@@ -877,7 +860,6 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 		int cmd, void __user *arg)
 {
 	struct request_queue *q = sdev->request_queue;
-	char scsi_cmd[MAX_COMMAND_SIZE];
 	struct scsi_sense_hdr sense_hdr;
 	int error;
 
@@ -930,9 +912,9 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 	case CDROM_SEND_PACKET:
 		return scsi_cdrom_send_packet(q, disk, mode, arg);
 	case CDROMCLOSETRAY:
-		return blk_send_start_stop(q, disk, 0x03);
+		return scsi_send_start_stop(sdev, 3);
 	case CDROMEJECT:
-		return blk_send_start_stop(q, disk, 0x02);
+		return scsi_send_start_stop(sdev, 2);
 	case SCSI_IOCTL_GET_IDLUN: {
 		struct scsi_idlun v = {
 			.dev_id = (sdev->id & 0xff)
@@ -957,19 +939,9 @@ int scsi_ioctl(struct scsi_device *sdev, struct gendisk *disk, fmode_t mode,
 		return scsi_test_unit_ready(sdev, IOCTL_NORMAL_TIMEOUT,
 					    NORMAL_RETRIES, &sense_hdr);
 	case SCSI_IOCTL_START_UNIT:
-		scsi_cmd[0] = START_STOP;
-		scsi_cmd[1] = 0;
-		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
-		scsi_cmd[4] = 1;
-		return ioctl_internal_command(sdev, scsi_cmd,
-				     START_STOP_TIMEOUT, NORMAL_RETRIES);
+		return scsi_send_start_stop(sdev, 1);
 	case SCSI_IOCTL_STOP_UNIT:
-		scsi_cmd[0] = START_STOP;
-		scsi_cmd[1] = 0;
-		scsi_cmd[2] = scsi_cmd[3] = scsi_cmd[5] = 0;
-		scsi_cmd[4] = 0;
-		return ioctl_internal_command(sdev, scsi_cmd,
-				     START_STOP_TIMEOUT, NORMAL_RETRIES);
+		return scsi_send_start_stop(sdev, 0);
         case SCSI_IOCTL_GET_PCI:
                 return scsi_ioctl_get_pci(sdev, arg);
 	case SG_SCSI_RESET:
-- 
2.30.2

