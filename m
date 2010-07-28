From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/6] scsi_dh : rename and export __detach_handler
Date: Wed, 28 Jul 2010 16:58:55 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC421@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55475 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab0G1W67 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 18:58:59 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

This path renames the __detach_handler to scsi_dh_handler_cleanup. Also exports the symbol such that it is available to all the scsi device hardware handlers. 

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
diff -uprN -X linux-2.6.35-rc5-vanilla/Documentation/dontdiff linux-2.6.35-rc5-vanilla/drivers/scsi/device_handler/scsi_dh.c linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh.c
--- linux-2.6.35-rc5-vanilla/drivers/scsi/device_handler/scsi_dh.c	2010-07-12 16:55:33.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh.c	2010-07-23 05:00:03.000000000 -0500
@@ -166,11 +166,12 @@ static int scsi_dh_handler_attach(struct
 	return err;
 }
 
-static void __detach_handler (struct kref *kref)
+void scsi_dh_handler_cleanup(struct kref *kref)
 {
 	struct scsi_dh_data *scsi_dh_data = container_of(kref, struct scsi_dh_data, kref);
 	scsi_dh_data->scsi_dh->detach(scsi_dh_data->sdev);
 }
+EXPORT_SYMBOL_GPL(scsi_dh_handler_cleanup);
 
 /*
  * scsi_dh_handler_detach - Detach a device handler from a device
@@ -193,7 +194,7 @@ static void scsi_dh_handler_detach(struc
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 
 	if (scsi_dh && scsi_dh->detach)
-		kref_put(&sdev->scsi_dh_data->kref, __detach_handler);
+		kref_put(&sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
 }
 
 /*
diff -uprN -X linux-2.6.35-rc5-vanilla/Documentation/dontdiff linux-2.6.35-rc5-vanilla/include/scsi/scsi_dh.h linux-2.6.35-rc5/include/scsi/scsi_dh.h
--- linux-2.6.35-rc5-vanilla/include/scsi/scsi_dh.h	2010-07-12 16:55:33.000000000 -0500
+++ linux-2.6.35-rc5/include/scsi/scsi_dh.h	2010-07-23 04:57:17.000000000 -0500
@@ -61,6 +61,7 @@ extern int scsi_dh_handler_exist(const c
 extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
+extern void scsi_dh_handler_cleanup(struct kref *kref);
 #else
 static inline int scsi_dh_activate(struct request_queue *req,
 					activate_complete fn, void *data)
@@ -84,4 +85,8 @@ static inline int scsi_dh_set_params(str
 {
 	return -SCSI_DH_NOSYS;
 }
+static void scsi_dh_handler_cleanup(struct kref *kref)
+{
+	return;
+}
 #endif


