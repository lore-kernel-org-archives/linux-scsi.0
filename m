From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 7/8] SCSI: allow to pass null rq to scsi_prep_state_check()
Date: Sat, 14 Oct 2017 17:22:31 +0800
Message-ID: <20171014092232.13943-8-ming.lei@redhat.com>
References: <20171014092232.13943-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171014092232.13943-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

In the following patch, we will implement scsi_get_budget()
which need to call scsi_prep_state_check() when rq isn't
dequeued yet.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..d159bb085714 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1301,7 +1301,7 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
-			if (!(req->rq_flags & RQF_PREEMPT))
+			if (req && !(req->rq_flags & RQF_PREEMPT))
 				ret = BLKPREP_DEFER;
 			break;
 		default:
@@ -1310,7 +1310,7 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			 * special commands.  In particular any user initiated
 			 * command is not allowed.
 			 */
-			if (!(req->rq_flags & RQF_PREEMPT))
+			if (req && !(req->rq_flags & RQF_PREEMPT))
 				ret = BLKPREP_KILL;
 			break;
 		}
-- 
2.9.5
