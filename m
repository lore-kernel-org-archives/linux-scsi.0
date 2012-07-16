From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/7] qla2xxx: Get rid of redundant
 qla_tgt_sess.tearing_down
Date: Mon, 16 Jul 2012 15:52:20 -0700
Message-ID: <1342479140.18004.294.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-2-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-2-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 11:04 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> The only place that sets qla_tgt_sess.tearing_down calls
> target_splice_sess_cmd_list() immediately afterwards, without dropping
> the lock it holds.  That function sets se_session.sess_tearing_down,
> so we can get rid of the qla_target-specific flag, and in the one
> place that looks at the qla_tgt_sess.tearing_down flag just test
> se_session.sess_tearing_down instead.
> 

Looks fine.  Applied to for-next.

Thanks Roland!

> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Arun Easi <arun.easi@qlogic.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c  |    2 +-
>  drivers/scsi/qla2xxx/qla_target.h  |    1 -
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    1 -
>  3 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 77759c7..87b5a330 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -2644,7 +2644,7 @@ static void qlt_do_work(struct work_struct *work)
>  	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
>  	    atio->u.isp24.fcp_hdr.s_id);
>  	if (sess) {
> -		if (unlikely(sess->tearing_down)) {
> +		if (unlikely(sess->se_sess->sess_tearing_down)) {
>  			sess = NULL;
>  			spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  			goto out_term;
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index 9f9ef16..07aa265 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -813,7 +813,6 @@ struct qla_tgt_sess {
>  	unsigned int conf_compl_supported:1;
>  	unsigned int deleted:1;
>  	unsigned int local:1;
> -	unsigned int tearing_down:1;
>  
>  	struct se_session *se_sess;
>  	struct scsi_qla_host *vha;
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 6e64314..3cb2b97 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -466,7 +466,6 @@ static int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
>  	vha = sess->vha;
>  
>  	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
> -	sess->tearing_down = 1;
>  	target_splice_sess_cmd_list(se_sess);
>  	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
>  
