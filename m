Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE745C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 10:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE8BE610E7
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 10:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhJSK3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 06:29:42 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:48426 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235085AbhJSK3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 06:29:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UsueaBN_1634639242;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UsueaBN_1634639242)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Oct 2021 18:27:28 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     sathya.prakash@broadcom.com
Cc:     sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: mpt3sas: make mpt3sas_dev_attrs static
Date:   Tue, 19 Oct 2021 18:27:19 +0800
Message-Id: <1634639239-2892-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

This symbol is not used outside of mpt3sas_ctl.c, so marks it static.

Fixes the following sparse warning:

drivers/scsi/mpt3sas/mpt3sas_ctl.c:3988:18: warning: symbol
'mpt3sas_dev_attrs' was not declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 1bb3ca27d2ca ("scsi: mpt3sas: Switch to attribute groups")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 0aabc9761be1..05b6c6a073c3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3985,7 +3985,7 @@ sas_ncq_prio_enable_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(sas_ncq_prio_enable);
 
-struct attribute *mpt3sas_dev_attrs[] = {
+static struct attribute *mpt3sas_dev_attrs[] = {
 	&dev_attr_sas_address.attr,
 	&dev_attr_sas_device_handle.attr,
 	&dev_attr_sas_ncq_prio_supported.attr,
-- 
2.19.1.6.gb485710b

