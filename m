From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/5] zfcp: fix kfree handling in zfcp_init_device_setup
Date: Tue, 13 Oct 2009 10:44:07 +0200
Message-ID: <20091013084943.478223000@de.ibm.com>
References: <20091013084406.630890000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:46824 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbZJMIuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 04:50:23 -0400
Content-Disposition: inline; filename=705-zfcp-init-device-kfree.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The pointer that is allocated with kmalloc() is passed to strsep()
which modifies it. Later on the modified pointer value will be passed
to kfree. Save the original pointer and pass that one to kfree
instead.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-10-07 10:17:01.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-10-07 10:17:01.000000000 +0200
@@ -128,12 +128,13 @@ out_ccwdev:
 static void __init zfcp_init_device_setup(char *devstr)
 {
 	char *token;
-	char *str;
+	char *str, *str_saved;
 	char busid[ZFCP_BUS_ID_SIZE];
 	u64 wwpn, lun;
 
 	/* duplicate devstr and keep the original for sysfs presentation*/
-	str = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	str_saved = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	str = str_saved;
 	if (!str)
 		return;
 
@@ -152,12 +153,12 @@ static void __init zfcp_init_device_setu
 	if (!token || strict_strtoull(token, 0, (unsigned long long *) &lun))
 		goto err_out;
 
-	kfree(str);
+	kfree(str_saved);
 	zfcp_init_device_configure(busid, wwpn, lun);
 	return;
 
- err_out:
-	kfree(str);
+err_out:
+	kfree(str_saved);
 	pr_err("%s is not a valid SCSI device\n", devstr);
 }
 

