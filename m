From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [scsi] scsi: ufshcd-platform: remove the useless cast in
 ERR_PTR/IS_ERR
Date: Wed, 15 Mar 2017 16:01:02 -0700
Message-ID: <430490a06bb568794c5ef3fe84474d82@codeaurora.org>
References: <20170314121936.1360-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170314121936.1360-1-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-03-14 05:19, Tomas Winkler wrote:
> IS_ERR and ERR_PTR already forcefully cast their argument,
> hence there is no need for additional (complex) casting.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c 
> b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index a72a4ba78125..8e5e6c04c035 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -309,8 +309,8 @@ int ufshcd_pltfrm_init(struct platform_device 
> *pdev,
> 
>  	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	mmio_base = devm_ioremap_resource(dev, mem_res);
> -	if (IS_ERR(*(void **)&mmio_base)) {
> -		err = PTR_ERR(*(void **)&mmio_base);
> +	if (IS_ERR(mmio_base)) {
> +		err = PTR_ERR(mmio_base);
>  		goto out;
>  	}

LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
