From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest git oopses during boot
Date: Thu, 7 Feb 2008 13:14:25 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802071304420.2896@woody.linux-foundation.org>
References: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>  <20080207020214.0f0cf1c7.akpm@linux-foundation.org>  <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>  <20080207233239Z.tomof@acm.org>  <8120cfd40802070933r42a98537v78feb7ee8e748a94@mail.gmail.com>
  <alpine.LFD.1.00.0802070956380.2883@woody.linux-foundation.org> <8120cfd40802071248x20ed938dh52cd9e314219613b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935502AbYBGVOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 16:14:34 -0500
In-Reply-To: <8120cfd40802071248x20ed938dh52cd9e314219613b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Arnesen <skogtun.linux@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, akpm@linux-foundation.org, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp



On Thu, 7 Feb 2008, Harald Arnesen wrote:
> >
> > Can you do a
> >
> >         make drivers/scsi/advansys.lst
> >
> > and see what it should be?
> 
> Anyway, here it is, as an attachment.

Ok, I was wrong. The code really *does* compile to that insane

	a3 14 00 00 00          mov    %eax,0x14

by your compiler.

That's the

	asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);

thing, and gcc seems to have decided that it can statically prove that 
asc_dvc_varp is NULL.

Quite frankly, I don't see that being true. But you have some patches in 
your tree that I haven't followed, so.. Are you sure the patches applied 
to the right spot? The patch I saw added that kzalloc() to the _end_ of 
the function (long after asc_dvc_varp was initialized), maybe that one got 
mis-applied?

Or maybe your compiler version is simply totally broken.

			Linus
