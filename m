From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 12:29:18 -0700
Message-ID: <1465673358.2364.37.camel@HansenPartnership.com>
References: <1465668572.2364.26.camel@HansenPartnership.com>
	 <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59350 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbcFKT3V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2016 15:29:21 -0400
In-Reply-To: <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, 2016-06-11 at 11:54 -0700, Linus Torvalds wrote:
> On Sat, Jun 11, 2016 at 11:09 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Two current fixes: one affects Qemu CD ROM emulation, which stopped
> > working after the updates in SCSI to require VPD pages from all
> > conformant devices.  Fix temporarily by blacklisting Qemu (we can
> > relax
> > later when they come into compliance).
> 
> Is there some reason to believe that the qemu CD-ROM emulation is the
> only one with this problem?

CD ROM manufacturers are usually reasonably good at standards
compliance, so yes, I expect real devices to work.  The reason the QEMU
one is failing is because it's emulated not produced by a manufacturer.

> When some device is known to break because the SCSI layer made some
> check stricter, why didn't you just relax the check again?
> 
> In other words, you already have one known device that behaves a way
> that the new code doesn't like, why do you think the new code is
> correct?

This isn't a stricter check, it's probing the device for more
information which we then use to set block parameters.  If we don't set
them, we can still use the device, but possibly not as efficiently
(even for a fast 16x or 32x DVD, this will affect the burn speed).

The device is allowed to say no.  The problem with the QEMU device is
that it wasn't saying anything.  It was hanging up and never responding
again, leading to a complete boot failure.

> And don't answer "specs". Specs are just so much toilet paper.

I actually ran out of SCSI specs a while ago.  Fortunately the kernel
ABI doc is soft, strong, and very, very long.

> If the Qemu CD-ROM emulation has worked with not just older versions
> of Linux, but presumably Windows and other OS's too, then it's likely
> that nobody has ever cared about the VPD pages before, and thus the
> new code that requires VPD is likely to break other things too.
> 
> So give a reason why you think qemu is _sop_ special, and why the new
> and clearly broken "require VPD" code is _so_ important.
> 
> And really, if the reason is "specs", then somebody needs to get 
> their head examined. We've had so many devices that only glance 
> quickly at the specs that people need to realize that paperwork is 
> one thing, and reality is another, and the two have only a very
> tenuous connection.
> 
> The commit that adds this "no VPD" entry doesn't even talk about when
> we broke this.  What change exactly was it that broke things?
> 
> I've pulled this, but I really think that this was completely bogus.
> Even if blacklisting ends up being the right thing to do in the end,
> the lack of explanations is awful, and the assumption that it's just
> one particular device is very very suspect.

So on the specs thing, we don't expect full compliance and we do code
around problem responses or things missing programmatically (mostly). 
 However, the problem here is the device effectively committing suicide
when it sees a VPD inquiry.  We do expect things like this sometimes
(mosly from USB manufacturers who seem to regard use of specs the same
way you do) but usually we have to blacklist them too to prevent the
problem command reaching the device.

James


