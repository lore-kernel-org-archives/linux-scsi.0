From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/3] MidLayer updates - Add device io statistics
Date: Thu, 03 Feb 2005 22:03:12 -0600
Message-ID: <1107489792.5502.50.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C12EAB2@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:704 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269407AbVBDEDW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 23:03:22 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EAB2@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2005-01-29 at 09:03 -0500, James.Smart@Emulex.Com wrote:
>   Adds io statistics (requests, completions, error count) as generic
>   attributes for scsi devices.

I needed the attached to make this compile without warnings on ia64

James

===== drivers/scsi/scsi_sysfs.c 1.65 vs edited =====
--- 1.65/drivers/scsi/scsi_sysfs.c	2005-02-03 21:35:03 -06:00
+++ edited/drivers/scsi/scsi_sysfs.c	2005-02-03 21:59:14 -06:00
@@ -411,7 +411,7 @@
 static ssize_t
 show_iostat_counterbits(struct device *dev, char *buf)
 {
-	return snprintf(buf, 20, "%d\n", sizeof(atomic_t) * 8);
+	return snprintf(buf, 20, "%d\n", (int)sizeof(atomic_t) * 8);
 }
 
 static DEVICE_ATTR(iocounterbits, S_IRUGO, show_iostat_counterbits, NULL);
@@ -421,7 +421,7 @@
 show_iostat_##field(struct device *dev, char *buf)			\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	u64 count = (u64)atomic_read(&sdev->field);			\
+	unsigned long long count = atomic_read(&sdev->field);		\
 	return snprintf(buf, 20, "0x%llx\n", count);			\
 }									\
 static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)


