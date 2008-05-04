From: matthias@kaehlcke.net
Subject: [patch 1/2] QLA2xxx: Convert qla_fw_lock in a mutex
Date: Sun, 04 May 2008 20:46:00 +0200
Message-ID: <20080504184600.184485929@kaehlcke.net>
References: <20080504184559.243525572@kaehlcke.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:39007 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbYEDTZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2008 15:25:52 -0400
Content-Disposition: inline; filename=scsi-qla2xxx-qla_fw_lock-to-mutex.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Matthias Kaehlcke <matthias@kaehlcke.net>

QLA2XXX driver: The semaphore qla_fw_lock is used as a mutex. 
Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_os.c	2008-05-04 20:17:57.000000000 +0200
+++ linux-2.6/drivers/scsi/qla2xxx/qla_os.c	2008-05-04 20:18:04.000000000 +0200
@@ -2640,7 +2640,7 @@
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
 
-static DECLARE_MUTEX(qla_fw_lock);
+static DEFINE_MUTEX(qla_fw_lock);
 
 static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP21XX, .segs = { 0x1000, 0 }, },
@@ -2671,7 +2671,7 @@
 		blob = &qla_fw_blobs[FW_ISP25XX];
 	}
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	if (blob->fw)
 		goto out;
 
@@ -2684,7 +2684,7 @@
 	}
 
 out:
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 	return blob;
 }
 
@@ -2693,11 +2693,11 @@
 {
 	int idx;
 
-	down(&qla_fw_lock);
+	mutex_lock(&qla_fw_lock);
 	for (idx = 0; idx < FW_BLOBS; idx++)
 		if (qla_fw_blobs[idx].fw)
 			release_firmware(qla_fw_blobs[idx].fw);
-	up(&qla_fw_lock);
+	mutex_unlock(&qla_fw_lock);
 }
 
 static pci_ers_result_t

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
