From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] osst: wrong index used in inner loop
Date: Mon, 21 Mar 2011 10:02:59 +0900
Message-ID: <20110321100300P.fujita.tomonori@lab.ntt.co.jp>
References: <4D8509D1.6080107@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33071 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab1CUBDw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2011 21:03:52 -0400
In-Reply-To: <4D8509D1.6080107@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roel.kluin@gmail.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011 20:53:53 +0100
roel <roel.kluin@gmail.com> wrote:

> Index i was already used in the outer loop.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/scsi/osst.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> I'm not sure if this is the right fix, maybe a break or return
> is missing?

What are you trying to fix with this patch?


> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index 521e218..d6d6d89 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -4702,8 +4702,9 @@ static int __os_scsi_tape_open(struct inode * inode, struct file * filp)
>  				STp->partition = STp->new_partition = 0;
>  				if (STp->can_partitions)
>  					STp->nbr_partitions = 1;  /* This guess will be updated later if necessary */
> -				for (i=0; i < ST_NBR_PARTITIONS; i++) {
> -					STps = &(STp->ps[i]);
> +				int j;
> +				for (j=0; j < ST_NBR_PARTITIONS; j++) {
> +					STps = &(STp->ps[j]);
>  					STps->rw = ST_IDLE;
>  					STps->eof = ST_NOEOF;
>  					STps->at_sm = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
