From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] libfc: fix seconds_since_last_reset miscalculation
Date: Thu, 17 Nov 2016 13:39:27 +0100
Message-ID: <1479386367-63443-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934197AbcKQRNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 12:13:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Commit 540eb1eef 'scsi: libfc: fix seconds_since_last_reset calculation'
removed the use of 'struct timespec' from fc_get_host_stats(). This broke the
output of 'fcoeadm -s' after kernel 4.8-rc1.

Fixes: 540eb1eef ('scsi: libfc: fix seconds_since_last_reset calculation')
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/libfc/fc_lport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 04ce7cf..50c7167 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -308,7 +308,7 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	fc_stats = &lport->host_stats;
 	memset(fc_stats, 0, sizeof(struct fc_host_statistics));
 
-	fc_stats->seconds_since_last_reset = (lport->boot_time - jiffies) / HZ;
+	fc_stats->seconds_since_last_reset = (jiffies - lport->boot_time) / HZ;
 
 	for_each_possible_cpu(cpu) {
 		struct fc_stats *stats;
-- 
1.8.5.6

