From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Wed, 05 May 2010 09:19:53 -0400
Message-ID: <1273065593.5227.42.camel@mulgrave.site>
References: <20100504144853.D94C72A205@ochil.suse.de>
	 <1272990403.5255.27.camel@mulgrave.site> <4BE0804D.1030406@cs.wisc.edu>
	 <4BE08320.40206@cs.wisc.edu> <1273005003.16631.43.camel@mulgrave.site>
	 <4BE10F89.4020101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48731 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab0EENUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 09:20:08 -0400
In-Reply-To: <4BE10F89.4020101@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Wed, 2010-05-05 at 08:26 +0200, Hannes Reinecke wrote:
> James Bottomley wrote:
> > On Tue, 2010-05-04 at 15:27 -0500, Mike Christie wrote:
> >> On 05/04/2010 03:15 PM, Mike Christie wrote:
> >>> On 05/04/2010 11:26 AM, James Bottomley wrote:
> >>>> The other patch is fine, but I don't think this is necessary. The
> >>>> reason is that even returning SUCCESS here, we go straight into
> >>>> scsi_finish_command() (which passes it up to the driver handler) and
> >>>> then scsi_io_completion(). There's a catch for UNIT_ATTENTION in
> >>>> scsi_io_completion
> >>> The request is sent as a REQ_TYPE_BLOCK_PC (this flag is set for the
> >>> request in sd_prepare_flush), and scsi_io_completion's blk_pc_request
> >>> check() that returns the request upwards is before the UNIT_ATTENTION
> >> I was looking at the wrong source.
> >>
> >> scsi_finish_command checks for REQ_TYPE_BLOCK_PC and sets good_bytes to 
> >> scsi_bufflen, so when scsi_io_completion calls scsi_end_request, it 
> >> fails the request before we can get to the UNIT_ATTENTION.
> > 
> > Ah, yes, missed that.
> > 
> > However there are other problems then.  We can't just eat all unit
> > attentions on the BLOCK_PC path because some of the user programs want
> > to see them (CD burners for one).  I know the patch allows some to
> > proceed upwards, but it's risky making all except device not started do
> > a retry.
> > 
> > I'm a bit stumped on this one ... the intention of BLOCK_PC is that the
> > caller simply retries if they get a unit attention (which is what all
> > SCSI code does).  The block code doesn't want to look at the sense data
> > but at the error return.  I suppose we could make UNIT_ATTENTION
> > translate to -EAGAIN and have block do the right thing?
> > 
> The intention of BLOCK_PC is ok, but the point here is the barrier
> request isn't really a BLOCK_PC request. The caller precisely
> does _not_ want to look the sense code but rather have the SCSI
> layer do all the necessary things.
> 
> Why can't we just mark the barrier request as something else than
> BLOCK_PC, eg REQ_TYPE_SPECIAL?
> Then we'd avoid these pitfalls and everything should work as expected, right?

Unfortunately, not.  A long time ago we used to use SPECIAL for prepared
commands, but we stripped that path out.  If you look at the prep
functions today, they only accept either REQ_TYPE_FS or
REQ_TYPE_BLOCK_PC ... they kill everything else, so we'd have to do
surgery on all the input paths to get this to work.

Looking at all of this, I'm really unhappy with the way barriers are
working in SCSI ... using BLOCK_PC for them was a big mistake, since
block can't handle the errors and BLOCK_PC by its very nature requests
that all errors, however trivially fixable, be returned.

It looks like we have precisely the same problems with discard too,
except there at least we'll ignore the error.

Someone needs to take a good look at fixing this ... or at least just
making discard and barrier use the same submit paths, so we can fix it
up in the lower layers.

In the meantime, I think the SUCCESS/NEEDS_RETRY fiddle in check
condition is still the easiest hack.

James


