From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Avoid crashing if device uses DIX but adapter
 does not support it
Date: Thu, 15 Jan 2015 08:32:02 -0500
Message-ID: <1421328722.3891.206.camel@localhost.localdomain>
References: <1421270017-14103-1-git-send-email-emilne@redhat.com>
	 <yq1fvbcvo2i.fsf@sermon.lab.mkp.net>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbbAONcG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2015 08:32:06 -0500
In-Reply-To: <yq1fvbcvo2i.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2015-01-14 at 20:18 -0500, Martin K. Petersen wrote:
> >>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:
> 
> Ewan> This can happen if a multipathed device uses DIX and another path
> Ewan> is added via an adapter that does not support it.  Multipath
> Ewan> should not allow this path to be added,
> 
> No it shouldn't :)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6d5c0b8..4f14f4a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1143,7 +1143,17 @@ int scsi_init_io(struct scsi_cmnd *cmd)
>  		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
>  		int ivecs, count;
>  
> -		BUG_ON(prot_sdb == NULL);
> +		if (prot_sdb == NULL) {
> +			/*
> +			 * This can happen if someone (e.g. multipath)
> +			 * queues a command to a device on an adapter
> +			 * that does not support T10 PI.
> 
> s/T10 PI/DIX/

Good point.  I'll submit a v2 to change the comment.

> 
> +			 */
> +			WARN_ON_ONCE(1);
> +			error = BLKPREP_KILL;
> +			goto err_exit;
> +		}
> +
>  		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
>  
>  		if (scsi_alloc_sgtable(prot_sdb, ivecs, is_mq)) {
> 
> Failing more gracefully is OK with me.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> 


