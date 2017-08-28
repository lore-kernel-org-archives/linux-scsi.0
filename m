From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v3 3/3] scsi_transport_sas: Fix error handling in sas_smp_request()
Date: Mon, 28 Aug 2017 13:41:49 -0700
Message-ID: <20170828204149.28693-8-bart.vanassche@wdc.com>
References: <20170828204149.28693-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9307 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1UoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2017 16:44:17 -0400
In-Reply-To: <20170828204149.28693-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org

sas_function_template.smp_handler implementations either return
0 or a Unix error code. Convert that error code into a SCSI
result. This patch is what I came up with after having analyzed
the following sparse warnings:

drivers/scsi/scsi_transport_sas.c:187:21: warning: incorrect type in assignment (different base types)
drivers/scsi/scsi_transport_sas.c:187:21:    expected restricted blk_status_t [usertype] ret
drivers/scsi/scsi_transport_sas.c:187:21:    got int
drivers/scsi/scsi_transport_sas.c:188:39: warning: incorrect type in assignment (different base types)
drivers/scsi/scsi_transport_sas.c:188:39:    expected int [signed] result
drivers/scsi/scsi_transport_sas.c:188:39:    got restricted blk_status_t [usertype] ret

Fixes: commit 17d5363b83f8 ("scsi: introduce a result field in struct scsi_request")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_transport_sas.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index e2e948f1ce28..6c05fd9a0be5 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -173,7 +173,7 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 			    struct sas_rphy *rphy)
 {
 	struct request *req;
-	blk_status_t ret;
+	int ret;
 	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 
 	while ((req = blk_fetch_request(q)) != NULL) {
@@ -185,7 +185,9 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 				blk_rq_bytes(req->next_rq);
 		handler = to_sas_internal(shost->transportt)->f->smp_handler;
 		ret = handler(shost, rphy, req);
-		scsi_req(req)->result = ret;
+		WARN_ONCE(ret != 0 && !IS_ERR_VALUE((uintptr_t)ret),
+			  "%s: ret = %d\n", __func__, ret);
+		scsi_req(req)->result = ret ? DID_ERROR << 16 : 0;
 
 		blk_end_request_all(req, 0);
 
-- 
2.14.1
