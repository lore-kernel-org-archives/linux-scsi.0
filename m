Return-Path: <SRS0=zduL=IG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A79C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 03:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BBF4650F3
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 03:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhCHDem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Mar 2021 22:34:42 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:43626 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231833AbhCHDek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Mar 2021 22:34:40 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQodxFV_1615174471;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UQodxFV_1615174471)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Mar 2021 11:34:37 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     lduncan@suse.com
Cc:     cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: iscsi: Switch to using the new API kobj_to_dev()
Date:   Mon,  8 Mar 2021 11:34:30 +0800
Message-Id: <1615174470-45135-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/scsi/scsi_transport_iscsi.c:930:60-61: WARNING opportunity for
kobj_to_dev().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 91074fd9..a01275e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -927,7 +927,7 @@ static umode_t iscsi_flashnode_sess_attr_is_visible(struct kobject *kobj,
 						    struct attribute *attr,
 						    int i)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct iscsi_bus_flash_session *fnode_sess =
 						iscsi_dev_to_flash_session(dev);
 	struct iscsi_transport *t = fnode_sess->transport;
-- 
1.8.3.1

