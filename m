From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v4 06/15] scsi: libfc: don't set
	FC_RQST_STATE_DONE before calling fc_bsg_jobdone()
Date: Thu, 17 Nov 2016 10:31:16 +0100
Message-ID: <4a88b902ff8b37efcdfb6439d10555701e170a40.1479374720.git.jthumshirn@suse.de>
References: <cover.1479374719.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1479374719.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "open list:SCSI SUBSYSTEM" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc,
 libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Don't set FC_RQST_STATE_DONE before calling fc_bsg_jobdone() as
fc_bsg_jobdone() calls blk_complete_requeust() which raises a soft-IRQ that
ends up in fc_bsg_sofirq_done() and fc_bsg_softirq_done() sets the
FC_RQST_STATE_DONE flag.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
---
 drivers/scsi/libfc/fc_lport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 5e24ca3..cc98ebc 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1912,7 +1912,6 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 		bsg_reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
-		job->state_flags |= FC_RQST_STATE_DONE;
 		fc_bsg_jobdone(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
@@ -1948,7 +1947,6 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			bsg_reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
-		job->state_flags |= FC_RQST_STATE_DONE;
 		fc_bsg_jobdone(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
-- 
1.8.5.6
