From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] zfcp: prevent double decrement on host_busy while being busy
Date: Thu, 27 Nov 2008 11:44:07 +0100
Message-ID: <20081127104636.259206000@de.ibm.com>
References: <20081127104406.090179000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34205 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213AbYK0Kqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2008 05:46:39 -0500
Content-Disposition: inline; filename=711-zfcp-decrement.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The zfcp_scsi_queuecommand was not acting according to the standard
when the respective unit was not available. In this case an -EBUSY was
returned, which is not valid in itself, and in addition scsi_done
was called. This combination is not allowed and was leading to a
double finish of the request and therefor double decrement of the
host_busy counter.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-11-26 17:21:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-11-27 10:58:30.000000000 +0100
@@ -88,7 +88,7 @@ static int zfcp_scsi_queuecommand(struct
 	ret = zfcp_fsf_send_fcp_command_task(adapter, unit, scpnt, 0,
 					     ZFCP_REQ_AUTO_CLEANUP);
 	if (unlikely(ret == -EBUSY))
-		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
+		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else if (unlikely(ret < 0))
 		return SCSI_MLQUEUE_HOST_BUSY;
 

-- 
