From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] zfcp: Fix handling for boxed port after physical close
Date: Mon, 10 Mar 2008 16:18:54 +0100
Message-ID: <20080310152329.345181000@de.ibm.com>
References: <20080310151852.808020000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:39188 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYCJPXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 11:23:32 -0400
Content-Disposition: inline; filename=zfcp-phys-close-boxed.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When a FSF physical close returns the status boxed, this means that
another system already closed the port. For our system this is the
same status as in the good path, we have to send the normal close. So,
set the status for the boxed response to the same as for the good
status.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.git.orig/drivers/s390/scsi/zfcp_fsf.c
+++ linux-2.6.git/drivers/s390/scsi/zfcp_fsf.c
@@ -2968,6 +2968,13 @@ zfcp_fsf_close_physical_port_handler(str
 		zfcp_erp_port_boxed(port);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
+
+		/* can't use generic zfcp_erp_modify_port_status because
+		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
+		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
+		list_for_each_entry(unit, &port->unit_list_head, list)
+			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+					  &unit->status);
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:

-- 
