From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 12:57:12 -0700
Message-ID: <CA+55aFxYA66mbx9jrWCmK5SeCA1EEgKMK=wXUGJjT-JyxOWTOA@mail.gmail.com>
References: <1465668572.2364.26.camel@HansenPartnership.com>
 <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
 <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com> <1465674067.2364.43.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465674067.2364.43.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 11, 2016 at 12:41 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> It looks like there's a hole where the emulation should be for the VPD
> inquiry, which is what cause the whole hang up and never speak to us
> again problem.

So? What makes you think real hardware doesn't have those kinds of issues?

This is no different from all the various real pieces of hardware that
lock up when you ask for a particular mode page that they don't
support. We are *very* careful not to randomly read mode pages because
of that issue. Several things are done only if the device claims it is
of a sufficiently new SCSI revision etc.

None of this is new.

The fact that Windows apparently doesn't do the VPD inquiry - since
qemu works work windows - should make you very very worried. Instead,
you completely ignore this and say "oh, it's just a qemu bug".

Software that isn't tested doesn't work. That's simply a fact that all
programmers should be intimately familiar with. I'm hoping you know
that.

Buit why the hell do you then believe that hardware is any different?
Because I can most definitely tell you it isn't.

Really. You have entirely ignored the "nobody has apparently ever
asked for vpd information" argument.

You also don't say what it was that we did to start asking for vpd
information. What's the commit this fixes? What is it that actually
introduced this problem? And why can it not - like our mode page
things - look at a lot of other fields first to judge whether the
known problematic access is really worth it.

Look at all those other blacklists we have. They are for real devices.
Things like "don't do mode page 3f" etc. All the checks we do before
we decide it's even worth it asking for caching information.

We have a lot of "let's be cautious" with mode page accesses. What did
we do that is different for vpd? Maybe that wasn't cautious enough.

Because we do have *other* devices that already have skip_vpd_pages
set.  So this whole thing was clearly never limited to qemu emulation.

So answer me already: what was the change that actually made us break recently?

And *why* do you seem to continue to believe that hardware cannot be
broken, despite all the evidence that said hardware has never ever
been tested?

                Linus
