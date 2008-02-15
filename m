From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 0/3] request stacking and request-based dm-multipath
Date: Fri, 15 Feb 2008 17:26:31 -0500 (EST)
Message-ID: <20080215.172631.85413800.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYBOW01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:26:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi Jens, list,

I'm working on device-mapper multipath (dm-multipath) and trying to
move its layer down below the I/O scheduler so that dm-multipath can
make better multipathing decision.
(This is subjected as request-based dm-multipath.)

On that design, dm-multipath treats and submits struct request to
underlying devices instead of struct bio.
So requests are stacked while currently dm and md are stacking bios.

The following 3 patches are implementation of the request stacking
framework.
  1/3: add rq->complete_io hook for request stacking
  2/3: move block-layer internal request completion to kblockd
  3/3: export driver's busy state and an example of scsi

The first 2 patches enable request stacking.
The last 1 patch is necessary to avoid a performance problem,
that requests are sent down too early while the underlying device
is busy.

I also attach the patch-set of request-based dm-multipath
as appendix to show how the request stacking interfaces are used.
(With this version of the patch-set, request-based dm-multipath
 works without userspace (multipath-tools and libdevmapper) change.)

This patch-set should be applied on top of 2.6.25-rc1.

Although I'm planning to discuss this topic in the Storage Workshop, too,
any comments and feedbacks in advance are very appreciated and helpful.


Below is the explanation about needs and details of the request stacking
patches.

SUMMARY
=======
Request-based dm-multipath needs this patch-set to hook in before
completing each chunk of request, check errors for it and retry it
using another path if error is detected.


BACKGROUND
==========
The patch-set, which adds the rq->complete_io() hook, is necessary
to allow device stacking at request level, that is request-based
device-mapper multipath.
Currently, device-mapper is implemented as a stacking block device
at BIO level.  OTOH, request-based dm will stack at request level
for better multipathing decision.
To stack devices at request level, the completion procedure needs
a hook for it.
For example, dm-multipath has to check errors and retry with other
paths if necessary before returning the I/O result to the upper layer.
struct request has 'end_io' hook currently.  But it's called at
the very late stage of completion handling where the I/O result
is already returned to the upper layer.
So we need something here.

The first approach to hook in completion of each chunk of request
was adding a new rq->end_io_first() hook and calling it on the top
of __end_that_request_first().
  - http://marc.info/?l=linux-kernel&m=116656637425880&w=2
  - http://marc.info/?l=linux-scsi&m=115520444515914&w=2
However, Jens pointed out that redesigning rq->end_io() as a full
completion handler would be better:

On Thu, 21 Dec 2006 08:49:47 +0100, Jens Axboe wrote:
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

I thought his comment was reasonable, and I modified the patches
based on his suggestion:
  - http://marc.info/?l=linux-kernel&m=118860086901958&w=2

But the patch was ugly.
After considering the patch, I come to think changing the role
of ->end_io() is not feasible.
The role of ->end_io() is a destructor, and current users only
want to do something at the destruction of struct request, don't
want to do other works like data completion.
So I think it's reasonable to add another hook for request stacking.
(or rename the current ->end_io() to ->dtor() and make ->end_io()
 a request stacking hook.)

Thanks,
Kiyoshi Ueda
