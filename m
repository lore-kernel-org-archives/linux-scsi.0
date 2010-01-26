From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH] scsi: zero scsi cmd result in scsi_init_cmd_errh
Date: Tue, 26 Jan 2010 12:57:32 -0800
Message-ID: <20100126205532.24221.74180.stgit@desktop-andmike.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:37678 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0AZU5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 15:57:42 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o0QKsQXB031211
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2010 13:54:26 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0QKvYDm067876
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2010 13:57:36 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o0QKvXwW002276
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2010 13:57:34 -0700
Received: from desktop-andmike.beaverton.ibm.com (desktop-andmike.beaverton.ibm.com [9.47.22.92])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o0QKvXsJ002247
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2010 13:57:33 -0700
Received: from desktop-andmike.beaverton.ibm.com (localhost [IPv6:::1])
	by desktop-andmike.beaverton.ibm.com (Postfix) with ESMTP id 15DC7D5CAF1
	for <linux-scsi@vger.kernel.org>; Tue, 26 Jan 2010 12:57:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch zeros the command result in scsi_init_cmd_errh to ensure that
the scsi command result is zero prior to starting the command as the
command could have previously had a non-zero result if the command has
been requeued. In a timeout case that exhausts retries this previous
non-zero result value can lead to incorrect final status not being set to
timeout in scsi_eh_flush_done_q which may lead to incorrect status being
conveyed to command originator or others viewing the result field.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---

Debug:
Added a debug flag to track result being dirty (DRIVER_RES_DIRTY). Set and
checked for dirty flag already set in scsi_queue_insert.

On timeout case received:
kernel: [42236.341626] scsi_queue_insert: Cmd ffff8800379ab080, result dirty 9


 drivers/scsi/scsi_lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d892768..25e5a6c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -295,6 +295,7 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
+	cmd->result = 0;
 }
 
 void scsi_device_unbusy(struct scsi_device *sdev)

