From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Tue, 27 May 2014 11:26:12 +0000
Message-ID: <1401189970.14454.60.camel@dabdike>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
					 <53835A77.1090708@acm.org> <1401118025.3303.5.camel@dabdike>
				 <5384439C.1040604@acm.org> <1401179019.14454.18.camel@dabdike>
			 <5384541B.1010400@acm.org> <1401186086.14454.43.camel@dabdike>
		 <53846D3E.6050901@redhat.com> <1401188364.14454.51.camel@dabdike>
	 <53847364.7060900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:51723 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaE0L0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 07:26:14 -0400
In-Reply-To: <53847364.7060900@redhat.com>
Content-Language: en-US
Content-ID: <2A9CB90D6C90D44090B2E6DEB2352AA2@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "jdl1291@gmail.com" <jdl1291@gmail.com>

On Tue, 2014-05-27 at 13:13 +0200, Paolo Bonzini wrote:
> Il 27/05/2014 12:59, James Bottomley ha scritto:
> > On Tue, 2014-05-27 at 12:47 +0200, Paolo Bonzini wrote:
> >> Il 27/05/2014 12:21, James Bottomley ha scritto:
> >>> I could also see us one day extending the TMF capability to abort any
> >>> running command, which would make even an assertion of block timed out
> >>> or completed invalid.
> >>
> >> Actually the assertion would remain valid, and that's exactly what Bart
> >> wants to document with this assertion.
> >
> > No, it wouldn't: if we abort a running command by definition the command
> > hadn't timed out and might not be completed.  This is required by TMF
> > handling because now you have an abort racing with a completion.  Either
> > the command completes normally because it misses the abort or the abort
> > gets to it and its returned status is set to TASK_ABORTED.  That's the
> > only way you can tell if the abort was successful or not.
> >
> > If you're thinking we would tell block to ignore returning commands
> > before issuing the abort, we'd never be able to tell if the abort were
> > successful, so we have to allow the race to collect the status.
> 
> You could use a different mechanism than a softirq to tell the abort 
> were successful, for example by overriding scsi_done.  But with respect 
> to the block layer, the mechanics of avoiding the race and double-free 
> would probably be the same.

I think there's some confusion about what the race and double free is:
It only occurs with timeouts.  In a timeout situation, the host had
decided it's not waiting any longer for the target to respond and
proceeds to error recovery.  At any time between the host making this
decision up to the point it kicks the target hard enough to clear all
in-flight commands, the target may return the command.  If we didn't
have some ignore function on command completions while we're handling
errors, this would lead to double completion.

If we decided to allow arbitrary aborts of running commands, we would
send a TMF in during the normal (i.e. un timed out) command period.
Because there's no timeout involved, there's no double free problem.
The race in this case is whether the abort catches the command or not
and to mediate that race we need the normal status return.

James

