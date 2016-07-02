From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCH] mvsas:Fix possible NULL pointer deference in mvs_dev_found_notify
Date: Sat, 02 Jul 2016 12:16:24 +0100
Message-ID: <5777A288.90608@osg.samsung.com>
References: <1467395018-12365-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45430
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcGBLdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2016 07:33:24 -0400
In-Reply-To: <1467395018-12365-1-git-send-email-xerofoify@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>, jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, jthumshirn@suse.de, tj@kernel.org, James.Bottomley@HansenPartnership.com, Wilfried.Weissmann@gmx.at, davispuh@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 01/07/16 18:43, Nicholas Krause wrote:
> This adds properly checking after the call to mvs_find_dev_mvi
> due to this function being able to return a NULL pointer and if
> this does arise we will deference it in mvs_alloc_dev due to
> this function never checking if a NULL pointer is given as
> it's input argument.
> v2 - Fix NULL pointer deferenece in error path by calling
> spin_unlock_irqrestore on the now NULL pointer, as returned
> by mvs_find_dev_mvi.

Hi Nicholas,

You mention v2 here but this is [PATCH] and not [PATCH v2]. Is this
the first version of the patch or second?

> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---

If the "v2 -" comments are part of the review and not of the git commit
message it is better to place it here. Between the "---" and the diff.

This is because when the maintainer applies the patch this section will
be truncated, and it won't show in the git log.

>  drivers/scsi/mvsas/mv_sas.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 83cd3ea..74f3954 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1191,6 +1191,10 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
>  	struct mvs_device *mvi_device;
>  
>  	mvi = mvs_find_dev_mvi(dev);
> +	if (!mvi) {
> +		res = -1;
> +		goto found_null;
> +	}
>  
>  	if (lock)
>  		spin_lock_irqsave(&mvi->lock, flags);
> @@ -1230,6 +1234,7 @@ int mvs_dev_found_notify(struct domain_device *dev, int lock)
>  found_out:
>  	if (lock)
>  		spin_unlock_irqrestore(&mvi->lock, flags);
> +found_null:
>  	return res;
>  }
>  
> 

If the goto is just going to return, why not do a return directly instead?

if (!mvi)
    return -1;

Thanks for the patch,
Luis
