From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 3/4] Show .retries and .jiffies_at_alloc in debugfs
Date: Wed, 30 Aug 2017 16:58:41 -0700
Message-ID: <20170830235842.29725-4-bart.vanassche@wdc.com>
References: <20170830235842.29725-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2692 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdH3X76 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 19:59:58 -0400
In-Reply-To: <20170830235842.29725-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

Make these two member variables available in debugfs such that
their value can be verified by kernel developers. An example of
the new output:

ffff8804a513d480 {.op=READ, .cmd_flags=META|PRIO, .rq_flags=MQ_INFLIGHT|DONTPREP|IO_STAT|STATS, .atomic_flags=STARTED, .tag=17, .internal_tag=-1, .cmd=Read(10) 28 00 08 81 32 38 00 00 08 00, .retries=0, allocated 0.010 s ago}

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index a97c9507103d..5e9755008aed 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -6,8 +6,10 @@
 void scsi_show_rq(struct seq_file *m, struct request *rq)
 {
 	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
+	int msecs = jiffies_to_msecs(jiffies - cmd->jiffies_at_alloc);
 	char buf[80];
 
 	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
-	seq_printf(m, ", .cmd=%s", buf);
+	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s ago", buf,
+		   cmd->retries, msecs / 1000, msecs % 1000);
 }
-- 
2.14.1
