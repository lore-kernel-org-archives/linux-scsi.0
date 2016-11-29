From: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen/scsifront: don't advance ring request pointer in case of error
Date: Tue, 29 Nov 2016 11:50:13 +0100
Message-ID: <20161129105013.7419-1-jgross@suse.com>
References: <20161125202650.GK6266@mwanda>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753243AbcK2Ku3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 05:50:29 -0500
In-Reply-To: <20161125202650.GK6266@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, lambert.quentin@gmail.com, linux-scsi@vger.kernel.org, dan.carpenter@oracle.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Juergen Gross <jgross@suse.com>

When allocating a new ring slot for a request don't advance the
producer index until the request is really ready to go to the backend.
Otherwise only partially filled requests will be visible to the
backend in case of errors on the frontend side.

In scsifront_action_handler() free the request id in case of an error.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
In case accepted I'll take this patch through the Xen tree as it is based
on another patch by lambert.quentin@gmail.com which is going through Xen, too.
---
 drivers/scsi/xen-scsifront.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index c01316c..33805f6 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -184,8 +184,6 @@ static struct vscsiif_request *scsifront_pre_req(struct vscsifrnt_info *info)
 
 	ring_req = RING_GET_REQUEST(&(info->ring), ring->req_prod_pvt);
 
-	ring->req_prod_pvt++;
-
 	ring_req->rqid = (uint16_t)id;
 
 	return ring_req;
@@ -196,6 +194,8 @@ static void scsifront_do_request(struct vscsifrnt_info *info)
 	struct vscsiif_front_ring *ring = &(info->ring);
 	int notify;
 
+	ring->req_prod_pvt++;
+
 	RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(ring, notify);
 	if (notify)
 		notify_remote_via_irq(info->irq);
@@ -626,6 +626,7 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	}
 
 	if (scsifront_enter(info)) {
+		scsifront_put_rqid(info, shadow->rqid);
 		spin_unlock_irq(host->host_lock);
 		kfree(shadow);
 		return FAILED;
-- 
2.10.2

