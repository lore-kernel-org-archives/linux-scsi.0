From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Sat, 14 Jun 2014 08:10:20 -0700
Message-ID: <1402758620.2224.121.camel@dabdike.int.hansenpartnership.com>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
	 <20140613185221.GA11872@infradead.org>
	 <1402686574.2224.61.camel@dabdike.int.hansenpartnership.com>
	 <CAHdzE-8kNKgKXyHUwO+HSMnvoHzb-pKW6PLWWLKohk2d+=gqyQ@mail.gmail.com>
	 <1402687105.2224.64.camel@dabdike.int.hansenpartnership.com>
	 <CAHdzE-_dDiHzj4pDUsVOdS26m7z3Rdgdt+9Wh=x-_mJL6XThXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAHdzE-_dDiHzj4pDUsVOdS26m7z3Rdgdt+9Wh=x-_mJL6XThXQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-13 at 19:50 -0700, Venkatesh Srinivas wrote:
> On 6/13/14, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> ...
> > OK, I've no idea what's in distro kernels, so you're looking for this
> > fix:
> >
> > commit d555a2abf3481f81303d835046a5ec2c4fb3ca8e
> > Author: James Bottomley <JBottomley@Parallels.com>
> > Date:   Fri Mar 28 10:50:17 2014 -0700
> >
> >     [SCSI] Fix spurious request sense in error handling
> >
> > It went into v3.15-rc3.  It looks like it wasn't backported to stable.
> 
> Backporting this fix to 3.14 appears to resolve this problem. Thank you!

OK, I've sent the patch in to Stable.

> 0) I don't understand how a command would be re-issued while its
> original is inflight without this patch. If we send down a spurious
> REQUESE SENSE and get NO SENSE, scsi_decide_disposition() in
> scsi_eh_get_sense() will return FAILED and not resubmit the command.
> Do you know the trace that results in the duplicate command being sent
> down?

The original is still at the LLD while we reuse the scsi_command to send
the request sense.  We can easily get double completions from that if
the original happens to come back.  It violates one of the requirements
of error handling: we may not reuse the command until we've forced the
LLD to relinquish it.

> 1) virtio-scsi uses the address of the scsi_cmnd as a tag; if
> scsi_eh_get_sense() is invoked for a timed-out command before the
> command returned, the REQUEST SENSE task from scsi_send_eh_cmnd() will
> have the same tag as the unreturned prior task. Scary.
> 
> 2) We would like to see this patch sent to the stable kernel tree; do
> you plan to send it out to stable@? Are there any further tests you
> plan to run on that particular fix before sending it that way?

It's already gone to stable.

James
