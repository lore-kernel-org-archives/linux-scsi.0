From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 03/44] zfcp: don't use fc_bsg_job::request and fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:34 +0200
Message-ID: <53a42af175ac34e3267aac3f30b4e839498ac44a.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752895AbcJKL3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 07:29:25 -0400
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/s390/scsi/zfcp_fc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 237688a..4c4023f 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -900,8 +900,9 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 	u32 preamble_word1;
 	u8 gs_type;
 	struct zfcp_adapter *adapter;
+	struct fc_bsg_request *bsg_request = job->request;
 
-	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
+	preamble_word1 = bsg_request->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
 	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
@@ -938,6 +939,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 {
 	struct zfcp_fsf_ct_els *els = job->dd_data;
 	struct fc_rport *rport = job->rport;
+	struct fc_bsg_request *bsg_request = job->request;
 	struct zfcp_port *port;
 	u32 d_id;
 
@@ -949,7 +951,7 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 		d_id = port->d_id;
 		put_device(&port->dev);
 	} else
-		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
+		d_id = ntoh24(bsg_request->rqst_data.h_els.port_id);
 
 	els->handler = zfcp_fc_ct_els_job_handler;
 	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
@@ -983,6 +985,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	struct Scsi_Host *shost;
 	struct zfcp_adapter *adapter;
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
+	struct fc_bsg_request *bsg_request = job->request;
 
 	shost = job->rport ? rport_to_shost(job->rport) : job->shost;
 	adapter = (struct zfcp_adapter *)shost->hostdata[0];
@@ -994,7 +997,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	ct_els->resp = job->reply_payload.sg_list;
 	ct_els->handler_data = job;
 
-	switch (job->request->msgcode) {
+	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
 	case FC_BSG_HST_ELS_NOLOGIN:
 		return zfcp_fc_exec_els_job(job, adapter);
-- 
1.8.5.6

