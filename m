From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/9] mpt2sas: Enable new EH timeout handler
Date: Thu, 29 Aug 2013 15:32:18 +0200
Message-ID: <1377783140-57191-8-git-send-email-hare@suse.de>
References: <1377783140-57191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab3H2NcY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 09:32:24 -0400
In-Reply-To: <1377783140-57191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 389d792..066e36c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2569,6 +2569,16 @@ _scsih_tm_display_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 }
 
 /**
+ * _scsih_timed_out - eh timeout handler
+ * @scmd: pointer to scsi command object
+ */
+static enum blk_eh_timer_return
+_scsih_timed_out(struct scsi_cmnd *scmd)
+{
+	return scsi_abort_command(scmd);
+}
+
+/**
  * _scsih_abort - eh threads main abort routine
  * @scmd: pointer to scsi command object
  *
@@ -7628,8 +7638,9 @@ static struct scsi_host_template scsih_driver_template = {
 	.slave_destroy			= _scsih_slave_destroy,
 	.scan_finished			= _scsih_scan_finished,
 	.scan_start			= _scsih_scan_start,
-	.change_queue_depth 		= _scsih_change_queue_depth,
+	.change_queue_depth		= _scsih_change_queue_depth,
 	.change_queue_type		= _scsih_change_queue_type,
+	.eh_timed_out			= _scsih_timed_out,
 	.eh_abort_handler		= _scsih_abort,
 	.eh_device_reset_handler	= _scsih_dev_reset,
 	.eh_target_reset_handler	= _scsih_target_reset,
-- 
1.7.12.4

