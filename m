From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 5/6] scsi_dh : release the refcounts in scsi_dh_hp_sw
 handler when activate is complete
Date: Wed, 28 Jul 2010 16:59:58 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC425@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:36242 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab0G1XAE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 19:00:04 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

This patch releases the refcounts when activate is complete in scsi_dh_hp_sw handler.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_hp_sw.c.orig	2010-07-23 06:02:22.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-07-23 06:03:17.000000000 -0500
@@ -230,6 +230,9 @@ done:
 		h->callback_fn(h->callback_data, err);
 		h->callback_fn = h->callback_data = NULL;
 	}
+	kref_put(&h->sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
+	put_device(&h->sdev->sdev_gendev);
+
 	return;
 
 }
@@ -307,6 +310,9 @@ static int hp_sw_activate(struct scsi_de
 
 	if (fn)
 		fn(data, ret);
+	kref_put(&sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
+	put_device(&sdev->sdev_gendev);
+
 	return 0;
 }
 


