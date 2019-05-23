From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH][next] scsi: hpsa: fix an uninitialized read and
 dereference of pointer dev
Date: Thu, 23 May 2019 08:35:48 -0700
Message-ID: <20190523153548.GA112363@archlinux-epyc>
References: <20190522083903.18849-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522083903.18849-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2019 at 09:39:03AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the check for a lockup_detected failure exits via the
> label return_reset_status that reads and dereferences an uninitialized
> pointer dev.  Fix this by ensuring dev is inintialized to null.
> 
> Addresses-Coverity: ("Uninitialized pointer read")
> Fixes: 14991a5bade5 ("scsi: hpsa: correct device resets")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

Clang similarly warns about this, hence my identical submission after
this, sorry for the noise.

> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c560a4532733..ac8338b0571b 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5947,7 +5947,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
>  	int rc = SUCCESS;
>  	int i;
>  	struct ctlr_info *h;
> -	struct hpsa_scsi_dev_t *dev;
> +	struct hpsa_scsi_dev_t *dev = NULL;
>  	u8 reset_type;
>  	char msg[48];
>  	unsigned long flags;
> -- 
> 2.20.1
> 
