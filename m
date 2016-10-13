From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH] scsi: hpsa: remove unneeded void pointer cast
Date: Thu, 13 Oct 2016 15:45:00 -0500
Message-ID: <f1733716-eb19-b623-69bf-5dca1d9f5b57@microsemi.com>
References: <1476375008-10034-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476375008-10034-1-git-send-email-javier@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: iss_storagedev@hp.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, esc.storagedev@microsemi.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/13/2016 11:10 AM, Javier Martinez Canillas wrote:
> It's not necessary to cast the result of kmalloc, since void pointers are
> promoted to any other type. This also fixes following coccinelle warning:
>
> casting value returned by memory allocation function to (BIG_IOCTL_Command_struct *) is useless.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>
>   drivers/scsi/hpsa.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index d007ec18179a..4e82b692298e 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6657,8 +6657,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
>   		return -EINVAL;
>   	if (!capable(CAP_SYS_RAWIO))
>   		return -EPERM;
> -	ioc = (BIG_IOCTL_Command_struct *)
> -	    kmalloc(sizeof(*ioc), GFP_KERNEL);
> +	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
>   	if (!ioc) {
>   		status = -ENOMEM;
>   		goto cleanup1;
Acked-by: Don Brace <don.brace@microsemi.com>
