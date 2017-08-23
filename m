From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] scsi_transport_sas: Fix error handling in sas_smp_request()
Date: Wed, 23 Aug 2017 11:25:58 -0700
Message-ID: <20170823182558.15370-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42278 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932405AbdHWS0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 14:26:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org

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
index 5006a656e16a..a318c46db7cc 100644
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
+		WARN_ONCE(ret != 0 && !IS_ERR_VALUE(ret + 0UL),
+			  "%s: ret = %d\n", __func__, ret);
+		scsi_req(req)->result = ret ? DID_ERROR << 16 : 0;
 
 		blk_end_request_all(req, 0);
 
-- 
2.14.0
