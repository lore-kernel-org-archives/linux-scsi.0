From: Jann Horn <jannh@google.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.18-rc3
Date: Mon, 16 Jul 2018 18:20:35 +0200
Message-ID: <CAG48ez0h4c7z+a6Dj-94Wb4-HdWM1YbrBd44oyBEiQyu8NhCKA@mail.gmail.com>
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

On Tue, Jul 10, 2018 at 2:41 AM Linus Torvalds
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

Minor issue:

+ pr_err_once("process %d (%s) does direct read on /dev/sg",
+ task_tgid_vnr(current), current->comm);
[...]
+ pr_err_once("process %d (%s) does direct write on /dev/sg",
+ task_tgid_vnr(current), current->comm);

printk wants a newline at the end of the message, otherwise the
message hangs until the next message is printed.
