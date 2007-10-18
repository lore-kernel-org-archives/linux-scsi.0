From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/4] qla1280,qla2xxx: Remove display of transfersize
Date: Thu, 18 Oct 2007 04:46:14 -0400
Message-ID: <1192697175160-git-send-email-matthew@wil.cx>
References: <1192697175888-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58067 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbXJRIpy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 04:45:54 -0400
In-Reply-To: <1192697175888-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

As part of their debug routines, both of these drivers print out the
transfersize.  That's just unnecessary, particularly since neither driver
actually uses it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/qla1280.c         |    4 +---
 drivers/scsi/qla2xxx/qla_dbg.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index bf07b17..d319ae8 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4025,11 +4025,9 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	for (i = 0; i < cmd->cmd_len; i++) {
 		printk("0x%02x ", cmd->cmnd[i]);
 	}
-	printk("  seg_cnt =%d\n", scsi_sg_count(cmd));
+	printk("  seg_cnt=%d, tag=%d\n", scsi_sg_count(cmd), cmd->tag);
 	printk("  request buffer=0x%p, request buffer len=0x%x\n",
 	       scsi_sglist(cmd), scsi_bufflen(cmd));
-	printk("  tag=%d, transfersize=0x%x \n",
-	       cmd->tag, cmd->transfersize);
 	printk("  Pid=%li, SP=0x%p\n", cmd->serial_number, CMD_SP(cmd));
 	printk(" underflow size = 0x%x, direction=0x%x\n",
 	       cmd->underflow, cmd->sc_data_direction);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index eaa04da..11b437e 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1417,8 +1417,7 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd)
 	       scsi_sg_count(cmd), cmd->allowed, cmd->retries);
 	printk("  request buffer=0x%p, request buffer len=0x%x\n",
 	       scsi_sglist(cmd), scsi_bufflen(cmd));
-	printk("  tag=%d, transfersize=0x%x\n",
-	    cmd->tag, cmd->transfersize);
+	printk("  tag=%d\n", cmd->tag);
 	printk("  serial_number=%lx, SP=%p\n", cmd->serial_number, sp);
 	printk("  data direction=%d\n", cmd->sc_data_direction);
 
-- 
1.4.4.2

