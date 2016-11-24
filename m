From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen-scsifront: Add a missing call to kfree
Date: Thu, 24 Nov 2016 09:24:52 +0100
Message-ID: <55b7d62c-a500-4121-8324-132f2621a04a@suse.com>
References: <20161119182256.9081-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161119182256.9081-1-lambert.quentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 19/11/16 19:22, Quentin Lambert wrote:
> Most error branches following the call to kmalloc contain
> a call to kfree. This patch add these calls where they are
> missing.
> 
> This issue was found with Hector.
> 
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

Applied to xen/tip.git for-linus-4.10


Juergen

> 
> ---
>  drivers/scsi/xen-scsifront.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/scsi/xen-scsifront.c
> +++ b/drivers/scsi/xen-scsifront.c
> @@ -627,6 +627,7 @@ static int scsifront_action_handler(stru
>  
>  	if (scsifront_enter(info)) {
>  		spin_unlock_irq(host->host_lock);
> +		kfree(shadow);
>  		return FAILED;
>  	}
>  
> 
> 
