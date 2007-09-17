From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 1/1] stale residual returned on write following BUSY retry
Date: Mon, 17 Sep 2007 15:11:39 -0700
Message-ID: <46EEFB9B.7050108@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060704080004090006080902"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35876 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760796AbXIQWKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 18:10:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Kevan Rehm <kfr@sgi.com>, James Bottomley <James.Bottomley@SteelEye.com>

This is a multi-part message in MIME format.
--------------060704080004090006080902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

A BUSY status returned on a write request results in a stale residual
being returned when the write ultimately successfully completes.

This can be reproduced as follows:

1) issue immediate mode rewind to scsi tape drive
2) issue write request

The tape drive returns busy.  The low level driver detects underrun and
sets the residual into the scsi command.  The low level driver responds
with (DID_OK << 16) | scsi_status.  scsi_status is 8, hence
status_byte(result) == 4, i.e., BUSY.

scsi_softirq_done() calls scsi_decide_disposition() which returns
ADD_TO_MLQUEUE.  scsi_softirq_done() then calls scsi_queue_insert()
which, on the way to resubmitting the request to the driver, calls
scsi_init_cmd_errh().

The attached patch modifies scsi_init_cmd_errh() to clear the resid
field.  This prevents a "stale" residual from being returned when the
scsi command finally completes without a BUSY status.

This patch applies to 2.6.23-rc6-git7.

Signed-off-by: Michael Reed <mdr@sgi.com>



--------------060704080004090006080902
Content-Type: text/x-patch;
 name="residual.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="residual.patch"

--- linux-2.6.23-rc6-git7.orig/drivers/scsi/scsi_lib.c	2007-09-17 14:02:03.000000000 -0700
+++ linux-2.6.23-rc6-git7/drivers/scsi/scsi_lib.c	2007-09-17 14:05:51.000000000 -0700
@@ -443,6 +443,7 @@ EXPORT_SYMBOL_GPL(scsi_execute_async);
 static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = 0;
+	cmd->resid = 0;
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
 	if (cmd->cmd_len == 0)
 		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);

--------------060704080004090006080902--
