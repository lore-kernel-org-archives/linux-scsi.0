From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Workaround for zero error blocks
Date: Mon, 6 Dec 2004 22:01:36 -0800
Message-ID: <20041206220136.0f8c1250@lembas.zaitcev.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36332 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261762AbULGGBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2004 01:01:44 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id iB761d35010308
	for <linux-scsi@vger.kernel.org>; Tue, 7 Dec 2004 01:01:44 -0500
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id iB761cr16125
	for <linux-scsi@vger.kernel.org>; Tue, 7 Dec 2004 01:01:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dledford@redhat.com
Cc: linux-scsi@vger.kernel.org, zaitcev@redhat.com

Doug & others:

I'd like to get comments on attached patch. Without it, doing
"dd if=/dev/scd0" produces a truncated image. Does it look sane?

Thanks,
-- Pete

P.S. Here's a device fingerprint in case it's a firmware bug and we want
to shame the vendor.

dmesg (INQUIRY):
  Vendor: CDWRITER  Model: IDE2410           Rev: A.23
  Type:   CD-ROM                             ANSI SCSI revision: 00

/proc/bus/usb/devices:
P:  Vendor=0c0b ProdID=b001 Rev=11.10
S:  Manufacturer=DMI
S:  Product=USB 2.0 Storage Adaptor
S:  SerialNumber=0B020142050D2A72


diff -urp -X dontdiff linux-2.6.10-rc2-bk8/drivers/scsi/sr.c linux-2.6.10-rc2-bk8-usb/drivers/scsi/sr.c
--- linux-2.6.10-rc2-bk8/drivers/scsi/sr.c	2004-11-16 17:03:18.000000000 -0800
+++ linux-2.6.10-rc2-bk8-usb/drivers/scsi/sr.c	2004-12-06 21:16:28.000000000 -0800
@@ -212,6 +212,35 @@ int sr_media_change(struct cdrom_device_
 	}
 	return retval;
 }
+
+/*
+ * This function allows to do "dd if=/dev/scd0 of=/tmp/image.bin" and get
+ * a non-truncated result which matches the burned ISO. The problem happens
+ * with a broken USB CD-ROM which does two things:
+ *  - reports the media size a few blocks bigger than recorded size
+ *  - reports sense with zero error block if we read across the end of media
+ */
+static void correct_zero_error_sector(long *error_sector, struct scsi_cmnd *SCpnt)
+{
+	unsigned int cmd_block;
+	unsigned int cmd_len, resid_len;
+
+	if (SCpnt->cmnd[0] != READ_6 && SCpnt->cmnd[0] != READ_10)
+		return;
+
+	/* Do not touch anything that is not a CD-ROM */
+	if (SCpnt->device->sector_size != 2048)
+		return;
+
+	cmd_block = SCpnt->request->sector >> 2;
+	cmd_len = SCpnt->request_bufflen >> 11;
+
+	resid_len = SCpnt->resid >> 11;
+	if (resid_len == 0 || resid_len >= cmd_len)
+		return;
+
+	*error_sector = cmd_block + (cmd_len - resid_len);
+}
  
 /*
  * rw_intr is the interrupt routine for the device driver.
@@ -252,6 +281,8 @@ static void rw_intr(struct scsi_cmnd * S
 				(SCpnt->sense_buffer[4] << 16) |
 				(SCpnt->sense_buffer[5] << 8) |
 				SCpnt->sense_buffer[6];
+			if (error_sector == 0)
+				correct_zero_error_sector(&error_sector, SCpnt);
 			if (SCpnt->request->bio != NULL)
 				block_sectors =
 					bio_sectors(SCpnt->request->bio);
