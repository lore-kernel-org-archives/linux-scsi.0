From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] scsi_error: blank out reservation conflict printk
Date: Tue, 01 Jun 2010 11:19:18 +0200
Message-ID: <20100601091918.890EB2A3AD@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab0FAJTT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 05:19:19 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id AEF489417A
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2010 11:19:18 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


When using SCSI reservations a 'reservation conflict' error
is actually expected. So we should better use the normal
SCSI_LOG_XXX functions to make it configurable for those
cases where we're actually interested in the error.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a5d630f..def540d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1509,8 +1509,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		sdev_printk(KERN_INFO, scmd->device,
-			    "reservation conflict\n");
+		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, scmd->device,
+						"reservation conflict\n"));
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;
