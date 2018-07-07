From: Jann Horn <jannh@google.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Sat, 7 Jul 2018 05:08:01 +0200
Message-ID: <CAG48ez1rkG=R82eeuYA7s9S6z7+iRfJpVb__PmYaecjZAZETaw@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com> <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 7, 2018 at 4:39 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Jul 6, 2018 at 7:31 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Who actually does direct read/write to /dev/sg? Could we perhaps just
> > add a config option to disable it entirely?
>
> On the IB side, the argument was that there was some crazy binary-only
> vendor management code that really wanted to use this completely crazy
> interface.
>
> I also think that the warnings are dubious. I'd rather add a
> deprecation warning to the whole "read/write to /dev/sg" itself, and
> then do what we did for ib_safe_file_access(), which was to just have
> the permission checks.

I guess we could try that...
Douglas Gilbert said that the read/write interface was the original
one, so there might be some users left... but the two hits I just
looked at on Debian codesearch seem to have switched to the SG_IO
ioctl already, using the read/write API as fallback only.

> It's not like a normal person should have access to /dev/sg to begin
> with. So it's not like you can open /dev/sg0 and then try to fool a
> suid program into doing the actual IO.
>
> I'd hope.
>
> Maybe I'm wrong, and there's some crazy "let's make /dev/sg available
> to normal users" setup out there somewhere. At least for me, /dev/sg
> isn't accessible to normal people:
>
>   [torvalds@i7 linux]$ cat /dev/sg0
>   cat: /dev/sg0: Permission denied
>
> but maybe some distro decided that everybody should have direct device access..

Al Viro pointed out that some distros grant access to CD devices to
non-root. I've checked in a Debian VM and a Ubuntu VM, and there,
/dev/sg0 is mode 0660, group "cdrom". That's not "everybody", but it's
not just root. At least in the Ubuntu VM, the user account that the
system installer created has access to "cdrom", but accounts that I
create afterwards using the settings UI don't get access to that
group. Unless other distros are more lax, it's probably not a big
issue?
