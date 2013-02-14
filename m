From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] sd: Do not return success from init_sd if DIF mempool allocation fails
Date: Thu, 14 Feb 2013 11:36:35 -0500
Message-ID: <1360859795-30448-3-git-send-email-emilne@redhat.com>
References: <1360859795-30448-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab3BNQgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2013 11:36:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1EGacbg026651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2013 11:36:38 -0500
Received: from emilne.csb (dhcp-185-251.bos.redhat.com [10.16.185.251])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r1EGabxa000379
	for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2013 11:36:38 -0500
In-Reply-To: <1360859795-30448-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

init_sd() was returning 0 if sd_cdb_cache or sd_cdb_pool could
not be allocated.  Return -ENOMEM instead, since the sd_disk_class
and the blkdevs will be unregistered if this happens.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8551f3e..4943a4f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2931,12 +2931,14 @@ static int __init init_sd(void)
 					 0, 0, NULL);
 	if (!sd_cdb_cache) {
 		printk(KERN_ERR "sd: can't init extended cdb cache\n");
+		err = -ENOMEM;
 		goto err_out_class;
 	}
 
 	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
 	if (!sd_cdb_pool) {
 		printk(KERN_ERR "sd: can't init extended cdb pool\n");
+		err = -ENOMEM;
 		goto err_out_cache;
 	}
 
-- 
1.7.11.7

