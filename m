From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 10/12] IB/srp: Use block layer tags
Date: Mon, 20 Oct 2014 13:44:12 +0200
Message-ID: <5444F58C.4010307@acm.org>
References: <5433E43D.3010107@acm.org> <5433E557.3010505@acm.org> <20141017105858.GA7819@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141017105858.GA7819-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/17/14 12:58, Christoph Hellwig wrote:
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index cc0bf83b..224ef25 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -853,7 +853,6 @@ static int srp_alloc_req_data(struct srp_rdma_ch *ch)
>>   			goto out;
>>
>>   		req->indirect_dma_addr = dma_addr;
>> -		req->index = i;
>>   		list_add_tail(&req->list, &ch->free_reqs);
>>   	}
>
> Seems like a nice optimization for the future would be to preallocate
> the srp requests with the block ones and the scsi command.

Agreed. The reason why that optimization has not been included in this 
patch series is because it would require more work than the optimization 
in patch 10/12. The free_reqs list is namely not only used when a SCSI 
command is submitted by the SCSI core but also when submitting a task 
management command or when replying to a request submitted by the target 
system. In other words, the free_reqs list would have to be modified 
such that it is only used for the latter two purposes.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
