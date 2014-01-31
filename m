From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Remove last vestiges of qla_tgt_cmd.cmd_list
Date: Fri, 31 Jan 2014 14:53:19 -0800
Message-ID: <1391208799.9826.6.camel@haakon3.risingtidesystems.com>
References: <1391202696-23070-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1391202696-23070-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: qla2xxx-upstream@qlogic.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-01-31 at 13:11 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> The only place this struct member is touched is in one INIT_LIST_HEAD.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Applied to target-pending/queue.

Thanks Roland!

--nab

>  drivers/scsi/qla2xxx/qla_target.c | 2 --
>  drivers/scsi/qla2xxx/qla_target.h | 1 -
>  2 files changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 38a1257e76e1..2f42b650367c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2593,8 +2593,6 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>  		return -ENOMEM;
>  	}
>  
> -	INIT_LIST_HEAD(&cmd->cmd_list);
> -
>  	memcpy(&cmd->atio, atio, sizeof(*atio));
>  	cmd->state = QLA_TGT_STATE_NEW;
>  	cmd->tgt = ha->tgt.qla_tgt;
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index b33e411f28a0..f4a4beee2b96 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -855,7 +855,6 @@ struct qla_tgt_cmd {
>  	uint16_t loop_id;	/* to save extra sess dereferences */
>  	struct qla_tgt *tgt;	/* to save extra sess dereferences */
>  	struct scsi_qla_host *vha;
> -	struct list_head cmd_list;
>  
>  	struct atio_from_isp atio;
>  };
