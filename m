From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 13:05:51 -0700
Message-ID: <CAKwvOd=c9RG2s3f-PgM1T84sHc5N9zcjrVpG5is+mGbTOxvtrQ@mail.gmail.com>
References: <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org> <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox> <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org> <20181026180515.GA12129@flashbox>
 <CAKwvOdnEHCmNjm-P068KQrbU0K+Dzyw_+_j7XLKJET0LWSz86A@mail.gmail.com> <CAHk-=wh0LsuM+kAZGbDaogDdSbdCk3GvXmjYVAMkpmLj2=VF=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wh0LsuM+kAZGbDaogDdSbdCk3GvXmjYVAMkpmLj2=VF=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bvanassche@acm.org, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <natechancellor@gmail.com>, hch@infradead.org, Kees Cook <keescook@google.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2018 at 12:22 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Oct 26, 2018 at 11:32 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > + Linus
> > I'm not about the process of removing code from the kernel.  Doesn't
> > that violate the "thou shalt not break userspace" rule?
>
> The only thing that breaks the "thou shalt not break userspace" rule
> is fairly simple: things that break user space.

Is removing a filesystem considered a userspace breakage?  If you have
an exofs mount, and you upgrade to a kernel with the RFC patch, you
will no longer be able to mount that type of FS.  Userspace code that
expects to mount an exofs FS would now always fail.  Maybe this is
equivalent to removing a previously supported mount option.
/proc/filesystems might have one less option.

So I guess this is different than dropping support for an architecture
since you cannot produce an updated kernel image, as opposed to this
RFC which would make existing drives fail to mount?

>
> Does removing the code break for somebody? If so we don't do it. But
> if nobody notices because nobody uses, it's fine.

Right, but it seems like a catch 22; it's not possible to prove that
nobody will notice because they are not using it.

Like the expression:
If a tree falls in a forest and no one is around to hear it, does it
make a sound?

If no one is using a kernel feature and its removed, will anyone notice?

If the maintainer would like to remove support for their subsystem,
should it continue to remain in the tree?  Code is never truly
deleted, and is relatively painless to resurrect with git.

Solutions that come to mind immediately:
* Just land the small fix discussed earlier in the thread. These
subsystems continue to exist.  Maybe this question comes up again for
this subsystem in a few years.  Christoph alludes to my question not
being the first time this was asked of this subsystem.
* Put out some kind of intent to deprecate, hoping to get feedback on
possible users that would be affected. Land the deletion patches in
-next.  This approach always runs the risk of not posting in the right
venue; and users can't be bothered to check for intent to deprecate
notices.
* Just delete it. Resurrect if users report use of this FS.

What are your thoughts?

>
> Basically, there is no "theoretical" rule about what breaks user space
> or not. In particular, the rule is *not* that you can't change ABI.
> You can do any change you want that changes a kernel exported ABI,
> just as long as nobody actually notices the change.
>
> But in practice, it's often _much_ more work to try to figure out
> whether something breaks somebody than it is to just say "don't change
> behavior", so 99% of the time, the rule ends up being just "try to
> avoid intentionally changing behavior, because you'll likely get it
> wrong".

I agree semantic changes to an existing API are problematic (not just
within the kernel), but do you consider deletion or removal of
parameters in the same category?

Thank you for your insight on this.
-- 
Thanks,
~Nick Desaulniers
