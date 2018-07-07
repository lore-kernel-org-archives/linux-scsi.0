From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Fri, 06 Jul 2018 22:22:38 -0700
Message-ID: <1530940958.3135.4.camel@HansenPartnership.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
         <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
         <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
         <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-07-06 at 19:48 -0700, Linus Torvalds wrote:
> On Fri, Jul 6, 2018 at 7:39 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > 
> > I'd rather add a deprecation warning to the whole "read/write
> > to /dev/sg" itself
> 
> In the meantime, I've pulled this, but do wonder why we actually
> allow that crazy read/write that doesn't even work for any other
> models (ie I guarantee you that cdrom writers etc don't use that
> interface, because SG_IO is the only thing that works on most
> hardware).

We did discuss removing the r/w interface, but, as you say, it's been
around for ages so it's not clear what regressions would surface if we
did.  It's mostly root only (with certain distro exceptions), so the
consensus for a short term fix was to make sure it couldn't be
exploited.  Long term we'll absolutely look into removing it.

The argument I've seen for the old interface is userspace programs that
want multiple outstanding commands in the old event driven single
threaded model (with SG_IO you need one thread for each command) but if
you asked me to name any, I couldn't, so perhaps they're all gone by
now.

James
