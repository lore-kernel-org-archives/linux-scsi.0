From: Ian Munsie <imunsie@au1.ibm.com>
Subject: Re: [PATCH 00/29] cxlflash: Miscellaneous bug fixes and corrections
Date: Mon, 14 Sep 2015 11:12:29 +1000
Message-ID: <1442188796-sup-7396@delenn.ozlabs.ibm.com>
References: <1442006012-46803-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44058 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbINBNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2015 21:13:36 -0400
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <imunsie@au1.ibm.com>;
	Mon, 14 Sep 2015 11:13:33 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 849922CE8050
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2015 11:13:30 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8E1DDIk58982468
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2015 11:13:21 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8E1Cuda023189
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2015 11:12:57 +1000
In-reply-to: <1442006012-46803-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "James.Bottomley" <James.Bottomley@HansenPartnership.com>, nab <nab@linux-iscsi.org>, brking <brking@linux.vnet.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, "andrew.donnellan" <andrew.donnellan@au1.ibm.com>, mikey <mikey@neuling.org>

Hi Matt & Manoj,

Just a general comment about this series - I'd like to see more detailed
commit messages for almost all these patches. Of course James is the
scsi maintainer and it's up to him whether to take these as is or not,
but generally when you write a commit message for a bug fix you want to
explain:

- What problem can occur, possibly including an example
- Why it occurs
- How this patch addresses it

You don't necessarily need to go overboard because at some point people
can just read the code, but some of these patches don't have any detail
beyond a single subject line, which is too little.

Speaking of the subject line - if the patch is fixing a bug there should
be some indication of that in the subject (it should probably include
the word "fix" somewhere). If the subject just states what you are
changing then it's not immediately obvious that it is a bug fix.

A few examples:

> [PATCH 01/29] cxlflash: Move global.mutex to caller of find_and_create_lun()
>
> Since the retrieved LUN is modified in the caller, hold the mutex
> across modifications as well.

Here the subject line just states what this patch does, but does not
indicate that it is a bug fix. Perhaps something more like "cxlflash:
fix global.mutex not being held while LUN is modified"? Without that, I
can't tell at a glance if this is fixing a bug, or if it's just a bit of
refactoring.

You have a suggestion in the body that there may be an issue and what
you are doing to address it, but you have not explained why this is a
problem.  Give an example of something that could go wrong - if you have
an actual documented case use it as an example, otherwise give us a
theoretical example, like "such and such could be modified while such
and such is happening, possibly leading to such and such". If you don't
have a solid example and are just doing this to harden the code because
you think there might be a problem, say so.

> [PATCH 02/29] cxlflash: Add a literal for units of max_sector

Ok, looking at the code this is fairly obvious what you are doing and
why, but you should give me some explanation in the commit message as
well, even if it's just something like "The magic number 512 in the code
is not very meaningful - replace it with the literal MAX_SECTOR_UNIT to
make it self-explanatory". This patch could probably be combined with
patch 3, then the commit message could just be a run down of the
literals you are adding/renaming.

> [PATCH 04/29] cxlflash: Obtain additional sdev reference
> 
> When a LUN is removed, the sdev that is associted with the LUN remains
> intact until its reference count drops to 0. In order to prevent an sdev
> from being removed while a context is still associated with it, obtain an
> additional reference per-context for each LUN attached to the context.
> 
> This resovles a potential Oops in the release handler when a dealing with
> a LUN that has already been removed.

This is much better - the commit message indicates that there is a
potential oops (what), why it occurs, and how you are addressing it :)

I'd probably change the subject line to indicate that it is a fix
though, perhaps:
"cxlflash: Fix potential oops by obtaining additional sdev reference"

> [PATCH 05/29] cxlflash: Always attempt LUN table initialization
> 
> On a virtual LUN open, there should always be an attempt made to
> update the LUN table for the adapter, regardless of the the global
> LUN's state prior to the open. This is necessary in a multi-adapter
> environment so that access to a LUN [that has already been transitioned
> to virtual mode] through a second (or greater) adapter is configured
> correctly by programming the adapter's LUN table.

After reading this I can see you have tried to explain the problem, but
it's still not super clear to me what it is (ok, you've said it's
necessary to do this, but what is the consequence of not doing this?)...
Perhaps I'm just not versed enough in scsi land though, and maybe this
is obvious to someone who is ;-)

I'd at least add one sentence explaining what this patch does - I assume
it fixes the problem you described, but the commit message doesn't state
that. Again, the subject should indicate this is a bug fix.

> [PATCH 06/29] cxlflash: Change rht_needs_ws from bool to u8
> 
> Fix sparse sizeof(bool) warning by changing type from bool to u8.

I'd almost reverse these two lines - the subject should indicate this is
fixing a sparse warning, and the body can indicate how. If you have the
actual warning from sparse I'd include that in the body as well.

> [PATCH 08/29] cxlflash: Add ioctl drain
> 
> Create the ability to drain ioctls by wrapping the ioctl handler
> call in a read semaphore and then implementing a small routine that
> obtains the write semaphore, effectively creating a wait point for
> all currently executing ioctls.

There's no indication of what the problem being fixed by this patch is,
or why it occurs - this commit message could just as easily be for a new
feature, which wouldn't go in the rc phase. If this is a new feature
that is going to be used by another patch to fix a bug, say so. If this
patch fixes a bug by itself, say so.

> [PATCH 10/29] cxlflash: Rename limbo to reset
> 
> Rename the state and waitq.

OK, this is fairly trivial and isn't a bug fix, but a little more
explanation would be good here - are you renaming them because they were
ambiguous or misleading in some way, or are the new names just more
precise?. It doesn't have to be long, it just has to answer "why?". If
you are renaming them now to address comments from the review phase
maybe mention that as well.


And so on - I think you get the idea.


Cheers,
-Ian

