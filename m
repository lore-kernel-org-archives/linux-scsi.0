From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Latest git oopses during boot
Date: Fri, 08 Feb 2008 09:10:29 +0900
Message-ID: <20080208091029F.fujita.tomonori@lab.ntt.co.jp>
References: <87hcgkzbry.fsf@basilikum.skogtun.org>
	<alpine.LFD.1.00.0802071404400.2896@woody.linux-foundation.org>
	<8120cfd40802071424h5cf04861x63a88ea18508eda9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:33706 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbYBHAKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 19:10:42 -0500
In-Reply-To: <8120cfd40802071424h5cf04861x63a88ea18508eda9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: skogtun.linux@gmail.com
Cc: torvalds@linux-foundation.org, skogtun.harald@gmail.com, tomof@acm.org, akpm@linux-foundation.org, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 7 Feb 2008 23:24:00 +0100
"Harald Arnesen" <skogtun.linux@gmail.com> wrote:

> On 2/7/08, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Thu, 7 Feb 2008, Harald Arnesen wrote:
> > >
> > > I'll try applying the patch to a freshly downloaded git-tree.
> >
> > Ok, good.
> >
> > > Shall I try another compiler? I have at least these two:
> > >
> > > gcc version 3.4.6 (Ubuntu 3.4.6-6ubuntu2)
> > > gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
> >
> > I would suggest a patch mis-application problem first (or possibly even
> > the patch itself being broken - I simply didn't look very closely at the
> > patch, but it *looked* ok).
> >
> > If it's a compiler bug, it's a pretty big one, and quite frankly, I doubt
> > it. Compiler bugs do happen, but they are pretty rare, and they tend to
> > have more subtle effects than the one you see.
> >
> > However:
> >
> > > in addition to the self-compiled 4.2.3 I used for the tests.
> >
> > 4.2.3? Really? That's pretty damn recent, and so almost totally untested.
> > That does make a compiler bug at least more likely.
> >
> > So yes, if you already have other compilers installed, you should try
> > them. If it really is a compiler bug, it's a really bad one, and you would
> > want to let the gcc people know.
> >
> > Still, I'd double-check that the
> >
> >         asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
> >
> > line was added properly first. You should see it way after the point where
> > it did
> >
> >         asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
> >
> > to initialize it (and both statements should be inside a
> >
> >         if (ASC_NARROW_BOARD(boardp)) {
> >
> > conditional - please check that the source code looks sane too).
> >
> >                         Linus
> 
> I just re-downloaded an re-patched and re-compiled (with gcc 4.2.3),
> and now the kernel boots. I must have screwed up the previous
> patching.
> 
> It now works, with Fujita's patch applied.

Thanks Harald and Linus,

The bug has been in the advansys driver. 2.6.23 and 2.6.24 works just
because the size of Scsi_Host structure was multiples of 8. After
2.6.24, some patches change Scsi_Host structure and now the size is
not multiples of 8. So we hit this bug.


I'll resend the patch with a proper description.
