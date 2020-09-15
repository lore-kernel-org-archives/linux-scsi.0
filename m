Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DF5C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DEB821D24
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 08:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIOIjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:39:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbgIOIjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 04:39:11 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E521BD06E92F6439C127;
        Tue, 15 Sep 2020 16:39:09 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 15 Sep 2020
 16:38:59 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <hare@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <gustavoars@kernel.org>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: myrb: make some symblos static
Date:   Tue, 15 Sep 2020 16:40:18 +0800
Message-ID: <20200915084018.2826922-1-yanaijie@huawei.com>
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

drivers/scsi/myrb.c:2229:27: warning: symbol 'myrb_template' was not
declared. Should it be static?
drivers/scsi/myrb.c:2318:31: warning: symbol 'myrb_raid_functions' was
not declared. Should it be static?
drivers/scsi/myrb.c:2492:6: warning: symbol 'myrb_err_status' was not
declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/myrb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index b2869c5dd7fb..cbf1e8b091b9 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2226,7 +2226,7 @@ static struct device_attribute *myrb_shost_attrs[] = {
 	NULL,
 };
 
-struct scsi_host_template myrb_template = {
+static struct scsi_host_template myrb_template = {
 	.module			= THIS_MODULE,
 	.name			= "DAC960",
 	.proc_name		= "myrb",
@@ -2315,7 +2315,7 @@ static void myrb_get_state(struct device *dev)
 	raid_set_state(myrb_raid_template, dev, state);
 }
 
-struct raid_function_template myrb_raid_functions = {
+static struct raid_function_template myrb_raid_functions = {
 	.cookie		= &myrb_template,
 	.is_raid	= myrb_is_raid,
 	.get_resync	= myrb_get_resync,
@@ -2489,7 +2489,7 @@ static void myrb_monitor(struct work_struct *work)
  *
  * Return: true for fatal errors and false otherwise.
  */
-bool myrb_err_status(struct myrb_hba *cb, unsigned char error,
+static bool myrb_err_status(struct myrb_hba *cb, unsigned char error,
 		unsigned char parm0, unsigned char parm1)
 {
 	struct pci_dev *pdev = cb->pdev;
-- 
2.25.4

