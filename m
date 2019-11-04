Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87EDCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 15:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC502080F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 15:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Yb3J0HOh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfKDPly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 10:41:54 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:48190 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKDPly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 10:41:54 -0500
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 10:41:53 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=QSgtOXkbXuicNqiow0
        3N2HCq4OKg8JvV2XV+/oS6MGY=; b=Yb3J0HOhJ/bCeLf8C4bjqTA2Gpu9yt0+KN
        Lrz/Xk7s/MHO+9u+2jwRqAwZWSZ+D3GbqgoKvQcdbG5REtAw0or8muTWO2amiL9e
        xVfwqtMu1x5b4Ok1xd+DFd8TQ6WNC2H+nvQPUohW2824loKckjhaZvjqt5EqWm7s
        MId5r8yeI=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp4 (Coremail) with SMTP id HNxpCgAXyXInQ8BdlN5RBA--.46S3;
        Mon, 04 Nov 2019 23:26:35 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] scsi: fnic: fix use after free
Date:   Mon,  4 Nov 2019 23:26:22 +0800
Message-Id: <1572881182-37664-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: HNxpCgAXyXInQ8BdlN5RBA--.46S3
X-Coremail-Antispam: 1Uf129KBjvdXoWruF47tF4UAF4UXw17GrW7Arb_yoWDAwbE9r
        WrtrZFkry5Krs3Gw12vw4rAFWS9aykXrn2kF10gw1ay3yUZrZrAwnFvrn5JryUWw47urZx
        trsxJr1SkF1UJjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjCeHPUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiVB9jclUMK9ogvAABsv
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The memory chunk io_req is released by mempool_free. Accessing
io_req->start_time will result in a use after free bug. Thevariable
start_time is a backup of the timestamp. So, use start_time here to
avoid use after free.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 80608b53897b..d3986a25d9c2 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1024,7 +1024,8 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 
-	io_duration_time = jiffies_to_msecs(jiffies) - jiffies_to_msecs(io_req->start_time);
+	io_duration_time = jiffies_to_msecs(jiffies) -
+						jiffies_to_msecs(start_time);
 
 	if(io_duration_time <= 10)
 		atomic64_inc(&fnic_stats->io_stats.io_btw_0_to_10_msec);
-- 
2.7.4

