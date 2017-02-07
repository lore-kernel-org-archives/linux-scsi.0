From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: rcode is unsigned, so can never be less
 than zero
Date: Tue, 7 Feb 2017 14:37:17 +0300
Message-ID: <20170207113717.GB11154@mwanda>
References: <20170207112738.18486-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170207112738.18486-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 07, 2017 at 11:27:38AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check on rcode >= 0 is always true because rcode is unsigned
> and can never be less than zero.  Remove the redundant check.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/aacraid/aachba.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 3b5ddf4..ddfd726 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1848,7 +1848,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
>  			FsaNormal, 1, 1, NULL, NULL);
>  
>  	/* analyse data */
> -	if (rcode >= 0 && phys_luns->resp_flag == 2) {

The original code is buggy.  rcode should be an int.

regards,
dan carpenter

