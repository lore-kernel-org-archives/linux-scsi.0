From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH for-3.15] scsi/libiscsi: Fix static checker warning on
 bh locking
Date: Mon, 31 Mar 2014 01:59:39 -0500
Message-ID: <5339125B.6020405@cs.wisc.edu>
References: <1396182389-4910-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56373 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaCaG7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:59:49 -0400
In-Reply-To: <1396182389-4910-1-git-send-email-ogerlitz@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Shlomo Pongratz <shlomop@mellanox.com>

On 03/30/2014 07:26 AM, Or Gerlitz wrote:
> From: Shlomo Pongratz <shlomop@mellanox.com>
> 
> Commit 659743b "[SCSI] libiscsi: Reduce locking contention in fast path" introduced a
> new smatch warning on libiscsi.c "iscsi_xmit_task() warn: inconsistent returns
> bottom_half:: locked (1410 [(-61)]) unlocked (1425 [0], 1425 [s32min-(-1),1-s32max])",
> which we can eliminate by using non bh locking on the nested spin_lock call.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
> 
>  drivers/scsi/libiscsi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 5b8605c..5087957 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1411,9 +1411,9 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
>  		conn->task = NULL;
>  	}
>  	/* regular RX path uses back_lock */
> -	spin_lock_bh(&conn->session->back_lock);
> +	spin_lock(&conn->session->back_lock);
>  	__iscsi_put_task(task);
> -	spin_unlock_bh(&conn->session->back_lock);
> +	spin_unlock(&conn->session->back_lock);
>  	return rc;

Thanks for cleaning this up Or and Shlomo.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

