From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: silence a static checker warning
Date: Fri, 23 Jun 2017 16:25:27 +0100
Message-ID: <a72ab14c-e1ab-1cb1-1477-7d9d14d92f05@huawei.com>
References: <20170623151544.57jlfbl5apofl6hj@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170623151544.57jlfbl5apofl6hj@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 23/06/2017 16:15, Dan Carpenter wrote:
> phy->phy_type is a u64.  We only ever use the first two bits so it's a
> bit over kill perhaps.

Hi Dan,

Right, u64 is unneeded and u32 would suffice, so I think that would be a 
more appropriate fix. And if we change hisi_sas_phy.phy_type to u32, I 
would want to reorder this structure to improve packing efficiency.

I can make this change unless you really want to...

Thanks,
John

Anyway, let's declare the flags as ULL as well
> because that lets us do things like "phy->phy_type &= ~PORT_TYPE_SAS;".
> In the current code, static checkers complain that that would
> unintentionally clear the high 32 bits as well.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 4fc23087a939..b23245aeab74 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -56,8 +56,8 @@
>  struct hisi_hba;
>
>  enum {
> -	PORT_TYPE_SAS = (1U << 1),
> -	PORT_TYPE_SATA = (1U << 0),
> +	PORT_TYPE_SAS = (1ULL << 1),
> +	PORT_TYPE_SATA = (1ULL << 0),
>  };
>
>  enum dev_status {
>
> .
>


