From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 13/44] libfc: Use fc_bsg_jobdone()
Date: Tue, 11 Oct 2016 13:28:44 +0200
Message-ID: <dce02f7b6436719a144483fd9613c4195392bdef.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <cover.1476180827.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
In-Reply-To: <cover.1476180827.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
References: <cover.1476180827.git.jthumshirn-l3A5Bk7waGM@public.gmane.org>
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

Use fc_bsg_jobdone() directly instead of the struct bsg_job::job_done()
callback.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/scsi/libfc/fc_lport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a1c12e7..8811fe0 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1912,7 +1912,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 			-ECONNABORTED : -ETIMEDOUT;
 		job->reply_len = sizeof(uint32_t);
 		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 		kfree(info);
 		return;
 	}
@@ -1947,7 +1947,7 @@ static void fc_lport_bsg_resp(struct fc_seq *sp, struct fc_frame *fp,
 				job->reply_payload.payload_len;
 		bsg_reply->result = 0;
 		job->state_flags |= FC_RQST_STATE_DONE;
-		job->job_done(job);
+		fc_bsg_jobdone(job);
 		kfree(info);
 	}
 	fc_frame_free(fp);
-- 
1.8.5.6
