From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 29/44] qla2xxx: use fc_bsg_to_rport() to access a bsg_job's rport
Date: Tue, 11 Oct 2016 13:29:00 +0200
Message-ID: <40f0d7def1fa3aeaeccb21b51c398070c6766427.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 109b852..917eafe 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -264,7 +264,7 @@ qla2x00_process_els(struct fc_bsg_job *bsg_job)
 	uint16_t nextlid = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+		rport = fc_bsg_to_rport(bsg_job);
 		fcport = *(fc_port_t **) rport->dd_data;
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
@@ -2485,7 +2485,7 @@ qla24xx_bsg_request(struct fc_bsg_job *bsg_job)
 	bsg_reply->reply_payload_rcv_len = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
-		rport = bsg_job->rport;
+		rport = fc_bsg_to_rport(bsg_job);
 		host = rport_to_shost(rport);
 		vha = shost_priv(host);
 	} else {
-- 
1.8.5.6
