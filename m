Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88B5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 15:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242796AbiBQPtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 10:49:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242798AbiBQPt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 10:49:28 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726BD15DDFC;
        Thu, 17 Feb 2022 07:49:06 -0800 (PST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JzzkK5pZ4z67HKP;
        Thu, 17 Feb 2022 23:48:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 17 Feb 2022 16:49:04 +0100
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 15:49:00 +0000
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <artur.paszkiewicz@intel.com>, <jinpu.wang@cloud.ionos.com>,
        <chenxiang66@hisilicon.com>, <damien.lemoal@opensource.wdc.com>,
        <hch@lst.de>
CC:     <Ajish.Koshy@microchip.com>, <yanaijie@huawei.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <liuqi115@huawei.com>, <Viswas.G@microchip.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 10/18] scsi: libsas: Add sas_execute_ssp_tmf()
Date:   Thu, 17 Feb 2022 23:42:38 +0800
Message-ID: <1645112566-115804-11-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1645112566-115804-1-git-send-email-john.garry@huawei.com>
References: <1645112566-115804-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a function to issue an SSP TMF.

Add a temp prototype to keep make W=1 happy.

Signed-off-by: John Garry <john.garry@huawei.com>
Tested-by: Yihang Li <liyihang6@hisilicon.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index d04002180be3..af2dd95a2b28 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -937,6 +937,9 @@ int sas_execute_tmf(struct domain_device *device, void *parameter,
 		task->dev = device;
 		task->task_proto = device->tproto;
 
+		if (!dev_is_sata(device))
+			memcpy(&task->ssp_task, parameter, para_len);
+
 		task->task_done = sas_task_internal_done;
 		task->tmf = tmf;
 
@@ -1022,6 +1025,21 @@ int sas_execute_tmf(struct domain_device *device, void *parameter,
 	return res;
 }
 
+int sas_execute_ssp_tmf(struct domain_device *device, u8 *lun,
+			struct sas_tmf_task *tmf);
+int sas_execute_ssp_tmf(struct domain_device *device, u8 *lun,
+			struct sas_tmf_task *tmf)
+{
+	struct sas_ssp_task ssp_task;
+
+	if (!(device->tproto & SAS_PROTOCOL_SSP))
+		return TMF_RESP_FUNC_ESUPP;
+
+	memcpy(ssp_task.LUN, lun, 8);
+
+	return sas_execute_tmf(device, &ssp_task, sizeof(ssp_task), -1, tmf);
+}
+
 /*
  * Tell an upper layer that it needs to initiate an abort for a given task.
  * This should only ever be called by an LLDD.
-- 
2.26.2

