From: Torsten Kaiser <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Sat, 6 Jun 2009 00:11:15 +0200
Message-ID: <64bb37e0906051511y766af2d3sc12ee2dd2048d905@mail.gmail.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906050852g2be64c7elb2872a6129d13f56@mail.gmail.com>
	 <20090605182015.GA10342@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53033 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZFEWLP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2009 18:11:15 -0400
In-Reply-To: <20090605182015.GA10342@8bytes.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jun 5, 2009 at 8:20 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Jun 05, 2009 at 05:52:27PM +0200, Torsten Kaiser wrote:
>> Should there be a warning if more then one possible match were found?
>
> True. That would be better. But I tried to keep the code change as small
> as possible without disabling the feature completly.
>
>> * driver maps address 'a' with size 1
>> * driver maps same address 'a' with size 2
>> * driver wrongly unmaps the second allocation with size 1
>>   -> no warning, because the first allocation is returned
>
> Hmm, I am not sure if we can handle this situation correctly in the
> dma-debug code. There is no unique key to identify a mapping request
> which allows to assign an unmap request to it. Currently dma-debug uses
> device and dma-address. But that seems not to be sufficient. The
> best-fit algorithm is also a but fuzzy of course.

Maybe we just shouldn't try to handle it at all:

static void add_dma_entry(struct dma_debug_entry *entry)
{
        struct hash_bucket *bucket;
        unsigned long flags;

        bucket = get_hash_bucket(entry, &flags);
        if(hash_bucket_find(bucket, entry)) {
                printk(KERN_ERR "DMA-API: device mapped same address twice, "
                  "this use case cannot be handled currently -
disabling debugging\n");
                global_disable = true;
        }
        hash_bucket_add(bucket, entry);
        put_hash_bucket(bucket, &flags);
}

This would allow this feature to remain for most cased, but would also
prevent all false warnings.

Torsten
