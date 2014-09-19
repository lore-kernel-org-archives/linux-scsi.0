From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 5/8] IB/srp: Remove stale connection retry mechanism
Date: Fri, 19 Sep 2014 21:25:01 +0300
Message-ID: <CAF9gx6JDwu0sGmfOu0Znn34frD5NCr19wp=5WAEchmaG9Ov1Wg@mail.gmail.com>
References: <541C27BF.6070609@acm.org>
	<541C287D.1050900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:63451 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaISSZE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 14:25:04 -0400
Received: by mail-la0-f48.google.com with SMTP id ty20so3603577lab.7
        for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2014 11:25:02 -0700 (PDT)
In-Reply-To: <541C287D.1050900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

On 9/19/2014 3:58 PM, Bart Van Assche wrote:
> Attempting to connect three times may be insufficient after an
> initiator system that was using multiple RDMA channels tries to
> relogin. Additionally, this login retry mechanism is a workaround
> for particular behavior of the IB/CM. Since the srp_daemon retries
> a failed login attempt anyway, remove the stale connection retry
> mechanism.
>

I agree, this work-around doesn't even always work for some targets. In
case the RDMA stack restarted while IB ports were down and srp initiator
didn't manage to teardown the connections, some targets are keeping
cm_ids online returning "stale connection" rejects longer then expected.

let user-space retry from scratch...

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 16 +++-------------
>   1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index d3c712f..9608e7a 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -904,7 +904,6 @@ static void srp_rport_delete(struct srp_rport *rport)
>
>   static int srp_connect_target(struct srp_target_port *target)
>   {
> - int retries = 3;
>   int ret;
>
>   WARN_ON_ONCE(target->connected);
> @@ -945,19 +944,10 @@ static int srp_connect_target(struct srp_target_port *target)
>   break;
>
>   case SRP_STALE_CONN:
> - /* Our current CM id was stale, and is now in timewait.
> - * Try to reconnect with a new one.
> - */
> - if (!retries-- || srp_new_cm_id(target)) {
> - shost_printk(KERN_ERR, target->scsi_host, PFX
> -     "giving up on stale connection\n");
> - target->status = -ECONNRESET;
> - return target->status;
> - }
> -
>   shost_printk(KERN_ERR, target->scsi_host, PFX
> -     "retrying stale connection\n");
> - break;
> +     "giving up on stale connection\n");
> + target->status = -ECONNRESET;
> + return target->status;
>
>   default:
>   return target->status;
>
