From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ib_srp: initialize dma_length in srp_map_idb
Date: Sun, 15 Nov 2015 23:10:54 +0200
Message-ID: <CAJ3xEMgKiB_qK-WkD0mB3NnCkE0=S_khc93-X381rRbROoYWkw@mail.gmail.com>
References: <1447610393-2899-1-git-send-email-hch@lst.de>
	<5648CD03.4000206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5648CD03.4000206-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 15, 2015, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 15/11/2015 19:59, Christoph Hellwig wrote:

>> Without this sg_dma_len will return 0 on architectures tha have
>> the dma_length field.

and what wrong with that?

Christoph, probably typo here? "tha" needs to be "that"

>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
>> b/drivers/infiniband/ulp/srp/ib_srp.c
>> index 32f7962..445c0a6 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -1520,6 +1520,9 @@ static int srp_map_idb(struct srp_rdma_ch *ch,
>> struct srp_request *req,
>>                 state.sg_nents = 1;
>>                 sg_set_buf(idb_sg, req->indirect_desc, idb_len);
>>                 idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
>> +#ifdef CONFIG_NEED_SG_DMA_LENGTH
>> +               idb_sg->dma_length = idb_sg->length;          /* hack^2 */
>> +#endif
>
>
> :)
>
> We should really get this properly map/unmap per IO at some point.
> Probably do it in both code paths...

Sagi, can you please elaborate a little further on the problem, srpt
WA, what do we do in isert and what is the proposed not WA solution?

> Having said that,
> Looks fine,
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
