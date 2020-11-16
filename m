Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E314C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE5F22314
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 09:49:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xb0qd6am"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgKPJI5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 04:08:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728529AbgKPJI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 04:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605517735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yiS5hNWZopt9p7SlIQqX7KLBYJaQAp16SdA0EAMqvf0=;
        b=Xb0qd6amlUyejojBd8rst6eWhxusJX6lNVygx7kro7d5i5sehOoGjeE+2ldQCQKoG1YJ75
        +hoMGfhVJ8pMoslnJL6n6F5xOnFgiLSf+Mewm0bbHdYEg3o+Mh/Jdxp22uJslMFWg0W3E3
        V9gG1UcDhkp7Rs7R5kFo9bVZ35U/dFQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-E8yJAuAhOPetnbJWQ2j9BA-1; Mon, 16 Nov 2020 04:08:50 -0500
X-MC-Unique: E8yJAuAhOPetnbJWQ2j9BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 742A410B9CA0;
        Mon, 16 Nov 2020 09:08:49 +0000 (UTC)
Received: from localhost (ovpn-13-166.pek2.redhat.com [10.72.13.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D1D962A4F;
        Mon, 16 Nov 2020 09:08:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V4 10/12] scsi: add scsi_device_busy() to read sdev->device_busy
Date:   Mon, 16 Nov 2020 17:07:35 +0800
Message-Id: <20201116090737.50989-11-ming.lei@redhat.com>
In-Reply-To: <20201116090737.50989-1-ming.lei@redhat.com>
References: <20201116090737.50989-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 18b91ea1a353..25dd9b2e12ab 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3756,7 +3756,7 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 						printk(MYIOC_s_DEBUG_FMT
 						"SDEV OUTSTANDING CMDS"
 						"%d\n", ioc->name,
-						atomic_read(&sdev->device_busy)));
+						scsi_device_busy(sdev)));
 				}
 
 			}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5f845d7094fc..ea1bed3e7a4a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3255,7 +3255,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
-	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
+	if (r == SUCCESS && scsi_device_busy(scmd->device))
 		r = FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dafcfa3ae77c..4709418c47e0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -384,7 +384,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
+	if (scsi_device_busy(sdev) >= sdev->queue_depth)
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1632,7 +1632,7 @@ static int scsi_mq_get_budget(struct request_queue *q)
 	 * the .restarts flag, and the request queue will be run for handling
 	 * this request, see scsi_end_request().
 	 */
-	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
+	if (unlikely(scsi_device_busy(sdev) == 0 &&
 				!scsi_device_blocked(sdev)))
 		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
 	return -1;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6e344fa33ad..ef5c79037bde 100644
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
index bfa8d77322d7..4fa2fbb2c833 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2504,7 +2504,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
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
2.25.4

