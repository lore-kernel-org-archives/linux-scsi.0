From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 3/4] IB/srp: Fix residual handling
Date: Wed, 09 Jul 2014 21:07:57 -0700
Message-ID: <1404965277.17131.4.camel@haswell.thedillows.org>
References: <53BD49E3.3090903@acm.org> <53BD4A5F.6070708@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BD4A5F.6070708-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-07-09 at 15:57 +0200, Bart Van Assche wrote:
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1644,10 +1644,14 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
>  				     SCSI_SENSE_BUFFERSIZE));
>  		}
 
Above this block, there is a line 
	if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {

My thought was that you could wrap the code starting at that block and
ending after the additional scsi_set_resid() calls you added with an
outer test like so:

	if (unlikely(rsp->flags & ~SRP_RSP_FLAG_RSPVALID)) {
		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
			...

instead of adding unlikely() to each test of flags. Once inside the
block -- which should be rare -- we're on the slow path anyway.

Your call.

> -		if (rsp->flags & (SRP_RSP_FLAG_DOOVER | SRP_RSP_FLAG_DOUNDER))
> -			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
> -		else if (rsp->flags & (SRP_RSP_FLAG_DIOVER | SRP_RSP_FLAG_DIUNDER))
> +		if (unlikely(rsp->flags & SRP_RSP_FLAG_DIUNDER))
>  			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
> +		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DIOVER))
> +			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));
> +		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOUNDER))
> +			scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
> +		else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))
> +			scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));
>  
>  		srp_free_req(target, req, scmnd,
>  			     be32_to_cpu(rsp->req_lim_delta));


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
