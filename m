Return-Path: <SRS0=bc2H=DS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E88CC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Oct 2020 21:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40EBF2074F
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Oct 2020 21:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbgJKVVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Oct 2020 17:21:16 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:47120 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKVVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Oct 2020 17:21:16 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 3BD272EA20B;
        Sun, 11 Oct 2020 17:21:13 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id JzPDS6luBh8p; Sun, 11 Oct 2020 17:14:16 -0400 (EDT)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 739FC2EA08E;
        Sun, 11 Oct 2020 17:21:12 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: lib/scatterlist.c : sgl_alloc_order promises more than it
 delivers
To:     Bart Van Assche <bvanassche@acm.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        USB list <linux-usb@vger.kernel.org>
References: <b9f5c065-7662-30e0-8cbd-27a77d28611e@interlog.com>
 <d9513f73-fa18-4b71-fabf-be0b9e1614fd@acm.org>
 <d487005a-ef6c-549f-7006-c7056cf3f36d@interlog.com>
 <da346d8f-b27e-7880-10e8-f2617e0ec7ff@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <c4da2372-2957-5ad1-1433-f5d5b6e6b85d@interlog.com>
Date:   Sun, 11 Oct 2020 17:21:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <da346d8f-b27e-7880-10e8-f2617e0ec7ff@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-26 12:32 a.m., Bart Van Assche wrote:
> On 2020-09-24 21:55, Douglas Gilbert wrote:
>> My code steps down from 1024 KiB elements on failure to 512 KiB and if that
>> fails it tries 256 KiB. Then it gives up. The log output is consistent with
>> my analysis. So your stated equality is an inequality when length >= 4 GiB.
>> There is no promotion of unsigned int nent to uint64_t .
>>
>> You can write your own test harness if you don't believe me. The test machine
>> doesn't need much ram. Without the call to sgl_free() corrected, if it really
>> did try to get that much ram and failed toward the end, then (partially)
>> freed up what it had obtained, then you would see a huge memory leak ...>
>>
>> Now your intention seems to be that a 4 GiB sgl should be valid. Correct?
>> Can that check just be dropped?
> 
> Hi Doug,
> 
> When I wrote that code, I did not expect that anyone would try to allocate
> 4 GiB or more as a single scatterlist. Are there any use cases for which a
> 4 GiB scatterlist works better than two or more smaller scatterlists?

Then one would wonder why it has this declaration:
     struct scatterlist *sgl_alloc_order(unsigned long long length,
                                         unsigned int order, bool chainable,
                                         gfp_t gfp, unsigned int *nent_p)

'unsigned long long length' [in bytes] is a lot; 64 or 128 bits worth;
definitely more than 32 bits.

And vmalloc is declared:
     void *vmalloc(unsigned long size);

Which is 64 bits on a 64 bit machine (i.e. must be able hold a pointer).
And it is vmalloc() that I want to replace with sgl_alloc_order() in the
scsi_debug driver. Robert Love writes of vmalloc():

     "The vmalloc() function, to make nonphysically contiguous pages
     contiguous in the virtual address space, must specifically set up
     the page table entries. Worse, pages obtained via vmalloc() must
     be mapped by their individual pages (because they are not physically
     contiguous), which results in much greater TLB4 thrashing than you see
     when directly mapped memory is used. Because of these concerns,
     vmalloc() is used only when absolutely necessary—typically, to obtain
     large regions of memory." ['LK Development' 3rd edition, page 244]

And scatterlist seems to be doing in the foreground what vmalloc() is
doing in the background, but without those drawbacks.

My testing suggests using a store built with sgl_alloc_order() *** is a
little faster but with a lower standard deviation (i.e. spread) on timings
from repeated tests.

Another advantage of a scatterlist-based store in the scsi_debug driver
is that the data-in and data-out buffers associated with SCSI commands
also come through as scatterlist-based objects. Thus I can do almost all
the manipulations the driver needs to do to simulate a disk by adding
these general functions:
     - sgl_copy_sgl()
     - sgl_cmp_sgl()
     - sgl_memset()
     - sgl_prefetch()

A memmove() variant would be simple to implement, but the scsi_debug
driver doesn't need it.

> Do you agree that many hardware DMA engines do not support transferring
> 4 GiB or more at once?

I agree that one element of a scatter gather list should not exceed 4 GiB
of memory. In scsi_debug the scatter gather list (one per store) has
in some cases several thousand elements. But I do not agree that the _sum_
of the size of those elements should be limited to 4 GiB. With those two
lines removed from sgl_alloc_order() I can test an 8 GiB scsi_debug ram
disk on a 16 GiB machine. [I made it into 1 partition, did mkfs.ext4,
mounted it, rsync-ed the kernel source onto it and built a kernel that
runs. A reasonable test, no?]

Doug Gilbert


*** the very useful property of sgl_alloc_order() is that each element
     of the scatter gather list has the same order (or it fails). This
     allows O(1) navigation of a big store like a 8 GiB ramdisk since
     sg_miter_skip() can be avoided with some simple integer maths.
