Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C60C77B73
	for <linux-scsi@archiver.kernel.org>; Sat, 27 May 2023 18:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjE0SGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 May 2023 14:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjE0SGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 May 2023 14:06:52 -0400
Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1A1D2
        for <linux-scsi@vger.kernel.org>; Sat, 27 May 2023 11:06:45 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id 2yJMqqEHp8aX92yJMqPEHz; Sat, 27 May 2023 20:06:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1685210804;
        bh=LJo0suhqS2HfE3uE26k/aOFLowEtiIxwmm1VGEPy9mU=;
        h=From:To:Cc:Subject:Date;
        b=GtlK9/SBhQJvW/RLCYpHPWPXzFqNL8XuXBBiKHP1H2vkKfA31txL/BLtCSyJRT8ej
         rmFEyhSfEvKEj/UcNlGPKmndDT/d9FXM+wWhqdYDrdzIZeOCkVwnJxbrENX0ZdlD9r
         ZXI4ERzvBEAWEhF9mFAYelsTMSf9w8G3kWLGa0NAcHtisIQEnDD/zFSgUzBz7QMifd
         aeGM16vRAZeeCYQ6zyPe5c5CaqI47wjWFWtOKhzSGZNvWueBZcPnE/j9h/0W28EaeN
         VCP+RAPPolitHxKpjtxiQOReUwU9YzoEGZQVHoJ1BaaX7am+g13Tn7iQl+NKZ/YUea
         W9CKSq0eZ8VkQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 27 May 2023 20:06:44 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: fnic: Use vzalloc()
Date:   Sat, 27 May 2023 20:06:37 +0200
Message-Id: <a1179941a6d440140513e681f4f3a1b92c8d83ae.1685210773.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use vzalloc() instead of hand writing it with vmalloc()+memset().
This is less verbose.

This also fixes some style issues :)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/fnic/fnic_debugfs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 6fedc3b7d1ab..c4d9ed0d7d75 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -201,25 +201,21 @@ static int fnic_trace_debugfs_open(struct inode *inode,
 		return -ENOMEM;
 
 	if (*rdata_ptr == fc_trc_flag->fnic_trace) {
-		fnic_dbg_prt->buffer = vmalloc(array3_size(3, trace_max_pages,
+		fnic_dbg_prt->buffer = vzalloc(array3_size(3, trace_max_pages,
 							   PAGE_SIZE));
 		if (!fnic_dbg_prt->buffer) {
 			kfree(fnic_dbg_prt);
 			return -ENOMEM;
 		}
-		memset((void *)fnic_dbg_prt->buffer, 0,
-		3 * (trace_max_pages * PAGE_SIZE));
 		fnic_dbg_prt->buffer_len = fnic_get_trace_data(fnic_dbg_prt);
 	} else {
 		fnic_dbg_prt->buffer =
-			vmalloc(array3_size(3, fnic_fc_trace_max_pages,
+			vzalloc(array3_size(3, fnic_fc_trace_max_pages,
 					    PAGE_SIZE));
 		if (!fnic_dbg_prt->buffer) {
 			kfree(fnic_dbg_prt);
 			return -ENOMEM;
 		}
-		memset((void *)fnic_dbg_prt->buffer, 0,
-			3 * (fnic_fc_trace_max_pages * PAGE_SIZE));
 		fnic_dbg_prt->buffer_len =
 			fnic_fc_trace_get_data(fnic_dbg_prt, *rdata_ptr);
 	}
-- 
2.34.1

