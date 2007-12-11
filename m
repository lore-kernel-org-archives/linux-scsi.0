From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 00/30] blk_end_request: full I/O completion
	handler (take 4)
Date: Tue, 11 Dec 2007 17:39:36 -0500 (EST)
Message-ID: <20071211.173936.122828268.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi Jens, Boaz,

The following is the updated patch-set for blk_end_request().
I have done some interface/implementation changes based on
feedbacks/discussions since the previous version.
(Although this patch-set was made on top of 2.6.24-rc4, I confirmed
 it can be applied to 2.6.24-rc5, too.  Also, I confirmed it has
 no build error on my IA64 box.)

As for patches without Cc tag, I couldn't find the maintainer
related to the patch.

Patch 27 through patch 30 conflict with Boaz's scsi bidi patch.
If Boaz's patch goes first, I will rebase these 4 patches on top of
Boaz's patch and post them again.


------------------ Changes from the previous post ---------------------
Changes between take3 and take4:
  o Rebased on top of 2.6.24-rc4 + an IDE's patch to remove dead
    post_transform_command()
    (http://marc.info/?l=linux-kernel&m=119654922030880&w=2)
  o Changed the 'uptodate' argument of blk_end_request interfaces
    to 'error'.  Changed all related drivers, too.  (PATCH 01-29)
  o Added blk_queued_rq() macro, which indicates whether the request
    is in the block-layer's queue or not  (PATCH 01)
  o Added blk_end_bidi_request() interface for bidi request (PATCH 26)
  o Removed some code duplications of blk_end_request interfaces
    using an internal function (blk_end_io())  (PATCH 24 and PATCH 26)
  o Added cleanup of request completion introduced by this
    patch-set  (PATCH 30)

Changes between take2 and take3:
  o Rebased on top of 2.6.24-rc3-mm2
  o Added a bidi patch, which changes bidi to use blk_end_request()
    (PATCH 27)
  o Dropped blk_rq_size() which was to get size of entire request
    because rq_byte_size() has been added to ll_rw_blk.c (PATCH 02)
  o Removed 'dequeue' argument, which was added in 2.6.23-rc7-mm1,
    from __end_request() (PATCH 03)
  o Removed lguest patch because lguest has been changed not to use
    end_that_request_{chunk/last} directly.

Changes between take1 and take2:
  o Rebased on top of 2.6.23-rc4-mm1
  o Don't pass the lock held information (PATCH 01)
  o Removed sect2byte() macro (PATCH 02)
  o fixed blk_rq_size() and blk_rq_cur_size() for blk_pc_requests (PATCH 02)
  o Separated the patch for changes of end_that_request_* user (PATCH 03-26)
  o Removed the patch which changes the role of rq->end_io()
    from this patch-set because some more discussions are needed
    about it.
-----------------------------------------------------------------------


Summary of each patch are below:
  01/30: add new request completion interface, blk_end_request (block)
  02/30: add some functions to get the size of request in bytes (block)
  03/30: convert to use blk_end_request (block)
  04/30: convert to use blk_end_request (arm)
  05/30: convert to use blk_end_request (um)
  06/30: convert to use blk_end_request (DAC960)
  07/30: convert to use blk_end_request (floppy)
  08/30: convert to use blk_end_request (nbd)
  09/30: convert to use blk_end_request (ps3disk)
  10/30: convert to use blk_end_request (sunvdc)
  11/30: convert to use blk_end_request (sx8)
  12/30: convert to use blk_end_request (ub)
  13/30: convert to use blk_end_request (viodasd)
  14/30: convert to use blk_end_request (xen-blkfront)
  15/30: convert to use blk_end_request (viocd)
  16/30: convert to use blk_end_request (i2o_block)
  17/30: convert to use blk_end_request (mmc)
  18/30: convert to use blk_end_request (s390)
  19/30: convert to use blk_end_request (ide-scsi)
  20/30: convert to use blk_end_request (xsysace)
  21/30: convert to use blk_end_request (cciss)
  22/30: convert to use blk_end_request (cpqarray)
  23/30: convert to use blk_end_request (normal parts of ide)
  24/30: add a valiant of blk_end_request having callback feature (block)
  25/30: convert to use blk_end_request (ide-cd, cdrom_newpc_intr())
  26/30: add a valiant of blk_end_request for bidi request (block)
  27/30: convert to use blk_end_request (scsi mid-layer)
  28/30: remove/unexport no longer needed end_that_request_* (block)
  29/30: remove no longer needed 'uptodate' related codes (block)
  30/30: cleanup of request completion introduced by this patch-set (block)

I have tested this patch-set on two machines,
IA64+QLA1280+QLA2200 box and x86_64+SATA+IDE-CDROM box.


Below is the explanation about needs and details of this patch-set.

SUMMARY
=======
This set of patches changes request completion interface
between device drivers and block layer to 1-step procedure
from current 2-step procedures (i.e. end_that_request_{first/chunk}
and end_that_request_last) so that the block layer can take over
the ownership of the request from device drivers before starting to
complete each chunk of the request.

This patch-set prepares for realizing another patch-set which changes
the role of rq->end_io().  It allows request-based multipath to hook
in before completing each chunk of request, check errors for it and
retry it using another path if error is detected.


BACKGROUND
==========
The patch-set which changes the role of rq->end_io() is necessary
to allow device stacking at request level, that is request-based
device-mapper multipath.
Currently, device-mapper is implemented as a stacking block device
at BIO level.  OTOH, request-based dm will stack at request level
to allow better multipathing decision.
To allow device stacking at request level, the completion procedure
need to provide a hook for it.
For example, dm-multipath has to check errors and retry with other
paths if necessary before returning the I/O result to upper layer.
struct request has 'end_io' hook currently.  But it's called at
the very late stage of completion handling where the I/O result
is already returned to the upper layer.
So we need something here.

The first approach to hook in completion of each chunk of request
was adding a new rq->end_io_first() hook and calling it on the top
of __end_that_request_first().
  - http://marc.theaimsgroup.com/?l=linux-scsi&m=115520444515914&w=2
  - http://marc.theaimsgroup.com/?l=linux-kernel&m=116656637425880&w=2
However, Jens pointed out that redesigning rq->end_io() as a full
completion handler would be better:

On Thu, 21 Dec 2006 08:49:47 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> Ok, I see what you are getting at. The current ->end_io() is called when
> the request has fully completed, you want notification for each chunk
> potentially completed.
> 
> I think a better design here would be to use ->end_io() as the full
> completion handler, similar to how bio->bi_end_io() works. A request
> originating from __make_request() would set something ala:
.....
> instead of calling the functions manually. That would allow you to get
> notification right at the beginning and do what you need, without adding
> a special hook for this.

I thought his comment was reasonable.
So I modified the patches based on his suggestion.


WHAT IS CHANGED
===============
The change is basically illustlated by the following pseudo code:

[Before]
  if (end_that_request_{first/chunk} succeeds) { <-- completes bios
     <do something driver specific>
     end_that_request_last() <-- calls end_io()
     <the request is free from the driver>
  } else {
     <the request was incomplete, retry for leftover or ignoring>
  }

[After]
  if (blk_end_request() succeeds) { <-- calls end_io(), completes bios
     <the request is free from the driver>
  } else {
     <the request was incomplete, retry for leftover or ignoring>
  }


In detail, request completion procedures are changed like below.

[Before]
  o 2 steps completion using end_that_request_{first/chunk}
    and end_that_request_last().
  o Device drivers have ownership of a request until they
    call end_that_request_last().
  o rq->end_io() is called at the last stage of
    end_that_request_last() for some block layer codes need
    specific request handling when completing it.

[After]
  o 1 step completion using blk_end_request().
    (end_that_request_* are no longer used from device drivers.)
  o Device drivers give over ownership of a request
    when calling blk_end_request().
    If it returns 0, the request is completed.
    If it returns 1, the request isn't completed and
    the ownership is returned to the device driver again.
  o rq->end_io() is called at the top of blk_end_request() to
    allow to hook all parts of request completion.
    Existing users of rq->end_io() must be changed to do
    all parts of request completion.

Thanks,
Kiyoshi Ueda
