From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/3] zfcp: add missing compat ptr conversion
Date: Wed, 13 Jan 2010 17:52:38 +0100
Message-ID: <20100113165513.637868000@de.ibm.com>
References: <20100113165235.299592000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:37431 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0AMQzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 11:55:15 -0500
Content-Disposition: inline; filename=705-zfcp-compat-ptr.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_cfdc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_cfdc.c	2010-01-13 17:41:07.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_cfdc.c	2010-01-13 17:45:39.000000000 +0100
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/miscdevice.h>
+#include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include "zfcp_def.h"
 #include "zfcp_ext.h"
@@ -163,7 +164,7 @@ static void zfcp_cfdc_req_to_sense(struc
 }
 
 static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
-				unsigned long buffer)
+				unsigned long arg)
 {
 	struct zfcp_cfdc_data *data;
 	struct zfcp_cfdc_data __user *data_user;
@@ -175,7 +176,11 @@ static long zfcp_cfdc_dev_ioctl(struct f
 	if (command != ZFCP_CFDC_IOC)
 		return -ENOTTY;
 
-	data_user = (void __user *) buffer;
+	if (is_compat_task())
+		data_user = compat_ptr(arg);
+	else
+		data_user = (void __user *)arg;
+
 	if (!data_user)
 		return -EINVAL;
 

