From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: Use-after-free in ata_qc_issue
Date: Sun, 22 Sep 2013 11:59:53 -0700
Message-ID: <CACT4Y+bKPWkiLJEC2tk076TmPcYcXb_BuKiSG9H2BoWnOZJuiQ@mail.gmail.com>
References: <CACT4Y+anZ6Mt9T=Zx5OepmawzkLDSmXo5ZkkhX5riZ8XvNHEmQ@mail.gmail.com>
 <20130922163913.GE28571@htj.dyndns.org> <CACT4Y+aGOzEdGZ_rnJ_52hWCph-nyDhd1ukKW=8M0QNSyR0WpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+aGOzEdGZ_rnJ_52hWCph-nyDhd1ukKW=8M0QNSyR0WpA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>, Marc C <marc.ceeeee@gmail.com>, aaron.lu@intel.com, linux-scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 22, 2013 at 11:24 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Sun, Sep 22, 2013 at 9:39 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> (cc'ing SCSI people)
>>
>> On Wed, Sep 18, 2013 at 11:45:22AM -0700, Dmitry Vyukov wrote:
>> > Hi!
>> >
>> > I am working on AddressSanitizer -- a tool that detects use-after-free
>> > and out-of-bounds bugs
>> > (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel).
>> > Below is one of the bug reports that I got while running trinity
>> > syscall fuzzer. Kernel is built on revision
>> > d8efd82eece89f8a5790b0febf17522affe9e1f1.
>> > The report was followed by a bunch of similar use-after-free reports,
>> > and later the kernel crashed somewhere in ata subsystem. I've attached
>> > the full log.
>> >
>> >
>> > ERROR: AddressSanitizer: heap-use-after-free on address ffff880034fce000
>> > ffff880034fce000 is located 0 bytes inside of 256-byte region
>> > [ffff880034fce000, ffff880034fce100)
>> > READ of size 8 at ffff880034fce000 by thread T3645:
>> >   #0      inlined     (asan_report_error+0x3e7/0x500)
>> > asan_describe_heap_address ./arch/x86/mm/asan/report.c:191
>> >   #0 ffffffff810d9af7 (asan_report_error+0x3e7/0x500)
>> > ./arch/x86/mm/asan/report.c:309
>> >   #1 ffffffff810d8c12 (asan_check_region.part.1+0x1b2/0x230)
>> > ./arch/x86/mm/asan/asan.c:263
>> >   #2      inlined     (__tsan_read8+0x28/0x30) asan_check_region
>> > ./arch/x86/mm/asan/asan.c:276
>> >   #2 ffffffff810d8d48 (__tsan_read8+0x28/0x30) ./arch/x86/mm/asan/asan.c:276
>> >   #3 ffffffff814cc0ef (sg_next+0xf/0x40) ??:0
>> >   #4      inlined     (ata_qc_issue+0x2b4/0x740) dma_map_sg_attrs
>> > ./include/asm-generic/dma-mapping-common.h:50
>> >   #4      inlined     (ata_qc_issue+0x2b4/0x740) ata_sg_setup
>> > ./drivers/ata/libata-core.c:4707
>> >   #4 ffffffff816574b4 (ata_qc_issue+0x2b4/0x740)
>> > ./drivers/ata/libata-core.c:5082
>>
>> So, if I'm reading this right, it means that the sg list is used after
>> being freed?
>
> Yes, that's correct.
> First thread 3645 allocated the list in scsi_setup_fs_cmnd().
> Then thread 1095 freed it in scsi_io_completion().
> Then thread 3645 accessed the list in ata_scsi_queuecmd().
>
>
>>  The sglist is directly from scsi_cmnd and use-after-free
>> there is likely to be quite noticeable.
>
> Note that we've seen this only once during several weeks of running
> trinity syscall fuzzer. So it's not something that happens all that
> frequently. This may explain why it was not noticed before. Also a
> use-after-free bug has some chances to silently corrupt heap and/or
> read garbage, but still survive.
>
>
>> Any chance you guys aren't
>> following mempool based allocations correctly?
>
> This is quite unlikely, I've looked at mempool code and I do not think
> it can affect tool operation. We intercept kmalloc/kmem_cache_free,
> poison the memory block and put it into a delay reuse queue. Then
> watch for memory accesses that access poisoned memory ranges.


I've noticed that free happens in scsi_error_handler thread, so maybe
a timeout or some other error condition is involved here.
It is possible that timeout happens while the request is still being
in process of submitting (in ata_scsi_queuecmd)?

Also the use-after-free access happens in:
for_each_sg(sg, s, nents, i)
  kmemcheck_mark_initialized(sg_virt(s), s->length);
Is it possible that the special code added for  kmemcheck touches
memory that it is not supposed to touch?
