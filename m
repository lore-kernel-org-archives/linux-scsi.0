From: Tvrtko Ursulin <tursulin@ursulin.net>
Subject: Re: [PATCH 6/6] lib/scatterlist: Drop order argument from
 sgl_free_n_order
Date: Wed, 7 Mar 2018 17:23:21 +0000
Message-ID: <37786476-a4e8-ce70-abff-35d99413fa68@ursulin.net>
References: <20180307124712.14963-1-tvrtko.ursulin@linux.intel.com>
 <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
 <1520439817.2890.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520439817.2890.21.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tvrtko.ursulin@intel.com" <tvrtko.ursulin@intel.com>, "hare@suse.com" <hare@suse.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org


On 07/03/18 16:23, Bart Van Assche wrote:
> On Wed, 2018-03-07 at 12:47 +0000, Tvrtko Ursulin wrote:
>> We can derive the order from sg->length and so do not need to pass it in
>> explicitly. Rename the function to sgl_free_n.
> 
> Using get_order() to compute the order looks fine to me but this patch will
> have to rebased in order to address the comments on the previous patches.

Ok I guess my main questions are the ones from the cover letter - where 
is this API going and why did it get in a bit of a funky state? Because 
it doesn't look fully thought through and tested to me.

My motivation is that I would like to extend it to add 
sgl_alloc_order_min_max, which takes min order and max order, and 
allocates as large chunks as it can given those constraints. This is 
something we have in i915 and could then drop our implementation and use 
the library function.

But I also wanted to refactor sgl_alloc_order to benefit from the 
existing chained struct scatterlist allocator. But SGL API does not 
embed into struct sg_table, neither it carries explicitly the number of 
nents allocated, making it impossible to correctly free with existing 
sg_free_table.

Another benefit of using the existing sg allocator would be that for 
large allocation you don't depend on the availability of contiguous 
chunks like you do with kmalloc_array.

For instance if in another reply you mentioned 4GiB allocations are a 
possibility. If you use order 0 that means you need 1M nents, which can 
be something like 32 bytes each and you need a 32MiB kmalloc for the 
nents array and thats quite big. If you would be able to reuse the 
existing sg_alloc_table infrastructure (I have patches which extract it 
if you don't want to deal with struct sg_table), you would benefit from 
PAGE_SIZE allocations.

Also I am not sure if a single gfp argument to sgl_alloc_order is the 
right thing to do. I have a feeling you either need to ignore it for 
kmalloc_array, or pass in two gfp_t arguments to be used for metadata 
and backing storage respectively.

So I have many questions regarding the current state and future 
direction, but essentially would like to make it usable for other 
drivers, like i915, as well.

Regards,

Tvrtko
