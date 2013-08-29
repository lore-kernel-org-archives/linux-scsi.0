From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/9] mptsas: Enable new EH timeout handler
Date: Thu, 29 Aug 2013 15:32:17 +0200
Message-ID: <1377783140-57191-7-git-send-email-hare@suse.de>
References: <1377783140-57191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab3H2NcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 09:32:25 -0400
In-Reply-To: <1377783140-57191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptsas.c   | 3 ++-
 drivers/message/fusion/mptscsih.c | 7 +++++++
 drivers/message/fusion/mptscsih.h | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index dd239bd..b3c87b2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1986,7 +1986,8 @@ static struct scsi_host_template mptsas_driver_template = {
 	.slave_configure		= mptsas_slave_configure,
 	.target_destroy			= mptsas_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
-	.change_queue_depth 		= mptscsih_change_queue_depth,
+	.change_queue_depth		= mptscsih_change_queue_depth,
+	.eh_timed_out			= mptscsih_timed_out,
 	.eh_abort_handler		= mptscsih_abort,
 	.eh_device_reset_handler	= mptscsih_dev_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..e743e84 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1679,6 +1679,13 @@ mptscsih_get_tm_timeout(MPT_ADAPTER *ioc)
 	}
 }
 
+enum blk_eh_timer_return
+mptscsih_timed_out(struct scsi_cmnd *SCpnt)
+{
+	return scsi_abort_command(SCpnt);
+}
+EXPORT_SYMBOL(mptscsih_timed_out);
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_abort - Abort linux scsi_cmnd routine, new_eh variant
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 83f5031..3f2dd05 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -118,6 +118,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 	u8 id, int lun, int ctx2abort, ulong timeout);
 extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
+enum blk_eh_timer_return mptscsih_timed_out(struct scsi_cmnd *SCpnt);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
-- 
1.7.12.4

