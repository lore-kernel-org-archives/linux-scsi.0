From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/10] zfcp: Use memdup_user and kstrdup
Date: Fri, 16 Jul 2010 15:37:34 +0200
Message-ID: <20100716134259.870531000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60626 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965464Ab0GPNnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:01 -0400
Content-Disposition: inline; filename=704-zfcp-dup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use the functions memdup_user and kstrdup to allocate memory and copy
the data in one step, saving some lines of code.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |    4 +---
 drivers/s390/scsi/zfcp_cfdc.c |   12 +++---------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-07-15 12:21:48.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-07-15 12:22:18.000000000 +0200
@@ -98,13 +98,11 @@ static void __init zfcp_init_device_setu
 	u64 wwpn, lun;
 
 	/* duplicate devstr and keep the original for sysfs presentation*/
-	str_saved = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	str_saved = kstrdup(devstr, GFP_KERNEL);
 	str = str_saved;
 	if (!str)
 		return;
 
-	strcpy(str, devstr);
-
 	token = strsep(&str, ",");
 	if (!token || strlen(token) >= ZFCP_BUS_ID_SIZE)
 		goto err_out;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_cfdc.c linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c
--- linux-2.6/drivers/s390/scsi/zfcp_cfdc.c	2010-07-15 12:21:48.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_cfdc.c	2010-07-15 12:22:18.000000000 +0200
@@ -189,18 +189,12 @@ static long zfcp_cfdc_dev_ioctl(struct f
 	if (!fsf_cfdc)
 		return -ENOMEM;
 
-	data = kmalloc(sizeof(struct zfcp_cfdc_data), GFP_KERNEL);
-	if (!data) {
-		retval = -ENOMEM;
+	data = memdup_user(data_user, sizeof(*data_user));
+	if (IS_ERR(data)) {
+		retval = PTR_ERR(data);
 		goto no_mem_sense;
 	}
 
-	retval = copy_from_user(data, data_user, sizeof(*data));
-	if (retval) {
-		retval = -EFAULT;
-		goto free_buffer;
-	}
-
 	if (data->signature != 0xCFDCACDF) {
 		retval = -EINVAL;
 		goto free_buffer;

