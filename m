From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC v3 PATCH 1/2] bsg: Add infrastructure to send in kernel
 bsg commands.
Date: Thu, 23 Jun 2011 19:02:56 -0700
Message-ID: <4E03F050.5030001@panasas.com>
References: <alpine.LFD.2.02.1106160825540.2424@localhost.localdomain> <20110623104625Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:43864 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1FXDRq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2011 23:17:46 -0400
In-Reply-To: <20110623104625Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chad.dupuis@qlogic.com, linux-scsi@vger.kernel.org

On 06/22/2011 06:51 PM, FUJITA Tomonori wrote:
>> @@ -965,6 +1009,40 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>>         }
>>   }
> 
> Rather than adding 'is_user' argument to everywhere, it could cleaner
> to add something like 'int from_kernel' in struct bsg_command? No?
> 

I agree it should be part of the bsg_command,

I would prefer if all these "from_kernel" or "is_user" are bool. and true/false
we don't do int for bool(s) in Kernel anymore.

> 
>> +int bsg_private_command (struct request_queue *q, struct sg_io_v4 *hdr)
A question:
  I needed to do something like this for a long time. But the way I need it I actually
  have user_buffers at @hdr. Because I want it as part of an OSD ioctl which is filtered
  and enhanced and then chained to here. (Like block devices chain to blk_ioctl)

  Could we add in the future, a bool param "is_user" to this API?

>> +{
>> +       struct request *rq;
>> +       struct bio *bio, *bidi_bio = NULL;
>> +       int at_head;
>> +       u8 sense[SCSI_SENSE_BUFFERSIZE];
>> +       fmode_t has_write_perm = 0;
>> +       int ret;
>> +
>> +       if (!q)
>> +               return -ENXIO;
>> +
>> +       /* Fake that we have write permission */
>> +       has_write_perm |= FMODE_WRITE;
>> +
>> +       rq = bsg_map_hdr_kern(q, hdr, has_write_perm, sense);
>> +
>> +       if (IS_ERR(rq)) {
>> +               return PTR_ERR(rq);
>> +       }
>> +
>> +       bio = rq->bio;
>> +       if (rq->next_rq)
>> +               bidi_bio = rq->next_rq->bio;
>> +       at_head = (0 == (hdr->flags & BSG_FLAG_Q_AT_TAIL));
>> +
>> +       blk_execute_rq(q, NULL, rq, at_head);
>> +       ret = blk_complete_sgv4_hdr_rq(rq, hdr, bio, bidi_bio, 0);
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL(bsg_private_command);
> 
> EXPORT_SYMBOL_GPL, please.
> 

I have a question about this API:
 From user mode we open a filehandle on the device and it is pinned down till
 we close the handle. A kernel user API might need to take the device reference
 somewhere. Is that true?

Thanks
Boaz
