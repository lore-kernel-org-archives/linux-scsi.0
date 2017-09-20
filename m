From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] block: cope with WRITE SAME failing in blkdev_issue_zeroout()
Date: Wed, 20 Sep 2017 15:03:11 +0200
Message-ID: <CAOi1vP_1TJ-QKg2doW=-e7xmjBtH1WaVV_+BkweLOiQyHk9kQg@mail.gmail.com>
References: <1504719490-7523-1-git-send-email-idryomov@gmail.com> <20170919203258.GB7347@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919203258.GB7347@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 19, 2017 at 10:32 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Sep 06, 2017 at 07:38:10PM +0200, Ilya Dryomov wrote:
>> sd_config_write_same() ignores ->max_ws_blocks == 0 and resets it to
>> permit trying WRITE SAME on older SCSI devices, unless ->no_write_same
>> is set.  This means blkdev_issue_zeroout() must cope with WRITE SAME
>> failing with BLK_STS_TARGET/-EREMOTEIO and explicitly write zeroes,
>> unless BLKDEV_ZERO_NOFALLBACK is specified.
>>
>> Commit 71027e97d796 ("block: stop using discards for zeroing") added
>> the following to __blkdev_issue_zeroout() comment:
>>
>>   "Note that this function may fail with -EOPNOTSUPP if the driver signals
>>   zeroing offload support, but the device fails to process the command (for
>>   some devices there is no non-destructive way to verify whether this
>>   operation is actually supported).  In this case the caller should call
>>   retry the call to blkdev_issue_zeroout() and the fallback path will be used."
>>
>> But __blkdev_issue_zeroout() doesn't fail in this case: if WRITE SAME
>> support is indicated, a REQ_OP_WRITE_ZEROES bio is built and returned
>> to blkdev_issue_zeroout().  -EREMOTEIO is then propagated up:
>>
>>   $ fallocate -zn -l 1k /dev/sdg
>>   fallocate: fallocate failed: Remote I/O error
>>   $ fallocate -zn -l 1k /dev/sdg  # OK
>>
>> (The second fallocate(1) succeeds because sd_done() sets ->no_write_same
>> in response to a sense that would become BLK_STS_TARGET.)
>>
>> Retry __blkdev_issue_zeroout() if the I/O fails with -EREMOTEIO.  This
>> is roughly what we did until 4.12, sans BLKDEV_ZERO_NOFALLBACK knob.
>
> I'm really not sure we should check for -EREMOTEIO specifically, but
> Martin who is more familiar with the SCSI code might be able to
> correct me, I'd feel safer about checking for any error which is
> what the old code did.

Yeah, I pondered that.  The old code did check for any error, but it
wouldn't attempt another WRITE SAME after a failure.  To do that here,
we'd need to refactor __blkdev_issue_zeroout(); as it is, if we retry
__blkdev_issue_zeroout() on a random error, it would happily go the
REQ_OP_WRITE_ZEROES way again.

Martin, what do you think?

Thanks,

                Ilya
