Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222D7C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 02:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C65A223600
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jan 2021 02:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbhANCfT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 21:35:19 -0500
Received: from smtp.infotech.no ([82.134.31.41]:50802 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbhANCfR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Jan 2021 21:35:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 99F182042C1;
        Wed, 13 Jan 2021 23:46:18 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AjtB2U0F5IhU; Wed, 13 Jan 2021 23:46:17 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 1F6B52042BE;
        Wed, 13 Jan 2021 23:46:16 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        kashyap.desai@broadcom.com
Subject: [PATCH v13 38/45] sg: warn v3 write system call users
Date:   Wed, 13 Jan 2021 17:45:19 -0500
Message-Id: <20210113224526.861000-39-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113224526.861000-1-dgilbert@interlog.com>
References: <20210113224526.861000-1-dgilbert@interlog.com>
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
index 6b81e4ba7054..c5533bbaf0d5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -645,6 +645,9 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 				     __func__);
 			return -EPERM;
 		}
+		pr_warn_once("Please use %s instead of write(),\n%s\n",
+			     "ioctl(SG_SUBMIT_V3)",
+			     "  See: http://sg.danny.cz/sg/sg_v40.html");
 		res = sg_v3_submit(filp, sfp, h3p, false, NULL);
 		return res < 0 ? res : (int)count;
 	}
-- 
2.25.1

