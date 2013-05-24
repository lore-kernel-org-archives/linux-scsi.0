From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 part1 1/4] sg_io: pass request_queue to
 blk_verify_command
Date: Fri, 24 May 2013 12:03:33 +0400
Message-ID: <1369382613.1945.19.camel@dabdike>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
	   <1369317503-4095-2-git-send-email-pbonzini@redhat.com>
	  <1369380965.1945.10.camel@dabdike> <519F1A28.6080303@redhat.com>
	 <1369381857.1945.15.camel@dabdike> <519F1C7A.2030605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <519F1C7A.2030605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-05-24 at 09:53 +0200, Paolo Bonzini wrote:
> Il 24/05/2013 09:50, James Bottomley ha scritto:
> > On Fri, 2013-05-24 at 09:43 +0200, Paolo Bonzini wrote:
> >> Il 24/05/2013 09:36, James Bottomley ha scritto:
> >>> On Thu, 2013-05-23 at 15:58 +0200, Paolo Bonzini wrote:
> >>>> Adjust the blk_verify_command function to let it look at per-queue
> >>>> data.  This will be done in the next patch.
> >>>
> >>> This is not a bug fix.  This is an enabler for your complex and to my
> >>> mind dubious rework of the SG_IO command filter.  I'm running out of
> >>> ways to say please don't mix bug fixes with features, because this
> >>> redesignating of the original patch set as part 1 and parts 2,3 doesn't
> >>> satisfy the requirement.
> >>
> >> I made it part 1/2/3 because parts 2/3 depend on part 1.  It makes
> >> dependency tracking easier, at least in my mind.
> >>
> >> If you have another solution that does not require passing request_queue
> >> to blk_verify_command, I'm all ears.
> > 
> > That's a circular response that doesn't answer the question.  The actual
> > question is: what is simple fix for the bug that isn't entangled with
> > enabling the SG_IO per device type whitelist feature.
> > 
> >>> Does anyone in the real world actually care about this bug?
> >>
> >> Yes, or I would move on and not waste so much time on this.
> > 
> > Fine, so produce a simple fix for this bug which we can discuss that's
> > not tied to this feature.
> 
> Honestly, I have no idea how this is even possible.

Really?  It looks to me like a simple block on the commands for disk
devices in the opcode switch would do it (with a corresponding change to
sg.c:sg_allow_access).

James
