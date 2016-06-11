From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 12:41:07 -0700
Message-ID: <1465674067.2364.43.camel@HansenPartnership.com>
References: <1465668572.2364.26.camel@HansenPartnership.com>
	 <CA+55aFyBOPjFoVMzGhxarXBtRfCVBBarxt-+L-_T63Taam9_qA@mail.gmail.com>
	 <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzoFPQB6GQ-bZZJQ2bQNxDyqioxZmsDxW=P7tVOauC+AA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ewan D. Milne" <emilne@redhat.com>, Jan Stancek <jstancek@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-06-11 at 12:12 -0700, Linus Torvalds wrote:
> On Sat, Jun 11, 2016 at 11:54 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > 
> > Is there some reason to believe that the qemu CD-ROM emulation is 
> > the only one with this problem?
> 
> Side note:the one thing that makes the qemu cd-rom emulator "special"
> is not that it's not real hardware: it's that it's a lot more likely
> to be tested than just about any other actual cd-rom out there,
> especially in environments that test new kernels. Lots of developers
> tend to have rather modern machines (and I haven't had a CD-ROM in my
> machine for the last couple of years, I think), or alternatively they
> end up booting things in emulation because it makes for easy testing.
> 
> So I really don't think that "oh, it happened only with a broken
> emulated device" is a very strong argument for saying that that
> emulated device was the problem.

It looks like there's a hole where the emulation should be for the VPD
inquiry, which is what cause the whole hang up and never speak to us
again problem.

> I really think it's likely that the whole "require VPD" is garbage.
> The whole "everybody and their dog has used qemu, and the qemu cd-rom
> emulation worked perfectly fine before" is a damn strong argument 
> that it's the new kernel doing something wrong.
> 
> So please figure our what the real breakage was, and fix *that*
> instead of blaming qemu.

The QEMU people have accepted it as their bug and are fixing it. 
 There's no other course of action, really because we can't stop people
sending this command using the BLOCK_PC interface from user space, so
it's now a known and easy to use way of stopping the device from
responding.  Fortunately, the effects seem to be confined to the CD
only ... but it could have been worse (*cough* venom floppy driver
*cough*)

James
