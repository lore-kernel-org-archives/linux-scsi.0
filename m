From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 0/7] Introduce blk_quiesce_queue() and blk_resume_queue()
Date: Wed, 28 Sep 2016 16:57:07 -0700
Message-ID: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

Multiple block drivers need the functionality to stop a request queue 
and to wait until all ongoing request_fn() / queue_rq() calls have 
finished without waiting until all outstanding requests have finished. 
Hence this patch series that introduces the blk_mq_quiesce_queue() and 
blk_mq_resume_queue() functions. The dm-mq, SRP and nvme patches in this 
patch series are three examples of where these functions are useful. 
These patches apply on top of the September 21 version of your 
for-4.9/block branch.

The changes compared to the previous version of this patch series are:
- Dropped the non-blk-mq changes from this patch series.
- Added support for harware queues with BLK_MQ_F_BLOCKING set.
- Added a call stack to the description of the dm race fix patch.
- Dropped the non-scsi-mq changes from the SRP patch.
- Added a patch that introduces blk_mq_queue_stopped() in the dm driver.

The individual patches in this series are:

0001-blk-mq-Introduce-blk_mq_queue_stopped.patch
0002-dm-Use-BLK_MQ_S_STOPPED-instead-of-QUEUE_FLAG_STOPPE.patch
0003-RFC-nvme-Use-BLK_MQ_S_STOPPED-instead-of-QUEUE_FLAG_.patch
0004-blk-mq-Introduce-blk_quiesce_queue-and-blk_resume_qu.patch
0005-dm-Fix-a-race-condition-related-to-stopping-and-star.patch
0006-SRP-transport-Port-srp_wait_for_queuecommand-to-scsi.patch
0007-RFC-nvme-Fix-a-race-condition.patch

Thanks,

Bart.
