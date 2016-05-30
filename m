From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_debug: fix sleep in invalid context
Date: Mon, 30 May 2016 12:02:45 -0700
Message-ID: <1464634965.2287.73.camel@HansenPartnership.com>
References: <1464632347-8621-1-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44172 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161886AbcE3TCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2016 15:02:50 -0400
In-Reply-To: <1464632347-8621-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, bart.vanassche@sandisk.com

On Mon, 2016-05-30 at 14:19 -0400, Douglas Gilbert wrote:
> In this post: http://www.spinics.net/lists/linux-scsi/msg97124.html
> the author shows some kernel infrastructure complaining about a
> sleep in an invalid context. For calls to fetch memory when
> processing SCSI commands, reviewers often propose non GFP_ATOMIC
> variants; reality dictates otherwise. Fix memory allocation for
> response to REPORT LUNS command.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 0f9ba41..b85c5dc 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3331,13 +3331,12 @@ static int resp_report_luns(struct scsi_cmnd
> *scp,
>  	tlun_cnt = lun_cnt + wlun_cnt;
>  
>  	rlen = (tlun_cnt * sizeof(struct scsi_lun)) + 8;
> -	arr = vmalloc(rlen);
> +	arr = kzalloc(rlen, GFP_ATOMIC);
>  	if (!arr) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST,
> INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
>  		return check_condition_result;
>  	}
> -	memset(arr, 0, rlen);
>  	pr_debug("select_report %d luns = %d wluns = %d no_lun0
> %d\n",
>  		 select_report, lun_cnt, wlun_cnt, sdebug_no_lun_0);
>  
> @@ -3355,7 +3354,7 @@ static int resp_report_luns(struct scsi_cmnd
> *scp,
>  	put_unaligned_be32(rlen - 8, &arr[0]);
>  
>  	res = fill_from_dev_buffer(scp, arr, rlen);
> -	vfree(arr);
> +	kfree(arr);

This might fix the immediate warning, but won't it demand huge
contiguous memory chunks in high lun configurations and thus fail
randomly?  Report luns is important to us because if that fails the
target won't attach.

What about vmalloc'ing enough space at configuration time, when you do
have process context, and simply reusing the already allocated buffer
in this routine?  If you want to be clever, you could do a single
vmalloc for the biggest LUN size you have and reuse that buffer for
every report lun command with suitable locking ... we tend to fire off
report luns sequentially at start of day, so it's not like they have
huge performance or concurrency requirements.

James

