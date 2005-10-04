From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_sas: fix compat ioctl handling
Date: Tue, 4 Oct 2005 20:40:00 +0200
Message-ID: <20051004184000.GA17168@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49567 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964908AbVJDSkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 14:40:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com
Cc: linux-scsi@vger.kernel.org

MEGASAS_IOC_FIRMWARE can't be redefined if CONFIG_COMPAT is set, we
need to define a MEGASAS_IOC_FIRMWARE32 define so native binaries
continue to work.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2005-10-04 20:22:11.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2005-10-04 20:29:14.000000000 +0200
@@ -2615,9 +2615,8 @@
 			  unsigned long arg)
 {
 	switch (cmd) {
-	case MEGASAS_IOC_FIRMWARE:{
-			return megasas_mgmt_compat_ioctl_fw(file, arg);
-		}
+	case MEGASAS_IOC_FIRMWARE32:
+		return megasas_mgmt_compat_ioctl_fw(file, arg);
 	case MEGASAS_IOC_GET_AEN:
 		return megasas_mgmt_ioctl_aen(file, arg);
 	}
Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.h
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.h	2005-10-04 20:07:32.000000000 +0200
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.h	2005-10-04 20:28:27.000000000 +0200
@@ -1124,12 +1124,10 @@
 	} frame;
 	struct compat_iovec sgl[MAX_IOCTL_SGE];
 } __attribute__ ((packed));
-
-#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct compat_megasas_iocpacket)
-#else
-#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
 #endif
 
+#define MEGASAS_IOC_FIRMWARE	_IOWR('M', 1, struct megasas_iocpacket)
+#define MEGASAS_IOC_FIRMWARE32	_IOWR('M', 1, struct compat_megasas_iocpacket)
 #define MEGASAS_IOC_GET_AEN	_IOW('M', 3, struct megasas_aen)
 
 struct megasas_mgmt_info {
