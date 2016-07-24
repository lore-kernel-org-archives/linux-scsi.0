From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: Delete an unnecessary check before the function
 call "kfree"
Date: Sun, 24 Jul 2016 08:51:11 -0400 (EDT)
Message-ID: <2031535968.6447913.1469364671549.JavaMail.zimbra@redhat.com>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <dd65c1cd-b8ee-5c44-d249-e3d9d0b08299@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <dd65c1cd-b8ee-5c44-d249-e3d9d0b08299@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "SF Markus Elfring" <elfring@users.sourceforge.net>
> To: linux-scsi@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>, "Hannes Reinecke" <hare@suse.de>, "James E. J.
> Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, "Julia Lawall" <julia.lawall@lip6.fr>
> Sent: Sunday, July 24, 2016 8:30:35 AM
> Subject: [PATCH] scsi: Delete an unnecessary check before the function call "kfree"
> 
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 24 Jul 2016 14:20:21 +0200
> 
> The kfree() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/scsi/scsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1f36aca..1794c0c 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -864,8 +864,7 @@ retry_pg83:
>  		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
>  		mutex_unlock(&sdev->inquiry_mutex);
>  		synchronize_rcu();
> -		if (orig_vpd_buf)
> -			kfree(orig_vpd_buf);
> +		kfree(orig_vpd_buf);
>  	}
>  }
>  
> --
> 2.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks fine, small comment is that the function call prior to check in the fucntion sets up variables etc. 
So is more expensive than a simple NULL check prior.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
