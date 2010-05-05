From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Wed, 5 May 2010 09:28:16 -0400
Message-ID: <20100505132816.GA21362@infradead.org>
References: <20100504144853.D94C72A205@ochil.suse.de> <1272990403.5255.27.camel@mulgrave.site> <4BE0804D.1030406@cs.wisc.edu> <4BE08320.40206@cs.wisc.edu> <1273005003.16631.43.camel@mulgrave.site> <4BE10F89.4020101@suse.de> <1273065593.5227.42.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007Ab0EEN2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2010 09:28:19 -0400
Content-Disposition: inline
In-Reply-To: <1273065593.5227.42.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Wed, May 05, 2010 at 09:19:53AM -0400, James Bottomley wrote:
> Unfortunately, not.  A long time ago we used to use SPECIAL for prepared
> commands, but we stripped that path out.  If you look at the prep
> functions today, they only accept either REQ_TYPE_FS or
> REQ_TYPE_BLOCK_PC ... they kill everything else, so we'd have to do
> surgery on all the input paths to get this to work.
> 
> Looking at all of this, I'm really unhappy with the way barriers are
> working in SCSI ... using BLOCK_PC for them was a big mistake, since
> block can't handle the errors and BLOCK_PC by its very nature requests
> that all errors, however trivially fixable, be returned.
> 
> It looks like we have precisely the same problems with discard too,
> except there at least we'll ignore the error.
> 
> Someone needs to take a good look at fixing this ... or at least just
> making discard and barrier use the same submit paths, so we can fix it
> up in the lower layers.

Both barriers and dicards are FS requests as far as the block layer is
concerned.  We turn them into BLOCK_PC requests very late in the game,
either in the prepare_flush function for barriers, or directly inside
prep_fn for discard.  I tried to handle discard requests as FS all
the way through, but the various different ways in which we account for
a request length didn't play nicely with that.

Handling cache flushes as FS requests all the way through should be
easier than that.

