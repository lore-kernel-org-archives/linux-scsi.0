From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: 21 Aug 2004 00:06:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093061216.2688.710.camel@mulgrave>
References: <1093053368.3318.569.camel@mulgrave>
	<4126BFCC.2000702@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3217 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268843AbUHUEG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 00:06:57 -0400
In-Reply-To: <4126BFCC.2000702@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-08-20 at 23:21, Jeff Garzik wrote:
> It seems to me that a more maintainable approach is to cache relevant 
> INQUIRY data in a buffer, and then create accessor macros for 
> programmers' use.
> 
> That way you don't have to keep adding members (really, mnemonics) to a 
> data structure, and associated initialization code, each time the 
> mid-layer or some low-level drivers want to test a new feature bit. 
> Initialization via memcpy is easy and automatic.

Actually, given the fact that we cache the inquiry data anyway, this
seems to be phenomenally easy to do.

James

===== include/scsi/scsi_device.h 1.19 vs edited =====
--- 1.19/include/scsi/scsi_device.h	2004-07-07 11:24:13 -05:00
+++ edited/include/scsi/scsi_device.h	2004-08-20 22:54:00 -05:00
@@ -191,5 +194,37 @@
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
+}
+
+/* accessor functions for the SCSI parameters */
+static inline int scsi_device_sync(struct scsi_device *sdev)
+{
+	return sdev->sdtr;
+}
+static inline int scsi_device_wide(struct scsi_device *sdev)
+{
+	return sdev->wdtr;
+}
+static inline int scsi_device_dt(struct scsi_device *sdev)
+{
+	return sdev->ppr;
+}
+static inline int scsi_device_dt_only(struct scsi_device *sdev)
+{
+	if (sdev->inquiry_len < 57)
+		return 0;
+	return (sdev->inquiry[56] & 0x0c) == 0x04;
+}
+static inline int scsi_device_ius(struct scsi_device *sdev)
+{
+	if (sdev->inquiry_len < 57)
+		return 0;
+	return sdev->inquiry[56] & 0x01;
+}
+static inline int scsi_device_qas(struct scsi_device *sdev)
+{
+	if (sdev->inquiry_len < 57)
+		return 0;
+	return sdev->inquiry[56] & 0x02;
 }
 #endif /* _SCSI_SCSI_DEVICE_H */

