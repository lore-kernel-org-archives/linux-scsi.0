Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F7AC4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0422B20639
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qSTeqvxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgJEIlh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1DEC0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QYAtts78Sek2+pJOsJIZsIv3wT6qP5fShsl67p3Ykns=; b=qSTeqvxYJmu5bPRR6FTzO1KtBo
        IXoVJ/QNVTH16j9NFBxCJrdFj1nbrA4SyneLYERZBYBnWZoBeqBBKEunse2ND5NfdpFwP2H604RDa
        SMkcEN4PTyEbWHmKhqNCMfwpgCYLj3UpwltJNHHgmMQS72JfPwwFSTT2lmKxSVeBao/ZsVGkuYUXB
        WwDloAhlbzIpWJTeUxPo+zDaVlZM1k881T8lVY1ggrose0bS4NUxbL8i6hdO8WYcJR5qIKdJSxNl2
        bSyy7LmuDdWeKJL5DzVLxvcyNAV5O1+HuZ/uIf9mpbPWEs3W1JQCoiihFaCeSPYe5EtBEHjLKBvhm
        k6UKCvwQ==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3r-0000lc-KB; Mon, 05 Oct 2020 08:41:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 03/10] scsi: move command size detection out of the fast path
Date:   Mon,  5 Oct 2020 10:41:23 +0200
Message-Id: <20201005084130.143273-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We only need to detect the command size for ioctl request from userspace,
which is limited to the passthrough path.  Move the check there instead
of doing it for all queuecommand invocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8a7ae46b5943da..3c551f06ebe9be 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1166,6 +1166,8 @@ static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
 	}
 
 	cmd->cmd_len = scsi_req(req)->cmd_len;
+	if (cmd->cmd_len == 0)
+		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = scsi_req(req)->retries;
@@ -1685,8 +1687,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	if (cmd->cmd_len == 0)
-		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 	cmd->scsi_done = scsi_mq_done;
 
 	reason = scsi_dispatch_cmd(cmd);
-- 
2.28.0

