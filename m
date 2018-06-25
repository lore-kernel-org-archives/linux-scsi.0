From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH 5/5] nvme: use __blk_mq_complete_request in timeout path
Date: Mon, 25 Jun 2018 09:40:29 +0800
Message-ID: <cc93effe-8e97-d4a8-851e-33208cf837a7@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
 <1529500964-28429-6-git-send-email-jianchao.w.wang@oracle.com>
 <20180620143956.GA20950@lst.de>
 <42583ee2-fe9d-39da-b82a-38a27b03fdb3@oracle.com>
 <1817441e-6810-ed40-a8fd-403742818aae@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1817441e-6810-ed40-a8fd-403742818aae@grimberg.me>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, keith.busch@intel.com, josef@toxicpanda.com, ulf.hansson@linaro.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 06/25/2018 02:07 AM, Sagi Grimberg wrote:
> 
>> Hi Christoph
>>
>> Thanks for your kindly response.
>>
>> On 06/20/2018 10:39 PM, Christoph Hellwig wrote:
>>>> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
>>>> index 73a97fc..2a161f6 100644
>>>> --- a/drivers/nvme/host/pci.c
>>>> +++ b/drivers/nvme/host/pci.c
>>>> @@ -1203,6 +1203,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
>>>>           nvme_warn_reset(dev, csts);
>>>>           nvme_dev_disable(dev, false);
>>>>           nvme_reset_ctrl(&dev->ctrl);
>>>> +        __blk_mq_complete_request(req);
>>>>           return BLK_EH_DONE;
>>>>       }
>>>>   @@ -1213,6 +1214,11 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
>>>>           dev_warn(dev->ctrl.device,
>>>>                "I/O %d QID %d timeout, completion polled\n",
>>>>                req->tag, nvmeq->qid);
>>>> +        /*
>>>> +         * nvme_end_request will invoke blk_mq_complete_request,
>>>> +         * it will do nothing for this timed out request.
>>>> +         */
>>>> +        __blk_mq_complete_request(req);
>>>
>>> And this clearly is bogus.  We want to iterate over the tagetset
>>> and cancel all requests, not do that manually here.
>>>
>>> That was the whole point of the original change.
>>>
>>
>> For nvme-pci, we indeed have an issue that when nvme_reset_work->nvme_dev_disable returns, timeout path maybe still
>> running and the nvme_dev_disable invoked by timeout path will race with the nvme_reset_work.
>> However, the hole is still there right now w/o my changes, but just narrower.
> 
> Given the amount of fixes (and fixes of fixes) we had in the timeout handler, maybe it'd be a good idea to step back and take a another look?
> 
> Won't it be better to avoid disabling the device and return
> BLK_EH_RESET_TIMER if we are not aborting in the timeout handler?
> 

Yes, that would be an ideal status for nvme-pci.
But we have to depend on the timeout handler to handle the timed out request from nvme_reset_work.

Thanks
Jianchao
