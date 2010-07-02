From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of
 q->prepare_flush_fn()
Date: Fri, 2 Jul 2010 16:39:52 +0900
Message-ID: <20100702163942G.fujita.tomonori@lab.ntt.co.jp>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de, axboe@kernel.dk
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri,  2 Jul 2010 16:33:23 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> scsi-ml builds flush requests via q->prepare_flush_fn(), however,
> builds discard requests via q->prep_rq_fn.
> 
> Using two different mechnisms for the similar requests (building
> commands in SCSI ULD) doesn't make sense.
> 
> Handing both via q->prep_rq_fn makes the code simpler.
> 
> We could kill q->prepare_flush_fn(). Except for ide, all the users
> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
> do like SCSI.
> 
> ==
>  block/blk-barrier.c |   12 ++++--------
>  drivers/scsi/sd.c   |   26 ++++++++++++++++----------
>  include/linux/bio.h |    2 ++
>  3 files changed, 22 insertions(+), 18 deletions(-)

Oops, this can be applied to Jens' for-2.6.36. It can't to scsi-misc
due to the discard patches.
