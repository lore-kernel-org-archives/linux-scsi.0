From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/6] scsi-mq: init sg in scsi_init_io.
Date: Sun, 22 Dec 2013 22:43:10 -0800
Message-ID: <1387780990.5567.145.camel@haakon3.risingtidesystems.com>
References: <201311291642081351818@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38645 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3LWGmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 01:42:03 -0500
In-Reply-To: <201311291642081351818@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-11-29 at 16:42 +0800, majianpeng wrote:
> Make scsi-mq support blk-pc-command.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/scsi/scsi_lib.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index bed596e..679e840 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1059,9 +1059,11 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  	/*
>  	 * Use pre-allocation of cmd->sdb scatterlists with scsi-mq..
>  	 */
> -//FIXME: scsi-mq dif descriptor init within scsi_init_io
>  	if (rq->mq_ctx) {
>  		BUG_ON(rq->nr_phys_segments > SCSI_MAX_SG_SEGMENTS);
> +		cmd->sdb.table.sgl = cmd->mq_sgl;
> +		cmd->sdb.table.nents = rq->nr_phys_segments;
> +		sg_init_table(cmd->sdb.table.sgl, rq->nr_phys_segments);
>  		scsi_init_sgtable(rq, &cmd->sdb);
>  		return BLKPREP_OK;
>  	}

Doesn't seem to be necessary for TYPE_ROM either..?

So requests of REQ_TYPE_BLOCK_PC for TYPE_ROM with scsi-mq are having
their sc->sdb.table setup from pre-allocated SGLs at the start of
scsi_mq_queue_rq(), before q->prep_rq_fn() -> sr_prep_fn() ->
scsi_setup_blk_pc_cmnd() is called.

--nab

