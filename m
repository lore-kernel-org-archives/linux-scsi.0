Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30740C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C288E2064C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OVfRWjaS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJEIlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgJEIlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2ACC0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=I+DmUprP4lyg/Mc50Hm6QFJUmH5nd0zGgX6GeT4Ag9U=; b=OVfRWjaSKwrwragCnth2IuNstu
        RiuEnJwYAco84zPhz84KBWDJW6WimYlWJvFcAlvORzEN5abULldm9Rdy30UPFoeljPJ2fN2zqPqmN
        Tid/mNLiR0H/l/rI5h9T8zpwmriCaUOtxhsfoDP+fhIDwzhgKFBfrRXZQNHNl4dobYgkBwltaKp7d
        drJ9t7+Pz7QQL8efY+PUFNHZaPr0kWsnEniiMZHnAseoOUcBO619odbcInyEPp8EE9FrQcHV58E8N
        C7phpw13gu1W13NcvvFqlVaLIfHv+cykKmWd6F/9K77pLHNnsXc3THNjd/UIYx0y8L0omyoPyegJD
        45LmryqQ==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3q-0000lW-8C; Mon, 05 Oct 2020 08:41:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 02/10] scsi: remove scsi_init_cmd_errh
Date:   Mon,  5 Oct 2020 10:41:22 +0200
Message-Id: <20201005084130.143273-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no good reason to keep this functionality as a separate
function, just merge it into the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b95e00ff346b09..8a7ae46b5943da 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -293,21 +293,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 }
 EXPORT_SYMBOL(__scsi_execute);
 
-/**
- * scsi_init_cmd_errh - Initialize cmd fields related to error handling.
- * @cmd:  command that is ready to be queued.
- *
- * This function has the job of initializing a number of fields related to error
- * handling. Typically this will be called once for each command, as required.
- */
-static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
-{
-	scsi_set_resid(cmd, 0);
-	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	if (cmd->cmd_len == 0)
-		cmd->cmd_len = scsi_command_size(cmd->cmnd);
-}
-
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
  * handler is not woken up if host in-flight requests number ==
@@ -1698,7 +1683,10 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (bd->last)
 		cmd->flags |= SCMD_LAST;
 
-	scsi_init_cmd_errh(cmd);
+	scsi_set_resid(cmd, 0);
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
+	if (cmd->cmd_len == 0)
+		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 	cmd->scsi_done = scsi_mq_done;
 
 	reason = scsi_dispatch_cmd(cmd);
-- 
2.28.0

