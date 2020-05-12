Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FC1C54E8B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 11:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0E88206F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 11:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgELLd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 07:33:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48414 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgELLd6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 07:33:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 907665787C08C24FD799;
        Tue, 12 May 2020 19:33:56 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 12 May 2020
 19:33:46 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2] scsi: hisi_sas: display proc_name in sysfs
Date:   Tue, 12 May 2020 19:32:58 +0800
Message-ID: <20200512113258.30781-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'proc_name' entry in sysfs for hisi_sas is 'null' now becuase it is
not initialized in scsi_host_template. It looks like:

[root@localhost ~]# cat /sys/class/scsi_host/host2/proc_name
(null)

While the other driver's entry looks like:

linux-vnMQMU:~ # cat /sys/class/scsi_host/host0/proc_name
megaraid_sas

Cc: John Garry <john.garry@huawei.com>
Cc: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
---

 v2: change subject to "display proc_name in sysfs" and add "Acked-by" tag.

 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fa25766502a2..c205bff20943 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1757,6 +1757,7 @@ static struct device_attribute *host_attrs_v1_hw[] = {
 
 static struct scsi_host_template sht_v1_hw = {
 	.name			= DRV_NAME,
+	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e05faf315dcd..c725cffe141e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3533,6 +3533,7 @@ static struct device_attribute *host_attrs_v2_hw[] = {
 
 static struct scsi_host_template sht_v2_hw = {
 	.name			= DRV_NAME,
+	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 374885aa8d77..59b1421607dd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3071,6 +3071,7 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
 
 static struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
+	.proc_name		= DRV_NAME,
 	.module			= THIS_MODULE,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
-- 
2.21.3

