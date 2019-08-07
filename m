From: Steffen Maier <maier@linux.ibm.com>
Subject: [PATCH 2/2] scsi: core: fix dh and multipathing for SCSI
	hosts without request batching
Date: Wed,  7 Aug 2019 16:49:48 +0200
Message-ID: <20190807144948.28265-3-maier@linux.ibm.com>
References: <20190807144948.28265-1-maier@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190807144948.28265-1-maier@linux.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-next@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

This was missing from scsi_device_from_queue() due to the introduction
of another new scsi_mq_ops_no_commit of linux-next commit
8930a6c20791 ("scsi: core: add support for request batching")
from Martin's scsi/5.4/scsi-queue or James' scsi/misc.

Only devicehandler code seems to call scsi_device_from_queue():
*** drivers/scsi/scsi_dh.c:
scsi_dh_activate[255]          sdev = scsi_device_from_queue(q);
scsi_dh_set_params[302]        sdev = scsi_device_from_queue(q);
scsi_dh_attach[325]            sdev = scsi_device_from_queue(q);
scsi_dh_attached_handler_name[363] sdev = scsi_device_from_queue(q);

Fixes multipath tools follow-on errors:

$ multipath -v6
...
libdevmapper: ioctl/libdm-iface.c(1887): device-mapper: reload ioctl on mpatha  failed: No such device
...
mpatha: failed to load map, error 19
...

showing also as kernel messages:

device-mapper: table: 252:0: multipath: error attaching hardware handler
device-mapper: ioctl: error adding target to table

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 90c257622bb0..73e7d29fbd66 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1922,7 +1922,8 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = NULL;
 
-	if (q->mq_ops == &scsi_mq_ops)
+	if (q->mq_ops == &scsi_mq_ops_no_commit ||
+	    q->mq_ops == &scsi_mq_ops)
 		sdev = q->queuedata;
 	if (!sdev || !get_device(&sdev->sdev_gendev))
 		sdev = NULL;
-- 
2.17.1
