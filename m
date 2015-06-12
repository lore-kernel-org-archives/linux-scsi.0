From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ipr: Byte swapping for device_id attribute in sysfs
Date: Thu, 11 Jun 2015 20:45:18 -0500
Message-ID: <201506120145.t5C1jIXa014812@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:56313 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbbFLBpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2015 21:45:22 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 11 Jun 2015 21:45:22 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 471F16E8047
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 21:37:07 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5C1jKlA60424216
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 01:45:20 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5C1jJAX014886
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 21:45:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, gbertazi@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


From: Wen Xiong <wenxiong@linux.vnet.ibm.com>

On LE system, users see the wrong device_id attribute. This patch
does necessary byte swapping for device_id attribute and works on
both of LE and BE systems.

Signed-off-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_device_id_swap drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_device_id_swap	2015-06-11 20:18:26.578563454 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-06-11 20:33:52.946558852 -0500
@@ -4449,7 +4449,7 @@ static ssize_t ipr_show_device_id(struct
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res && ioa_cfg->sis64)
-		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", res->dev_id);
+		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", be64_to_cpu(res->dev_id));
 	else if (res)
 		len = snprintf(buf, PAGE_SIZE, "0x%llx\n", res->lun_wwn);
 
_

