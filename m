From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 00:52:41 -0700
Message-ID: <20140527075241.GA9944@infradead.org>
References: <538359DB.9080601@acm.org>
 <53835A52.9010306@acm.org>
 <53835A77.1090708@acm.org>
 <1401118025.3303.5.camel@dabdike>
 <5384439C.1040604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaE0Hwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 03:52:43 -0400
Content-Disposition: inline
In-Reply-To: <5384439C.1040604@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, May 27, 2014 at 09:49:48AM +0200, Bart Van Assche wrote:
> > I don't see the value of patches 2,3 they're checking for an impossible
> > condition ... why might it be possible?
> 
> When reading the source code in scsi_error.c it's easy to overlook that
> scmd_eh_abort_handler(), scsi_abort_command() and scsi_eh_scmd_add() are
> all invoked for requests in which the REQ_ATOM_COMPLETE bit has been
> set. Although it is possible to mention this as a comment above these
> functions, such comments are not checked at runtime. It would require
> additional work from the reader to verify whether or not such source
> code comments are up to date. However, the condition inside a
> WARN_ON_ONCE() statement is checked every time the code is executed.
> Hence my preference for a WARN_ON_ONCE() statement instead of writing
> down somewhere that these three functions operate on requests in which
> the REQ_ATOM_COMPLETE bit has been set.


I really do like the REQ_ATOM_COMPLETE asserts - as experience tells
these kinds of assumptions are best checked, otherwise they will
unintentionally be violated.

I'm less excited about the list walk I have to say, as the overhead is
getting fairly large for a simple assertation.
