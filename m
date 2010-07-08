From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] scsi: address leak in scsi_setup_discard_cmnd error
 path (was: Re: scsi: unify the error handling of the prep functions)
Date: Thu, 8 Jul 2010 08:06:03 -0400
Message-ID: <20100708120602.GA28083@redhat.com>
References: <20100705125651R.fujita.tomonori@lab.ntt.co.jp>
 <20100705134529.GA18645@redhat.com>
 <20100706135958.GA10772@redhat.com>
 <20100708131726C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab0GHMGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 08:06:19 -0400
Content-Disposition: inline
In-Reply-To: <20100708131726C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jaxboe@fusionio.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, dm-devel@redhat.com

On Thu, Jul 08 2010 at 12:17am -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 6 Jul 2010 09:59:58 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Here is a minimalist patch that 1) removes the discard request's page
> > leak 2) preserves the prep cleanup rules covered above.  Fixing the leak
> > is a priority, introducing additional error path code sharing/cleanup is
> > secondary and can come later.
> 
> This patch doesn't work. I hit kernel oops since now this patch frees
> a discard page twice.

I load tested my v2 patch quite a bit but didn't hit the oops.  Guess
you're just lucky ;)

> If scsi_init_io hits BLKPREP_DEFER (e.g. due to scsi_init_sgtable),
> scsi_setup_blk_pc_cmnd calls scsi_unprep_request. So sd_unprep_fn
> frees a page. Then, scsi_setup_discard_cmnd frees the same page again.

OK, thanks for catching this.

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi: fix discard page leak
> 
> We leak a page allocated for discard on some error conditions
> (e.g. scsi_prep_state_check returns BLKPREP_DEFER in
> scsi_setup_blk_pc_cmnd).
> 
> We unprep on requests that weren't prepped in the error path of
> scsi_init_io. It makes the error path to clean up scsi commands messy.
> 
> Let's strictly apply the rule that we can't unprep on a request that
> wasn't prepped.
> 
> Calling just scsi_put_command() in the error path of scsi_init_io() is
> enough. We don't set REQ_DONTPREP yet.
> 
> scsi_setup_discard_cmnd can safely free a page on the error case with
> the above rule.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Jens, it'd be great if we could get this fix in now.
