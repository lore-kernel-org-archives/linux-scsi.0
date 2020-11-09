Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F0DC5517A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 02:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E80A1206F4
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 02:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgKICnK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Nov 2020 21:43:10 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:43217 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgKICnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2020 21:43:09 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id 10756666A1E;
        Mon,  9 Nov 2020 10:43:06 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] scsi: use kobj_to_dev() instead
Date:   Mon,  9 Nov 2020 10:43:01 +0800
Message-Id: <1604889781-29715-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZT0JLGR1PH0pIGk5NVkpNS09DQ0JMQ01IQktVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MxQ6SSo4Hj8pHRMBQjdMNhkN
        E01PCS9VSlVKTUtPQ0NCTENNQ0lDVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJS0JDNwY+
X-HM-Tid: 0a75aae2b79a9373kuws10756666a1e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use kobj_to_dev() instead of container_of().

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/scsi/3w-sas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index dda6fa8..7cde82e
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -99,7 +99,7 @@ static ssize_t twl_sysfs_aen_read(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *outbuf, loff_t offset, size_t count)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host *shost = class_to_shost(dev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)shost->hostdata;
 	unsigned long flags = 0;
@@ -130,7 +130,7 @@ static ssize_t twl_sysfs_compat_info(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *bin_attr,
 				     char *outbuf, loff_t offset, size_t count)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host *shost = class_to_shost(dev);
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)shost->hostdata;
 	unsigned long flags = 0;
-- 
2.7.4

