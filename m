From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: [Resend PATCH 1/3] scsi: sd: set valid return value in failed path
Date: Tue, 15 Jan 2013 13:31:31 +0800
Message-ID: <1358227893-31772-1-git-send-email-yan@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53347 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3AOFbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jan 2013 00:31:45 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Tue, 15 Jan 2013 15:25:32 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 3E2D82BB0050
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:37 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0F5Vage56557576
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:36 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0F5VaPB002211
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jan 2013 16:31:36 +1100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

Set valid return value to avoid returning 0 in a
failed path of sd_init().

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..181cd87 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3126,6 +3126,7 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = -ENOMEM;
 	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
-- 
1.7.9.5

