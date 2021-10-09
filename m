Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D72C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 04:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F5C60F6B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 04:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhJIElP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 00:41:15 -0400
Received: from smtp181.sjtu.edu.cn ([202.120.2.181]:44138 "EHLO
        smtp181.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhJIElP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 00:41:15 -0400
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp181.sjtu.edu.cn (Postfix) with ESMTPS id 377B41008CBC1;
        Sat,  9 Oct 2021 12:39:15 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 1FE0B200C082D;
        Sat,  9 Oct 2021 12:39:15 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id O8Xitoy0QZnE; Sat,  9 Oct 2021 12:39:15 +0800 (CST)
Received: from guozhi-ipads.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 0808B200B8924;
        Sat,  9 Oct 2021 12:38:54 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi scsi_transport_iscsi.c: fix misuse of %llu in scsi_transport_iscsi.c
Date:   Sat,  9 Oct 2021 12:38:51 +0800
Message-Id: <20211009043851.212503-1-qtxuning1999@sjtu.edu.cn>
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
 drivers/scsi/scsi_transport_iscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 922e4c7bd88e..14050c4fdb89 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -129,8 +129,7 @@ show_transport_handle(struct device *dev, struct device_attribute *attr,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	return sysfs_emit(buf, "%llu\n",
-		  (unsigned long long)iscsi_handle(priv->iscsi_transport));
+	return sysfs_emit(buf, "%p\n", priv->iscsi_transport);
 }
 static DEVICE_ATTR(handle, S_IRUGO, show_transport_handle, NULL);
 
-- 
2.33.0

