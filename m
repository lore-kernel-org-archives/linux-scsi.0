From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 05/11] IB/iser: Replace fastreg descriptor valid bool
 with indicators container
Date: Mon, 24 Feb 2014 10:27:56 +0200
Message-ID: <530B028C.7060405@dev.mellanox.co.il>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>	 <1393157974-24931-6-git-send-email-sagig@mellanox.com>	 <1393224839.22656.19.camel@haakon3.risingtidesystems.com> <1393227000.22656.24.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393227000.22656.24.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 2/24/2014 9:30 AM, Nicholas A. Bellinger wrote:
> On Sun, 2014-02-23 at 22:53 -0800, Nicholas A. Bellinger wrote:
>> On Sun, 2014-02-23 at 14:19 +0200, Sagi Grimberg wrote:
>>> In T10-PI support we will have memory keys for protection
>>> buffers and signature transactions. We prefer to compact
>>> indicators rather than keeping multiple bools.
>>>
>>> This commit does not change any functionality.
>>>
>>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> ---
>>>   drivers/infiniband/ulp/iser/iscsi_iser.h  |    8 ++++++--
>>>   drivers/infiniband/ulp/iser/iser_memory.c |    4 ++--
>>>   drivers/infiniband/ulp/iser/iser_verbs.c  |    2 +-
>>>   3 files changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
>>> index 5ffa92f..5f7dbfd 100644
>>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
>>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
>>> @@ -280,13 +280,17 @@ struct iser_device {
>>>   							    enum iser_data_dir cmd_dir);
>>>   };
>>>   
>>> +enum iser_reg_indicator {
>>> +	ISER_DATA_KEY_VALID = 1 << 0,
>>> +};
>>> +
>>>   struct fast_reg_descriptor {
>>>   	struct list_head		  list;
>>>   	/* For fast registration - FRWR */
>>>   	struct ib_mr			 *data_mr;
>>>   	struct ib_fast_reg_page_list     *data_frpl;
>>> -	/* Valid for fast registration flag */
>>> -	bool				  valid;
>>> +	/* registration indicators container */
>>> +	u8				  reg_indicators;
>>>   };
>>>   
>>>   struct iser_conn {
>>> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
>>> index 0e029fe..3edab18 100644
>>> --- a/drivers/infiniband/ulp/iser/iser_memory.c
>>> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
>>> @@ -479,7 +479,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
>>>   		return -EINVAL;
>>>   	}
>>>   
>>> -	if (!desc->valid) {
>>> +	if (!(desc->reg_indicators & ISER_DATA_KEY_VALID)) {
>>>   		memset(&inv_wr, 0, sizeof(inv_wr));
>>>   		inv_wr.wr_id = ISER_FRWR_LI_WRID;
>>>   		inv_wr.opcode = IB_WR_LOCAL_INV;
>> This block doesn't apply either..
>>
>> ISER_FRWR_LI_WRID does not appear to be defined anywhere in v3.14-rc2
>> code..?  Is this patch missing a new definition..?
> Er, missed the bit wrt:
>
>     IB/iser: Suppress completion for fast registration work requests
>
> Applied along with ib_iser + ib_isert patches to target-pending/rdma-dif
>
> --nab

OK, I see you got the missing piece.
This fixes all your conflicts right (I verified it before myself)?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
