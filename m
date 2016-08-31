From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Should queue_max_hw_sectors() always be <= max_dev_sectors?
Date: Wed, 31 Aug 2016 00:11:36 -0400
Message-ID: <yq18tvd7f2f.fsf@sermon.lab.mkp.net>
References: <202d350b-0e59-1a10-4b65-3563f0afa084@redhat.com>
        <yq1y43d7kgm.fsf@sermon.lab.mkp.net>
        <74ef47ec-4aee-bdba-b000-cc0b46cf815a@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <74ef47ec-4aee-bdba-b000-cc0b46cf815a@kernel.dk> (Jens Axboe's
        message of "Tue, 30 Aug 2016 20:36:02 -0600")
Sender: target-devel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Grover <agrover@redhat.com>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:

Jens,

>> It is a requirement for SG_IO, firmware updates, tape drives,
>> etc. that the controller limits are reported correctly since they do
>> I/Os that are much bigger than typical filesystem requests. When we
>> tried to conflate the two things broke in interesting ways.

Jens> That's crazy. If max_hw_sectors_kb is expected to be the DMA
Jens> constraint, then it makes no sense to name it 'sectors'.

I don't believe I named it :)

It's the maximum DMA transfer size supported by the controller. Some
controllers have limitations above and beyond their scatter-gather
capabilities.

You could argue that they should use max_dev_sectors since the limit is
probably more of a firmware virtual disk thing than a DMA engine
constraint. But max_dev_sectors and the matching SCSI transfer size cap
are both very new to the game.

Jens> We currently have the one exported constraints, and making it
Jens> anything but the 'this is the maximum IO size we can support'
Jens> would be nonsensical.

That implies that the value is the same for all types of I/O which is
not the case. Hasn't been for a long time. See discard, write same,
etc. blk_rq_get_max_sectors() is passed a struct request because the
answer depends on what type of request and which operation it is.

With max_hw_sectors_kb we're not so lucky. We could assume read/write
but it would break existing apps that check it for SG_IO or to set tape
block size. And they do exist.

Jens> Which, coincidentally, is what that file already is for most other
Jens> devices.

Because none of the other protocols happen to have device limits.

Jens> It'd make more sense to bring SCSI into this realm, instead of
Jens> imposing this weird world view on others.

Hey, I didn't invent the SCSI device constraint. I think it sucks. But
it is a hard limit and we absolutely have to enforce it. And we can't
lower the hw limit willy-nilly because it breaks non-REQ_TYPE_FS
requests.

As a result, max_dev_sectors is only used by sd and it's only used to
gate max_sectors_kb for filesystem requests. I would have happily kept
it internal to SCSI but users need to be able to set max_sectors_kb
through sysfs. And consequently I need to be able to clamp on it there.

I'm happy to clean things up if you have a better idea how to enforce
the device limit without breaking existing apps. It's possible that with
the arbitrary bio size changes some of the original pain points have
gone away. Will take a look.

But implementation aesthetics aside, Andy's problem still
persists. Because at least in the context of SCSI the answer to his
question is "it depends" :(

-- 
Martin K. Petersen	Oracle Linux Engineering
