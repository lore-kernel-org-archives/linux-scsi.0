Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D38C4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F634238D7
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CFDnE/A6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgIWBew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 21:34:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727052AbgIWBev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Sep 2020 21:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600824889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vj5Yxa4YfrmmQKyb00EESZ/fVl9ah0hfIrdfrUcWEiI=;
        b=CFDnE/A6/xwfqkET4ZfWy82piwwb5eOGswpJ4OJRyrcPRw8Mx8zxVIUM08fpQhteiynzic
        wTmrpZqtwsW66xfmxALBZODutQd/hwIsEMNIhUdsKBuLKZMrnY9taWYGNOmvVlN/Q5KoCl
        wi9JPEcDu6zinGIFARwHZxwY2kkPbGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-haoKwrgXPrGB_GxEts8k1g-1; Tue, 22 Sep 2020 21:34:47 -0400
X-MC-Unique: haoKwrgXPrGB_GxEts8k1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D54E186DD2C;
        Wed, 23 Sep 2020 01:34:46 +0000 (UTC)
Received: from localhost (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89D4E78808;
        Wed, 23 Sep 2020 01:34:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 for 5.11 10/12] scsi: add scsi_device_busy() to read sdev->device_busy
Date:   Wed, 23 Sep 2020 09:33:37 +0800
Message-Id: <20200923013339.1621784-11-ming.lei@redhat.com>
In-Reply-To: <20200923013339.1621784-1-ming.lei@redhat.com>
References: <20200923013339.1621784-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add scsi_device_busy() for drivers, so that we can prepare for tracking
device queue depth via sbitmap_queue.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
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
index 2e2756d8a49b..cab6e23d8756 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3060,7 +3060,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
-	if (r == SUCCESS && atomic_read(&scmd->device->device_busy))
+	if (r == SUCCESS && scsi_device_busy(scmd->device))
 		r = FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41380e200925..e5b336847852 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -399,7 +399,7 @@ static void scsi_single_lun_run(struct scsi_device *current_sdev)
 
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >= sdev->queue_depth)
+	if (scsi_device_busy(sdev) >= sdev->queue_depth)
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1652,7 +1652,7 @@ static int scsi_mq_get_budget(struct request_queue *q)
 	 * the .restarts flag, and the request queue will be run for handling
 	 * this request, see scsi_end_request().
 	 */
-	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
+	if (unlikely(scsi_device_busy(sdev) == 0 &&
 				!scsi_device_blocked(sdev)))
 		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
 	return -1;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 163dbcb741c1..6a51827a4e81 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -659,7 +659,7 @@ sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+	return snprintf(buf, 20, "%d\n", scsi_device_busy(sdev));
 }
 static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..8014f504d7b8 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2511,7 +2511,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s, void *v)
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
2.25.2

