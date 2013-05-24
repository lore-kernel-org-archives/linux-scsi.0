From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi: move initialization of scmd->eh_entry
Date: Fri, 24 May 2013 11:50:47 +0200
Message-ID: <1369389050-118628-2-git-send-email-hare@suse.de>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab3EXJux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 05:50:53 -0400
In-Reply-To: <1369389050-118628-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

The 'eh_entry' list might be used even before scsi_softirq_done()
is called. Hence we should rather initialize it together with
the other eh-related variables.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c31187d..a5515ec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -318,6 +318,8 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
+	INIT_LIST_HEAD(&cmd->eh_entry);
+	cmd->eh_eflags = 0;
 }
 
 void scsi_device_unbusy(struct scsi_device *sdev)
@@ -1483,8 +1485,6 @@ static void scsi_softirq_done(struct request *rq)
 	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
 	int disposition;
 
-	INIT_LIST_HEAD(&cmd->eh_entry);
-
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);
-- 
1.7.12.4

