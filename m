Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D0BC00307
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B3BC21670
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 12:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391494AbfIFM6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 08:58:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404930AbfIFM6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 08:58:17 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CED8BFF98E9F63AD3B0C;
        Fri,  6 Sep 2019 20:58:15 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 20:58:05 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 13/13] scsi: hisi_sas: Fix the conflict between device gone and host reset
Date:   Fri, 6 Sep 2019 20:55:37 +0800
Message-ID: <1567774537-20003-14-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When device gone, it will check whether it is during reset, if not, it
will send internal task abort. Before internal task abort returned, reset
begins, and it will check whether SAS_PHY_UNUSED is set, if not, it will
call hisi_sas_init_device(), but at that time domain_device may already
be freed or part of it is freed, so it may referenece null pointer in
hisi_sas_init_device(). It may occur as follows:
    thread0				thread1
hisi_sas_dev_gone()
    check whether in RESET(no)
    internal task abort
				    reset prep
				    soft_reset
				    ... (part of reset_done)
    internal task abort failed
    release resource anyway
    clear_itct
    device->lldd_dev=NULL
				    hisi_sas_reset_init_all_device
					check sas_dev->dev_type is SAS_PHY_UNUSED and
					!device
    set dev_type SAS_PHY_UNUSED
    sas_free_device
					hisi_sas_init_device
					...

Semaphore hisi_hba.sema is used to sync the processes of device gone and
host reset.

To solve the issue, expand the scope that semaphore protects and let
them never occur together.

And also some places will check whether domain_device is NULL to judge
whether the device is gone. So when device gone, need to clear
sas_dev->sas_device.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 04cbc54be387..a7b3d9d38fdc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1049,21 +1049,22 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	dev_info(dev, "dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
 
+	down(&hisi_hba->sem);
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
 		hisi_sas_internal_task_abort(hisi_hba, device,
 					     HISI_SAS_INT_ABT_DEV, 0);
 
 		hisi_sas_dereg_device(hisi_hba, device);
 
-		down(&hisi_hba->sem);
 		hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
-		up(&hisi_hba->sem);
 		device->lldd_dev = NULL;
 	}
 
 	if (hisi_hba->hw->free_device)
 		hisi_hba->hw->free_device(sas_dev);
 	sas_dev->dev_type = SAS_PHY_UNUSED;
+	sas_dev->sas_device = NULL;
+	up(&hisi_hba->sem);
 }
 
 static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
@@ -1543,11 +1544,11 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
 	msleep(1000);
 	hisi_sas_refresh_port_id(hisi_hba);
 	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-	up(&hisi_hba->sem);
 
 	if (hisi_hba->reject_stp_links_msk)
 		hisi_sas_terminate_stp_reject(hisi_hba);
 	hisi_sas_reset_init_all_devices(hisi_hba);
+	up(&hisi_hba->sem);
 	scsi_unblock_requests(shost);
 	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
 
-- 
2.17.1

