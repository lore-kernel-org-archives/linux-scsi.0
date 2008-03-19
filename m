From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 00/13] request stacking and request-based
	dm-multipath
Date: Wed, 19 Mar 2008 18:05:11 -0500 (EST)
Message-ID: <20080319.180511.70226434.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jens, Mike, Hannes, Alasdair and list,

This is a new version of request-based dm-multipath patches,
updated based on discussions and comments at LSF'08.
The patches are created on top of 2.6.25-rc5.

Major changes from the previous version (*) are:
    - Request stacking drivers clone both request and bio, and
      use both rq->end_io and bio->bi_end_io for request stacking
    - Request stacking drivers use blk_complete_request() and
      complete request in a softirq context, which doesn't have
      queue lock, to avoid some deadlock issues
    (*) http://lkml.org/lkml/2008/2/15/411

Some basic function/performance testings are done with NEC iStorage,
which is active-active multipath, and no problem was found.


Jens,
The first 4 patches are for the block layer.  Are they acceptable?


Alasdair,
Request stacking design affects dm implementaion a lot.
If you have any objection on the design of dm side, please let me
know on this version since I'd like to fix the design and proceed
further dm implementation.


Summary of the patch-set:
  01/13: block: add request data completion interface
  02/13: block: add request submission interface
  03/13: block: export driver's busy state via queue flag (and an example)
  04/13: block: export blk_register_queue()
  05/13: dm: remove dead code (preparation for request-based dm)
  06/13: dm: tidy local_init (preparation for request-based dm)
  07/13: dm: prepare mempools on module init for request-based dm
  08/13: dm: add target interface for request-based dm
  09/13: dm: add core functions for request-based dm
  10/13: dm: add a switch to enable request-based dm if target is ready
  11/13: dm: reject bad table load for request-based dm
  12/13: dm-mpath: add hw-handler interface for request-based dm
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
  - Keep user interface same (table/message/status)
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
    the I/O results are already returned to the upper layer.
So request-based dm hooks bio->bi_end_io() and doesn't complete the bio
in error cases, and gives over the error handling to rq->end_io() hook.


TODO
====
  - dm generic interface for dynamic load balancing
  - dynamic load balancer using the interface

Thanks,
Kiyoshi Ueda
