From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] qla2xxx: Fix invalid handle erroneous message.
Date: Tue, 20 Dec 2016 06:15:08 -0800
Message-ID: <20161220141508.GI16487@infradead.org>
References: <1482208424-12358-1-git-send-email-himanshu.madhani@cavium.com>
 <1482208424-12358-10-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38425 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933901AbcLTOPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2016 09:15:09 -0500
Content-Disposition: inline
In-Reply-To: <1482208424-12358-10-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Mon, Dec 19, 2016 at 08:33:43PM -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Termination of Immediate Notify IOCB was using wrong
> IOCB handle. IOCB completion code was unable to find
> appropriate code path due to wrong handle.
> 
> Following message is seen in the logs.
> 
> "Error entry - invalid handle/queue (ffff)."
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_isr.c    | 4 ++++
>  drivers/scsi/qla2xxx/qla_target.c | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index af840bf..16bc948 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2495,6 +2495,10 @@ struct scsi_dif_tuple {
>  	if (pkt->entry_status & RF_BUSY)
>  		res = DID_BUS_BUSY << 16;
>  
> +	if ((pkt->entry_type == NOTIFY_ACK_TYPE) &&
> +	    (pkt->handle == QLA_TGT_SKIP_HANDLE))
> +		return;

No need for the inner braces.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
