From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 6/6] scsi_dh : release the refcounts in scsi_dh_rdac handler
 when activate is complete
Date: Wed, 28 Jul 2010 17:00:11 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC426@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:56054 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691Ab0G1XAS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 19:00:18 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

This patch releases the refcounts when activate is complete in scsi_dh_rdac handler.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2010-07-23 05:51:24.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-07-23 05:54:05.000000000 -0500
@@ -209,6 +209,7 @@ static const char *lun_state[] =
 struct rdac_queue_data {
 	struct list_head	entry;
 	struct rdac_dh_data	*h;
+	struct scsi_device	*sdev;
 	activate_complete	callback_fn;
 	void			*callback_data;
 };
@@ -614,6 +615,9 @@ done:
 			qdata->h->state = RDAC_STATE_ACTIVE;
 		if (qdata->callback_fn)
 			qdata->callback_fn(qdata->callback_data, err);
+		kref_put(&qdata->sdev->scsi_dh_data->kref,
+			 scsi_dh_handler_cleanup);
+		put_device(&qdata->sdev->sdev_gendev);
 		kfree(qdata);
 	}
 	return;
@@ -630,6 +634,7 @@ static int queue_mode_select(struct scsi
 		return SCSI_DH_RETRY;
 
 	qdata->h = get_rdac_data(sdev);
+	qdata->sdev = sdev;
 	qdata->callback_fn = fn;
 	qdata->callback_data = data;
 
@@ -663,6 +668,8 @@ static int rdac_activate(struct scsi_dev
 done:
 	if (fn)
 		fn(data, err);
+	kref_put(&sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
+	put_device(&sdev->sdev_gendev);
 	return 0;
 }
 


