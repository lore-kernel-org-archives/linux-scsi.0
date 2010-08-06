From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] make error handling robust in the face of reservations
Date: Fri, 06 Aug 2010 15:17:24 -0500
Message-ID: <1281125844.6245.109.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0HFURa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 16:17:30 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 91DCA5362F
	for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2010 22:17:29 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

There's a curious case where devices in clusters are offlining if they
go into error handling.  The reason is that in this particular cluster,
Test Unit Ready gets a RESERVATION CONFLICT return when another node
owns the storage.  This means that all TURs that error handling use are
marked failed, so we always assume the device is unrecoverable and take
it offline.

Fix this by checking in the error handling code processing returns to
see if the command was a TUR and translate the EH return to SUCCESS
(after all, if the target managed to return RESERVATION CONFLICT, we've
successfully made contact with it).

James

---
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2bf9846..5e2d36f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -473,10 +473,12 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 */
 		return SUCCESS;
 	case RESERVATION_CONFLICT:
-		/*
-		 * let issuer deal with this, it could be just fine
-		 */
-		return SUCCESS;
+		if (scmd->cmnd[0] == TEST_UNIT_READY)
+			/* it is a success, we probed the device and
+			 * found it */
+			return SUCCESS;
+		/* otherwise, we failed to send the command */
+		return FAILED;
 	case QUEUE_FULL:
 		scsi_handle_queue_full(scmd->device);
 		/* fall through */


