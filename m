From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [7/8] zfcp: fix module parameter parsing
Date: Mon, 13 Jun 2005 13:22:25 +0200
Message-ID: <20050613112225.GG8998@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:65501 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S261520AbVFMLWY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 07:22:24 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DBMNmf176936
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 11:22:23 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DBMN2H187832
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:22:23 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DBMMfW032043
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:22:23 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>

This is patch 7 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one fixes module parameter parsing for "device" parameter.
The original module parameter was changed while parsing it.
This corrupted the output in sysfs (/sys/module/zfcp/parameters/device).


Regards,

Andreas


From: Heiko Carstens <heiko.carstens@de.ibm.com>

zfcp: fix module parameter parsing

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_aux.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_aux.c	2005-06-11 22:58:05.130151824 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_aux.c	2005-06-11 23:35:23.913804976 +0200
@@ -218,13 +218,20 @@
  * Parse "device=..." parameter string.
  */
 static int __init
-zfcp_device_setup(char *str)
+zfcp_device_setup(char *devstr)
 {
-	char *tmp;
+	char *tmp, *str;
+	size_t len;
 
-	if (!str)
+	if (!devstr)
 		return 0;
 
+	len = strlen(devstr) + 1;
+	str = (char *) kmalloc(len, GFP_KERNEL);
+	if (!str)
+		goto err_out;
+	memcpy(str, devstr, len);
+
 	tmp = strchr(str, ',');
 	if (!tmp)
 		goto err_out;
@@ -241,10 +248,12 @@
 	zfcp_data.init_fcp_lun = simple_strtoull(tmp, &tmp, 0);
 	if (*tmp != '\0')
 		goto err_out;
+	kfree(str);
 	return 1;
 
  err_out:
 	ZFCP_LOG_NORMAL("Parse error for device parameter string %s\n", str);
+	kfree(str);
 	return 0;
 }
 

