From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 21:35:02 -0700
Message-ID: <1369456502.5008.5.camel@dabdike>
References: <20130522134134.GA15189@mtj.dyndns.org>
	 <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org>
	 <519CDDA4.2050100@redhat.com> <20130522193009.GA23845@mtj.dyndns.org>
	 <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org>
	 <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org>
	 <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org>
	 <519F12FF.6090809@redhat.com>
	 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-05-24 at 17:02 +0900, Tejun Heo wrote:
> On Fri, May 24, 2013 at 4:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> The same filtering table being applied to different classes of
> >> hardware is a software bug, but my point is that the practive
> >> essentially entrusts non-insignificant part of security enforcement to
> >> the hardware itself.  The variety of hardware in question is very wide
> >> and significant portion has historically been known to be flaky.
> >
> > Unproven theory, and contradicted by actual practice.  Bugs are more
> > common in the handling of borderline conditions, not in the handling of
> > unimplemented commands.
> >
> > If you want to be secure aginst buggy firmware, the commands you have to
> > block are READ and WRITE.  Check out the list of existing USB quirks.
> 
> Well, I'd actually much prefer disabling CDB whitelisting for all !MMC
> devices if at all possible.

I'll go along with this.  I'm also wondering what the problem would be
if we just allowed all commands on either CAP_SYS_RAWIO or opening the
device for write, so we just defer to the filesystem permissions and
restricted read only opens to the basic all device opcodes.

>  You're basically arguing that because what
> we have is already broken, it should be okay to break it further.
> Also, RW commands having more quirks doesn't necessarily indicate that
> they tend to be more broken. They just get hammered on a lot in
> various ways so problems on those commands tend to be more noticeable.

I agree with this, so finding a way to get rid of the opcode table seems
to be what we need.

> > You need to allow more commands.
> > The count-me-out knob allows all commands.
> > You cannot always allow all commands.
> > Ergo, you cannot always use the count-me-out knob.

Do we have a real world example of this?  Getting the kernel out of the
command filtering business does seem to be a good idea to me.

> The thing is that both approaches aren't perfect here so you can make
> similar type of argument from the other side. If the system wants to
> give out raw hardware access to VMs, requiring it to delegate the
> device fully could be reasonable. Not ideal but widening direct
> command access by default is pretty nasty too.

James
