From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 11:28:55 -0700
Message-ID: <80b7a49f-7612-6d27-89e5-bb2f2f27f0d5@kernel.dk>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com> <20171108003934.GB20599@ming.t460p>
 <26ee805b-883f-d588-5649-13700244b6e8@kernel.dk>
 <20171108025830.GA30129@ming.t460p>
 <1a153ff3-9d53-d347-cb16-b8480e690221@kernel.dk>
 <1510159293.24237.19.camel@wdc.com>
 <e699ee0f-1ff9-42be-8283-7cdaea65b0b3@kernel.dk>
 <1510165336.13896.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1510165336.13896.1.camel@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 11/08/2017 11:22 AM, Laurence Oberman wrote:
> On Wed, 2017-11-08 at 10:57 -0700, Jens Axboe wrote:
>> On 11/08/2017 09:41 AM, Bart Van Assche wrote:
>>> On Tue, 2017-11-07 at 20:06 -0700, Jens Axboe wrote:
>>>> At this point, I have no idea what Bart's setup looks like. Bart,
>>>> it
>>>> would be REALLY helpful if you could tell us how you are
>>>> reproducing
>>>> your hang. I don't know why this has to be dragged out.
>>>
>>> Hello Jens,
>>>
>>> It is a disappointment to me that you have allowed Ming to evaluate
>>> other
>>> approaches than reverting "blk-mq: don't handle TAG_SHARED in
>>> restart". That
>>> patch namely replaces an algorithm that is trusted by the community
>>> with an
>>> algorithm of which even Ming acknowledged that it is racy. A quote
>>> from [1]:
>>> "IO hang may be caused if all requests are completed just before
>>> the current
>>> SCSI device is added to shost->starved_list". I don't know of any
>>> way to fix
>>> that race other than serializing request submission and completion
>>> by adding
>>> locking around these actions, which is something we don't want.
>>> Hence my
>>> request to revert that patch.
>>
>> I was reluctant to revert it, in case we could work out a better way
>> of
>> doing it. As I mentioned in the other replies, it's not exactly the
>> prettiest or most efficient. However, since we currently don't have
>> a good solution for the issue, I'm fine with reverting that patch.
>>
>>> Regarding the test I run, here is a summary of what I mentioned in
>>> previous
>>> e-mails:
>>> * I modified the SRP initiator such that the SCSI target queue
>>> depth is
>>>   reduced to one by setting starget->can_queue to 1 from inside
>>>   scsi_host_template.target_alloc.
>>> * With that modified SRP initiator I run the srp-test software as
>>> follows
>>>   until something breaks:
>>>   while ./run_tests -f xfs -d -e deadline -r 60; do :; done
>>
>> What kernel options are needed? Where do I download everything I
>> need?
>>
>> In other words, would it be possible to do a fuller guide for getting
>> this setup and running?
>>
>> I'll run my simple test case as well, since it's currently breaking
>> basically everywhere.
>>
>>> Today a system with at least one InfiniBand HCA is required to run
>>> that test.
>>> When I have the time I will post the SRP initiator and target
>>> patches on the
>>> linux-rdma mailing list that make it possible to run that test
>>> against the
>>> SoftRoCE driver (drivers/infiniband/sw/rxe). The only hardware
>>> required to
>>> use that driver is an Ethernet adapter.
>>
>> OK, I guess I can't run it then... I'll have to rely on your testing.
> 
> Hello 
> 
> I agree with Bart in this case, we should revert this.
> My test-bed is tied up and I have not been able to give it back to Ming
> so he could follow up on Bart's last update.
> 
> Right now its safer to revert.

I had already reverted it when sending out that email, so we should be
all set (hopefully).

-- 
Jens Axboe
