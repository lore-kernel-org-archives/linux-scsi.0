Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1A2C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 09:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525A42065E
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 09:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="e8/u2cnL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgHIJzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Aug 2020 05:55:22 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:33270 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbgHIJzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Aug 2020 05:55:21 -0400
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A552F2E148C;
        Sun,  9 Aug 2020 12:55:17 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id n4xIVkYFrT-tGwaAA4Z;
        Sun, 09 Aug 2020 12:55:17 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596966917; bh=E8e4oWgiV1+dwdEtUwikqO1aLyiC9ELfVoNgv/deRlw=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=e8/u2cnLG/CXeaCG6Ld2vPogpmbRd+hJ4m3yFBrQogDycI0EaWohpldpUWds4CXRa
         P4Y0rhQ3+F+0WpkOVyP6F4BIOwo5aWcSmtkB6NmVYs+OjKQMhTJ343xRdp2vL6YZCw
         NHdUXu7If2IZKt8/VKGoWDIDzYUmwfCsgbZqEHAo=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 95.108.174.193-red.dhcp.yndx.net (95.108.174.193-red.dhcp.yndx.net [95.108.174.193])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id EZfCPIauMW-tGmOrI3v;
        Sun, 09 Aug 2020 12:55:16 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
To:     linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, jejb@linux.ibm.com,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Subject: [PATCH] scsi_debugfs: dump allocted field in more convenient format
Date:   Sun,  9 Aug 2020 09:55:01 +0000
Message-Id: <20200809095501.23166-1-dmtrmonakhov@yandex-team.ru>
X-Mailer: git-send-email 2.18.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All request's data fields are formatted as key=val, the only exception is
allocated field, which complicates parsing.

With that patch request looks like follows:
0000000012a51451 {.op=WRITE, .cmd_flags=SYNC|IDLE, .rq_flags=STARTED|DONTPREP|ELVPRIV|IO_STAT, .state=in_flight, .tag=137, .internal_tag=188, .cmd=opcode=0x2a 2a 00 00 00 45 18 00 00 08 00, .retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=30.000, .alloc_age=0.004}

Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
---
 drivers/scsi/scsi_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index c19ea7a..6ce22b1 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -45,7 +45,7 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 		   cmd->retries, cmd->result);
 	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
 			ARRAY_SIZE(scsi_cmd_flags));
-	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
+	seq_printf(m, ", .timeout=%d.%03d, .alloc_age=%d.%03d",
 		   timeout_ms / 1000, timeout_ms % 1000,
 		   alloc_ms / 1000, alloc_ms % 1000);
 }
-- 
2.7.4

