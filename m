From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI host ID assigment overoptimization removal in 2.4.18
Date: Thu, 18 Jul 2002 15:45:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D371ACA.2065E434@splentec.com>
References: <20020718152242.B4026@j4.msk.systemsix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g6IJjBs22704
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jul 2002 15:45:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Vladislav Bolkhovitine wrote:
> 
> There is an overoptimization in SCSI host ID assigment algorithm in 2.4.18
> and possibly others, which lead to appearance of SCSI hosts with the same IDs.
> 
> Simple scenario:
> 1. Add one adapter, host_id=0
> 2. Remove it
> 3. Add another adapter, its host_id=0
> 4. Add the adapter 1 again, it reuses its original scsi_host_no_list entry
>         and gets host_id=0 as well. Oops.
> 
> When the adapter was being unregistered on step 2, max_scsi_hosts gets
> decremented to 0. During registration of the new host, it received
> host_id=max_scsi_hosts. On the step 4, the old entry in scsi_host_no_list
> was found and reused, thus we have two hosts with the same host_id 0.
> 
> So, it is impossible to use simultaneously scsi_host_no_list and host IDs
> reusing (i.e. max_scsi_hosts decrementing). I chose to remove the last one.
> Here is the patch against 2.4.18.
> 
> I was not able to find who is the maintainer of SCSI subsistem at the moment.
> Who is doing so, please consider the idea of this patch to include in the
> mainstream kernel.


Yep, I concur -- this patch works.

I've wanted a patch for this for sometime and brought this same
issue on 02/05/29, but was too busy with my own project to unscramble
the infamous SCSI host registration.

AFAIK, Doug is working on this now and it will be a whole different
and better story for latter 2.5/6 (struct list_head, etc.).

Anyways, this works for 2.4 and I'd be happy to see it in.

Thanks,
-- 
Luben
 
> Vlad
> 
> diff -urdN linux-2.4.18.orig/drivers/scsi/hosts.c linux-2.4.18.host_fix/drivers/scsi/hosts.c
> --- linux-2.4.18.orig/drivers/scsi/hosts.c      Mon Feb 25 22:38:04 2002
> +++ linux-2.4.18.host_fix/drivers/scsi/hosts.c  Wed Jul 17 17:08:47 2002
> @@ -107,6 +107,17 @@
>      if (shn) shn->host_registered = 0;
>      /* else {} : This should not happen, we should panic here... */
> 
> +    /*
> +     * With this algorithm together with scsi_host_no_list entry reusage
> +     * from scsi_register() it is possible really easy to get two
> +     * hosts with the same host_id. Simple scenario:
> +     *  - add one adapter, host_id=0
> +     *  - remove it
> +     *  - add another adapter, its host_id=0
> +     *  - add the adapter 1 again, it reuses its scsi_host_no_list entry
> +     *     and gets host_id=0 as well. Oops.
> +     */
> +#if 0
>      /* If we are removing the last host registered, it is safe to reuse
>       * its host number (this avoids "holes" at boot time) (DB)
>       * It is also safe to reuse those of numbers directly below which have
> @@ -121,6 +132,7 @@
>                 break;
>         }
>      }
> +#endif
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
