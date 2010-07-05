From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: unify the error handling of the prep functions
Date: Mon, 5 Jul 2010 09:45:29 -0400
Message-ID: <20100705134529.GA18645@redhat.com>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0GENpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jul 2010 09:45:51 -0400
Content-Disposition: inline
In-Reply-To: <20100705125651R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, dm-devel@redhat.com

On Mon, Jul 05 2010 at 12:00am -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This can be applied to the block's for-2.6.36.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi: unify the error handling of the prep functions
> 
> This unifies the error handling of the prep functions (and fix the
> leak of a page allocated for discard in the case of BLKPREP_KILL or
> BLK_PREP_DEFER).
> 
> The error handling of the prep path is very messy. Some errors are
> handled in the prep functions while some are in scsi_prep_return().
> 
> Let's handle all the errors in scsi_prep_return().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch addresses the discard page leak too (scsi_prep_error calls
scsi_unprep_request which calls blk_unprep_request).

Acked-by: Mike Snitzer <snitzer@redhat.com>
