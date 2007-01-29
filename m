From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH] - export scsilun_to_int
Date: Mon, 29 Jan 2007 09:40:22 -0700
Message-ID: <20070129164022.GA1867@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60373 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXA2Qjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:39:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

export symbol to be used in 1st fusion patch

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/scsi/scsi_scan.c a/drivers/scsi/scsi_scan.c
--- b/drivers/scsi/scsi_scan.c	2007-01-24 19:19:28.000000000 -0700
+++ a/drivers/scsi/scsi_scan.c	2007-01-28 12:42:12.000000000 -0700
@@ -1192,7 +1192,7 @@ static void scsi_sequential_lun_scan(str
  *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
  *     the integer: 0x0b030a04
  **/
-static int scsilun_to_int(struct scsi_lun *scsilun)
+int scsilun_to_int(struct scsi_lun *scsilun)
 {
 	int i;
 	unsigned int lun;
@@ -1203,6 +1203,7 @@ static int scsilun_to_int(struct scsi_lu
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
+EXPORT_SYMBOL(scsilun_to_int);
 
 /**
  * int_to_scsilun: reverts an int into a scsi_lun
diff -uarpN b/include/scsi/scsi_device.h a/include/scsi/scsi_device.h
--- b/include/scsi/scsi_device.h	2007-01-24 19:19:28.000000000 -0700
+++ a/include/scsi/scsi_device.h	2007-01-28 12:42:06.000000000 -0700
@@ -281,6 +281,7 @@ extern void scsi_target_block(struct dev
 extern void scsi_target_unblock(struct device *);
 extern void scsi_remove_target(struct device *);
 extern void int_to_scsilun(unsigned int, struct scsi_lun *);
+extern int scsilun_to_int(struct scsi_lun *scsilun);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
