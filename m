From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH] scsi: cxlflash: Fix an error handling path in
 'cxlflash_disk_attach()'
Date: Wed, 16 Aug 2017 15:32:19 +1000
Message-ID: <0b3495e0-dd8d-3269-39fe-9f29d751f74b@au1.ibm.com>
References: <20170815201835.781F76A041@b03ledav003.gho.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170815201835.781F76A041@b03ledav003.gho.boulder.ibm.com>
Content-Language: en-AU
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, manoj@linux.vnet.ibm.com, mrochs@linux.vnet.ibm.com, ukrishn@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16/08/17 06:18, Christophe JAILLET wrote:
> 'rc' is known to be 0 at this point.
> If 'create_context()' fails, returns -ENOMEM instead of 0 which means
> success.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

ENOMEM seems right here.

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

> ---
>   drivers/scsi/cxlflash/superpipe.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
> index ad0f9968ccfb..08da593cb2f6 100644
> --- a/drivers/scsi/cxlflash/superpipe.c
> +++ b/drivers/scsi/cxlflash/superpipe.c
> @@ -1390,6 +1390,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
>   	if (unlikely(!ctxi)) {
>   		dev_err(dev, "%s: Failed to create context ctxid=%d\n",
>   			__func__, ctxid);
> +		rc = -ENOMEM;
>   		goto err;
>   	}
>   
> 

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
