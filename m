Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35866C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD71B64E2A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhBGJYW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 04:24:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229760AbhBGJYR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 04:24:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612689770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kFDQ+NjVkRJSQqXEU2prlgTj89AU1b/gSz5ilEHk3mc=;
        b=B0w7Mxmk2caBOOlqafpYAKOt7YiwKeHHxMWHW7FcC2TjcYx+gJB44zjGn/o9hMlYL0XiB7
        3n5sPICOogdhj1atRA0xLBUVAdtHoPv09aBZXybpv+lqp6Sq/hmXjTK8frPNWgiPDtDmTY
        GlC5jzKe5vSKnxoy6ScZwWjHCcwjQ1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-LLwOtc2nPeWnODhiDznr5g-1; Sun, 07 Feb 2021 04:22:48 -0500
X-MC-Unique: LLwOtc2nPeWnODhiDznr5g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A127189DF4F;
        Sun,  7 Feb 2021 09:22:47 +0000 (UTC)
Received: from localhost (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8508B60BF3;
        Sun,  7 Feb 2021 09:22:37 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V8 11/13] scsi: add scsi_device_busy() to read sdev->device_busy
Date:   Sun,  7 Feb 2021 17:20:27 +0800
Message-Id: <20210207092029.1558550-12-ming.lei@redhat.com>
In-Reply-To: <20210207092029.1558550-1-ming.lei@redhat.com>
References: <20210207092029.1558550-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add scsi_device_busy() for drivers, so that we can prepare for tracking
device queue depth via sbitmap_queue.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/message/fusion/mptsas.c      | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 drivers/scsi/scsi_lib.c              | 4 ++--
 drivers/scsi/scsi_sysfs.c            | 2 +-
 drivers/scsi/sg.c                    | 2 +-
 include/scsi/scsi_device.h           | 5 +++++
 6 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5eb0b3361e4e..85aa5788826b 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3781,7 +3781,7 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 						printk(MYIOC_s_DEBUG_FMT
 						"SDEV OUTSTANDING CMDS"
 						"%d\n", ioc->name,
-						atomic_read(&sdev->device_busy)));
+						scsi_device_busy(sdev)));
 				}
 
 			}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c8b09a81834d..784ad7105d1b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3415,7 +3415,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
-	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
+	if (r == SUCCESS && scsi_device_busy(scmd->device))
 		r = FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 00c36a4bebd9..cb56bf456e55 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -385,7 +385,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
+	if (scsi_device_busy(sdev) >= sdev->queue_depth)
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1638,7 +1638,7 @@ static int scsi_mq_get_budget(struct request_queue *q)
 	 * the .restarts flag, and the request queue will be run for handling
 	 * this request, see scsi_end_request().
 	 */
-	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
+	if (unlikely(scsi_device_busy(sdev) == 0 &&
 				!scsi_device_blocked(sdev)))
 		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
 	return -1;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b6378c8ca783..0840e44140de 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -670,7 +670,7 @@ sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+	return snprintf(buf, 20, "%d\n", scsi_device_busy(sdev));
 }
 static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4383d93110f8..737cea9d908e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2503,7 +2503,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
-			      (int) atomic_read(&scsidp->device_busy),
+			      (int) scsi_device_busy(scsidp),
 			      (int) scsi_device_online(scsidp));
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1a5c9a3df6d6..dd0b9f690a26 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -590,6 +590,11 @@ static inline int scsi_device_supports_vpd(struct scsi_device *sdev)
 	return 0;
 }
 
+static inline int scsi_device_busy(struct scsi_device *sdev)
+{
+	return atomic_read(&sdev->device_busy);
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
-- 
2.29.2

