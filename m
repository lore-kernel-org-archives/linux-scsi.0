From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: ibmvscsi: Don't use rc uninitialized in
 ibmvscsi_do_work
Date: Sun, 2 Jun 2019 20:23:44 -0700
Message-ID: <20190603032344.GA26021@archlinux-epyc>
References: <20190531185306.41290-1-natechancellor@gmail.com>
 <87blzgnvhx.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87blzgnvhx.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, clang-built-linux@googlegroups.com, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Michael,

On Sun, Jun 02, 2019 at 08:15:38PM +1000, Michael Ellerman wrote:
> Hi Nathan,
> 
> It's always preferable IMHO to keep any initialisation as localised as
> possible, so that the compiler can continue to warn about uninitialised
> usages elsewhere. In this case that would mean doing the rc = 0 in the
> switch, something like:

I am certainly okay with implementing this in a v2. I mulled over which
would be preferred, I suppose I guessed wrong :) Thank you for the
review and input.

> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 727c31dc11a0..7ee5755cf636 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -2123,9 +2123,6 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
>  
>         spin_lock_irqsave(hostdata->host->host_lock, flags);
>         switch (hostdata->action) {
> -       case IBMVSCSI_HOST_ACTION_NONE:
> -       case IBMVSCSI_HOST_ACTION_UNBLOCK:
> -               break;
>         case IBMVSCSI_HOST_ACTION_RESET:
>                 spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>                 rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
> @@ -2142,7 +2139,10 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
>                 if (!rc)
>                         rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
>                 break;
> +       case IBMVSCSI_HOST_ACTION_NONE:
> +       case IBMVSCSI_HOST_ACTION_UNBLOCK:
>         default:
> +               rc = 0;
>                 break;
>         }
> 
> 
> But then that makes me wonder if that's actually correct?
> 
> If we get an action that we don't recognise should we just throw it away
> like that? (by doing hostdata->action = IBMVSCSI_HOST_ACTION_NONE). Tyrel?

However, because of this, I will hold off on v2 until Tyrel can give
some feedback.

Thanks,
Nathan
