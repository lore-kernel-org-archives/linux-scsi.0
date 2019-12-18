Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE4CC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 16:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E4B218AC
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 16:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLRQvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 11:51:49 -0500
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:48311 "EHLO
        h4.fbrelay.privateemail.com." rhost-flags-OK-OK-FAIL-FAIL)
        by vger.kernel.org with ESMTP id S1726955AbfLRQvs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Dec 2019 11:51:48 -0500
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2019 11:51:48 EST
Received: from MTA-06-3.privateemail.com (mta-06.privateemail.com [68.65.122.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 312D3807B9
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 11:40:37 -0500 (EST)
Received: from MTA-06.privateemail.com (localhost [127.0.0.1])
        by MTA-06.privateemail.com (Postfix) with ESMTP id 6946F6004D;
        Wed, 18 Dec 2019 11:40:36 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.206])
        by MTA-06.privateemail.com (Postfix) with ESMTPA id 76AA860043;
        Wed, 18 Dec 2019 16:40:35 +0000 (UTC)
From:   rattard@ryanattard.info
To:     axboe@kernel.dk, linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        JBottomley@parallels.com
Cc:     Ryan Attard <ryanattard@ryanattard.info>
Subject: [PATCH 1/1] Allow non-root users to perform ZBC commands.
Date:   Wed, 18 Dec 2019 10:40:09 -0600
Message-Id: <20191218164008.99155-2-rattard@ryanattard.info>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191218164008.99155-1-rattard@ryanattard.info>
References: <20191218164008.99155-1-rattard@ryanattard.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ryan Attard <ryanattard@ryanattard.info>

Allow users with read permissions to issue REPORT ZONE commands and
users with write permissions to manage zones on devices supporting the
ZBC specification.

Signed-off-by: Ryan Attard <ryanattard@ryanattard.info>
---
 block/scsi_ioctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 260fa80ef575..005a84b2ecdb 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -194,6 +194,11 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
 	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
+
+	/* ZBC Commands */
+	__set_bit(ZBC_OUT, filter->write_ok);
+	__set_bit(ZBC_IN, filter->read_ok);
+
 }
 
 int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
-- 
2.24.0

