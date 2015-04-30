From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 12/12] IB/srp: Make CM timeout dependent on subnet timeout
Date: Thu, 30 Apr 2015 13:27:02 +0300
Message-ID: <55420376.5070305@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EFB3.6030704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541EFB3.6030704-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 4/30/2015 12:02 PM, Bart Van Assche wrote:
> In large networks the subnet timeout may have been set to a value
> above 20. In small networks it can be safe to reduce the subnet
> timeout below 20. The CM timeout should be proportional to the
> subnet timeout. Hence make the CM timeout dependent on the subnet
> timeout. Since the default subnet timeout used by OpenSM is 18
> this patch does not change the CM timeout if the default OpenSM
> subnet timeout is used.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 27d3a64..a18a2ae 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -704,6 +704,19 @@ static int srp_lookup_path(struct srp_rdma_ch *ch)
>   	return ch->status;
>   }
>
> +static u8 srp_get_subnet_timeout(struct srp_host *host)
> +{
> +	struct ib_port_attr attr;
> +	int ret;
> +	u8 subnet_timeout = 18;
> +
> +	ret = ib_query_port(host->srp_dev->dev, host->port, &attr);
> +	if (ret == 0)
> +		subnet_timeout = attr.subnet_timeout;
> +
> +	return subnet_timeout;
> +}
> +
>   static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
>   {
>   	struct srp_target_port *target = ch->target;
> @@ -711,8 +724,11 @@ static int srp_send_req(struct srp_rdma_ch *ch, bool multich)
>   		struct ib_cm_req_param param;
>   		struct srp_login_req   priv;
>   	} *req = NULL;
> +	u8 subnet_timeout;
>   	int status;
>
> +	subnet_timeout = srp_get_subnet_timeout(target->srp_host);

Is this really something that srp initiator should look at?
I'd say that this needs to be a ib_cm code in case the input timeout
values are not set (e.g. zero).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
