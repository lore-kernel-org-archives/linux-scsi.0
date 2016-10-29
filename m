From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v5 0/14] Fix race conditions related to stopping block layer
 queues
Date: Fri, 28 Oct 2016 17:18:17 -0700
Message-ID: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0071.outbound.protection.outlook.com ([104.47.33.71]:17488
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753086AbcJ2AUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 20:20:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Hello Jens,

Multiple block drivers need the functionality to stop a request queue 
and to wait until all ongoing request_fn() / queue_rq() calls have 
finished without waiting until all outstanding requests have finished. 
Hence this patch series that introduces the blk_mq_quiesce_queue() 
function. The dm-mq, SRP and NVMe patches in this patch series are three 
examples of where these functions are useful. These patches have been 
tested on top of kernel v4.9-rc2. The following tests have been run to 
verify this patch series:
- Mike's mptest suite that stress-tests dm-multipath.
- My own srp-test suite that stress-tests SRP on top of dm-multipath.
- fio on top of the NVMeOF host driver that was connected to the NVMeOF
   target driver on the same host.
- Laurence verified the previous version (v3) of this patch series by
   running it through the Red Hat SRP and NVMe test suites.

The changes compared to the third version of this patch series are:
- Added a blk_mq_stop_hw_queues() call in blk_mq_quiesce_queue() as
   requested by Ming Lei.
- Modified scsi_unblock_target() such that it waits until
   .queuecommand() finished. Unexported scsi_wait_for_queuecommand().
- Reordered the two NVMe patches.
- Added a patch that avoids that blk_mq_requeue_work() restarts stopped
   queues.
- Added a patch that removes blk_mq_cancel_requeue_work().

Changes between v4 and v3:
- Left out the dm changes from the patch that introduces
   blk_mq_hctx_stopped() because a later patch deletes the changed code
   from the dm core.
- Moved the blk_mq_hctx_stopped() declaration from a public to a
   private block layer header file.
- Added a new patch that moves more code into
   blk_mq_direct_issue_request(). This patch avoids that a new function
   has to be introduced to avoid code duplication.
- Explained the implemented algorithm in the patch that introduces
   blk_mq_quiesce_queue() in the description of the patch that
   introduces this function.
- Added "select SRCU" to the patch that introduces
   blk_mq_quiesce_queue() to avoid build failures.
- Documented the shost argument in the scsi_wait_for_queuecommand()
   kerneldoc header.
- Fixed an unintended behavior change in the last patch of this series.

Changes between v3 and v2:
- Changed the order of the patches in this patch series.
- Added several new patches: a patch that avoids that .queue_rq() gets
   invoked from the direct submission path if a queue has been stopped
   and also a patch that introduces the helper function
   blk_mq_hctx_stopped().
- blk_mq_quiesce_queue() has been reworked (thanks to Ming Lin and Sagi
   for their feedback).
- A bool 'kick' argument has been added to blk_mq_requeue_request().
- As proposed by Christoph, the code that waits for queuecommand() has
   been moved from the SRP transport driver to the SCSI core.

Changes between v2 and v1:
- Dropped the non-blk-mq changes from this patch series.
- Added support for harware queues with BLK_MQ_F_BLOCKING set.
- Added a call stack to the description of the dm race fix patch.
- Dropped the non-scsi-mq changes from the SRP patch.
- Added a patch that introduces blk_mq_queue_stopped() in the dm driver.

The individual patches in this series are:

0001-blk-mq-Do-not-invoke-.queue_rq-for-a-stopped-queue.patch
0002-blk-mq-Introduce-blk_mq_hctx_stopped.patch
0003-blk-mq-Introduce-blk_mq_queue_stopped.patch
0004-blk-mq-Move-more-code-into-blk_mq_direct_issue_reque.patch
0005-blk-mq-Avoid-that-requeueing-starts-stopped-queues.patch
0006-blk-mq-Remove-blk_mq_cancel_requeue_work.patch
0007-blk-mq-Introduce-blk_mq_quiesce_queue.patch
0008-blk-mq-Add-a-kick_requeue_list-argument-to-blk_mq_re.patch
0009-dm-Use-BLK_MQ_S_STOPPED-instead-of-QUEUE_FLAG_STOPPE.patch
0010-dm-Fix-a-race-condition-related-to-stopping-and-star.patch
0011-SRP-transport-Move-queuecommand-wait-code-to-SCSI-co.patch
0012-SRP-transport-scsi-mq-Wait-for-.queue_rq-if-necessar.patch
0013-nvme-Fix-a-race-condition-related-to-stopping-queues.patch
0014-nvme-Use-BLK_MQ_S_STOPPED-instead-of-QUEUE_FLAG_STOP.patch

Thanks,

Bart.
