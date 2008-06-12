From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [RFC] Set functions for scsi_cmnd result
Date: Thu, 12 Jun 2008 11:29:57 +0200
Message-ID: <20080612092955.GA9032@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:35813 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYFLJaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 05:30:09 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m5C9TxWh216108
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 09:29:59 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5C9TwQk1679596
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 10:29:58 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5C9TwQu004221
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 10:29:58 +0100
Received: from localhost (schmichrtp.mainz.de.ibm.com [9.155.23.50])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m5C9TvqF004203
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2008 10:29:57 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

zfcp currently has helper functions to set the host and driver bytes
in the scsi_cmnd result. These functions do not belong in the
low-level driver. The attached patch moves the functions to the global
SCSI header file, so that every driver can use them.

If nobody wants ths, i will remove them from zfcp and directly
manipulate the status like other drivers do.

---
 drivers/s390/scsi/zfcp_scsi.c |   20 --------------------
 include/scsi/scsi.h           |   10 ++++++++++
 2 files changed, 10 insertions(+), 20 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-12 11:00:16.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-12 11:06:37.000000000 +0200
@@ -107,27 +107,7 @@ zfcp_set_fcp_dl(struct fcp_cmnd_iu *fcp_
 	*zfcp_get_fcp_dl_ptr(fcp_cmd) = fcp_dl;
 }
 
-/*
- * note: it's a bit-or operation not an assignment
- * regarding the specified byte
- */
-static inline void
-set_byte(int *result, char status, char pos)
-{
-	*result |= status << (pos * 8);
-}
 
-void
-set_host_byte(int *result, char status)
-{
-	set_byte(result, status, 2);
-}
-
-void
-set_driver_byte(int *result, char status)
-{
-	set_byte(result, status, 3);
-}
 
 static int
 zfcp_scsi_slave_alloc(struct scsi_device *sdp)
--- a/include/scsi/scsi.h	2008-06-10 17:30:49.000000000 +0200
+++ b/include/scsi/scsi.h	2008-06-12 11:06:34.000000000 +0200
@@ -425,6 +425,16 @@ struct scsi_lun {
 #define driver_byte(result) (((result) >> 24) & 0xff)
 #define suggestion(result)  (driver_byte(result) & SUGGEST_MASK)
 
+static inline void set_host_byte(int *result, char status)
+{
+	*result |= status << 16;
+}
+
+static inline void set_driver_byte(int *result, char status)
+{
+	*result |= status << 24;
+}
+
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
 #define sense_error(sense)  ((sense) & 0xf)
 #define sense_valid(sense)  ((sense) & 0x80);
