From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [PATCH 1/3] scsi: sd: set valid return value in init_sd()
Date: Fri, 23 Nov 2012 11:06:45 +0800
Message-ID: <1353640007-12834-1-git-send-email-yan@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35671 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923Ab2KWDG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2012 22:06:58 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Fri, 23 Nov 2012 13:02:35 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qAN2u8UK4325744
	for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 13:56:09 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qAN36oSE030149
	for <linux-scsi@vger.kernel.org>; Fri, 23 Nov 2012 14:06:50 +1100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

init_sd() forgets to set error code when we fail to create slab
cache, thus return 0 in a failed path. Return ENOMEM in this case.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 352bc77..4cc277d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3120,6 +3120,7 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out_class;
 
+	err = -ENOMEM;
 	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
-- 
1.7.9.5

