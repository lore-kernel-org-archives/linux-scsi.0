From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/2] convert sg to use block layer helpers
Date: Fri, 9 Feb 2007 18:29:55 +0100
Message-ID: <20070209172955.GB3873@kernel.dk>
References: <1171010063.3713.26.camel@max> <45CCA6D2.10008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:27493 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946582AbXBIR3c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 12:29:32 -0500
Content-Disposition: inline
In-Reply-To: <45CCA6D2.10008@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Fri, Feb 09 2007, Douglas Gilbert wrote:
> Mike Christie wrote:
> > sg duplicates a lot of block layer dio and copying code. The block layer
> > is missing some things like mmap helpers and a way to support sg and
> > st's reserve buffer. The next two patches move move functionality from
> > sg to the block layer so later st and osst can use it, and then coverts
> > sg to use the block layer helper.
> > 
> > The goal is to kill scsi_execute_async and friends and covert the ULDs
> > to use the block layer functions directly. This is nice because
> > scsi_execute_async sucks and it actually duplicates block layer code,
> > and in the end the scsi layer does not have to do any bio processing
> > (which irks Jens :)), and we have common code for all ULDs.
> > 
> > The patches were made over Jens's bsg branch in his block layer git tree
> > on kernel.org. Sorry for the large patches. The sg conversion patch rips
> > out alot of code duplicated in the block layer and the patch to add some
> > missing functionality to the block layer has conversions to bsg, tgt,
> > etc so git bisect works on it.
> 
> Mike,
> Might I suggest ripping all the scatter gather list
> handling out of the block layer and putting it in
> a library (a bit like libata). That way when the
> block layer paradigm doesn't apply, we don't lose
> all the useful things that have been put in there.

Don't think block layer, think block IO helpers. That's essentially what
large parts of the block layer is.

-- 
Jens Axboe

