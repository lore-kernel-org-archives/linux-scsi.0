From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 13/15] ib_srp: Allow SRP disconnect through sysfs
Date: Mon, 16 Jul 2012 16:20:36 -0600
Message-ID: <500493B4.4010303@cs.wisc.edu>
References: <5207288.nSt5MkVMpO@asus> <12137079.5Hhh1ukOmv@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12137079.5Hhh1ukOmv@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 03/25/2012 09:01 AM, Bart Van Assche wrote:
> +static void srp_rport_delete(struct srp_rport *rport)
> +{
> +	struct srp_target_port *target = rport->lld_data;
> +
> +	BUG_ON(!target);
> +

I don't think this null check is needed, because below you set the
lld_data before you call srp_rport_add which does the transport driver
model/sysfs file addition for the rport. So I think the rport delete
sysfs file won't show up before you set the lld_data.



>  static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
>  {
>  	struct srp_rport_identifiers ids;
> @@ -2002,6 +2021,8 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
>  		return PTR_ERR(rport);
>  	}
>  
> +	rport->lld_data = target;
> +

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
