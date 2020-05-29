Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDFD1C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 01:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B73D02078C
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 01:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438358AbgE2BQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 21:16:35 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:28492 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438324AbgE2BQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 21:16:34 -0400
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2020 21:16:33 EDT
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 9B525DCB201D2880862A;
        Fri, 29 May 2020 09:00:34 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id 04T10XuH015789;
        Fri, 29 May 2020 09:00:33 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020052909010711-3735763 ;
          Fri, 29 May 2020 09:01:07 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     linuxdrivers@attotech.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        wang.liang82@zte.com.cn, Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: [PATCH] scsi: esas2r: Replace kzalloc with kmalloc in the log message
Date:   Fri, 29 May 2020 09:02:43 +0800
Message-Id: <1590714163-15966-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-05-29 09:01:07,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-05-29 09:00:37,
        Serialize complete at 2020-05-29 09:00:37
X-MAIL: mse-fl2.zte.com.cn 04T10XuH015789
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

Use kmalloc instead of kzalloc in the log message according to
the previous kmalloc() call.

Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
---
 drivers/scsi/esas2r/esas2r_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7b49e2e..2cdc4ea 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -198,8 +198,8 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
 					      GFP_KERNEL);
 		if (a->local_atto_ioctl == NULL) {
 			esas2r_log(ESAS2R_LOG_WARN,
-				   "write_hw kzalloc failed for %zu bytes",
-				   sizeof(struct atto_ioctl));
+				   "%s kmalloc failed for %zu bytes",
+				   __func__, sizeof(struct atto_ioctl));
 			return -ENOMEM;
 		}
 	}
-- 
2.9.5

