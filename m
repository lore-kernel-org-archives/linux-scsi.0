From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 11:54:30 -0700
Message-ID: <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
References: <1465668572.2364.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465668572.2364.26.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 11, 2016 at 11:09 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Two current fixes: one affects Qemu CD ROM emulation, which stopped
> working after the updates in SCSI to require VPD pages from all
> conformant devices.  Fix temporarily by blacklisting Qemu (we can relax
> later when they come into compliance).

Is there some reason to believe that the qemu CD-ROM emulation is the
only one with this problem?

When some device is known to break because the SCSI layer made some
check stricter, why didn't you just relax the check again?

In other words, you already have one known device that behaves a way
that the new code doesn't like, why do you think the new code is
correct?

And don't answer "specs". Specs are just so much toilet paper.

If the Qemu CD-ROM emulation has worked with not just older versions
of Linux, but presumably Windows and other OS's too, then it's likely
that nobody has ever cared about the VPD pages before, and thus the
new code that requires VPD is likely to break other things too.

So give a reason why you think qemu is _sop_ special, and why the new
and clearly broken "require VPD" code is _so_ important.

And really, if the reason is "specs", then somebody needs to get their
head examined. We've had so many devices that only glance quickly at
the specs that people need to realize that paperwork is one thing, and
reality is another, and the two have only a very tenuous connection.

The commit that adds this "no VPD" entry doesn't even talk about when
we broke this.  What change exactly was it that broke things?

I've pulled this, but I really think that this was completely bogus.
Even if blacklisting ends up being the right thing to do in the end,
the lack of explanations is awful, and the assumption that it's just
one particular device is very very suspect.

                    Linus
