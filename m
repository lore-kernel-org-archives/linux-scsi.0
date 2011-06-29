From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [RFC v3 PATCH 1/2] bsg: Add infrastructure to send in kernel
 bsg commands.
Date: Wed, 29 Jun 2011 16:27:34 -0400
Message-ID: <alpine.LFD.2.02.1106291623380.8334@localhost.localdomain>
References: <alpine.LFD.2.02.1106160825540.2424@localhost.localdomain> <20110623104625Y.fujita.tomonori@lab.ntt.co.jp> <4E03F050.5030001@panasas.com> <20110629160422H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:40425
	"EHLO CH1EHSOBE018.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754754Ab1F2U1v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2011 16:27:51 -0400
In-Reply-To: <20110629160422H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Wed, 29 Jun 2011, FUJITA Tomonori wrote:

> On Thu, 23 Jun 2011 19:02:56 -0700
> Boaz Harrosh <bharrosh@panasas.com> wrote:
>
>> On 06/22/2011 06:51 PM, FUJITA Tomonori wrote:
>>>> @@ -965,6 +1009,40 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>>>         }
>>>>   }
>>>
>>> Rather than adding 'is_user' argument to everywhere, it could cleaner
>>> to add something like 'int from_kernel' in struct bsg_command? No?
>>>
>>
>> I agree it should be part of the bsg_command,
>>
>> I would prefer if all these "from_kernel" or "is_user" are bool. and true/false
>> we don't do int for bool(s) in Kernel anymore.
>
> Yeah.
>

This makes sense.

>
>>>> +int bsg_private_command (struct request_queue *q, struct sg_io_v4 *hdr)
>> A question:
>>   I needed to do something like this for a long time. But the way I need it I actually
>>   have user_buffers at @hdr. Because I want it as part of an OSD ioctl which is filtered
>>   and enhanced and then chained to here. (Like block devices chain to blk_ioctl)
>>
>>   Could we add in the future, a bool param "is_user" to this API?
>
> Why applications can't simply send bsg commands instead of ioctl?
>
>
>>>> +{
>>>> +       struct request *rq;
>>>> +       struct bio *bio, *bidi_bio = NULL;
>>>> +       int at_head;
>>>> +       u8 sense[SCSI_SENSE_BUFFERSIZE];
>>>> +       fmode_t has_write_perm = 0;
>>>> +       int ret;
>>>> +
>>>> +       if (!q)
>>>> +               return -ENXIO;
>>>> +
>>>> +       /* Fake that we have write permission */
>>>> +       has_write_perm |= FMODE_WRITE;
>>>> +
>>>> +       rq = bsg_map_hdr_kern(q, hdr, has_write_perm, sense);
>>>> +
>>>> +       if (IS_ERR(rq)) {
>>>> +               return PTR_ERR(rq);
>>>> +       }
>>>> +
>>>> +       bio = rq->bio;
>>>> +       if (rq->next_rq)
>>>> +               bidi_bio = rq->next_rq->bio;
>>>> +       at_head = (0 == (hdr->flags & BSG_FLAG_Q_AT_TAIL));
>>>> +
>>>> +       blk_execute_rq(q, NULL, rq, at_head);
>>>> +       ret = blk_complete_sgv4_hdr_rq(rq, hdr, bio, bidi_bio, 0);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +EXPORT_SYMBOL(bsg_private_command);
>>>
>>> EXPORT_SYMBOL_GPL, please.
>>>
>>
>> I have a question about this API:
>>  From user mode we open a filehandle on the device and it is pinned down till
>>  we close the handle. A kernel user API might need to take the device reference
>>  somewhere. Is that true?
>
> Yeah, as I wrote at the previous submission, I still suspect that this
> patch has such problem. I guess we need to get the reference (and
> check the status) before sending in-kernel requests. And that's why I
> don't like in-kernel request support (making the reference model
> complicated).
>

I presume here you mean taking a kref of bcd->ref?  So essentially
we'd want to:

kref_get(&bcd->ref);
...
execute command.
...
kref_put(&bcd->ref, bsg_kref_release_function);

in bsg_private_command()?

>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

