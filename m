Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D26FC43461
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 03:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59920221ED
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 03:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgILDik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 23:38:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgILDig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 23:38:36 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD83D7AD575CD581D6FF;
        Sat, 12 Sep 2020 11:38:31 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 12 Sep 2020
 11:38:21 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <intel-linux-scu@intel.com>, <artur.paszkiewicz@intel.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <arnd@arndb.de>, <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: isci: make isci_host_attrs static
Date:   Sat, 12 Sep 2020 11:37:41 +0800
Message-ID: <20200912033741.142415-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This eliminates the following sparse warning:

drivers/scsi/isci/init.c:145:25: warning: symbol 'isci_host_attrs' was
not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/isci/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 085e285f427d..93bc9019667f 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -142,7 +142,7 @@ static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, c
 
 static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
 
-struct device_attribute *isci_host_attrs[] = {
+static struct device_attribute *isci_host_attrs[] = {
 	&dev_attr_isci_id,
 	NULL
 };
-- 
2.25.4

