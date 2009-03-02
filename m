From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Mon, 2 Mar 2009 19:36:49 +0100
Message-ID: <20090302183649.GB11787@kernel.dk>
References: <20090227230927.GA21377@roadking.ldev.net> <20090302153246A.fujita.tomonori@lab.ntt.co.jp> <da824cf30903020919q2d3496e6sb5a253b0acba681a@mail.gmail.com> <49AC237A.7060005@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760088AbZCBShQ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49AC237A.7060005@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Grant Grundler <grundler@google.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mike.miller@hp.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 02 2009, Mike Christie wrote:
> Grant Grundler wrote:
>> On Sun, Mar 1, 2009 at 10:32 PM, FUJITA Tomonori
>> <fujita.tomonori@lab.ntt.co.jp> wrote:
>> ...
>>>> +/*
>>>> + * For operations that cannot sleep, a command block is allocated at init,
>>>> + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
>>>> + * which ones are free or in use.  Lock must be held when calling this.
>>>> + * cmd_free() is the complement.
>>>> + */
>>>> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
>>>> +{
>>>> +     struct CommandList_struct *c;
>>>> +     int i;
>>>> +     union u64bit temp64;
>>>> +     dma_addr_t cmd_dma_handle, err_dma_handle;
>>>> +
>>>> +     do {
>>>> +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>>>> +             if (i == h->nr_cmds)
>>>> +                     return NULL;
>>>> +     } while (test_and_set_bit
>>>> +              (i & (BITS_PER_LONG - 1),
>>>> +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
>>> Using bitmap to manage free commands looks too complicated a bit to
>>> me. Can we just use lists for command management?
>>
>> Bit maps are generally more efficient than lists since we touch less data.
>> For both search and moving elements from free<->busy lists. This probably
>> won't matter if we are talking less than 10K IOPS. And willy demonstrated
>> other layers have pretty high overhead (block, libata and SCSI midlayer)
>> at high transaction rates.
>>
>
> If it was just needing this for the queuecommand path it would be  
> simple. For the queuecommand path we could just use the scsi host  
> tagging code for the index. You do not need a lock in the queuecommand  
> path for getting a index and command, and you do not need to duplicate  
> the tag/index allocation code in the block/scsi code
>
> A problem with the host tagging is what to do if you need a tag/index  
> for a internal command. In the slow path like the device reset and cache  
> flush case you could use a list or preallocated command or whatever  
> other drivers are using that makes you happy.
>
> Or for the reset/shutdown/internal path could we come up with a  
> extension to the existing API. Maybe just add some wrapper around some  
> of blk_queue_start_tag that takes a the bqt (the bqt would come from the  
> host wide one) and allocates the tag (need a something similar for the  
> release side).

This is precisely what I did for libata, here is is interleaved with
some other stuff:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=f557570ec6042370333b6b9c33bbbae175120a89

It needs a little more polish and so on, but the concept is identical to
what you describe for this case. And I agree, it's much better to use
the same index instead of generating/maintaining seperate bitmaps for
this type of thing.

-- 
Jens Axboe
