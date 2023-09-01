Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B294ACA0FE9
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Sep 2023 09:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348902AbjIAJmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Sep 2023 05:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbjIAJmA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2023 05:42:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D81410D5;
        Fri,  1 Sep 2023 02:41:54 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RcY0q1Wbjz1L8yr;
        Fri,  1 Sep 2023 17:40:11 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 1 Sep 2023 17:41:51 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Hannes Reinecke <hare@suse.de>, <linux-kernel@vger.kernel.org>,
        <louhongxiang@huawei.com>, <lixiaokeng@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [RFC PATCH v2 02/19] scsi: scsi_error: Move complete variable eh_action from shost to sdevice
Date:   Fri, 1 Sep 2023 17:41:10 +0800
Message-ID: <20230901094127.2010873-3-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230901094127.2010873-1-haowenchao2@huawei.com>
References: <20230901094127.2010873-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

eh_action is used to wait for error handle command's completion if scsi
command is send in error handle. Now the error handler might based on
scsi_device, so move it to scsi_device.

This is preparation for a genernal LUN/target based error handle
strategy.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c  | 6 +++---
 include/scsi/scsi_device.h | 2 ++
 include/scsi/scsi_host.h   | 2 --
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1d1d97b94613..879fdd7c165b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -914,7 +914,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 			"%s result: %x\n", __func__, scmd->result));
 
-	eh_action = scmd->device->host->eh_action;
+	eh_action = scmd->device->eh_action;
 	if (eh_action)
 		complete(eh_action);
 }
@@ -1203,7 +1203,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
-	shost->eh_action = &done;
+	sdev->eh_action = &done;
 
 	scsi_log_send(scmd);
 	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
@@ -1246,7 +1246,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 		rtn = SUCCESS;
 	}
 
-	shost->eh_action = NULL;
+	sdev->eh_action = NULL;
 
 	scsi_log_completion(scmd, rtn);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 08ed9a03015d..df3f1b8d1390 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -324,6 +324,8 @@ struct scsi_device {
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
 	struct scsi_device_eh	*eh;
+	struct completion	*eh_action;	/* Wait for specific actions */
+						/* on the device. */
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 70b7475dcf56..def0d99e9b36 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -554,8 +554,6 @@ struct Scsi_Host {
 	struct list_head	eh_abort_list;
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct completion     * eh_action; /* Wait for specific actions on the
-					      host. */
 	wait_queue_head_t       host_wait;
 	const struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
-- 
2.35.3

