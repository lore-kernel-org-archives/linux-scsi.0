From: Harald Arnesen <skogtun.harald@gmail.com>
Subject: Re: Latest git oopses during boot
Date: Thu, 07 Feb 2008 22:39:45 +0100
Message-ID: <87hcgkzbry.fsf@basilikum.skogtun.org>
References: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
	<20080207020214.0f0cf1c7.akpm@linux-foundation.org>
	<8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
	<20080207233239Z.tomof@acm.org>
	<8120cfd40802070933r42a98537v78feb7ee8e748a94@mail.gmail.com>
	<alpine.LFD.1.00.0802070956380.2883@woody.linux-foundation.org>
	<8120cfd40802071248x20ed938dh52cd9e314219613b@mail.gmail.com>
	<alpine.LFD.1.00.0802071304420.2896@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:59773 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481AbYBGVjy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 16:39:54 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1010025nfb.21
        for <linux-scsi@vger.kernel.org>; Thu, 07 Feb 2008 13:39:50 -0800 (PST)
In-Reply-To: <alpine.LFD.1.00.0802071304420.2896@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 7 Feb 2008 13:14:25 -0800 (PST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harald Arnesen <skogtun.linux@gmail.com>, FUJITA Tomonori <tomof@acm.org>, akpm@linux-foundation.org, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 7 Feb 2008, Harald Arnesen wrote:
>> >
>> > Can you do a
>> >
>> >         make drivers/scsi/advansys.lst
>> >
>> > and see what it should be?
>> 
>> Anyway, here it is, as an attachment.
>
> Ok, I was wrong. The code really *does* compile to that insane
>
> 	a3 14 00 00 00          mov    %eax,0x14
>
> by your compiler.
>
> That's the
>
> 	asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
>
> thing, and gcc seems to have decided that it can statically prove that 
> asc_dvc_varp is NULL.
>
> Quite frankly, I don't see that being true. But you have some patches in 
> your tree that I haven't followed, so.. Are you sure the patches applied 
> to the right spot? The patch I saw added that kzalloc() to the _end_ of 
> the function (long after asc_dvc_varp was initialized), maybe that one got 
> mis-applied?
>
> Or maybe your compiler version is simply totally broken.
>
> 			Linus

I'll try applying the patch to a freshly downloaded git-tree.

Shall I try another compiler? I have at least these two:

gcc version 3.4.6 (Ubuntu 3.4.6-6ubuntu2)
gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)

in addition to the self-compiled 4.2.3 I used for the tests.
-- 
Hilsen Harald.
