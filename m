From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/9] mptsas: Enable new EH timeout handler
Date: Mon, 10 Jun 2013 09:40:56 +0200
Message-ID: <1370850058-27613-8-git-send-email-hare@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933Ab3FJHlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:04 -0400
In-Reply-To: <1370850058-27613-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptsas.c   | 1 +
 drivers/message/fusion/mptscsih.c | 7 +++++++
 drivers/message/fusion/mptscsih.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index dd239bd..ed56434 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1987,6 +1987,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.target_destroy			= mptsas_target_destroy,
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
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

