From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Fri, 6 Jul 2018 19:39:25 -0700
Message-ID: <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com> <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 6, 2018 at 7:31 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Who actually does direct read/write to /dev/sg? Could we perhaps just
> add a config option to disable it entirely?

On the IB side, the argument was that there was some crazy binary-only
vendor management code that really wanted to use this completely crazy
interface.

I also think that the warnings are dubious. I'd rather add a
deprecation warning to the whole "read/write to /dev/sg" itself, and
then do what we did for ib_safe_file_access(), which was to just have
the permission checks.

It's not like a normal person should have access to /dev/sg to begin
with. So it's not like you can open /dev/sg0 and then try to fool a
suid program into doing the actual IO.

I'd hope.

Maybe I'm wrong, and there's some crazy "let's make /dev/sg available
to normal users" setup out there somewhere. At least for me, /dev/sg
isn't accessible to normal people:

  [torvalds@i7 linux]$ cat /dev/sg0
  cat: /dev/sg0: Permission denied

but maybe some distro decided that everybody should have direct device access..

Jann?

                 Linus
