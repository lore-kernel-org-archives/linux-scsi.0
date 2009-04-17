From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 14/15] zfcp: Reference counting for cfdc requests
Date: Fri, 17 Apr 2009 15:08:14 +0200
Message-ID: <20090417131123.660094000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:44037 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbZDQNL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:26 -0400
Content-Disposition: inline; filename=adapter-ref.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Before dropping the reference count with zfcp_adapter_put, increase it
with zfcp_adapter_get when issuing cfdc requests. 

Reviewed-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_cfdc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_cfdc.c	2009-04-17 15:03:18.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_cfdc.c	2009-04-17 15:03:56.000000000 +0200
@@ -4,7 +4,7 @@
  * Userspace interface for accessing the
  * Access Control Lists / Control File Data Channel
  *
- * Copyright IBM Corporation 2008
+ * Copyright IBM Corporation 2008, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -197,6 +197,7 @@ static long zfcp_cfdc_dev_ioctl(struct f
 		retval = -ENXIO;
 		goto free_buffer;
 	}
+	zfcp_adapter_get(adapter);
 
 	retval = zfcp_cfdc_sg_setup(data->command, fsf_cfdc->sg,
 				    data_user->control_file);

