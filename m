From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Latest git oopses during boot
Date: Thu, 7 Feb 2008 02:02:14 -0800
Message-ID: <20080207020214.0f0cf1c7.akpm@linux-foundation.org>
References: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
	<20080206144732.5a1a2c3b.akpm@linux-foundation.org>
	<8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbYBGKCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 05:02:00 -0500
In-Reply-To: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Arnesen <skogtun.linux@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


(cc's restored, and expanded a bit)

On Thu, 7 Feb 2008 10:44:29 +0100 "Harald Arnesen" <skogtun.linux@gmail.com> wrote:

> On Feb 6, 2008 11:47 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 6 Feb 2008 17:32:22 +0100
> > "Harald Arnesen" <skogtun.linux@gmail.com> wrote:
> >
> > > Photo of screen attached (no serial terminal, and alas, no decent
> > > tripod either).
> >
> > Thanks, but you've disabled so many debug options that the trace isn't
> > very useful.
> >
> >
> > > git-bisect gives me this:
> > >
> > > 6b7b651055221127304a4e373ee9b762398d54d7 is first bad commit
> > > commit 6b7b651055221127304a4e373ee9b762398d54d7
> > > Author: FUJITA Tomonori <tomof@acm.org>
> > > Date:   Mon Feb 4 22:27:55 2008 -0800
> > >
> > >     iommu sg merging: add device_dma_parameters structure
> > >
> > >     IOMMUs merges scatter/gather segments without considering a low level
> > >     driver's restrictions. The problem is that IOMMUs can't access to the
> > >     limitations because they are in request_queue.
> > >
> > >     This patchset introduces a new structure, device_dma_parameters,
> > >     including dma information. A pointer to device_dma_parameters is added
> > >     to struct device. The bus specific structures (like pci_dev) includes
> > >     device_dma_parameters. Low level drivers can use dma_set_max_seg_size
> > >     to tell IOMMUs about the restrictions.
> > >
> > >     We can move more dma stuff in struct device (like dma_mask) to struct
> > >     device_dma_parameters later (needs some cleanups before that).
> > >
> > >     This includes patches for all the IOMMUs that could merge sg (x86_64,
> > >     ppc, IA64, alpha, sparc64, and parisc) though only the ppc patch was
> > >     tested. The patches for other IOMMUs are only compile tested.
> > >
> > > $ gcc -v
> > > Using built-in specs.
> > > Target: i686-pc-linux-gnu
> > > Configured with: ../configure --prefix=/opt/gcc
> > > Thread model: posix
> > > gcc version 4.2.3
> > >
> > > Config:
> > >
> > > ...
> > >
> > > # CONFIG_DEBUG_BUGVERBOSE is not set
> > >
> >
> > This one really should be enabled at all times, please.
> >
> > Can you please set it and retry?
> >
> 
> I'm off to my day job now, but I did it earlier this morning. New
> screenshot attached.
> 
> Seems to be the advansys driver, so I tried to remove it - and indeed,
> the kernel now boots. So I guess it's either that driver or my ancient
> Nikon Coolscan II that is the only thing attached to the board.

Thanks.  I uploaded the oops picture to
http://userweb.kernel.org/~akpm/oops.jpg

> Cc to the Matthew Wilcox added.

mm...  looks like all Matthew's changes were in 2.6.23.  And 2.6.23 worked
OK, yes?


The only recent changes to drivers/scsi/advansys.c are 

commit b80ca4f7ee36c26d300c5a8f429e73372d153379
Author: FUJITA Tomonori <tomof@acm.org>
Date:   Sun Jan 13 15:46:13 2008 +0900

    [SCSI] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
    
    This replaces sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in
    several LLDs. It's a preparation for the future changes to remove
    sense_buffer array in scsi_cmnd structure.
    
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:100644 100644 9dd3952... 492702b... M  drivers/scsi/advansys.c

commit 747d016e7e25e216b31022fe2b012508d99fb682
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Mon Jan 14 00:55:18 2008 -0800

    advansys: fix section mismatch warning
    
    Fix section mismatch warning:
    
    WARNING: vmlinux.o(.exit.text+0x152a): Section mismatch: reference to .init.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Cc: Matthew Wilcox <willy@debian.org>
    Cc: James Bottomley <James.Bottomley@steeleye.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

which seem fairly benign.


gcc inlining is going to make it rather a lot of work to find out which
statement has actually oopsed there.

