From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/9] scsi_transport_fc: Enable new EH timeout handler
Date: Mon,  1 Jul 2013 16:24:31 +0200
Message-ID: <1372688671-85639-10-git-send-email-hare@suse.de>
References: <1372688671-85639-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab3GAOYj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 10:24:39 -0400
In-Reply-To: <1372688671-85639-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e106c27..1e1de9f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2079,7 +2079,7 @@ fc_timed_out(struct scsi_cmnd *scmd)
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
-	return BLK_EH_NOT_HANDLED;
+	return scsi_abort_command(scmd);
 }
 
 /*
-- 
1.7.12.4

