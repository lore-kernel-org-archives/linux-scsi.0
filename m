From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target updates for v4.4-rc1
Date: Fri, 13 Nov 2015 12:27:52 -0800
Message-ID: <CA+55aFzHbgmXeTr9yxsk1jvwV=q5Cx0mE564tQqNQueAyL9OUg@mail.gmail.com>
References: <1447408790.23126.109.camel@haakon3.risingtidesystems.com>
	<CA+55aFy0XCw5d4DVajRbG=jnR_VEUQNu2thf5VqAUsi1ihw3GQ@mail.gmail.com>
	<1447444535.23126.119.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1447444535.23126.119.camel@haakon3.risingtidesystems.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 13, 2015 at 11:55 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
>> So just to make it really clear to people: if you ignore the reports
>> from linux-next, then I will damn well ignore you. Comprende? Fair is
>> fair.
>
> Would you accept an updated PULL request with Alexander's patch, or
> prefer this whole series wait until v4.5..?

You can't just apply Alexander's patch, because that patch wouldn't
compile in your tree - it comes about as a conflict due to me having
gotten commit 7bd1d4093c2f ("stm class: Introduce an abstraction for
System Trace Module devices") from one of Greg's pulls.

But what I want maintainers to do is to *tell* be about these things.
I have absolutely no issues with handling merge conflicts - they
happen all the time.

But when those merge conflicts were known about from linux-next, and
particularly when those merge conflicts were silent semantic conflicts
that didn't even show up as an actual explicit conflict int he git
history (only as a compile issue - or worse - a runtime problem), then
I want maintainers to

 (a) show they were aware of it (you should have been, or there is
something wrong in our process)
and
 (b) let me know about it and point to the resolution.

That way I'm not taken by surprise, and things won't fall through the cracks.

Yes, I do allmodconfig builds between every pull, which is how I
noticed this, but that doesn't always catch things either, and it
doesn't catch _other_ configs that may be relevant too.

Note that it also doesn't mean that I want you to do the merge for me.
I want to be aware of these issues, and I want to see the resolution,
and I'm more than happy to do it myself. In fact, I almost insist,
unless the resolution is _so_ painful that I push it back to the
maintainer. I just want the heads-up about the issue and about the fix
for the issue, because that is the upside of linux-next: these things
gets noticed there first, exactly so that people can be aware of them.

And yes, I also react a lot more negatively when things like this
happen with the very end of the merge window in sight. I usually make
the actual rc1 release on Sunday, but I want Sunday itself to be
pretty much quiet apart from perhaps a "oops, sorry, here's a fix that
we just noticed" kind of issues.  I don't want to be taken by surprise
like this just a couple of days before I want to do the rc.

So please try to just re-send the pull, but this time with
explanations of the conflict and a pointer to the fixup for the
conflict (some people end up doing a pre-merge for me as an example,
in _addition_ to the unmerged tree they send me).

I may or may not then use the particular conflict resolution that I'm
pointed at or told about (because maybe I decide to do it my way), but
regardless it really helps to have a heads-up. And when people go to
the effort and do a "and here's a pre-merged version", I basically
*always* then end up doing something like

     git checkout -b test-merge ORIG_HEAD
     git pull <premerged branch>
     git diff master
    .. everything looks good ..
     git checkout master
     git branch -D test-merge

just to check that yes, we agreed (or, even more interestingly, how
our different merges differed).

Now, *most* of the time there are no conflicts at all. And then
occasionally there are trivial conflicts that just come about because
people touched the MAINTAINERS file close to each other. Don't worry
about those truly trivial ones, they certainly don't need any kind of
"here's how to resolve them" or a pre-merged tree. You could *mention*
them ("You'll get a trivial conflict with an obvious resolution in
file XYZ"), but quite frankly, even that isn't required.

So I'm not asking for some silly extra busy-work. But when linux-next
notified you about a conflict, and it wasn't just something trivial,
then *that* is when I just want to be told.

And yes, part of that "I want to be told" is literally just because I
want to see that the whole "process" worked, and that things had been
in linux-next, and people had reacted to them. Usually actually
resolving the conflict isn't all that hard, and I can always find the
linux-next discussions (like I did now). See?

                   Linus
