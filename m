From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 3/6] scsi_dh : release the refcounts in scsi_dh_alua handler
 when activate is complete
Date: Wed, 28 Jul 2010 16:59:24 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC423@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:39329 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab0G1W72 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 18:59:28 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

This patch releases the refcounts when activate is complete in alua handler.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_alua.c.orig	2010-07-23 05:58:39.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_alua.c	2010-07-23 06:00:54.000000000 -0500
@@ -287,6 +287,8 @@ done:
 		h->callback_fn(h->callback_data, err);
 		h->callback_fn = h->callback_data = NULL;
 	}
+	kref_put(&h->sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
+	put_device(&h->sdev->sdev_gendev);
 	return;
 }
 
@@ -684,6 +686,8 @@ static int alua_activate(struct scsi_dev
 out:
 	if (fn)
 		fn(data, err);
+	kref_put(&sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
+	put_device(&sdev->sdev_gendev);
 	return 0;
 }
 


