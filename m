From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/8] zfcp: fix mempool usage for status_read requests
Date: Tue, 04 Nov 2008 16:35:07 +0100
Message-ID: <20081104153627.530433000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62749 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYKDPgh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:36:37 -0500
Content-Disposition: inline; filename=fix-status-read-alloc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When allocating fsf requests without qtcb, store the pointer to the
mempool in the fsf requests for later call to mempool_free. This
codepath is only used by the status_read requests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-11-04 14:44:17.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-11-04 14:44:19.000000000 +0100
@@ -683,6 +683,7 @@ static struct zfcp_fsf_req *zfcp_fsf_all
 	if (!req)
 		return NULL;
 	memset(req, 0, sizeof(*req));
+	req->pool = pool;
 	return req;
 }
 

-- 
