Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70896C4727D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C96020639
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kbck9aS+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgJEIll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F43C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tkBBgKCgCj4gIGCF/h0WCFwxiDkDI8aZTONywexT79U=; b=Kbck9aS+gTv98sJN/e9ZwzaGJw
        UIo1kOYYv0LhQ0m0jeX8bxjDaevcyzsqsR+DeOX3bEWyM3Tz18pVJkhxdGb/JhNY7C9QpQdeUxBo2
        zusG/TpEwjvwxKzAWfBmX+aex+tJac6DC+9hEGhd6ObX2f1iki4j0Y3XJktL3J4sylF22bNw+PA6S
        j8ka3CghohypDoSJRgc5gEoZHH2Sr0phs/EuA/kipPWeNcLiMmyqUe5+QMPTZBGAfnu7RXJQbhON7
        U7uqUtBDjZ5N+QIJa42KJGKS4If/yVoybVrYkanRAaTMgOqdaG0Rtn19Q0Co2u5mkPRRRuekCT8l2
        9utuIGkw==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3v-0000mU-SH; Mon, 05 Oct 2020 08:41:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 06/10] scsi: rename scsi_prep_state_check to scsi_device_state_check
Date:   Mon,  5 Oct 2020 10:41:26 +0200
Message-Id: <20201005084130.143273-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The old name is rather confusing now that the the legacy prep_fn is gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 670ad06812b419..3940641052f90b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1214,7 +1214,7 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 }
 
 static blk_status_t
-scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
+scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 {
 	switch (sdev->sdev_state) {
 	case SDEV_OFFLINE:
@@ -1653,7 +1653,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * commands.
 	 */
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
-		ret = scsi_prep_state_check(sdev, req);
+		ret = scsi_device_state_check(sdev, req);
 		if (ret != BLK_STS_OK)
 			goto out_put_budget;
 	}
-- 
2.28.0

