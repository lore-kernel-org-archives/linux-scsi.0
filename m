From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 10:21:32 +0000
Message-ID: <1401186086.14454.43.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
			 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>
		 <5384439C.1040604@acm.org> <1401179019.14454.18.camel@dabdike>
	 <5384541B.1010400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:48798 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaE0KVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 06:21:35 -0400
In-Reply-To: <5384541B.1010400@acm.org>
Content-Language: en-US
Content-ID: <06CF5878353E3A4C92B500876A56295D@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, 2014-05-27 at 11:00 +0200, Bart Van Assche wrote:
> On 05/27/14 10:23, James Bottomley wrote:
> > On Tue, 2014-05-27 at 09:49 +0200, Bart Van Assche wrote:
> >> When reading the source code in scsi_error.c it's easy to overlook that
> >> scmd_eh_abort_handler(), scsi_abort_command() and scsi_eh_scmd_add() are
> >> all invoked for requests in which the REQ_ATOM_COMPLETE bit has been
> >> set.
> > 
> > I really don't like this entanglement of state of block and SCSI.
> > "complete" in block terms isn't the same as in SCSI terms.  The
> > REQ_ATOM_COMPLETE flag is fully internal to block and indicates that
> > we've taken over processing the command and any completions into block
> > get ignored.  This is for the possible race between timeout and inbound
> > command completion.  If you start coding SCSI assertions in terms of it,
> > you're entangling layers that should be separate.
> > 
> > The assertion in SCSI terms is that abort and ->done cannot race.
> 
> Recent e-mail threads on the linux-scsi mailing list have shown that it
> is easily overlooked which error handler functions are called only for
> requests marked by the block layer as "complete" and hence cannot race
> with scsi_softirq_done(). So far my proposals for how to improve the
> documentation of how this race is avoided were rejected. Do you perhaps
> have a proposal of how this should be documented properly ?

Um, if that's your goal, then I don't see how adding a 
	WARN_ON_ONCE(!blk_rq_completed(scmd->request));
makes it clear that timeout and the softirq cannot race.

I suppose for me, it's just an obvious systems assertion since every
command must be in a defined state for the state model, either a command
has timed out or it's in normal completion.  But since we inherit this
race mediation from block, isn't that the place to document it if people
are confused?

I could also see us one day extending the TMF capability to abort any
running command, which would make even an assertion of block timed out
or completed invalid.

James

