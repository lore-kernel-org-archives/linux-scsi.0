Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D12C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJXDZi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiJXDXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:03 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C848032EF9
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 3EE262041BD;
        Mon, 24 Oct 2022 05:21:55 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NWGSnYuvtYNt; Mon, 24 Oct 2022 05:21:55 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 13EBC2041AF;
        Mon, 24 Oct 2022 05:21:53 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 36/44] sg: warn v3 write system call users
Date:   Sun, 23 Oct 2022 23:20:50 -0400
Message-Id: <20221024032058.14077-37-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Should generate one log message per kernel run when the write()
system call is used with the sg interface version 3. Due to
security concerns suggest that they use ioctl(SG_SUBMIT_v3)
instead.

Sg interface version 1 or 2 based code may also be calling
write() in this context. There is no easy solution for them
(short of upgrading their interface to version 3 or 4), so
don't produce a warning suggesting the conversion will be
simple.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef83f2097c73..c9eb9e842f9e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -644,6 +644,9 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 				     __func__);
 			return -EPERM;
 		}
+		pr_warn_once("Please use %s instead of write(),\n%s\n",
+			     "ioctl(SG_SUBMIT_V3)",
+			     "  See: https://sg.danny.cz/sg/sg_v40.html");
 		res = sg_v3_submit(filp, sfp, h3p, false, NULL);
 		return res < 0 ? res : (int)count;
 	}
-- 
2.37.3

