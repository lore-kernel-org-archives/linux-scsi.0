From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 11:00:11 +0200
Message-ID: <5384541B.1010400@acm.org>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>		 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>	 <5384439C.1040604@acm.org> <1401179019.14454.18.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:39939 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaE0JAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 05:00:15 -0400
In-Reply-To: <1401179019.14454.18.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On 05/27/14 10:23, James Bottomley wrote:
> On Tue, 2014-05-27 at 09:49 +0200, Bart Van Assche wrote:
>> When reading the source code in scsi_error.c it's easy to overlook that
>> scmd_eh_abort_handler(), scsi_abort_command() and scsi_eh_scmd_add() are
>> all invoked for requests in which the REQ_ATOM_COMPLETE bit has been
>> set.
> 
> I really don't like this entanglement of state of block and SCSI.
> "complete" in block terms isn't the same as in SCSI terms.  The
> REQ_ATOM_COMPLETE flag is fully internal to block and indicates that
> we've taken over processing the command and any completions into block
> get ignored.  This is for the possible race between timeout and inbound
> command completion.  If you start coding SCSI assertions in terms of it,
> you're entangling layers that should be separate.
> 
> The assertion in SCSI terms is that abort and ->done cannot race.

Recent e-mail threads on the linux-scsi mailing list have shown that it
is easily overlooked which error handler functions are called only for
requests marked by the block layer as "complete" and hence cannot race
with scsi_softirq_done(). So far my proposals for how to improve the
documentation of how this race is avoided were rejected. Do you perhaps
have a proposal of how this should be documented properly ?

Thanks,

Bart.

