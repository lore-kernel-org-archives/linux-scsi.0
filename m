From: Jann Horn <jannh@google.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Tue, 10 Jul 2018 10:36:02 -0700
Message-ID: <CAG48ez0Ccpp3yv+FVX9Sp3WHqPh6US=quDjELmv5RYVgqfBtVg@mail.gmail.com>
References: <1530913134.3135.2.camel@HansenPartnership.com>
 <CA+55aFy-o3fRtkQnJU=0zv7CPUtgfKiwhfQi_05K25Y_-mx+_w@mail.gmail.com>
 <CA+55aFxQ8QzGTWsVdVQVok9cLbgZDFjG2g3JZtWJd+G9jHkYoQ@mail.gmail.com>
 <CA+55aFxAy__3hE1OoUFPKZfptLT1cXuoujsnSGXBMzJPQ+Qjzg@mail.gmail.com>
 <1530940958.3135.4.camel@HansenPartnership.com> <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwg-2GP4ASTdd1pusmZkF7c8AN9febVDCaioDxzYJSLfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 9, 2018 at 5:41 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Jul 6, 2018 at 10:22 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > We did discuss removing the r/w interface, but, as you say, it's been
> > around for ages so it's not clear what regressions would surface if we
> > did.
>
> So since nobody else followed up on this, the attached patch is what I
> was thinking of just committing.
>
> It removes the warnings from the access check, and just puts them
> (unconditionally) at the top of the read/write function instead.
>
> Hmm?

Random unimportant nitpickery:

AFAICS it does mean that if two processes use /dev/sg* - the first one
in a way that passes sg_check_file_access(), the second one in a way
that gets blocked for whatever reason -, the pr_err_once() will fire
for the process that's working and not fire for the one that got
blocked. But if nobody should be using that interface anyway, I guess
that's not a practical concern.

Also, the device is called /dev/sg%d with %d being sdp->index.
