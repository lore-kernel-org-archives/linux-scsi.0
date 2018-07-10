From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Tue, 10 Jul 2018 15:24:20 -0700
Message-ID: <CA+55aFxdkGTQ-djy6Z4D52xzHhwWdqQyfVgKweTiUfRpvYoztw@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
 <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
 <1530940958.3135.4.camel@HansenPartnership.com> <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
 <70d566f0-2dda-60c2-7c7a-e09e371f8607@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70d566f0-2dda-60c2-7c7a-e09e371f8607@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tonyb@cybernetics.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 10, 2018 at 2:53 PM Tony Battersby <tonyb@cybernetics.com> wrote:
>
> At my job (https://www.cybernetics.com/), I use the write()/read()
> interface to the SCSI generic driver for access to tape drives and tape
> medium changers.  For example, the write()/read() interface is useful
> for implementing RAID-like functionality for tape drives since a single
> thread can send commands to multiple tape drives at once and poll() for
> command completion.

Ugh.

> We have a lot of code invested in this interface,
> so it would be a huge pain for us if it were removed.  But in our case,
> everything runs as root (as the firmware of an embedded storage
> appliance), so extra permission checks should be OK.

I wonder if we could make the warning literally about not having
CAP_SYS_RAWIO on the file descriptor.

Because the /dev/sg interfaces don't even do the kind of command
filtering that the SG_IO code does.

The SG_IO code (well, at least the block/scsi_ioctl.c code - again
/dev/sg does NOT get it right!) actually has a whitelist of commands
that have known behavior, and that can be done by normal users when
you open a device.

To actually do _arbitrary_ commands, you have to have CAP_SYS_RAWIO.
And there we check the _current_ capabilities (not the file descriptor
one), because an ioctl isn't something you just fool a random suid
program into doing for you.

So /dev/sg really has serious issues. Not just the read/write part,
but even the SG_IO part is broken right now (sg_new_write() actually
does do blk_verify_command(), but only for read-only opens for some
reason).

                 Linus
