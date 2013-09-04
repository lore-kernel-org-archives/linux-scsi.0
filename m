From: Dmitry Vyukov <dvyukov@google.com>
Subject: Potential out-of-bounds access in drivers/scsi/sd.c
Date: Wed, 4 Sep 2013 04:31:41 +0400
Message-ID: <CACT4Y+bt9weet_0DxfX3s=_xnxBGZjMG0gF7vea+8psov+ky8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40344 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3IDAcD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 20:32:03 -0400
Received: by mail-ie0-f176.google.com with SMTP id s9so11341558iec.7
        for <linux-scsi@vger.kernel.org>; Tue, 03 Sep 2013 17:32:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: richard@r-senior.demon.co.uk, stern@rowland.harvard.edu, ltuikov@yahoo.com, jbottomley@parallels.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

Hi,

We are working on a memory error detector AddressSanitizer for Linux
kernel (https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel),
it can detect use-after-free and buffer-overflow errors.

Here one of the reports from the tool:

[  166.124485] ERROR: AddressSanitizer: heap-buffer-overflow on
address ffff880024ab8600
[  166.126613] ffff880024ab8600 is located 0 bytes to the right of
512-byte region [ffff880024ab8400, ffff880024ab8600)
[  166.129583] Accessed by thread T2505:
[  166.130732]   #0      inlined     describe_heap_address
./arch/x86/mm/asan/report.c:164
[  166.130732]   #0 ffffffff810dd277 (asan_report_error+0x2f7/0x400)
./arch/x86/mm/asan/report.c:278
[  166.132475]   #1 ffffffff810dc6a0 (asan_check_region+0x30/0x40)
./arch/x86/mm/asan/asan.c:37
[  166.134485]   #2 ffffffff810dd3c3 (__tsan_read1+0x13/0x20) ??:0
[  166.136397]   #3      inlined     sd_read_cache_type ./drivers/scsi/sd.c:2426
[  166.136397]   #3 ffffffff81675546
(sd_revalidate_disk+0x23d6/0x28d0) ./drivers/scsi/sd.c:2720
[  166.138531]   #4 ffffffff812f437b (revalidate_disk+0x4b/0xc0)
./fs/block_dev.c:975
[  166.140449]   #5 ffffffff8167143e (sd_rescan+0x3e/0x50)
./drivers/scsi/sd.c:1473
[  166.142539]   #6 ffffffff8162c164 (scsi_rescan_device+0x64/0x90)
./drivers/scsi/scsi_scan.c:1566
[  166.144557]   #7 ffffffff81694e65 (ata_scsi_dev_rescan+0xf5/0x170)
./drivers/ata/libata-scsi.c:3986
[  166.146680]   #8      inlined     trace_workqueue_execute_end
./kernel/workqueue.c:2186
[  166.146680]   #8 ffffffff81111640 (process_one_work+0x2d0/0x750)
./kernel/workqueue.c:2191
[  166.149012]   #9 ffffffff81111d23 (worker_thread+0x263/0x640)
./include/linux/list.h:188
[  166.151061]   #10 ffffffff8111c092 (kthread+0x132/0x140) kthread.c:0
[  166.152853]   #11 ffffffff8192841c (ret_from_fork+0x7c/0xb0)
./arch/x86/kernel/entry_64.S:570
[  166.154790]
[  166.155389] Allocated by thread T2505:
[  166.156801]   #0 ffffffff810dc768 (asan_slab_alloc+0x48/0xb0)
./arch/x86/mm/asan/asan.c:91
[  166.158850]   #1      inlined     slab_alloc ./mm/slab.c:3475
[  166.158850]   #1      inlined     __do_kmalloc ./mm/slab.c:3749
[  166.158850]   #1 ffffffff812832ec (__kmalloc+0xbc/0x500) ./mm/slab.c:3763
[  166.161364]   #2 ffffffff81673234 (sd_revalidate_disk+0xc4/0x28d0)
./drivers/scsi/sd.c:2698
[  166.164302]   #3 ffffffff812f437b (revalidate_disk+0x4b/0xc0)
./fs/block_dev.c:975
[  166.167012]   #4 ffffffff8167143e (sd_rescan+0x3e/0x50)
./drivers/scsi/sd.c:1473
[  166.169478]   #5 ffffffff8162c164 (scsi_rescan_device+0x64/0x90)
./drivers/scsi/scsi_scan.c:1566
[  166.172321]   #6 ffffffff81694e65 (ata_scsi_dev_rescan+0xf5/0x170)
./drivers/ata/libata-scsi.c:3986
[  166.175156]   #7      inlined     trace_workqueue_execute_end
./kernel/workqueue.c:2186
[  166.175156]   #7 ffffffff81111640 (process_one_work+0x2d0/0x750)
./kernel/workqueue.c:2191
[  166.177222]   #8 ffffffff81111d23 (worker_thread+0x263/0x640)
./include/linux/list.h:188
[  166.179193]   #9 ffffffff8111c092 (kthread+0x132/0x140) kthread.c:0
[  166.180988]   #10 ffffffff8192841c (ret_from_fork+0x7c/0xb0)
./arch/x86/kernel/entry_64.S:570
[  166.182931]
[  166.183537] Shadow bytes around the buggy address:
[  166.185391]   ffff880024ab8380: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  166.187758]   ffff880024ab8400: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  166.190227]   ffff880024ab8480: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  166.192684]   ffff880024ab8500: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  166.195152]   ffff880024ab8580: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[  166.197649] =>ffff880024ab8600:[fa]fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  166.199128]   ffff880024ab8680: fa fa fa fa fa fa fa fa fa fa fa fa
fa fa fa fa
[  166.200962]   ffff880024ab8700: fa fa fa fa fa fa fa fa fd fd fd fd
fd fd fd fd
[  166.203069]   ffff880024ab8780: fd fd fd fd fd fd fd fd fd fd fd fd
fd fd fd fd
[  166.205202]   ffff880024ab8800: fd fd fd fd fd fd fd fd fd fd fd fd
fd fd fd fd
[  166.207302]   ffff880024ab8880: fd fd fd fd fd fd fd fd fd fd fd fd
fd fd fd fd
[  166.209237] Shadow byte legend (one shadow byte represents 8
application bytes):
[  166.211273]   Addressable:           00
[  166.212358]   Partially addressable: 01 02 03 04 05 06 07
[  166.213871]   Heap redzone:          fa
[  166.214979]   Heap kmalloc redzone:  fb
[  166.216062]   Freed heap region:     fd
[  166.217149]   Shadow gap:            fe

The code in sd_read_cache_type does the following:

while (offset < len) {
...
}
...
if ((buffer[offset] & 0x3f) != modepage) {
    sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
    goto defaults;
}

When control leaves the while loop, offset >= len, so buffer[offset]
reads random garbage out-of-bounds.
It the worst case it can lead to crash, or if (buffer[offset] & 0x3f)
happen to be == modepage, then it will read more garbage.

Please help validate and triage this.
