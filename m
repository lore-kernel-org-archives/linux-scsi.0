From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Fix a possible hang on target shutdown
Date: Fri, 13 Jan 2012 14:28:26 -0800
Message-ID: <1326493706.30987.56.camel@haakon2.linux-iscsi.org>
References: <1326329885-6814-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1326329885-6814-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-01-11 at 16:58 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> If tgt->tgt_stop is set, current code in qla_tgt_do_work() jumps to the
> exit path before setting sess, so the code
> 
>         if (sess)
>                 __qla_tgt_sess_put(sess);
> 
> skips the kref_put() and therefore sess is be left with an extra
> reference forever.  When this happens, qla_tgt_stop_phase1() waits
> forever for all the sessions to go away.  Fix this by making sure sess
> is always set in qla_tgt_do_work().
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index b1ef4b1..51de953 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2955,7 +2955,7 @@ static void qla_tgt_do_work(struct work_struct *work)
>  	scsi_qla_host_t *vha = cmd->vha;
>  	struct qla_hw_data *ha = vha->hw;
>  	struct qla_tgt *tgt = ha->qla_tgt;
> -	struct qla_tgt_sess *sess = NULL;
> +	struct qla_tgt_sess *sess = cmd->sess;
>  	atio_from_isp_t *atio = &cmd->atio;
>  	unsigned char *cdb;
>  	unsigned long flags;
> @@ -2965,7 +2965,6 @@ static void qla_tgt_do_work(struct work_struct *work)
>  	if (tgt->tgt_stop)
>  		goto out_term;	
>  
> -	sess = cmd->sess;
>  	if (!sess) {
>  		uint8_t *s_id = NULL;
>  		uint16_t loop_id = 0;

A very nice catch here Roland.

Applied to lio-core/qla_tgt-3.3, and will make sure this is included in
the next RFC.

Thanks,

--nab
