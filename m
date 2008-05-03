From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: On patch "Let scsi_cmnd->cmnd use request->cmd buffer"
Date: Sun, 4 May 2008 01:30:27 +0200 (CEST)
Message-ID: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37682 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbYECXcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 19:32:19 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

Commit 64a87b244b9297667ca80264aab849a36f494884 contains:
-------------------------- drivers/firewire/fw-sbp2.c --------------------------
index 2a99937..dda82f3 100644
@@ -1487,7 +1487,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
 		goto out;
 
-	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
+	memcpy(orb->request.command_block, cmd->cmnd, cmd->cmd_len);
 
 	orb->base.callback = complete_command_orb;
 	orb->base.request_bus =


Should drivers/ieee1394/sbp2.c::sbp2_create_command_orb() be changed in
the same way?
-- 
Stefan Richter
-=====-==--- -=-= --=--
http://arcgraph.de/sr/

