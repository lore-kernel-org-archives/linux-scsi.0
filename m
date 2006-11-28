From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Tue, 28 Nov 2006 19:57:08 +0100
Message-ID: <20061128185708.GE5400@kernel.dk>
References: <456B2416.7000101@panasas.com> <456B38E9.6060209@cs.wisc.edu> <456B3C1F.4050907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:48159 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S935994AbWK1S4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 13:56:52 -0500
Content-Disposition: inline
In-Reply-To: <456B3C1F.4050907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Benny Halevy <bhalevy@panasas.com>

On Mon, Nov 27 2006, Mike Christie wrote:
> Mike Christie wrote:
> > Boaz Harrosh wrote:
> >> Playing with some tests which I admit are not 100% orthodox I have
> >> stumbled upon a bug that raises a serious question:
> >>
> >> In the call to scsi_execute_async() in the use_sg case, must the
> >> scatterlist* (pointed to by buffer) map a buffer that's contiguous in
> >> virtual memory or is it allowed to map disjoint segments of memory?
> > 
> > I thought they were continguous. I think James has said before that they
> > can be disjoint. When we converted sg it did not look like sg or st
> > supported disjoint. The main non dio path used a buffer from
> > get_free_pages so I thought that would always be contiguous. The dio
> > path then always set the first sg offset, but the rest it set to zero.
> 
> And the len is set to page size for the middle entries too.
> 
> But for the non DIO st path we can end up with some middle sg entires
> that are not a full page so that code in scsi_execute_async is broken
> for that.

If something doesn't work with non-contig sg entries, that would be a
bug. If the question is regarding holes in the sg list, that is probably
unchartered territory and I would not regard that as supported.

-- 
Jens Axboe

