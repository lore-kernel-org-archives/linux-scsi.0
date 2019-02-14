From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: remove redundant null check on pointer
 sess
Date: Thu, 14 Feb 2019 08:54:57 +0300
Message-ID: <20190214055457.GA2326@kadam>
References: <20190213135335.4790-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190213135335.4790-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 13, 2019 at 01:53:35PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The null check on pointer sess and the subsequent call is redundant
> as sess is null on all the the paths that lead to the out_term2 label.
> Hence the null check and the call can be removed.
> 
> Detected by CoverityScan, CID#1420663 ("Logically dead code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 6b8c655d9eb4..9af329a5ed90 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -6396,8 +6396,6 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
>  	return;
>  
>  out_term2:
> -	if (sess)
> -		ha->tgt.tgt_ops->put_sess(sess);

Several places do:

		sess = NULL;
		goto out_term2;

We could remove the "sess = NULL;" because it's not required now.

>  	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
>  out_term:
>  	qlt_send_term_exchange(ha->base_qpair, NULL, &prm->tm_iocb2, 1, 0);

regards,
dan carpenter
