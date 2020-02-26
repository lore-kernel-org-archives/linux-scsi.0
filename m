Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDB6C4BA18
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E967820838
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 17:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgBZRUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:20:30 -0500
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:51257 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbgBZRUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 12:20:30 -0500
Received: from MTA-09-4.privateemail.com (mta-09.privateemail.com [198.54.127.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id B08E180BF2;
        Wed, 26 Feb 2020 12:06:12 -0500 (EST)
Received: from MTA-09.privateemail.com (localhost [127.0.0.1])
        by MTA-09.privateemail.com (Postfix) with ESMTP id AE22C60041;
        Wed, 26 Feb 2020 12:06:01 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.236])
        by MTA-09.privateemail.com (Postfix) with ESMTPA id B388E6005F;
        Wed, 26 Feb 2020 17:05:56 +0000 (UTC)
From:   Ryan Attard <ryanattard@ryanattard.info>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     ryanattard@ryanattard.info, axboe@kernel.dk, dgilbert@interlog.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Subject: [PATCH 1/1 RESEND] Allow non-root users to perform ZBC commands.
Date:   Wed, 26 Feb 2020 11:05:19 -0600
Message-Id: <20200226170518.92963-2-ryanattard@ryanattard.info>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226170518.92963-1-ryanattard@ryanattard.info>
References: <20200226170518.92963-1-ryanattard@ryanattard.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow users with read permissions to issue REPORT ZONE commands and
users with write permissions to manage zones on block devices supporting
the ZBC specification.

Signed-off-by: Ryan Attard <ryanattard@ryanattard.info>
---
 block/scsi_ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b4e73d5dd5c2..ef722f04f88a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -193,6 +193,10 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
 	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
+
+	/* ZBC Commands */
+	__set_bit(ZBC_OUT, filter->write_ok);
+	__set_bit(ZBC_IN, filter->read_ok);
 }
 
 int blk_verify_command(unsigned char *cmd, fmode_t mode)
-- 
2.24.1

