From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io async WRITE_SAME results in iSCSI NULL pointer [was: Re:
 Write same support]
Date: Tue, 21 Feb 2012 14:33:12 -0500
Message-ID: <20120221193312.GA6565@redhat.com>
References: <20120216210301.GA27404@redhat.com>
 <yq139a55rhr.fsf@sermon.lab.mkp.net>
 <20120220184623.GA29931@redhat.com>
 <20120220234410.GC31853@redhat.com>
 <yq1k43h2gm9.fsf@sermon.lab.mkp.net>
 <20120221031854.GA468@redhat.com>
 <yq1pqd825zt.fsf@sermon.lab.mkp.net>
 <20120221065504.GB468@redhat.com>
 <yq1linw1i6e.fsf@sermon.lab.mkp.net>
 <20120221144145.GA4743@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab2BUTd1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Feb 2012 14:33:27 -0500
Content-Disposition: inline
In-Reply-To: <20120221144145.GA4743@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com, michaelc@cs.wisc.edu, Vivek Goyal <vgoyal@redhat.com>

On Tue, Feb 21 2012 at  9:41am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Feb 21 2012 at  7:31am -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:

> > PS. The good news is that your async stuff works when I set phys_segs to
> > 1 in sd.
> 
> Yeah, it worked with the patch I provided in my previous mail too.  But
> ultimately the async stuff wasn't working for me due to merging.

(not related to async interface but...)

After further testing (iSCSI from with a guest) it is clear that we
still have a problem with REQ_WRITE_SAME bios being merged into WRITE
requests (I added a debugging WARN_ON_ONCE to generate the following):

------------[ cut here ]------------
WARNING: at block/blk-merge.c:476 blk_rq_merge_ok+0x4d/0xb4()
Hardware name: KVM
Modules linked in: dm_thin_pool dm_persistent_data dm_bufio libcrc32c dm_mod sunrpc iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi virtio_net virtio_balloon i2c_piix4 i2c_core virtio_blk virtio_pci virtio_ring virtio [last unloaded: dm_thin_pool]
Pid: 5, comm: kworker/u:0 Not tainted 3.2.0-snitm+ #185
Call Trace:
 [<ffffffff81042efa>] warn_slowpath_common+0x85/0x9d
 [<ffffffff81042f2c>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff811cd8bc>] blk_rq_merge_ok+0x4d/0xb4
 [<ffffffff811c4213>] elv_rq_merge_ok+0x17/0x47
 [<ffffffff811c4287>] elv_merge+0x44/0xc2
 [<ffffffff811ca815>] blk_queue_bio+0xf2/0x2d5
 [<ffffffff811c9ca2>] generic_make_request+0xa1/0xe2
 [<ffffffff811c9dc2>] submit_bio+0xdf/0x119
 [<ffffffff8113191d>] ? bio_alloc_bioset+0x4d/0xc2
 [<ffffffff811ceee3>] blkdev_issue_write_same+0x203/0x26c
 [<ffffffff8106511a>] ? local_clock+0x41/0x5a
 [<ffffffffa00f5dbf>] do_worker+0x3b6/0x5f1 [dm_thin_pool]
 [<ffffffff8107084e>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffffa00f5a09>] ? process_shared_bio+0x36e/0x36e [dm_thin_pool]
 [<ffffffffa00f5a09>] ? process_shared_bio+0x36e/0x36e [dm_thin_pool]
 [<ffffffff8105b6d0>] process_one_work+0x213/0x37b
 [<ffffffff8105b641>] ? process_one_work+0x184/0x37b
 [<ffffffff8105bb6d>] worker_thread+0x138/0x21c
 [<ffffffff8105ba35>] ? rescuer_thread+0x1fd/0x1fd
 [<ffffffff8105f6b1>] kthread+0xa0/0xa8
 [<ffffffff81073663>] ? trace_hardirqs_on_caller+0x12f/0x166
 [<ffffffff81398384>] kernel_thread_helper+0x4/0x10
 [<ffffffff81390534>] ? retint_restore_args+0x13/0x13
 [<ffffffff8105f611>] ? __init_kthread_worker+0x5b/0x5b
 [<ffffffff81398380>] ? gs_change+0x13/0x13
---[ end trace 07b896d4bdef61b0 ]---

This patch fixes it for me, please feel free to add it to your series:

From: Mike Snitzer <snitzer@redhat.com>
Date:   Tue Feb 21 13:55:42 2012 -0500

    block: disallow certain bios from being merged into a request
    
    Not all WRITE bios are pure WRITEs (there may be other flags set,
    e.g. REQ_WRITE_SAME).  Introduce bio_mergeable() and have
    blk_rq_merge_ok() check that a given bio is mergeable.
    
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3f73823..81484d3 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -468,7 +468,7 @@ int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
 
 bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 {
-	if (!rq_mergeable(rq))
+	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
 	/* don't merge discard requests and secure discard requests */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a505d7..7cf2d37 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -568,7 +568,10 @@ static inline void blk_clear_queue_full(struct request_queue *q, int sync)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && (rq)->cmd_type == REQ_TYPE_FS)
 
-
+#define BIO_NOMERGE_FLAGS	\
+	(REQ_DISCARD | REQ_WRITE_SAME)
+#define bio_mergeable(bio)	\
+	(!((bio)->bi_rw & BIO_NOMERGE_FLAGS))
 
 /*
  * q->prep_rq_fn return values
