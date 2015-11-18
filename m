From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/9] srpt: chain RDMA READ/WRITE requests
Date: Wed, 18 Nov 2015 08:32:59 -0800
Message-ID: <564CA83B.4060403@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-5-git-send-email-hch@lst.de> <564BD1AF.60200@sandisk.com>
 <564C41B8.2080904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564C41B8.2080904@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/18/2015 01:15 AM, Sagi Grimberg wrote:
> On 18/11/2015 03:17, Bart Van Assche wrote:
>> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>>> -        ret = ib_post_send(ch->qp, &wr.wr, &bad_wr);
>>> -        if (ret)
>>> -            break;
>>> +        if (i == n_rdma - 1) {
>>> +            /* only get completion event for the last rdma read */
>>> +            if (dir == DMA_TO_DEVICE)
>>> +                wr->wr.send_flags = IB_SEND_SIGNALED;
>>> +            wr->wr.next = NULL;
>>> +        } else {
>>> +            wr->wr.next = &ioctx->rdma_ius[i + 1].wr;
>>> +        }
>>>       }
>>>
>>> +    ret = ib_post_send(ch->qp, &ioctx->rdma_ius->wr, &bad_wr);
>>>       if (ret)
>>>           pr_err("%s[%d]: ib_post_send() returned %d for %d/%d\n",
>>>                    __func__, __LINE__, ret, i, n_rdma);
>>
>> Hello Christoph,
>
> Hi Bart,
>
>>
>> Chaining RDMA requests is a great idea. But it seems to me that this
>> patch is based on the assumption that posting multiple RDMA requests
>> either succeeds as a whole or fails as a whole. Sorry but I'm not sure
>> that the verbs API guarantees this. In the ib_srpt driver a QP can be
>> changed at any time into the error state and there might be drivers that
>> report an immediate failure in that case.
>
> I'm not so sure it actually matters if some WRs succeeded. In the normal
> flow when srpt has enough available work requests (sq_wr_avail) they
> should all succeed otherwise we're in trouble. If the QP transitioned
> to ERROR state, then some failed, but those that succeeded will
> generate flush completions, and srpt should handle it correctly
> shouldn't it?
>
>> I think even when chaining
>> RDMA requests that we still need a mechanism to wait until ongoing RDMA
>> transfers have finished if some but not all RDMA requests have been
>> posted.
>
> I'm not an expert on srpt, can you explain how this mechanism will help?

Hello Sagi,

As you know events like a cable pull can cause some of the RDMA work 
requests to succeed and others to fail. It is essential that all RDMA 
work requests related to the same SCSI command have finished before the 
buffers these requests operate upon are reused. The purpose of the 
SRPT_RDMA_ABORT request is to wait for the RDMA requests that were 
posted without IB_SEND_SIGNALED and for which no error completion will 
be received. BTW, I think this consideration applies to all SCSI target 
drivers and not only to SRP target drivers.

Bart.
