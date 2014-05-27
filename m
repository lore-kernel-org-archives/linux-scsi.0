From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 08:23:43 +0000
Message-ID: <1401179019.14454.18.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
		 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>
	 <5384439C.1040604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:53173 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaE0IXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 04:23:45 -0400
In-Reply-To: <5384439C.1040604@acm.org>
Content-Language: en-US
Content-ID: <55F7DA6FA37BD64DA7B25722275E697B@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, 2014-05-27 at 09:49 +0200, Bart Van Assche wrote:
> On 05/26/14 17:27, James Bottomley wrote:
> > On Mon, 2014-05-26 at 17:15 +0200, Bart Van Assche wrote:
> >> Make it possible to test the REQ_ATOM_COMPLETE bit from outside the
> >> block layer core.
> > 
> > I don't see the value of patches 2,3 they're checking for an impossible
> > condition ... why might it be possible?
> 
> When reading the source code in scsi_error.c it's easy to overlook that
> scmd_eh_abort_handler(), scsi_abort_command() and scsi_eh_scmd_add() are
> all invoked for requests in which the REQ_ATOM_COMPLETE bit has been
> set.

I really don't like this entanglement of state of block and SCSI.
"complete" in block terms isn't the same as in SCSI terms.  The
REQ_ATOM_COMPLETE flag is fully internal to block and indicates that
we've taken over processing the command and any completions into block
get ignored.  This is for the possible race between timeout and inbound
command completion.  If you start coding SCSI assertions in terms of it,
you're entangling layers that should be separate.

The assertion in SCSI terms is that abort and ->done cannot race.

James

>  Although it is possible to mention this as a comment above these
> functions, such comments are not checked at runtime. It would require
> additional work from the reader to verify whether or not such source
> code comments are up to date. However, the condition inside a
> WARN_ON_ONCE() statement is checked every time the code is executed.
> Hence my preference for a WARN_ON_ONCE() statement instead of writing
> down somewhere that these three functions operate on requests in which
> the REQ_ATOM_COMPLETE bit has been set.


