From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi: pmcraid: Add missing resource releases
Date: Tue, 22 Nov 2016 17:14:46 +0100
Message-ID: <4a93981a-4d1e-206c-5ac6-cae486163760@redhat.com>
References: <20161119174318.20394-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161119174318.20394-1-lambert.quentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 19.11.2016 18:43, Quentin Lambert wrote:
> Most error branches following the call to pmcraid_get_free_cmd contain
> a call to pmcraid_return_cmd. This patch add these calls where they are
> missing.
>
> Moreover, most error branches following the call to class_create contain
> a call to class_destroy. This patch add these calls where they are
> missing.
>
> This issue was found with Hector.
>
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

Looks good,
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Tomas

>
> ---
>  drivers/scsi/pmcraid.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -3787,11 +3787,11 @@ static long pmcraid_ioctl_passthrough(
>  						      direction);
>  		if (rc) {
>  			pmcraid_err("couldn't build passthrough ioadls\n");
> -			goto out_free_buffer;
> +			goto out_free_cmd;
>  		}
>  	} else if (request_size < 0) {
>  		rc = -EINVAL;
> -		goto out_free_buffer;
> +		goto out_free_cmd;
>  	}
>  
>  	/* If data is being written into the device, copy the data from user
> @@ -3908,6 +3908,8 @@ out_handle_response:
>  
>  out_free_sglist:
>  	pmcraid_release_passthrough_ioadls(cmd, request_size, direction);
> +
> +out_free_cmd:
>  	pmcraid_return_cmd(cmd);
>  
>  out_free_buffer:
> @@ -6018,8 +6020,10 @@ static int __init pmcraid_init(void)
>  
>  	error = pmcraid_netlink_init();
>  
> -	if (error)
> +	if (error) {
> +		class_destroy(pmcraid_class);
>  		goto out_unreg_chrdev;
> +	}
>  
>  	error = pci_register_driver(&pmcraid_driver);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
