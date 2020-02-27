Return-Path: <SRS0=MD5Y=4P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E226C35677
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE1F2469F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Feb 2020 17:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgB0RAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Feb 2020 12:00:03 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47330 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729855AbgB0RAD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Feb 2020 12:00:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9219920418E;
        Thu, 27 Feb 2020 18:00:01 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gzz5W-3UqkVw; Thu, 27 Feb 2020 17:59:59 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 6741A20416A;
        Thu, 27 Feb 2020 17:59:52 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v7 37/38] sg: warn v3 write system call users
Date:   Thu, 27 Feb 2020 11:59:01 -0500
Message-Id: <20200227165902.11861-38-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227165902.11861-1-dgilbert@interlog.com>
References: <20200227165902.11861-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
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

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 18066aabd195..24c4a539eae0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -646,6 +646,10 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 				     __func__);
 			return -EPERM;
 		}
+		WARN_ONCE(true, "Please use %s instead of write(),\n%s\n",
+			  "ioctl(SG_SUBMIT_V3)",
+			  "  See: http://sg.danny.cz/sg/sg_v40.html");
+
 		res = sg_v3_submit(filp, sfp, h3p, false, NULL);
 		return res < 0 ? res : (int)count;
 	}
-- 
2.25.1

