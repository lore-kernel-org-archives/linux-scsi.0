From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/8] IB/srp: Remove stale connection retry mechanism
Date: Sat, 20 Sep 2014 20:45:04 +0300
Message-ID: <CAJ3xEMhPKiut4MwZH9F7-T0+u7B6XPuh-FTZpA=Xe4ViAj5UUQ@mail.gmail.com>
References: <541C27BF.6070609@acm.org>
	<541C287D.1050900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541C287D.1050900-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 19, 2014 at 3:58 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Attempting to connect three times may be insufficient after an
> initiator system that was using multiple RDMA channels tries to
> relogin. Additionally, this login retry mechanism is a workaround
> for particular behavior of the IB/CM.

Can you be more specific re the particular behavior of the IB CM?
added Sean, the CM maintainer.

> Since the srp_daemon retries
> a failed login attempt anyway, remove the stale connection retry
> mechanism.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index d3c712f..9608e7a 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -904,7 +904,6 @@ static void srp_rport_delete(struct srp_rport *rport)
>
>  static int srp_connect_target(struct srp_target_port *target)
>  {
> -       int retries = 3;
>         int ret;
>
>         WARN_ON_ONCE(target->connected);
> @@ -945,19 +944,10 @@ static int srp_connect_target(struct srp_target_port *target)
>                         break;
>
>                 case SRP_STALE_CONN:
> -                       /* Our current CM id was stale, and is now in timewait.
> -                        * Try to reconnect with a new one.
> -                        */
> -                       if (!retries-- || srp_new_cm_id(target)) {
> -                               shost_printk(KERN_ERR, target->scsi_host, PFX
> -                                            "giving up on stale connection\n");
> -                               target->status = -ECONNRESET;
> -                               return target->status;
> -                       }
> -
>                         shost_printk(KERN_ERR, target->scsi_host, PFX
> -                                    "retrying stale connection\n");
> -                       break;
> +                                    "giving up on stale connection\n");
> +                       target->status = -ECONNRESET;
> +                       return target->status;
>
>                 default:
>                         return target->status;
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
