From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Retry ADD_TO_MLQUEUE return value for EH commands
Date: Thu, 17 Sep 2009 17:00:26 +0200
Message-ID: <20090917150026.B8692367F6@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbZIQPAY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2009 11:00:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


A target reset when I/O is ongoing might result
an eventual device offline, as scsi_eh_completed_normally()
might return ADD_TO_MLQUEUE in addition to the
advertised SUCCESS, FAILED, and NEEDS_RETRY.

Which is unfortunate as scsi_send_eh_cmnd() will
therefore map ADD_TO_MLQUEUE to FAILED instead of
the more appropriate NEEDS_RETRY.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 39ce3ab..dd6d344 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -793,6 +793,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 		case NEEDS_RETRY:
 		case FAILED:
 			break;
+		case ADD_TO_MLQUEUE:
+			rtn = NEEDS_RETRY;
+			break;
 		default:
 			rtn = FAILED;
 			break;
