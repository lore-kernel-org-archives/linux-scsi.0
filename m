From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 08/15] scsi_transport_srp: Add transport layer error
 handling
Date: Mon, 01 Jul 2013 07:19:14 -0400
Message-ID: <1372677554.12468.53.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD873E.6040208@acm.org>
	 <1372626334.12468.34.camel@haswell.thedillows.org>
	 <51D12941.3050105@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D12941.3050105-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-07-01 at 09:01 +0200, Bart Van Assche wrote:
> On 06/30/13 23:05, David Dillow wrote:
> > On Fri, 2013-06-28 at 14:53 +0200, Bart Van Assche wrote:
> >> +int srp_tmo_valid(int fast_io_fail_tmo, int dev_loss_tmo)
> >> +{
> >> +	return (fast_io_fail_tmo < 0 || dev_loss_tmo < 0 ||
> >> +		fast_io_fail_tmo < dev_loss_tmo) &&
> >> +		fast_io_fail_tmo < LONG_MAX / HZ &&
> >> +		dev_loss_tmo < LONG_MAX / HZ ? 0 : -EINVAL;
> >> +}
> >
> > They should also be capped by SCSI_DEVICE_BLOCK_MAX_TIMEOUT instead of
> > LONG_MAX / HZ, I think.
> 
> The fast_io_fail_tmo should indeed be capped by that value. However, I'm 
> not sure about dev_loss_tmo. I think there are several use cases (e.g. 
> initiator-side mirroring) where it's useful to set dev_loss_tmo to a 
> larger value than ten minutes.

Ah, yes, very good point.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
