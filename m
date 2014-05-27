From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 08:00:32 +0000
Message-ID: <1401177631.14454.9.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
	 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>
	 <5384439C.1040604@acm.org> <20140527075241.GA9944@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:56548 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaE0IAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 04:00:38 -0400
In-Reply-To: <20140527075241.GA9944@infradead.org>
Content-Language: en-US
Content-ID: <776CB029B3251D4197B6F3E474F37084@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, 2014-05-27 at 00:52 -0700, hch@infradead.org wrote:
> On Tue, May 27, 2014 at 09:49:48AM +0200, Bart Van Assche wrote:
> > > I don't see the value of patches 2,3 they're checking for an impossible
> > > condition ... why might it be possible?
> > 
> > When reading the source code in scsi_error.c it's easy to overlook that
> > scmd_eh_abort_handler(), scsi_abort_command() and scsi_eh_scmd_add() are
> > all invoked for requests in which the REQ_ATOM_COMPLETE bit has been
> > set. Although it is possible to mention this as a comment above these
> > functions, such comments are not checked at runtime. It would require
> > additional work from the reader to verify whether or not such source
> > code comments are up to date. However, the condition inside a
> > WARN_ON_ONCE() statement is checked every time the code is executed.
> > Hence my preference for a WARN_ON_ONCE() statement instead of writing
> > down somewhere that these three functions operate on requests in which
> > the REQ_ATOM_COMPLETE bit has been set.
> 
> 
> I really do like the REQ_ATOM_COMPLETE asserts - as experience tells
> these kinds of assumptions are best checked, otherwise they will
> unintentionally be violated.
> 
> I'm less excited about the list walk I have to say, as the overhead is
> getting fairly large for a simple assertation.

OK, my two objections are unconditional export of state from block that
we're trying to confine there.  Experience shows we'll grow unwanted
users of blk_rq_completed.  Probably export the assert from block not
blk_rq_completed().

The second is the WARN_ON_ONCE.  If this assert fails, we're doing error
handling on an uncompleted command and that will cause double
completion, leading to a massive cockup but one which might not
necessarily bring the machine down, so this should be BUG_ON

James

