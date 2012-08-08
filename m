From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi_dh_rdac: Add empty set_params function to scsi_dh_rdac
Date: Wed, 8 Aug 2012 16:10:07 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B0BCA09F1@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:55177 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030391Ab2HHQKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2012 12:10:25 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>, "Mike Snitzer <snitzer@redhat.com> (snitzer@redhat.com)" <snitzer@redhat.com>

This patch adds empty set_params function to scsi_dh_rdac.

This patch is required for the following features to work properly.
1. add  retain_attached_hw_handler feature

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=a58a935d5a1b2ad267017a68c3a1bca26226cc76

2. add scsi_dh_attached_handler_name

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=7e8a74b177f17d100916b6ad415450f7c9508691


DM layer detaches the handler if the set_params is not implemented or fails.

For example if we pass following parameters from multipath:

	features "1 retain_attached_hw_handler" (consider rdac as attached_hw_handler)
	hardware_handler "2 alua 1"

If the attached_hw_handler is rdac, then DM anyway tries to call set_params on rdac. Because rdac does not 
implement set_params, scsi_dh_set_params fails and DM detaches the handler.

This patch fixes this problem. 

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.5-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2012-08-08 10:38:54.000000000 -0500
+++ linux-3.5-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c	2012-08-08 11:02:10.000000000 -0500
@@ -816,6 +816,17 @@ static const struct scsi_dh_devlist rdac
 	{NULL, NULL},
 };
 
+/*
+ * params - parameters in the following format
+ *      "no_of_params\0param1\0param2\0param3\0...\0"
+ *      for example, string for 2 parameters with value 10 and 21
+ *      is specified as "2\010\021\0".
+ */
+static int rdac_set_params(struct scsi_device *sdev, const char *params)
+{
+	return 0;
+}
+
 static bool rdac_match(struct scsi_device *sdev)
 {
 	int i;
@@ -846,6 +857,7 @@ static struct scsi_device_handler rdac_d
 	.attach = rdac_bus_attach,
 	.detach = rdac_bus_detach,
 	.activate = rdac_activate,
+	.set_params = rdac_set_params,
 	.match = rdac_match,
 };
 


