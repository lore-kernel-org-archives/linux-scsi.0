Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE8AECE58E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F8421A49
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440088AbfJQTjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:39:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45074 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437851AbfJQTjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:39:46 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBce-0006fk-Et; Thu, 17 Oct 2019 19:39:44 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-scsi@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 8/8] SG_IO: get rid of access_ok()
Date:   Thu, 17 Oct 2019 20:39:25 +0100
Message-Id: <20191017193925.25539-8-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017193925.25539-1-viro@ZenIV.linux.org.uk>
References: <20191017193659.GA18702@ZenIV.linux.org.uk>
 <20191017193925.25539-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

simply not needed there - neither sg_new_read() nor sg_new_write() need
it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/sg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f3d090b93cdf..0940abd91d3c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -896,8 +896,6 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
-		if (!access_ok(p, SZ_SG_IO_HDR))
-			return -EFAULT;
 		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
 				 1, read_only, 1, &srp);
 		if (result < 0)
-- 
2.11.0

