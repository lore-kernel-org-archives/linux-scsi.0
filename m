From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 16:07:15 +0400
Message-ID: <1369224435.1811.22.camel@dabdike>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
	 <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org>
	 <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org>
	 <519C9CBC.3050003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <519C9CBC.3050003@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-05-22 at 12:23 +0200, Paolo Bonzini wrote:
> Il 22/05/2013 12:02, Tejun Heo ha scritto:
> > On Wed, May 22, 2013 at 11:53:30AM +0200, Paolo Bonzini wrote:
> >> Il 22/05/2013 11:32, Tejun Heo ha scritto:
> >>> On Wed, May 22, 2013 at 08:35:54AM +0200, Paolo Bonzini wrote:
> >>>> I'm not sure what is more ridiculous, whether the seven pings or the
> >>>> lack of review...
> >>>
> >>> So, ummm, I don't know what Jens is thinking but at this point I'm
> >>> basically waiting for someone else to pick it up as review to return
> >>> ratio is too low to continue.  It doesn't seem like I can get the
> >>> series into a shape I can ack with reasonable amount of effort.
> >>
> >> Then please say so.  I didn't find any comment in your review that I missed.
> > 
> > Well, I've tried that multiple times and didn't get the results that I
> > was expecting each time, so doing it all over again felt pointless.
> > Even now, you just repeat what you've been saying and I'd have to
> > fight through each and every point.
> 
> Yes, because I have no idea what _your_ point is.

OK, let me try.  I did draw straws with Jens at LSF to see who would
look at this and he lost, but the complexity of the patch set probably
makes it hard for him to find the time.

The first problem, which Tejun already pointed out is that you've
combined a "bug fix" with a large feature set in such a way that they
can't be separated, so saying the first four patches fix a bug isn't
helpful.

The second problem is that it's not at all clear what the bug actually
is.  You have to wade through tons of red hat bugzillas before you come
up with the fact that there's one command which we allow users to send
which is ambiguous: GPCMD_READ_SUBCHANNEL which has the same opcode as
UNMAP on a disk.  Once you finally work this out, you wonder what all
the fuss is about because UNMAP is advisory ... even if an unprivileged
user can now send the command, it can't be used to damage any data or
even get access to any data, so there doesn't seem to be an actual bug
to fix at all.

The various committees do try hard to ensure there's no opcode
overlap ... although they don't always succeed as you see with the UNMAP
above, so I'm not at all sure we need the huge complexity of per scsi
device type command filter lists, which is what the rest of the feature
additions is about.

The third problem is that in order to verify that all the code motion
doesn't actually introduce a bug, you have to wade through about seven
patches ... the patch split really isn't at all conducive to reviewing
this critical piece.

Finally, the patch for the feature I think you actually want, which is
13/14, could have been implemented fairly simply as a single patch and
doesn't have to be part of this series.

James
