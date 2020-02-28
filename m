Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F69C3F2CD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EA152469C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 23:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1paOzq2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgB1XaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:30:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726561AbgB1XaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Feb 2020 18:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582932624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9vcqksjgrzibgB/ZK/iccYxqnzedXPb7WyOQzHZ7cA=;
        b=Q1paOzq27ddsmy7Tofa5EkHxIvnEtNKTiWuRMRLohn1Dyc66zlTnFCl5GBVPkf+DsvXkI9
        NZPn5ryicyrl4Of8ssYSaUs+ueqw+U6x9IW/D4CdT3BHPVl5km7tNMlCE5IwB35AudmvzM
        kFzfBjsb8BSxmFIssxXVAzN8Oy6Gaqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-oPu8jtkkN_WK2Ta1KiVlHw-1; Fri, 28 Feb 2020 18:30:22 -0500
X-MC-Unique: oPu8jtkkN_WK2Ta1KiVlHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16CA413F5;
        Fri, 28 Feb 2020 23:30:20 +0000 (UTC)
Received: from localhost (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0A59101D491;
        Fri, 28 Feb 2020 23:30:16 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH V2 09/10] scsi: add scsi_device_busy() to read sdev->device_busy
Date:   Sat, 29 Feb 2020 07:29:19 +0800
Message-Id: <20200228232920.20960-10-ming.lei@redhat.com>
In-Reply-To: <20200228232920.20960-1-ming.lei@redhat.com>
References: <20200228232920.20960-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add scsi_device_busy() for drivers, so that we can prepare for tracking
device queue depth via sbitmap_queue.

Cc: Omar Sandoval <osandov@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/message/fusion/mptsas.c      | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 drivers/scsi/scsi_lib.c              | 4 ++--
 drivers/scsi/scsi_sysfs.c            | 2 +-
 drivers/scsi/sg.c                    | 2 +-
 include/scsi/scsi_device.h           | 5 +++++
 6 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mpt=
sas.c
index 6a79cd0ebe2b..71d96526b24d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3756,7 +3756,7 @@ mptsas_send_link_status_event(struct fw_event_work =
*fw_event)
 						printk(MYIOC_s_DEBUG_FMT
 						"SDEV OUTSTANDING CMDS"
 						"%d\n", ioc->name,
-						atomic_read(&sdev->device_busy)));
+						scsi_device_busy(sdev)));
 				}
=20
 			}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index c597d544eb39..6685ec041c38 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3060,7 +3060,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
-	if (r =3D=3D SUCCESS && atomic_read(&scmd->device->device_busy))
+	if (r =3D=3D SUCCESS && scsi_device_busy(scmd->device))
 		r =3D FAILED;
  out:
 	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c8eb555b3ce8..a3474b418602 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -410,7 +410,7 @@ static void scsi_single_lun_run(struct scsi_device *c=
urrent_sdev)
=20
 static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 {
-	if (atomic_read(&sdev->device_busy) >=3D sdev->queue_depth)
+	if (scsi_device_busy(sdev) >=3D sdev->queue_depth)
 		return true;
 	if (atomic_read(&sdev->device_blocked) > 0)
 		return true;
@@ -1635,7 +1635,7 @@ static int scsi_mq_get_budget(struct blk_mq_hw_ctx =
*hctx)
 	if (scsi_dev_queue_ready(q, sdev))
 		return 0;
=20
-	if (atomic_read(&sdev->device_busy) =3D=3D 0 && !scsi_device_blocked(sd=
ev))
+	if (scsi_device_busy(sdev) =3D=3D 0 && !scsi_device_blocked(sdev))
 		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
 	return -1;
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 677b5c5403d2..d6cb5a0a03f2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -659,7 +659,7 @@ sdev_show_device_busy(struct device *dev, struct devi=
ce_attribute *attr,
 		char *buf)
 {
 	struct scsi_device *sdev =3D to_scsi_device(dev);
-	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+	return snprintf(buf, 20, "%d\n", scsi_device_busy(sdev));
 }
 static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);
=20
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4e6af592f018..943a18256881 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2507,7 +2507,7 @@ static int sg_proc_seq_show_dev(struct seq_file *s,=
 void *v)
 			      scsidp->id, scsidp->lun, (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
-			      (int) atomic_read(&scsidp->device_busy),
+			      (int) scsi_device_busy(scsidp),
 			      (int) scsi_device_online(scsidp));
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f8312a3e5b42..09caf6f2f528 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -584,6 +584,11 @@ static inline int scsi_device_supports_vpd(struct sc=
si_device *sdev)
 	return 0;
 }
=20
+static inline int scsi_device_busy(struct scsi_device *sdev)
+{
+	return atomic_read(&sdev->device_busy);
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
--=20
2.20.1

