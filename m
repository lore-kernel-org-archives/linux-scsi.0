From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: Use-after-free in ata_qc_issue
Date: Sun, 22 Sep 2013 11:24:15 -0700
Message-ID: <CACT4Y+aGOzEdGZ_rnJ_52hWCph-nyDhd1ukKW=8M0QNSyR0WpA@mail.gmail.com>
References: <CACT4Y+anZ6Mt9T=Zx5OepmawzkLDSmXo5ZkkhX5riZ8XvNHEmQ@mail.gmail.com>
 <20130922163913.GE28571@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:65471 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3IVSYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 14:24:37 -0400
Received: by mail-la0-f43.google.com with SMTP id ep20so1896131lab.30
        for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 11:24:36 -0700 (PDT)
In-Reply-To: <20130922163913.GE28571@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>, Marc C <marc.ceeeee@gmail.com>, aaron.lu@intel.com, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Sun, Sep 22, 2013 at 9:39 AM, Tejun Heo <tj@kernel.org> wrote:
>
> (cc'ing SCSI people)
>
> On Wed, Sep 18, 2013 at 11:45:22AM -0700, Dmitry Vyukov wrote:
> > Hi!
> >
> > I am working on AddressSanitizer -- a tool that detects use-after-free
> > and out-of-bounds bugs
> > (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel).
> > Below is one of the bug reports that I got while running trinity
> > syscall fuzzer. Kernel is built on revision
> > d8efd82eece89f8a5790b0febf17522affe9e1f1.
> > The report was followed by a bunch of similar use-after-free reports,
> > and later the kernel crashed somewhere in ata subsystem. I've attached
> > the full log.
> >
> >
> > ERROR: AddressSanitizer: heap-use-after-free on address ffff880034fce000
> > ffff880034fce000 is located 0 bytes inside of 256-byte region
> > [ffff880034fce000, ffff880034fce100)
> > READ of size 8 at ffff880034fce000 by thread T3645:
> >   #0      inlined     (asan_report_error+0x3e7/0x500)
> > asan_describe_heap_address ./arch/x86/mm/asan/report.c:191
> >   #0 ffffffff810d9af7 (asan_report_error+0x3e7/0x500)
> > ./arch/x86/mm/asan/report.c:309
> >   #1 ffffffff810d8c12 (asan_check_region.part.1+0x1b2/0x230)
> > ./arch/x86/mm/asan/asan.c:263
> >   #2      inlined     (__tsan_read8+0x28/0x30) asan_check_region
> > ./arch/x86/mm/asan/asan.c:276
> >   #2 ffffffff810d8d48 (__tsan_read8+0x28/0x30) ./arch/x86/mm/asan/asan.c:276
> >   #3 ffffffff814cc0ef (sg_next+0xf/0x40) ??:0
> >   #4      inlined     (ata_qc_issue+0x2b4/0x740) dma_map_sg_attrs
> > ./include/asm-generic/dma-mapping-common.h:50
> >   #4      inlined     (ata_qc_issue+0x2b4/0x740) ata_sg_setup
> > ./drivers/ata/libata-core.c:4707
> >   #4 ffffffff816574b4 (ata_qc_issue+0x2b4/0x740)
> > ./drivers/ata/libata-core.c:5082
>
> So, if I'm reading this right, it means that the sg list is used after
> being freed?

Yes, that's correct.
First thread 3645 allocated the list in scsi_setup_fs_cmnd().
Then thread 1095 freed it in scsi_io_completion().
Then thread 3645 accessed the list in ata_scsi_queuecmd().


>  The sglist is directly from scsi_cmnd and use-after-free
> there is likely to be quite noticeable.

Note that we've seen this only once during several weeks of running
trinity syscall fuzzer. So it's not something that happens all that
frequently. This may explain why it was not noticed before. Also a
use-after-free bug has some chances to silently corrupt heap and/or
read garbage, but still survive.


> Any chance you guys aren't
> following mempool based allocations correctly?

This is quite unlikely, I've looked at mempool code and I do not think
it can affect tool operation. We intercept kmalloc/kmem_cache_free,
poison the memory block and put it into a delay reuse queue. Then
watch for memory accesses that access poisoned memory ranges.
