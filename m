Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC602C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 07:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B734520639
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 07:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgHYHBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 03:01:20 -0400
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:33036 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728939AbgHYHBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 03:01:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 30EA5837F27B;
        Tue, 25 Aug 2020 07:01:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: kick90_3a07d8a27059
X-Filterd-Recvd-Size: 3293
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 07:01:09 +0000 (UTC)
Message-ID: <5e8d3765063043f7a90c92c098317319757595ed.camel@perches.com>
Subject: Re: [PATCH] scsi: megaraid: Remove unnecessary assignment to
 variable ret
From:   Joe Perches <joe@perches.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 25 Aug 2020 00:01:07 -0700
In-Reply-To: <20200825063836.92239-1-jingxiangfeng@huawei.com>
References: <20200825063836.92239-1-jingxiangfeng@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-08-25 at 14:38 +0800, Jing Xiangfeng wrote:
> The variable ret is being initialized with 'FAILED'. So we can remove
> this assignement.

If you are going to change the code at all,
might as well try to improve it more by removing
the unnecessary out: label altogether.

Perhaps:
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 883cccb59c2d..1a8f18113136 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4688,9 +4688,8 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 
 int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 {
-
 	struct megasas_instance *instance;
-	int ret = FAILED;
+	int ret;
 	u16 devhandle;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	mr_device_priv_data = scmd->device->hostdata;
@@ -4700,32 +4699,27 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
 		"SCSI host:%d\n", instance->host->host_no);
-		ret = FAILED;
-		return ret;
+		return FAILED;
 	}
 
 	if (!mr_device_priv_data) {
 		sdev_printk(KERN_INFO, scmd->device,
 			    "device been deleted! scmd: (0x%p)\n", scmd);
 		scmd->result = DID_NO_CONNECT << 16;
-		ret = SUCCESS;
-		goto out;
+		return SUCCESS;
 	}
 
-	if (!mr_device_priv_data->is_tm_capable) {
-		ret = FAILED;
-		goto out;
-	}
+	if (!mr_device_priv_data->is_tm_capable)
+		return FAILED;
 
 	mutex_lock(&instance->reset_mutex);
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
-		goto out;
+		return SUCCESS;
 	}
 
 	sdev_printk(KERN_INFO, scmd->device,
@@ -4741,7 +4735,6 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	scmd_printk(KERN_NOTICE, scmd, "target reset %s!!\n",
 		(ret == SUCCESS) ? "SUCCESS" : "FAILED");
 
-out:
 	return ret;
 }
 


