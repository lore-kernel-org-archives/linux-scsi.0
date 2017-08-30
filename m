From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 3/3] Show .retries and .jiffies_at_alloc in debugfs
Date: Tue, 29 Aug 2017 17:07:42 -0700
Message-ID: <20170830000742.29653-4-bart.vanassche@wdc.com>
References: <20170830000742.29653-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37711 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751744AbdH3AJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 20:09:30 -0400
In-Reply-To: <20170830000742.29653-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

Make these two member variables available in debugfs such that
their value can be verified by kernel developers. An example of
the new output from a system with CONFIG_HZ=100:

ffff8804a41ed480 {.op=READ, .cmd_flags=META|PRIO, .rq_flags=MQ_INFLIGHT|IO_STAT, .atomic_flags=COMPLETE, .tag=17, .internal_tag=-1, .cmd=Read(10) 28 00 09 01 1f a0 00 00 08 00, .retries=0, .jiffies_at_alloc=-25647}

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index a97c9507103d..282834935e07 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -9,5 +9,6 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 	char buf[80];
 
 	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);
-	seq_printf(m, ", .cmd=%s", buf);
+	seq_printf(m, ", .cmd=%s, .retries=%d, .jiffies_at_alloc=%ld", buf,
+		   cmd->retries, cmd->jiffies_at_alloc - jiffies);
 }
-- 
2.14.1
