From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 00/13] request-based dm-multipath
Date: Fri, 12 Sep 2008 10:38:14 -0400 (EDT)
Message-ID: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@HansenPartnership.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens, James and Alasdair,

This is a new version of request-based dm-multipath patches.
The patches are created on top of 2.6.27-rc6 + Alasdair's dm patches
for linux-next below:
    dm-mpath-use-more-error-codes.patch
    dm-mpath-remove-is_active-from-struct-dm_path.patch

Major changes from the previous version (*) are:
    - Moved busy state information for device/host to
      q->backing_dev_info from q->queue_flags, since backing_dev_info
      seems to be more appropriate location. (PATCH 03)
      And corresponding changes to the scsi driver. (PATCH 04)

    - Added a queue flag to indicate whether the block device is
      request stackable or not, so that request stacking drivers
      can avoid to stack request-based device on bio-based device.
      (PATCH 05)

    - Fixed the problem that requests are not flushed on flush suspend.
      (PATCH 10)

    - Changed queue initialization method for bio-based dm devices
      from blk_alloc_queue() to blk_init_queue(). (PATCH 11)

    - Changed congestion check method in dm-multipath not to invoke
      __choose_pgpath(). (PATCH 13)

    (*) http://lkml.org/lkml/2008/3/19/478

Some basic function/performance testings are done with NEC iStorage
(active-active multipath), and no problem was found.
Please review and apply if no problem.


Summary of the patch-set:
  01/13: block: add request data completion interface
  02/13: block: add request submission interface
  03/13: mm: export driver's busy state via backing_dev_info
  04/13: scsi: export busy status
  05/13: block: add a queue flag for request stacking support
  06/13: dm: remove unused code (preparation for request-based dm)
  07/13: dm: tidy local_init (preparation for request-based dm)
  08/13: dm: prepare mempools on module init for request-based dm
  09/13: dm: add target interface for request-based dm
  10/13: dm: add core functions for request-based dm
  11/13: dm: add a switch to enable request-based dm if target is ready
  12/13: dm: reject requests violating limits for request-based dm
  13/13: dm-mpath: convert to request-based from bio-based


Summary of the design and request-based dm-multipath are below.

BACKGROUND
==========
Currently, device-mapper (dm) is implemented as a stacking block device
at bio level.  This bio-based implementation has an issue below
on dm-multipath.

    Because hook for I/O mapping is above block layer __make_request(),
    contiguous bios can be mapped to different underlying devices
    and these bios aren't merged into a request.
    Dynamic load balancing could happen this situation, though
    it has not been implemented yet.
    Therefore, I/O mapping after bio merging is needed for better
    dynamic load balancing.

The basic idea to resolve the issue is to move multipathing layer
down below the I/O scheduler, and it was proposed from Mike Christie
as the block layer (request-based) multipath:
    http://marc.info/?l=linux-scsi&m=115520444515914&w=2

Mike's patch added new block layer device for multipath and didn't
have dm interface.  So I modified his patch to be used from dm.
It is request-based dm-multipath.


DESIGN OVERVIEW
===============
While currently dm and md stacks block devices at bio level,
request-based dm stacks at request level and submits/completes
struct request instead of struct bio.


Overview of the request-based dm patch:
  - Mapping is done in a unit of struct request, instead of struct bio
  - Hook for I/O mapping is at q->request_fn() after merging and
    sorting by I/O scheduler, instead of q->make_request_fn().
  - Hook for I/O completion is at bio->bi_end_io() and rq->end_io(),
    instead of only bio->bi_end_io()
                  bio-based (current)     request-based (this patch)
      ------------------------------------------------------------------
      submission  q->make_request_fn()    q->request_fn()
      completion  bio->bi_end_io()        bio->bi_end_io(), rq->end_io()
  - Whether the dm device is bio-based or request-based is determined
    at table loading time
  - Keep user interface same (table/message/status/ioctl)
  - Any bio-based devices (like dm/md) can be stacked on request-based
    dm device.
    Request-based dm device *cannot* be stacked on any bio-based device.


Expected benefit:
  - better load balancing


Additional explanations:

Why does request-based dm use bio->bi_end_io(), too?
Because:
  - dm needs to keep not only the request but also bios of the request,
    if dm target drivers want to retry or do something on the request.
    For example, dm-multipath has to check errors and retry with other
    paths if necessary before returning the I/O result to the upper layer.

  - But rq->end_io() is called at the very late stage of completion
    handling where all bios in the request have been completed and
    the I/O results are already visible to the upper layer.
So request-based dm hooks bio->bi_end_io() and doesn't complete the bio
in error cases, and gives over the error handling to rq->end_io() hook.


Thanks,
Kiyoshi Ueda
