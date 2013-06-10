From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/9] scsi: move initialization of scmd->eh_entry
Date: Mon, 10 Jun 2013 09:40:50 +0200
Message-ID: <1370850058-27613-2-git-send-email-hare@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33748 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3FJHlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:02 -0400
In-Reply-To: <1370850058-27613-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

The 'eh_entry' list might be used even before scsi_softirq_done()
is called. Hence we should rather initialize it together with
the other eh-related variables.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 86d5220..c1774de 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -317,6 +317,8 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
+	INIT_LIST_HEAD(&cmd->eh_entry);
+	cmd->eh_eflags = 0;
 }
 
 void scsi_device_unbusy(struct scsi_device *sdev)
@@ -1482,8 +1484,6 @@ static void scsi_softirq_done(struct request *rq)
 	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
 	int disposition;
 
-	INIT_LIST_HEAD(&cmd->eh_entry);
-
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);
-- 
1.7.12.4

