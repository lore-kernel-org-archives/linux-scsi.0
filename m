From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: Add a missing call to kfree
Date: Mon, 21 Nov 2016 12:53:43 +0000
Message-ID: <e1e060ba-a231-b4f3-4a41-f9fac9ca2d54@huawei.com>
References: <20161119174259.20344-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161119174259.20344-1-lambert.quentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 19/11/2016 17:42, Quentin Lambert wrote:
> Most error branches following the call to hisi_sas_shost_alloc contain
> a call to kfree. This patch add these calls where they are
> missing.
>
> This issue was found with Hector.

I think that this patch is fine. However I have noticed that we should 
do a call to hisi_sas_free() for this failure, and later failures in the 
probe.

I can generate a patch for this.

Cheers,
John

>
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_main.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1503,8 +1503,10 @@ int hisi_sas_probe(struct platform_devic
>
>  	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
>  	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
> -	if (!arr_phy || !arr_port)
> -		return -ENOMEM;
> +	if (!arr_phy || !arr_port) {
> +		rc = -ENOMEM;
> +		goto err_out_ha;
> +	}
>
>  	sha->sas_phy = arr_phy;
>  	sha->sas_port = arr_port;
>
> .
>
