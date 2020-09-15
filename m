Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C7EC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E6621974
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgIOIjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:39:02 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12261 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbgIOIjB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 04:39:01 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3DB9DA807576034F4D44;
        Tue, 15 Sep 2020 16:38:59 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 15 Sep 2020
 16:38:49 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <hare@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <lee.jones@linaro.org>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: myrs: make some symbols static
Date:   Tue, 15 Sep 2020 16:40:08 +0800
Message-ID: <20200915084008.2826835-1-yanaijie@huawei.com>
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

This addresses the following sparse warning:

drivers/scsi/myrs.c:1532:5: warning: symbol 'myrs_host_reset' was not
declared. Should it be static?
drivers/scsi/myrs.c:1922:27: warning: symbol 'myrs_template' was not
declared. Should it be static?
drivers/scsi/myrs.c:2036:31: warning: symbol 'myrs_raid_functions' was
not declared. Should it be static?
drivers/scsi/myrs.c:2046:6: warning: symbol 'myrs_flush_cache' was not
declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/myrs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 103803e779f2..7a3ade765ce3 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1529,7 +1529,7 @@ static struct device_attribute *myrs_shost_attrs[] = {
 /*
  * SCSI midlayer interface
  */
-int myrs_host_reset(struct scsi_cmnd *scmd)
+static int myrs_host_reset(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	struct myrs_hba *cs = shost_priv(shost);
@@ -1919,7 +1919,7 @@ static void myrs_slave_destroy(struct scsi_device *sdev)
 	kfree(sdev->hostdata);
 }
 
-struct scsi_host_template myrs_template = {
+static struct scsi_host_template myrs_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
 	.proc_name		= "myrs",
@@ -2033,7 +2033,7 @@ myrs_get_state(struct device *dev)
 	raid_set_state(myrs_raid_template, dev, state);
 }
 
-struct raid_function_template myrs_raid_functions = {
+static struct raid_function_template myrs_raid_functions = {
 	.cookie		= &myrs_template,
 	.is_raid	= myrs_is_raid,
 	.get_resync	= myrs_get_resync,
@@ -2043,7 +2043,7 @@ struct raid_function_template myrs_raid_functions = {
 /*
  * PCI interface functions
  */
-void myrs_flush_cache(struct myrs_hba *cs)
+static void myrs_flush_cache(struct myrs_hba *cs)
 {
 	myrs_dev_op(cs, MYRS_IOCTL_FLUSH_DEVICE_DATA, MYRS_RAID_CONTROLLER);
 }
-- 
2.25.4

