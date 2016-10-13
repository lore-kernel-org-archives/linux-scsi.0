From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 1/4] block: Add iocontext priority to request
Date: Thu, 13 Oct 2016 13:59:15 -0700
Message-ID: <CAPcyv4i1ZgPTfewtpsegdvedc4aEwPDvMNjD97UUAEVZUC-jzQ@mail.gmail.com>
References: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com>
 <1476388433-2539-2-git-send-email-adam.manzanares@hgst.com>
 <CAPcyv4giMwLRkP9YDcOo4st2RqxPXsYYyTOJ2_U8ywQPteM5gQ@mail.gmail.com>
 <068e03c4-3558-a6b1-2008-d13bde4958a1@kernel.dk> <CAPcyv4jtxp5yFUGqLOmch6EH=CzKtZr4Qb-qnjHb=xLpU5LspQ@mail.gmail.com>
 <094ff78d-b410-b2ac-ad60-2af09cf47523@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <094ff78d-b410-b2ac-ad60-2af09cf47523@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Adam Manzanares <adam.manzanares@hgst.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, mchristi@redhat.com, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>, Adam Manzananares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 1:24 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 10/13/2016 02:19 PM, Dan Williams wrote:
>>
>> On Thu, Oct 13, 2016 at 1:09 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 10/13/2016 02:06 PM, Dan Williams wrote:
>>>>
>>>>
>>>> On Thu, Oct 13, 2016 at 12:53 PM, Adam Manzanares
>>>> <adam.manzanares@hgst.com> wrote:
>>>>>
>>>>>
>>>>> Patch adds an association between iocontext ioprio and the ioprio of a
>>>>> request. This value is set in blk_rq_set_prio which takes the request
>>>>> and
>>>>> the ioc as arguments. If the ioc is valid in blk_rq_set_prio then the
>>>>> iopriority of the request is set as the iopriority of the ioc. In
>>>>> init_request_from_bio a check is made to see if the ioprio of the bio
>>>>> is
>>>>> valid and if so then the request prio comes from the bio.
>>>>>
>>>>> Signed-off-by: Adam Manzananares <adam.manzanares@wdc.com>
>>>>> ---
>>>>>  block/blk-core.c       |  4 +++-
>>>>>  include/linux/blkdev.h | 14 ++++++++++++++
>>>>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>>> index 14d7c07..361b1b9 100644
>>>>> --- a/block/blk-core.c
>>>>> +++ b/block/blk-core.c
>>>>> @@ -1153,6 +1153,7 @@ static struct request *__get_request(struct
>>>>> request_list *rl, int op,
>>>>>
>>>>>         blk_rq_init(q, rq);
>>>>>         blk_rq_set_rl(rq, rl);
>>>>> +       blk_rq_set_prio(rq, ioc);
>>>>>         req_set_op_attrs(rq, op, op_flags | REQ_ALLOCED);
>>>>>
>>>>>         /* init elvpriv */
>>>>> @@ -1656,7 +1657,8 @@ void init_request_from_bio(struct request *req,
>>>>> struct bio *bio)
>>>>>
>>>>>         req->errors = 0;
>>>>>         req->__sector = bio->bi_iter.bi_sector;
>>>>> -       req->ioprio = bio_prio(bio);
>>>>> +       if (ioprio_valid(bio_prio(bio)))
>>>>> +               req->ioprio = bio_prio(bio);
>>>>
>>>>
>>>>
>>>> Should we use ioprio_best() here?  If req->ioprio and bio_prio()
>>>> disagree one side has explicitly asked for a higher priority.
>>>
>>>
>>>
>>> It's a good question - but if priority has been set in the bio, it makes
>>> sense that that would take priority over the general setting for the
>>> task/io context. So I think the patch is correct as-is.
>>
>>
>> Assuming you always trust the kernel to know the right priority...
>
>
> If it set it in the bio, it better know what it's doing. Besides,
> there's nothing stopping the caller from checking the task priority when
> it sets it. If we do ioprio_best(), then we are effectively preventing
> anyone from submitting a bio with a lower priority than the task has
> generally set.

Ah, that makes sense.  Move the ioprio_best() decision out to whatever
code is setting bio_prio() to allow for cases where the kernel knows
best.
