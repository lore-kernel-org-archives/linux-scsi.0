From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 12 Jan 2017 10:23:47 +0200
Message-ID: <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>
List-Id: linux-scsi@vger.kernel.org


>>> Hi all,
>>>
>>> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
>>>
>>> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
>>> networking field and accoring to Sagi's findings in [1] performance with
>>> polling is not on par with IRQ usage.
>>>
>>> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
>>> more block drivers and how to overcome the currently seen performance issues.
>>
>> It would be an interesting topic to discuss, as it is a shame that blk-iopoll
>> isn't used more widely.
>
> Forgot to mention - it should only be a topic, if experimentation has
> been done and results gathered to pin point what the issues are, so we
> have something concrete to discus. I'm not at all interested in a hand
> wavy discussion on the topic.
>

Hey all,

Indeed I attempted to convert nvme to use irq-poll (let's use its
new name) but experienced some unexplained performance degradations.

Keith reported a 700ns degradation for QD=1 with his Xpoint devices,
this sort of degradation are acceptable I guess because we do schedule
a soft-irq before consuming the completion, but I noticed ~10% IOPs
degradation fr QD=32 which is not acceptable.

I agree with Jens that we'll need some analysis if we want the
discussion to be affective, and I can spend some time this if I
can find volunteers with high-end nvme devices (I only have access
to client nvme devices.

I can add debugfs statistics on average the number of completions I
consume per intererupt, I can also trace the interrupt and the soft-irq
start,end. Any other interesting stats I can add?

I also tried a hybrid mode where the first 4 completions were handled
in the interrupt and the rest in soft-irq but that didn't make much
of a difference.

Any other thoughts?
