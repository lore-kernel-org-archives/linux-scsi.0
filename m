From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/5] zfcp: Fix timer initialization for ct and els requests
Date: Tue, 13 Oct 2009 10:44:10 +0200
Message-ID: <20091013084946.045644000@de.ibm.com>
References: <20091013084406.630890000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:33570 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933682AbZJMIu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 04:50:26 -0400
Content-Disposition: inline; filename=715-zfcp-timer-init.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Add HZ since the start_timer function expects jiffies, not seconds.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-10-12 09:56:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-10-12 09:56:31.000000000 +0200
@@ -1079,7 +1079,7 @@ static int zfcp_fsf_setup_ct_els(struct 
 	/* common settings for ct/gs and els requests */
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.support.timeout = 2 * R_A_TOV;
-	zfcp_fsf_start_timer(req, 2 * R_A_TOV + 10);
+	zfcp_fsf_start_timer(req, (2 * R_A_TOV + 10) * HZ);
 
 	return 0;
 }

