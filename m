From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 12/12] IB/srp: Make CM timeout dependent on subnet timeout
Date: Thu, 30 Apr 2015 12:45:58 +0200
Message-ID: <554207E6.9000901@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EFB3.6030704@sandisk.com>
 <55420376.5070305@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0091.outbound.protection.outlook.com ([207.46.100.91]:42473
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737AbbD3KqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 06:46:04 -0400
In-Reply-To: <55420376.5070305@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>

On 04/30/15 12:27, Sagi Grimberg wrote:
> On 4/30/2015 12:02 PM, Bart Van Assche wrote:
>> In large networks the subnet timeout may have been set to a value
>> above 20. In small networks it can be safe to reduce the subnet
>> timeout below 20. The CM timeout should be proportional to the
>> subnet timeout. Hence make the CM timeout dependent on the subnet
>> timeout. Since the default subnet timeout used by OpenSM is 18
>> this patch does not change the CM timeout if the default OpenSM
>> subnet timeout is used.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Cc: Sagi Grimberg <sagig@mellanox.com>
>> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
>> ---
>>    drivers/infiniband/ulp/srp/ib_srp.c | 20 ++++++++++++++++++--
>>    1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
>> index 27d3a64..a18a2ae 100644
>> --- a/drivers/infiniband/ulp/srp/ib_srp.c
>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>> @@ -704,6 +704,19 @@ static int srp_lookup_path(struct srp_rdma_ch *ch)
>>    	return ch->status;
>>    }
>>
>> +static u8 srp_get_subnet_timeout(struct srp_host *host)
>> +{
>> +	struct ib_port_attr attr;
>> +	int ret;
>> +	u8 subnet_timeout = 18;
>> +
>> +	ret = ib_query_port(host->srp_dev->dev, host->port, &attr);
>> +	if (ret == 0)
>> +		subnet_timeout = attr.subnet_timeout;
>> +
>> +	return subnet_timeout;
>> +}
>> +
>>    static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
>>    {
>>    	struct srp_target_port *target = ch->target;
>> @@ -711,8 +724,11 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
>>    		struct ib_cm_req_param param;
>>    		struct srp_login_req   priv;
>>    	} *req = NULL;
>> +	u8 subnet_timeout;
>>    	int status;
>>
>> +	subnet_timeout = srp_get_subnet_timeout(target->srp_host);
>
> Is this really something that srp initiator should look at?
> I'd say that this needs to be a ib_cm code in case the input timeout
> values are not set (e.g. zero).

I'm open to suggestions for how to move this functionality into the IB 
CM. Today the IB CM interprets all timeout values as absolute timeouts 
instead of timeouts that are relative to the subnet timeout. If we want 
to move this functionality into the IB CM we need an approach that 
allows the IB CM to discern relative from absolute values. I think this 
is only possible by changing struct ib_cm_req_param. Sean, would you 
perhaps like to share your opinion about this ?

Bart.
