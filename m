Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F58C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 03:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1044C60FC2
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 03:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhJIDFP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 23:05:15 -0400
Received: from smtp181.sjtu.edu.cn ([202.120.2.181]:42972 "EHLO
        smtp181.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhJIDFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 23:05:14 -0400
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp181.sjtu.edu.cn (Postfix) with ESMTPS id C3FF11008B38A;
        Sat,  9 Oct 2021 11:03:15 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id AE0B9200C082A;
        Sat,  9 Oct 2021 11:03:15 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ceEVCXZTXeQJ; Sat,  9 Oct 2021 11:03:15 +0800 (CST)
Received: from guozhi-ipads.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 202E0200C02C2;
        Sat,  9 Oct 2021 11:03:00 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi scsi_transport_iscsi.c: fix misuse of %llu in scsi_transport_iscsi.c
Date:   Sat,  9 Oct 2021 11:02:54 +0800
Message-Id: <20211009030254.205714-1-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pointers should be printed with %p or %px rather than
cast to (unsigned long long) and printed with %llu.
Change %llu to %p to print the pointer into sysfs.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 922e4c7bd88e..7d6a570ebf48 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -129,8 +129,8 @@ show_transport_handle(struct device *dev, struct device_attribute *attr,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	return sysfs_emit(buf, "%llu\n",
-		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
+	return sysfs_emit(buf, "%p\n",
+		iscsi_ptr(priv->iscsi_transport));
 }
 static DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
 
-- 
2.33.0

