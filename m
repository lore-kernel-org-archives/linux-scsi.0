From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 1/4] block: Add iocontext priority to request
Date: Thu, 13 Oct 2016 14:09:34 -0600
Message-ID: <068e03c4-3558-a6b1-2008-d13bde4958a1@kernel.dk>
References: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com>
 <1476388433-2539-2-git-send-email-adam.manzanares@hgst.com>
 <CAPcyv4giMwLRkP9YDcOo4st2RqxPXsYYyTOJ2_U8ywQPteM5gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:36717 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbcJMUKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 16:10:00 -0400
Received: by mail-it0-f50.google.com with SMTP id l13so194330225itl.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 13:09:37 -0700 (PDT)
In-Reply-To: <CAPcyv4giMwLRkP9YDcOo4st2RqxPXsYYyTOJ2_U8ywQPteM5gQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Adam Manzanares <adam.manzanares@hgst.com>
Cc: Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, mchristi@redhat.com, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>, Adam Manzananares <adam.manzanares@wdc.com>

On 10/13/2016 02:06 PM, Dan Williams wrote:
> On Thu, Oct 13, 2016 at 12:53 PM, Adam Manzanares
> <adam.manzanares@hgst.com> wrote:
>> Patch adds an association between iocontext ioprio and the ioprio of a
>> request. This value is set in blk_rq_set_prio which takes the request and
>> the ioc as arguments. If the ioc is valid in blk_rq_set_prio then the
>> iopriority of the request is set as the iopriority of the ioc. In
>> init_request_from_bio a check is made to see if the ioprio of the bio is
>> valid and if so then the request prio comes from the bio.
>>
>> Signed-off-by: Adam Manzananares <adam.manzanares@wdc.com>
>> ---
>>  block/blk-core.c       |  4 +++-
>>  include/linux/blkdev.h | 14 ++++++++++++++
>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 14d7c07..361b1b9 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1153,6 +1153,7 @@ static struct request *__get_request(struct request_list *rl, int op,
>>
>>         blk_rq_init(q, rq);
>>         blk_rq_set_rl(rq, rl);
>> +       blk_rq_set_prio(rq, ioc);
>>         req_set_op_attrs(rq, op, op_flags | REQ_ALLOCED);
>>
>>         /* init elvpriv */
>> @@ -1656,7 +1657,8 @@ void init_request_from_bio(struct request *req, struct bio *bio)
>>
>>         req->errors = 0;
>>         req->__sector = bio->bi_iter.bi_sector;
>> -       req->ioprio = bio_prio(bio);
>> +       if (ioprio_valid(bio_prio(bio)))
>> +               req->ioprio = bio_prio(bio);
>
> Should we use ioprio_best() here?  If req->ioprio and bio_prio()
> disagree one side has explicitly asked for a higher priority.

It's a good question - but if priority has been set in the bio, it makes
sense that that would take priority over the general setting for the
task/io context. So I think the patch is correct as-is.

Adam, you'll want to rewrite the commit message though. A good commit
message should explain WHY the change is made, not detail the code
implementation of it.

-- 
Jens Axboe

