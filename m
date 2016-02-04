From: jiangyiwen <jiangyiwen@huawei.com>
Subject: Re: dm-mpath: fix a tiny case which can cause an infinite loop
Date: Thu, 4 Feb 2016 16:25:46 +0800
Message-ID: <56B30B0A.5080600@huawei.com>
References: <56B2B282.60400@huawei.com> <20160204032452.GA15344@redhat.com>
 <56B2CA48.9010802@huawei.com> <20160204042528.GA15599@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:40776 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbcBDI0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 03:26:20 -0500
In-Reply-To: <20160204042528.GA15599@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, xuejiufei@huawei.com, "Qijiang (Joseph, Euler)" <joseph.qi@huawei.com>, martin.petersen@oracle.com

On 2016/2/4 12:25, Mike Snitzer wrote:
> On Wed, Feb 03 2016 at 10:49pm -0500,
> jiangyiwen <jiangyiwen@huawei.com> wrote:
> 
>> On 2016/2/4 11:24, Mike Snitzer wrote:
>>> On Wed, Feb 03 2016 at  9:08pm -0500,
>>> jiangyiwen <jiangyiwen@huawei.com> wrote:
>>>
>>>> When two processes submit WRTIE SAME bio simultaneously and
>>>> first IO return failed because of INVALID FIELD IN CDB, and
>>>> then second IO can enter into an infinite loop.
>>>> The problem can be described as follows:
>>>>
>>>> process 1                              process 2
>>>> submit_bio(REQ_WRITE_SAME) and
>>>> wait io completion
>>>>                                        begin submit_bio(REQ_WRITE_SAME)
>>>>                                        -> blk_queue_bio()
>>>>                                          -> dm_request_fn()
>>>>                                            -> map_request()
>>>>                                              -> scsi_request_fn()
>>>>                                                -> blk_peek_request()
>>>>                                                  -> scsi_prep_fn()
>>>> In the moment, IO return and
>>>> sense_key with illegal_request,
>>>> sense_code with 0x24(INVALID FIELD IN CDB).
>>>> In this way it will set no_write_same = 1
>>>> in sd_done() and disable write same
>>>>                                        In sd_setup_write_same_cmnd()
>>>>                                        when find (no_write_same == 1)
>>>>                                        will return BLKPREP_KILL,
>>>>                                        and then in blk_peek_request()
>>>>                                        set error to EIO.
>>>>                                        However, in multipath_end_io()
>>>>                                        when find error is EIO it will
>>>>                                        fail path and retry even if
>>>>                                        device doesn't support WRITE SAME.
>>>>
>>>> In this situation, when process of multipathd reinstate
>>>> path by using test_unit_ready periodically, it will cause
>>>> second WRITE SAME IO enters into an infinite loop and
>>>> loop never terminates.
>>>>
>>>> In do_end_io(), when finding device doesn't support WRITE SAME and
>>>> request is WRITE SAME, return EOPNOTSUPP to applications.
>>>>
>>>> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
>>>> Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
>>>> Reviewed-by: xuejiufei <xuejiufei@huawei.com>
>>>> ---
>>>>  drivers/md/dm-mpath.c | 5 +++++
>>>>  1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>>> index cfa29f5..ad1602a 100644
>>>> --- a/drivers/md/dm-mpath.c
>>>> +++ b/drivers/md/dm-mpath.c
>>>> @@ -1269,6 +1269,11 @@ static int do_end_io(struct multipath *m, struct request *clone,
>>>>  	if (noretry_error(error))
>>>>  		return error;
>>>>
>>>> +	/* do not retry in case of WRITE SAME not supporting */
>>>> +	if ((clone->cmd_flags & REQ_WRITE_SAME) &&
>>>> +			!clone->q->limits.max_write_same_sectors)
>>>> +		return -EOPNOTSUPP;
>>>> +
>>>>  	if (mpio->pgpath)
>>>>  		fail_path(mpio->pgpath);
>>>>
>>>
>>> Did you test this patch?  Looks like it isn't going to make a
>>> difference.  'error' will be -EREMOTEIO, which will be caught by
>>> noretry_error().  So we'll never go on to run your new code.
>>>
>>> Please see commit 7eee4ae2db ("dm: disable WRITE SAME if it fails").
>>>
>>> I think DM already handles this case properly.  The only thing is it'll
>>> return -EREMOTEIO (rather than -EOPNOTSUPP) further up the stack.
>>>
>>> .
>>>
>> Hi Mike,
>> Yes, I have already test in version linux-3.8, and I also have already
>> carefully checked latest kernel code, and find that it also exists this
>> problem. I know about this commit 7eee4ae2db ("dm: disable WRITE SAME
>> if it fails"), it only can solve first IO situation which I mentioned
>> above, in other words, when WRITE SAME IO truly send to device, it
>> actually return -EREMOTEIO if device doesn't support WRITE SAME.
>> But in above situation which issues two WRITE SAME IO simultaneously,
>> second IO will not truly send to device instead of returning
>> BLKPREP_KILL in sd_setup_write_same_cmnd() because find
>> (no_write_same == 1) which no_write_same is set when first IO returned,
>> and then in blk_peek_request() will return EIO to MD/DM which caused
>> the problem above mentioned.
>>
>> I have described detailed process of problem, you will find actually
>> it is a problem when reviewed carefully.
> 
> OK, so -EIO is getting returned.  That shouldn't happen.  -EIO is the
> generic catch-all error that we're going to retry.  We have
> differentiated IO errors in SCSI that get returned up the IO stack
> (e.g. -EREMOTEIO, etc).
> 
> The SCSI, or block layer, should return a non-retryable error for this
> case.  But we only have the differentiated IO errors for SCSI cmds that
> are issued, so it seems we still need to train SCSI (and block by
> association/dependency) to return permanent errors that are identified
> during request preparation.
> 
> But it may be that we need to widen the WRITE_SAME error handling code
> in DM to check for -EREMOTEIO or -EOPNOTSUPP.  But I'm really not in
> favor of special-casing -EIO for WRITE_SAME, we need to be sprinkling
> less special-case code to make up for lack of information for lower
> layers.
> 
> .
> 
I totally agree with you. SCSI or block layer should not return EIO
to MD/DM, but the return code associated with many other process,
it will influence more if I modify blk_peek_request. So I use this
method to avoid it, and I also expect martin can get a better idea.

In addition, with increasing number of various storage, I worried
whether multipath still can occur an infinite loop as I mentioned
above someday. Thus I think whether multipath should have a
timeout mechanism to solve this type of problem which will cause a
ping-pong effect, for instance, return error to applications when
try a certain counts or time in multipath. This is my idea, I hope
it will have more people to discuss it.


