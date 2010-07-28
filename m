From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 4/6] scsi_dh : release the refcounts in scsi_dh_emc handler
 when activate is complete
Date: Wed, 28 Jul 2010 16:59:43 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC424@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:44473 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab0G1W7r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 18:59:47 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

This patch releases the refcounts when activate is complete in emc handler.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_emc.c.orig	2010-07-23 05:56:50.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh_emc.c	2010-07-23 05:57:08.000000000 -0500
@@ -563,6 +563,9 @@ done:
 
 	if (fn)
 		fn(data, result);
+
+	kref_put(&sdev->scsi_dh_data->kref, scsi_dh_handler_cleanup);
+	put_device(&sdev->sdev_gendev);
 	return 0;
 }
 /*


