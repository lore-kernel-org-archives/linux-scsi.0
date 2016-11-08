From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] libfc: fix seconds_since_last_reset miscalculation
Date: Tue,  8 Nov 2016 09:44:54 +0100
Message-ID: <1478594694-98847-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Commit 540eb1eef 'scsi: libfc: fix seconds_since_last_reset calculation'
removed the use of 'struct timespec' from fc_get_host_stats(). This broke the
output of 'fcoeadm -s' after kernel 4.8-rc1 as lport->boot_time - jiffies
could become negative as in this example:

$ cat /sys/class/fc_host/host8/statistics/seconds_since_last_reset 
0x10624dd2f1977b4

Take this into account so
/sys/class/fc_host/hostX/statistics/seconds_since_last_reset is sane again.

Fixes: 540eb1eef ('scsi: libfc: fix seconds_since_last_reset calculation')
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Holger Schranz <holger@fam-schranz.de>
---
 drivers/scsi/libfc/fc_lport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 04ce7cf..475c0a9 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -304,11 +304,15 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	unsigned int cpu;
 	u64 fcp_in_bytes = 0;
 	u64 fcp_out_bytes = 0;
+	unsigned long boot_time = lport->boot_time;
 
 	fc_stats = &lport->host_stats;
 	memset(fc_stats, 0, sizeof(struct fc_host_statistics));
 
-	fc_stats->seconds_since_last_reset = (lport->boot_time - jiffies) / HZ;
+	if (boot_time > jiffies)
+		fc_stats->seconds_since_last_reset = (boot_time - jiffies) / HZ;
+	else
+		fc_stats->seconds_since_last_reset = (jiffies - boot_time) / HZ;
 
 	for_each_possible_cpu(cpu) {
 		struct fc_stats *stats;
-- 
1.8.5.6
