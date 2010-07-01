From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: add sd_unprep_fn to free discard page
Date: Thu, 01 Jul 2010 08:57:37 -0500
Message-ID: <1277992657.2813.18.camel@mulgrave.site>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <4C2C9AE4.1050803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47775 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab0GAN5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 09:57:45 -0400
In-Reply-To: <4C2C9AE4.1050803@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, axboe@kernel.dk, snitzer@redhat.com, hch@lst.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 16:40 +0300, Boaz Harrosh wrote:
> On 07/01/2010 01:49 PM, FUJITA Tomonori wrote:
> > This patchset fixes page leak issue in discard commands with unprep
> > facility that James posted:
> > 
> > http://marc.info/?l=linux-scsi&m=127791727508214&w=2
> > 
> > The 1/3 patch adds unprep facility to the block layer (identical to
> > what James posted).
> > 
> 
> Alternatively to this patch you could also call scsi_driver->done()
> on all commands. There are only two users (sd sr) it's not that bad to add
> an if (blk_pc_req()) inside these ->done() function.

We could, but it wouldn't fix the problem.  The system issue is that
->done isn't symmetrical to ->prep_rq_fn() ... ->done() sits in the
middle of the SCSI completion path and we could decide to requeue the
command after calling it (that's why we can't free the discard page
either in ->done() or in the midlayer where ->done() is called).

The system solution is a symmetrical pair for ->prep_rq_fn() which is
only called either after all error handling is complete, or we decide to
completely strip the command down for a retry that goes through prep
again.

> > The 2/3 patch frees a page for discard commands by using the unprep
> > facility. James' original patch doesn't work since it accesses to
> > rq->bio in q->unprep_rq_fn. We hit oops since q->unprep_rq_fn is
> > called when all the data buffer (req->bio and scsi_data_buffer) in the
> > request is freed.
> > 
> > I use rq->buffer to keep track of an allocated page as the block layer
> > sets rq->buffer to the address of bio's page. scsi-ml (and llds) don't
> > use rq->buffer (rq->buffer is set to NULL). So I can't say that I like
> > it lots. Any other way to do that?
> > 
> 
> rq->buffer is intended for block-driver use as well as req->special.
> sd+scsi-ml is the block-driver here. req->special is used by scsi-ml
> and rq->buffer is set to NULL inside the call to
> scsi_setup_blk_pc_cmnd/scsi_setup_fs_cmnd. Since you set the ->buffer
> after the call to scsi_setup_blk_pc_cmnd you should be in the clear.
> 
> I think scsi-ml should stop setting rq->buffer to NULL and leave it
> be for ULD use. It is left from the time that LLDs where converted
> to use BIOs, just to make sure out-of-tree drivers crash.

So I buy this more.  There is a slight assymmetry in that we have the
bio in prep, but not in unprep.  Since requests can complete partially
(freeing the bios on the way), there's no real way to avoid this.  I
think the use of ->buffer is a bit unsavoury but it looks acceptable.

James


