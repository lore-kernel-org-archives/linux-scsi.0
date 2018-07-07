From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Fri, 6 Jul 2018 20:25:14 -0700
Message-ID: <CA+55aFxp8zRN_QDaAsezWwHTYhtvLYqromaeB5F4eDz18Tdxcw@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com> <CAG48ez1rkG=R82eeuYA7s9S6z7+iRfJpVb__PmYaecjZAZETaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1rkG=R82eeuYA7s9S6z7+iRfJpVb__PmYaecjZAZETaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Doug Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 6, 2018 at 8:08 PM Jann Horn <jannh@google.com> wrote:
>
>
> I guess we could try that...
> Douglas Gilbert said that the read/write interface was the original
> one, so there might be some users left...

I think it's the "original" interface as in "predating Linux, and
maybe early 90's".

There are *very* few things that do direct SCSI commands in the first
place. The traditional thing was for things like low-level formatting
and for reading audio CD data or burning CD/DVD's.

Yes, in _theory_ there are other things, but they are much more rare.

ATA made /dev/sg* irrelevant for CD/DVDs, and you literally *had* to
use SG_IO to do it.

And if it's anything even remotely generic (ie "this can work on SATA
or NVMe"), again, only SG_IO has a chance in hell of working.

I could imagine that yes, there's some crazy vendor disk array
configuration tool that still uses read/write since it only works with
some very particular hardware, but even then SG_IO should just be much
more convenient than the odd read/write interface.

> > but maybe some distro decided that everybody should have direct device access..
>
> Al Viro pointed out that some distros grant access to CD devices to
> non-root. I've checked in a Debian VM and a Ubuntu VM, and there,
> /dev/sg0 is mode 0660, group "cdrom". That's not "everybody", but it's
> not just root. At least in the Ubuntu VM, the user account that the
> system installer created has access to "cdrom", but accounts that I
> create afterwards using the settings UI don't get access to that
> group. Unless other distros are more lax, it's probably not a big
> issue?

I suspect Fedora is similar. I have a USB storage device, which is why
I have /dev/sg0, and it's in the "disk" group. I'm not part of it even
as the primary user, so..

Anyway, cdrom devices are definitely *not* a reason for using
/dev/sg*, exactly because no cdrom burner would ever use anything but
SG_IO, because it they did, they'd not work in 99% of all cases during
the big reign of cheap ATA CD/DVD drives.

                Linus
