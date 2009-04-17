From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/15] zfcp: Let actcli handle control file errors
Date: Fri, 17 Apr 2009 15:08:09 +0200
Message-ID: <20090417131122.999486000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:44019 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbZDQNLZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:25 -0400
Content-Disposition: inline; filename=709-zfcp-actcli-errors.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Error codes specific to the control file requests are evaluated by the
actcli tool, so don't report -ENXIO for those. Generic problems are
still checked for outside the command specific handler.

Reviewed-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:44.000000000 +0200
@@ -2479,8 +2479,6 @@ out:
 
 static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *req)
 {
-	if (req->qtcb->header.fsf_status != FSF_GOOD)
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
 /**

