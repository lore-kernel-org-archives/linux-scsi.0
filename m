From: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>
Subject: [PATCH] ses: Avoid kernel panic when lun 0 is not mapped
Date: Mon, 28 Feb 2011 18:13:22 -0500
Message-ID: <35D9CA00EB0D2346A1F23EB8FC42940A03CC57DAA2@palmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:49515 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753104Ab1B1XMZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 18:12:25 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>

During device discovery, scsi mid layer sends INQUIRY command to LUN 0. If the LUN 0 is not mapped to host, it creates a temporary scsi_device with LUN id 0 and sends REPORT_LUNS command to it. After the REPORT_LUNS succeeds, it walks through the LUN table and adds each LUN found to sysfs. At the end of REPORT_LUNS lun table scan, it will delete the temporary scsi_device of LUN 0.

When scsi devices are added to sysfs, it calls add_dev function of all the registered class interfaces. If ses driver has been registered, ses_intf_add() of ses module will be called. This function calls scsi_device_enclosure() to check the inquiry data for EncServ bit. Since inquiry was not allocated for temporary LUN 0 scsi_device, it will cause NULL pointer exception.

To fix the problem, sdev->inquiry is checked for NULL before reading it.

Signed-off-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.38-rc6/include/scsi/scsi_device.h.orig	2011-02-28 16:12:51.000000000 -0600
+++ linux-2.6.38-rc6/include/scsi/scsi_device.h	2011-02-28 16:16:02.000000000 -0600
@@ -461,7 +461,7 @@ static inline int scsi_device_qas(struct
 }
 static inline int scsi_device_enclosure(struct scsi_device *sdev)
 {
-	return sdev->inquiry[6] & (1<<6);
+	return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
 }
 
 static inline int scsi_device_protection(struct scsi_device *sdev)


