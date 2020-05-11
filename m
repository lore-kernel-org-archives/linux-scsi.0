Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E00C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 11:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4419520735
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 11:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgEKLqv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 07:46:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4329 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbgEKLqv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 07:46:51 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 15DC253A6DB7E3CFC730;
        Mon, 11 May 2020 19:46:48 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 11 May 2020 19:46:40 +0800
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
To:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangxiongfeng2@huawei.com>
Subject: [PATCH] scsi: fcoe: add a newline when printing 'fcoe_transport' by sysfs
Date:   Mon, 11 May 2020 19:40:40 +0800
Message-ID: <1589197240-28118-1-git-send-email-wangxiongfeng2@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When I print 'fcoe_transport' by sysfs, it displays as follows. It is
better to add a newline for easy reading.

[root@hulk-202 ~]# cat /sys/module/libfcoe/parameters/show
Attached FCoE transports:fcoe [root@hulk-202 ~]#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 drivers/scsi/fcoe/fcoe_transport.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index a20ddc3..1b82753 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -607,7 +607,10 @@ static int fcoe_transport_show(char *buffer, const struct kernel_param *kp)
 	}
 	mutex_unlock(&ft_mutex);
 	if (i == j)
-		i += snprintf(&buffer[i], IFNAMSIZ, "none");
+		i += snprintf(&buffer[i], IFNAMSIZ, "none\n");
+	else if (PAGE_SIZE - i >= 1)
+		i += sprintf(&buffer[i], "\n");
+
 	return i;
 }
 
-- 
1.7.12.4

