From: Tejun Heo <tj@kernel.org>
Subject: Re: Use-after-free in ata_qc_issue
Date: Sun, 22 Sep 2013 12:39:13 -0400
Message-ID: <20130922163913.GE28571@htj.dyndns.org>
References: <CACT4Y+anZ6Mt9T=Zx5OepmawzkLDSmXo5ZkkhX5riZ8XvNHEmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+anZ6Mt9T=Zx5OepmawzkLDSmXo5ZkkhX5riZ8XvNHEmQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-ide@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>, marc.ceeeee@gmail.com, aaron.lu@intel.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

(cc'ing SCSI people)

On Wed, Sep 18, 2013 at 11:45:22AM -0700, Dmitry Vyukov wrote:
> Hi!
> 
> I am working on AddressSanitizer -- a tool that detects use-after-free
> and out-of-bounds bugs
> (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel).
> Below is one of the bug reports that I got while running trinity
> syscall fuzzer. Kernel is built on revision
> d8efd82eece89f8a5790b0febf17522affe9e1f1.
> The report was followed by a bunch of similar use-after-free reports,
> and later the kernel crashed somewhere in ata subsystem. I've attached
> the full log.
> 
> 
> ERROR: AddressSanitizer: heap-use-after-free on address ffff880034fce000
> ffff880034fce000 is located 0 bytes inside of 256-byte region
> [ffff880034fce000, ffff880034fce100)
> READ of size 8 at ffff880034fce000 by thread T3645:
>   #0      inlined     (asan_report_error+0x3e7/0x500)
> asan_describe_heap_address ./arch/x86/mm/asan/report.c:191
>   #0 ffffffff810d9af7 (asan_report_error+0x3e7/0x500)
> ./arch/x86/mm/asan/report.c:309
>   #1 ffffffff810d8c12 (asan_check_region.part.1+0x1b2/0x230)
> ./arch/x86/mm/asan/asan.c:263
>   #2      inlined     (__tsan_read8+0x28/0x30) asan_check_region
> ./arch/x86/mm/asan/asan.c:276
>   #2 ffffffff810d8d48 (__tsan_read8+0x28/0x30) ./arch/x86/mm/asan/asan.c:276
>   #3 ffffffff814cc0ef (sg_next+0xf/0x40) ??:0
>   #4      inlined     (ata_qc_issue+0x2b4/0x740) dma_map_sg_attrs
> ./include/asm-generic/dma-mapping-common.h:50
>   #4      inlined     (ata_qc_issue+0x2b4/0x740) ata_sg_setup
> ./drivers/ata/libata-core.c:4707
>   #4 ffffffff816574b4 (ata_qc_issue+0x2b4/0x740)
> ./drivers/ata/libata-core.c:5082

So, if I'm reading this right, it means that the sg list is used after
being freed?  The sglist is directly from scsi_cmnd and use-after-free
there is likely to be quite noticeable.  Any chance you guys aren't
following mempool based allocations correctly?

Thanks.

-- 
tejun
