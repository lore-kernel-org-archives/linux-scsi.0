From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] libata updates
Date: Thu, 26 Jul 2012 10:14:03 -0700
Message-ID: <CA+55aFwjZVeh7erqpqbRaM=-edOv1m0_5uaau-pFOoeD4Mg=kw@mail.gmail.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org>
 <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
 <50107297.305@pobox.com> <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
 <50107A0D.3060003@pobox.com> <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
 <5010A6FE.7000604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5010A6FE.7000604@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 25, 2012 at 7:10 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>
> Thanks, so noted.  I guess if the merge gets more complex than something
> easily described in an email, that implies that maintainers should do more
> cross-coordination and maybe a merge tree.

It's fairly rare. It happens mostly with the arch trees for some
reason - the ARM tree used to be an unholy mess.

And then we have the small "oops, we didn't even notice" things when
some driver (or FS) interface changes, and we have a new driver/fs or
just extended an old one, and there's a subtle conflict. And people
miss those, and quite frankly, it's not a huge deal. We can fix it up
later. It's the "oh, I knew about this" cases where it's fixed up as a
separate commit I dislike.

And quite frankly, I really do a lot of merges, and over the history
of git we have not had all that many really complicated ones. I
commonly send people email saying "ok, this clashed, you need to
double-check my merge", but it's not common that they are really
problems.

So to a first approximation, I'd actually prefer that submaintainers
not care *at*all* about whether something clashes upstream or not. If
there are consistent and problematic clashes, that implies some deeper
problem, and the solution to that is not "let's pre-merge", but rather
more along the lines of "we're doing something wrong, maybe our
interfaces are crap, or our modularity is wrong, let's think about
it".

And for subsystems where we have had problems, it's actually really
nice if the maintainer sends me the unmerged "this is the work I've
done" tree, and then perhaps has a separate "xyzzy-merged" branch that
has a pre-merged version. For cases like that, I will do the merge
myself, but I'll actually double-check my merge against the maintainer
merge. And it's happened more than once that my merge has differed,
and _my_ merge is the correct one. The maintainer may know his code
better, but I know my merging. I do a ton of them.

For example, this week I've done 66 merges, and 15 of them had
conflicts. Of the 15, only two were interesting iirc, but even those
weren't really "problematic", they were just enough to trigger me to
send out emails to the maintainers about them. And I don't think your
libata merge would really have merited even that, apart from the small
semantic thing (which would also have been trivial with a oneliner
"heads up, check out the semantic change in xyz.c:abcdef()".

> What's the best way for libata to move forward, now that this hideous merge
> has been pushed out to the Well Known libata branches?  The
> pre-jgarzik-merge commit you would have pulled is
> dc7f71f486f4f5fa96f6dcf86833da020cde8a11 had my pull request been proper.

I'll take your merge, it's not like it's a huge problem. What I care
most about is the "flow", and I am making a stink just so that this
doesn't become a common issue. We have tons of ugly history, and I'm
not black-and-white - problems happen. Big deal. I just want to make
sure that they don't become systemic.

                  Linus
