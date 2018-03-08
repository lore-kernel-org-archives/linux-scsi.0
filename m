From: Tvrtko Ursulin <tursulin@ursulin.net>
Subject: Re: [PATCH 6/6] lib/scatterlist: Drop order argument from
 sgl_free_n_order
Date: Thu, 8 Mar 2018 07:59:33 +0000
Message-ID: <faa56419-bdce-c539-5eee-5e180c62b0a5@ursulin.net>
References: <20180307124712.14963-1-tvrtko.ursulin@linux.intel.com>
 <20180307124712.14963-7-tvrtko.ursulin@linux.intel.com>
 <1520447415.5558.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520447415.5558.12.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 07/03/18 18:30, James Bottomley wrote:
> On Wed, 2018-03-07 at 12:47 +0000, Tvrtko Ursulin wrote:
>> From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> Firstly, I don't see any justifiable benefit to churning this API, so
> why bother? but secondly this:

Primarily because I wanted to extend sgl_alloc_order slightly in order 
to be able to use it from i915. And then in the process noticed a couple 
of bugs in the implementation, type inconsistencies and unused exported 
symbols. That gave me a feeling API could actually use a bit of work.

>> We can derive the order from sg->length and so do not need to pass it
>> in explicitly.
> 
> Is wrong.  I can have a length 2 scatterlist that crosses a page
> boundary, but I can also have one within a single page, so the order
> cannot be deduced from the length.

sgl_alloc_order never does this.

However there is a different bug in my patch relating to the last entry 
which can have shorter length from the rest. So get_order on the last 
entry is incorrect - I have to store the deduced order and carry it over.

In which case it may even make sense to refactor sgl_alloc_order a bit 
more to avoid wastage on the last entry with high order allocations.

Regards,

Tvrtko
