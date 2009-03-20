From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/5] ibmvfc: Fixup module parms attributes
Date: Fri, 20 Mar 2009 15:44:37 -0500
Message-ID: <200903202044.n2KKiVOC004363@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:54175 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZCTUoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2009 16:44:34 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2KKh7wC001767
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:43:07 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2KKiWH1176016
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:32 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2KKiWKk004380
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The ibmvfc driver really does not handle dynamically changing disc_threads.
To change this dynamically would cause confusion in the driver regarding
the number of event structs allocated. Fix this by simply not allowing
disc_threads to be changed at runtime.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_module_parm_fixups drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_module_parm_fixups	2009-03-02 13:13:22.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-18 08:48:42.000000000 -0500
@@ -75,7 +75,7 @@ MODULE_PARM_DESC(max_lun, "Maximum allow
 module_param_named(max_targets, max_targets, uint, S_IRUGO);
 MODULE_PARM_DESC(max_targets, "Maximum allowed targets. "
 		 "[Default=" __stringify(IBMVFC_MAX_TARGETS) "]");
-module_param_named(disc_threads, disc_threads, uint, S_IRUGO | S_IWUSR);
+module_param_named(disc_threads, disc_threads, uint, S_IRUGO);
 MODULE_PARM_DESC(disc_threads, "Number of device discovery threads to use. "
 		 "[Default=" __stringify(IBMVFC_MAX_DISC_THREADS) "]");
 module_param_named(debug, ibmvfc_debug, uint, S_IRUGO | S_IWUSR);
_
