From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v2 07/16] scsi: libfc: don't set
	FC_RQST_STATE_DONE before calling fc_bsg_jobdone()
Date: Wed, 12 Oct 2016 15:06:33 +0200
Message-ID: <c0be09bd5581f7993618132ed4bced8e5cb62ce1.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1476276823.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "open list:FCOE SUBSYSTEM libfc,
 libfcoe, fcoe" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Don't set FC_RQST_STATE_DONE before calling fc_bsg_jobdone() as
fc_bsg_jobdone() calls blk_complete_requeust() which raises a soft-IRQ that
ends up in fc_bsg_sofirq_done() and fc_bsg_softirq_done() sets the
FC_RQST_STATE_DONE flag.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/scsi/libfc/fc_lport.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 156708a..53d13721 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1911,7 +1911,6 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 		bsg_reply->result = (PTR_ERR(fp) == -FC_EX_CLOSED) ?
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
-		job->state_flags |= FC_RQST_STATE_DONE;
 		fc_bsg_jobdone(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
@@ -1947,7 +1946,6 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			bsg_reply->reply_payload_rcv_len =
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
-		job->state_flags |= FC_RQST_STATE_DONE;
 		fc_bsg_jobdone(job, bsg_reply->result,
 			       bsg_reply->reply_payload_rcv_len);
 		kfree(info);
-- 
1.8.5.6
