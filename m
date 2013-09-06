From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/18] lpfc 8.3.42: Fixed logging format of setting driver
 sysfs attributes hard to interpret
Date: Fri, 6 Sep 2013 12:20:20 -0400
Message-ID: <1378484420.14051.28.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22342 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IFQU6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:20:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed logging format of setting driver sysfs attributes hard to interpret


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-09-06 10:04:15.825058574 -0400
@@ -1865,8 +1865,10 @@ lpfc_##attr##_set(struct lpfc_vport *vpo
 { \
 	if (val >= minval && val <= maxval) {\
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT, \
-			"3053 lpfc_" #attr " changed from %d to %d\n", \
-			vport->cfg_##attr, val); \
+			"3053 lpfc_" #attr \
+			" changed from %d (x%x) to %d (x%x)\n", \
+			vport->cfg_##attr, vport->cfg_##attr, \
+			val, val); \
 		vport->cfg_##attr = val;\
 		return 0;\
 	}\



