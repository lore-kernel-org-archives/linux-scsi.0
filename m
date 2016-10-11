From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 04/44] ibmvfc: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Tue, 11 Oct 2016 13:28:35 +0200
Message-ID: <47dc03cafbb55cae8fbc117764556d8c0f95da68.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Paul Mackerras <paulus@samba.org>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Johannes Thumshirn <jthumshirn@suse.de>, "open list:LINUX FOR POWERPC 32-BIT AND 64-BIT" <linuxppc-dev@lists.ozlabs.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
helper variables bsg_request and bsg_reply. This will be helpfull when
transitioning to bsg-lib.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ab67ec4..8b55279 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1821,28 +1821,30 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	struct ibmvfc_event *evt;
 	union ibmvfc_iu rsp_iu;
 	unsigned long flags, port_id = -1;
-	unsigned int code = job->request->msgcode;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	unsigned int code = bsg_request->msgcode;
 	int rc = 0, req_seg, rsp_seg, issue_login = 0;
 	u32 fc_flags, rsp_len;
 
 	ENTER;
-	job->reply->reply_payload_rcv_len = 0;
+	bsg_reply->reply_payload_rcv_len = 0;
 	if (rport)
 		port_id = rport->port_id;
 
 	switch (code) {
 	case FC_BSG_HST_ELS_NOLOGIN:
-		port_id = (job->request->rqst_data.h_els.port_id[0] << 16) |
-			(job->request->rqst_data.h_els.port_id[1] << 8) |
-			job->request->rqst_data.h_els.port_id[2];
+		port_id = (bsg_request->rqst_data.h_els.port_id[0] << 16) |
+			(bsg_request->rqst_data.h_els.port_id[1] << 8) |
+			bsg_request->rqst_data.h_els.port_id[2];
 	case FC_BSG_RPT_ELS:
 		fc_flags = IBMVFC_FC_ELS;
 		break;
 	case FC_BSG_HST_CT:
 		issue_login = 1;
-		port_id = (job->request->rqst_data.h_ct.port_id[0] << 16) |
-			(job->request->rqst_data.h_ct.port_id[1] << 8) |
-			job->request->rqst_data.h_ct.port_id[2];
+		port_id = (bsg_request->rqst_data.h_ct.port_id[0] << 16) |
+			(bsg_request->rqst_data.h_ct.port_id[1] << 8) |
+			bsg_request->rqst_data.h_ct.port_id[2];
 	case FC_BSG_RPT_CT:
 		fc_flags = IBMVFC_FC_CT_IU;
 		break;
@@ -1931,12 +1933,12 @@ static int ibmvfc_bsg_request(struct fc_bsg_job *job)
 	if (rsp_iu.passthru.common.status)
 		rc = -EIO;
 	else
-		job->reply->reply_payload_rcv_len = rsp_len;
+		bsg_reply->reply_payload_rcv_len = rsp_len;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	job->reply->result = rc;
+	bsg_reply->result = rc;
 	job->job_done(job);
 	rc = 0;
 out:
-- 
1.8.5.6
