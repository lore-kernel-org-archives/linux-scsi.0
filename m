From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] tgt: Wrong comment and redundant code in scsi_map_user_pages
Date: Thu, 21 May 2009 15:49:06 +0300
Message-ID: <4A154DC2.3020803@panasas.com>
References: <4A0C3F05.5030308@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:3319 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750880AbZEUMtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 08:49:14 -0400
In-Reply-To: <4A0C3F05.5030308@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/14/2009 06:55 PM, Boaz Harrosh wrote:
> scsi_init_io() fully prepares the command properly. scsi_tgt_lib need
> not assign scsi_cmnd members any more.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/scsi_tgt_lib.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
> index 1030327..ef11b4d 100644
> --- a/drivers/scsi/scsi_tgt_lib.c
> +++ b/drivers/scsi/scsi_tgt_lib.c
> @@ -383,11 +383,6 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
>  		scsi_release_buffers(cmd);
>  		goto unmap_rq;
>  	}
> -	/*
> -	 * we use REQ_TYPE_BLOCK_PC so scsi_init_io doesn't set the
> -	 * length for us.
> -	 */
> -	cmd->sdb.length = blk_rq_bytes(rq);
>  
>  	return 0;
>  

Dear TOMO
Ping?

James I forgot to say this should be for post-merge tree as the use
of blk_rq_bytes(rq) was done by Tejun. (Given Tomo's Ack of course)

Thanks
Boaz
