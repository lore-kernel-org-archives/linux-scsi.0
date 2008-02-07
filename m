From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest git oopses during boot
Date: Thu, 7 Feb 2008 10:18:43 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802070956380.2883@woody.linux-foundation.org>
References: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>  <20080207020214.0f0cf1c7.akpm@linux-foundation.org>  <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>  <20080207233239Z.tomof@acm.org>
 <8120cfd40802070933r42a98537v78feb7ee8e748a94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbYBGSSu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 13:18:50 -0500
In-Reply-To: <8120cfd40802070933r42a98537v78feb7ee8e748a94@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Arnesen <skogtun.linux@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, akpm@linux-foundation.org, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp



On Thu, 7 Feb 2008, Harald Arnesen wrote:
> 
> OK, tried it. Another screen shot attached
> (I must really get another box to use as a serial terminal).

This oops decodes to

     8b 44 24 10             mov    0x10(%esp),%eax
     8b 90 7c 02 00 00       mov    0x27c(%eax),%edx
     83 ea 54                sub    $0x54,%edx
     24 18                   and    $0x18,%al
     8b 4c 24 14             mov    0x14(%esp),%ecx
     f6 41 04 04             testb  $0x4,0x4(%ecx)
     75 57                   jne    0x70
     ba d0 80 00 00          mov    $0x80d0,%edx
     b8 68 bf 30 c0          mov    $0xc030bf68,%eax
     e8 2f 8a 38 c7          call   0xc7388a57
**   a3 14 00 00 00          mov    %eax,0x14	**
     85 c0                   test   %eax,%eax
     0f 84 b3 14 00 00       je     0x14c0
     8b 44 24 14             mov    0x14(%esp),%eax
     83 c0 0c                add    $0xc,%eax

and the oopsing instruction is literally an insane "store to absolute
address 0x14" which will definitely oops unconditionally. 

Quit frankly, that code makes no sense.  It smells like code corruption,
especially as it is right at a return point of a function call (ie maybe
the function screwed up the stack accesses somehow).

Actually, it look slike the call address itself is screwed up too.  I
don't think "0xc7388a57" is likely to be a valid address.

The code *looks* like the test

	if (ASC_NARROW_BOARD(boardp)) {
		ASC_DBG(1, "narrow board\n");
		asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
		asc_dvc_varp->bus_type = bus_type;

but with strange corruption. 

Can you do a

	make drivers/scsi/advansys.lst

and see what it should be?

		Linus
