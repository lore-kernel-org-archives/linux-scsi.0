From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Return NEEDS_RETRY for eh commands with status BUSY
Date: Thu, 29 Jul 2010 10:10:16 +0200
Message-ID: <20100729081016.985AC2A3A6@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0G2IKR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 04:10:17 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id AB7F88726A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2010 10:10:16 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


When the transport is busy and we're sending an EH command drivers
occasionally return 'BUSY'. As this in most cases is the TUR
command sent as part of the error recovery this is a sure way
to make the error recovery escalate. Returning 'NEEDS_RETRY'
here will just retry the TUR command and eventually abort the
original command, thus making error handling far smoother.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 225d221..41266ec 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -544,6 +544,7 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		scsi_handle_queue_full(scmd->device);
 		/* fall through */
 	case BUSY:
+		return NEEDS_RETRY;
 	default:
 		return FAILED;
 	}
