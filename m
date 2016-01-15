From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 07:46:14 -0800
Message-ID: <1452872774.2356.5.camel@HansenPartnership.com>
References: <20160114214602.GC3520@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56912 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbcAOPqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 10:46:16 -0500
In-Reply-To: <20160114214602.GC3520@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

On Thu, 2016-01-14 at 16:46 -0500, Tejun Heo wrote:
> SCSI command completion path bumps ioerr_cnt whenever scsi_cmd
> ->result isn't zero; unfortunately, this means that non-error sense 
> reporting bumps the counter too.  This is pronounced with ATA 
> passthrough commands because most of them explicitly request the 
> resulting taskfile to be transported via sense data bumping the count
> unconditionally.
> 
> Don't bump the counter if scsi_cmd->result simply indicates that 
> sense data is available.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Dave Jones <dsj@fb.com>
> ---
>  drivers/scsi/scsi_lib.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index fa6b2c4..e90e3f7 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1622,7 +1622,8 @@ static void scsi_softirq_done(struct request
> *rq)
>  	INIT_LIST_HEAD(&cmd->eh_entry);
>  
>  	atomic_inc(&cmd->device->iodone_cnt);
> -	if (cmd->result)
> +	if (cmd->result &&
> +	    cmd->result != ((DRIVER_SENSE << 24) |
> SAM_STAT_CHECK_CONDITION))
>  		atomic_inc(&cmd->device->ioerr_cnt);

OK, it makes sense to me that we don't include non-error check
conditions.  However, then you shouldn't be checking DRIVER_SENSE.  We
still have a few drivers that rely on the error handler to fetch sense
explicitly ... they could eventually return non-error conditions as
well.

James

