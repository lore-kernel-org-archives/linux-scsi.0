From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] target: Pass through I/O topology for block backstores
Date: Fri, 11 Oct 2013 11:52:53 -0700
Message-ID: <52584905.4080307@redhat.com>
References: <1381513206-8155-1-git-send-email-agrover@redhat.com> <20131011180348.GA21030@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20131011180348.GA21030@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 10/11/2013 11:03 AM, Christoph Hellwig wrote:
> On Fri, Oct 11, 2013 at 10:40:06AM -0700, Andy Grover wrote:
>> In addition to block size (already implemented), passing through
>> alignment offset, logical-to-phys block exponent, I/O granularity and
>> optimal I/O length will allow initiators to properly handle layout on
>> LUNs with 4K block sizes.
>>
>> Tested with various weird values via scsi_debug module.
>>
>> One thing to look at with this patch is the new block limits values --
>> instead of granularity 1 optimal 8192, Lio will now be returning whatever
>> the block device says, which may affect performance.
>
> Wouldn't it be nicer to have a single method that takes a whole
> queue_limits structure?

It seemed better to me to keep the munging from queue_limits values to 
what the target core needed in the block backstore code, and not use a 
block-specific structure in the backstore<->core interface.

It looks like a few includes of blkdev.h slipped into target core, but 
these can be removed safely -- lio core doesn't depend on the block layer.

We could define a new struct to get the 4 values at once, but it didn't 
seem worth it, esp. since two are only needed by emulate_readcapacity16, 
and the other two only by emulate_evpd_b0.

-- Andy
