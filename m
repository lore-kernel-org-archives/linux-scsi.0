From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 02/11] qla2xxx: Cleanup TMF code translation from
 qla_target.
Date: Wed, 11 Jan 2017 13:08:14 -0800
Message-ID: <c749caca-08f2-4f47-f021-ce8cc5ec9c8f@sandisk.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-3-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/23/2016 08:23 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Move code code which converts Task Mgmt Command flags for
> ATIO to TCM #defines, from qla2xxx driver to tcm_qla2xxx
> driver.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  | 75 ++++----------------------------------
>  drivers/scsi/qla2xxx/qla_target.h  |  6 ++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 39 +++++++++++++++++++-
>  3 files changed, 49 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 47acc26..6e58848 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1592,8 +1592,9 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
>  	mcmd->sess = sess;
>  	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
>  	mcmd->reset_count = vha->hw->chip_reset;
> +	mcmd->tmr_func = QLA_TGT_ABTS;
>  
> -	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
> +	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
>  	    abts->exchange_addr_to_abort);

Does this change remove the last user of the 'lun' variable from this
function? If so, please remove that variable entirely.

Thanks,

Bart.
