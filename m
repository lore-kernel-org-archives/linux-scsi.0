From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/9] libsas: Enable new EH timeout handler
Date: Thu, 29 Aug 2013 15:32:16 +0200
Message-ID: <1377783140-57191-6-git-send-email-hare@suse.de>
References: <1377783140-57191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3H2NcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 09:32:25 -0400
In-Reply-To: <1377783140-57191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index da3aee1..6eb2f0c 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -864,7 +864,7 @@ enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
 {
 	scmd_printk(KERN_DEBUG, cmd, "command %p timed out\n", cmd);
 
-	return BLK_EH_NOT_HANDLED;
+	return scsi_abort_command(cmd);
 }
 
 int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
-- 
1.7.12.4

