From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 13:25:59 -0700
Message-ID: <CA+55aFw5xsPx0r01Z5aKXn6UbHLhGbXoa0qyGVJbfWiC7yq1WA@mail.gmail.com>
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
> The QEMU people have accepted it as their bug and are fixing it.

Of course they are. Somebody found a bug in their device model, I'd
expect nothing else.

But I'm not worried about qemu. I'm worried about all the other random
devices that have never been tested.

>  There's no other course of action, really because we can't stop people
> sending this command using the BLOCK_PC interface from user space, so
> it's now a known and easy to use way of stopping the device from
> responding.

Bah. That's not an argument from kernel space. We've had that forever.
Broken device that hangs up when you try to read past the end? If you
can open the raw device for reading, you can still do a
SCSI_IOCTL_SEND_COMMAND to send that read command past the end.

The fact that you can craft special commands that can cause problems
for specific devices (if you have access to the raw device) does *not*
at all argue that the kernel should then do those accesses of its own
volition.

My worry basically comes down to: we're clearly now doing something
that has never ever been tested by anybody before.

And I think that the assumption that the bug would magically be
limited to qemu is a *big* assumption.

                Linus
