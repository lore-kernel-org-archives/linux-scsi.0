From: Paolo Bonzini <pbonzini@redhat.com>
Subject: performance improvements for the sglist API (Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
Date: Wed, 25 Jul 2012 17:09:43 +0200
Message-ID: <50100C37.1060408@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <500FF656.6000203@redhat.com> <5010047D.6070807@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5010047D.6070807@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 16:36, Boaz Harrosh ha scritto:
>> > 
>> > I did test the patch with value-assignment.
>> > 
> 
> Still you should use the sg_set_page()!!
> 1. It is not allowed to directly manipulate sg entries. One should always
>    use the proper accessor. Even if open coding does work and is not a bug
>    it should not be used anyway!
> 2. Future code that will support chaining will need to do as I say so why
>    change it then, again?

Future code that will support chaining will not copy anything at all.

Also, and more important, note that I am _not_ calling sg_init_table
before the loop, only once in the driver initialization.  That's because
memset in sg_init_table is an absolute performance killer, especially if
you have to do it in a critical section; and I'm not making this up, see
blk_rq_map_sg:

                          * If the driver previously mapped a shorter
                          * list, we could see a termination bit
                          * prematurely unless it fully inits the sg
                          * table on each mapping. We KNOW that there
                          * must be more entries here or the driver
                          * would be buggy, so force clear the
                          * termination bit to avoid doing a full
                          * sg_init_table() in drivers for each command.
                          */
                          sg->page_link &= ~0x02;
                          sg = sg_next(sg);

So let's instead fix the API so that I (and blk-merge.c) can touch
memory just once.  For example you could add __sg_set_page and
__sg_set_buf, basically the equivalent of

    memset(sg, 0, sizeof(*sg));
    sg_set_{page,buf}(sg, page, len, offset);

Calling these functions would be fine if you later add a manual call to
sg_mark_end, again the same as blk-merge.c does.  See the attached
untested/uncompiled patch.

And value assignment would be the same as a

    __sg_set_page(sg, sg_page(page), sg->length, sg->offset);

> Please don't change two things in one patch. The fix is for high-pages
> please fix only that here. You can blasphemy open-code the sg manipulation
> in a separate patch.

The blasphemy is already there (the scatterlist that is handed to virtio
won't have the right end-of-chain marker).  If anything,
value-assignment is trading a subtle blasphemy for a blatant one.
That's already an improvement, but let's just fix the API instead.

Paolo
