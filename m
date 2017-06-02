From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH RESEND] Eliminate extra 'out_free' label from fcoe_init
 function
Date: Fri, 2 Jun 2017 18:06:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706021806010.19640@hadrien>
References: <8e1e75c4-3a80-00c3-2697-37fb1c86f7a1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:25390
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750955AbdFBQGw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 12:06:52 -0400
In-Reply-To: <8e1e75c4-3a80-00c3-2697-37fb1c86f7a1@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



On Fri, 2 Jun 2017, Milan P. Gandhi wrote:

> Simplify the check for return code of fcoe_if_init routine
> in fcoe_init function such that we could eliminate need for
> extra 'out_free' label and duplicate mutex_unlock statement.
>
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index ea21e7b..a2cf3d0 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -2523,14 +2523,13 @@ static int __init fcoe_init(void)
>  	fcoe_dev_setup();
>
>  	rc = fcoe_if_init();
> +	mutex_unlock(&fcoe_config_mutex);
> +
>  	if (rc)
> -		goto out_free;
> +		goto out_destroy;
>
> -	mutex_unlock(&fcoe_config_mutex);

That's what I was thinking of, but it's not a RESEND, but rather a v2.
You need to explain under the --- what is the change since the original
submission.

julia

>  	return 0;
>
> -out_free:
> -	mutex_unlock(&fcoe_config_mutex);
>  out_destroy:
>  	destroy_workqueue(fcoe_wq);
>  	return rc;
>
