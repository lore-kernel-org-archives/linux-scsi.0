From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: snic: remove redundant assignment to variable ret
Date: Tue, 6 Aug 2019 16:17:21 +0300
Message-ID: <20190806131721.GI1974@kadam>
References: <20190731224950.16818-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190731224950.16818-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 31, 2019 at 11:49:50PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable ret is being assigned with a value that is never read as
> there is return statement immediately afterwards.  The assignment
> is redundant and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/snic/snic_disc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
> index e9ccfb97773f..d89c75991323 100644
> --- a/drivers/scsi/snic/snic_disc.c
> +++ b/drivers/scsi/snic/snic_disc.c
> @@ -261,8 +261,6 @@ snic_tgt_create(struct snic *snic, struct snic_tgt_id *tgtid)
>  	tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
>  	if (!tgt) {
>  		SNIC_HOST_ERR(snic->shost, "Failure to allocate snic_tgt.\n");
> -		ret = -ENOMEM;
> -
>  		return tgt;

Not related to this patch, but it would be nicer to return NULL instead
of tgt.  It's the same but the literal is nicer.  No need for the error
message after a kmalloc failure either.

	tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
	if (!tgt)
		return NULL;

regards,
dan carpenter
