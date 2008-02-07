From: "Harald Arnesen" <skogtun.linux@gmail.com>
Subject: Re: Latest git oopses during boot
Date: Thu, 7 Feb 2008 12:14:56 +0100
Message-ID: <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
References: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
	 <20080206144732.5a1a2c3b.akpm@linux-foundation.org>
	 <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
	 <20080207020214.0f0cf1c7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:41293 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYBGLO6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 06:14:58 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2202549rvb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Feb 2008 03:14:57 -0800 (PST)
In-Reply-To: <20080207020214.0f0cf1c7.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <tomof@acm.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> (cc's restored, and expanded a bit)

Ah, sorry, not used to gmail's web interface. Clicked the wrong button.

> > Seems to be the advansys driver, so I tried to remove it - and indeed,
> > the kernel now boots. So I guess it's either that driver or my ancient
> > Nikon Coolscan II that is the only thing attached to the board.
>
> Thanks.  I uploaded the oops picture to
> http://userweb.kernel.org/~akpm/oops.jpg
>
> > Cc to the Matthew Wilcox added.
>
> mm...  looks like all Matthew's changes were in 2.6.23.  And 2.6.23 worked
> OK, yes?

Both 2.6.23 and 2.6.24 are ok.

> The only recent changes to drivers/scsi/advansys.c are
>
> commit b80ca4f7ee36c26d300c5a8f429e73372d153379
> Author: FUJITA Tomonori <tomof@acm.org>
> Date:   Sun Jan 13 15:46:13 2008 +0900
>
>     [SCSI] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
>
>     This replaces sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in
>     several LLDs. It's a preparation for the future changes to remove
>     sense_buffer array in scsi_cmnd structure.
>
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> :100644 100644 9dd3952... 492702b... M  drivers/scsi/advansys.c
>
> commit 747d016e7e25e216b31022fe2b012508d99fb682
> Author: Randy Dunlap <randy.dunlap@oracle.com>
> Date:   Mon Jan 14 00:55:18 2008 -0800
>
>     advansys: fix section mismatch warning
>
>     Fix section mismatch warning:
>
>     WARNING: vmlinux.o(.exit.text+0x152a): Section mismatch: reference to .init.
>
>     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>     Cc: Matthew Wilcox <willy@debian.org>
>     Cc: James Bottomley <James.Bottomley@steeleye.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> which seem fairly benign.
>
>
> gcc inlining is going to make it rather a lot of work to find out which
> statement has actually oopsed there.
-- 
Hilsen Harald
