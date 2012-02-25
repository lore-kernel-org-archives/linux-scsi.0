From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Fix sign of FCP_RESID field for status with
 RESID_OVER
Date: Fri, 24 Feb 2012 17:11:30 -0800
Message-ID: <1330132290.4528.142.camel@haakon2.linux-iscsi.org>
References: <1330028042-15599-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1330028042-15599-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-02-23 at 12:14 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> We don't need to change the sign of our prm->residual field; the target
> core sets a flag to distinguish overflow and underflow, but
> se_cmd->residual_count is always positive.  The existing code seems to
> be a carryover from the port from scst, which uses the sign of the
> residual field to distinguish overflow and underflow.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 9282014..b12fb84 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1808,7 +1808,6 @@ static int qla_tgt_pre_xmit_response(struct qla_tgt_cmd *cmd, struct qla_tgt_prm
>  			se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
>  			cmd->bufflen, prm->rq_result);
>  		prm->rq_result |= SS_RESIDUAL_OVER;
> -		prm->residual = -prm->residual;
>  	}
>  
>  	if (xmit_type & QLA_TGT_XMIT_STATUS) {

Applied.  Thanks Roland!

--nab
