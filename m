From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] qla2xxx: Update target lookup session tables when
 a target session changes
Date: Wed, 17 Oct 2012 14:30:28 -0700
Message-ID: <1350509428.10820.41.camel@haakon2.linux-iscsi.org>
References: <1349988092-27640-1-git-send-email-roland@kernel.org>
	 <1349988092-27640-3-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349988092-27640-3-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Arun Easi <arun.easi@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-10-11 at 13:41 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> It is possible for the target code to change the loop_id or s_id of a
> target session in reaction to an FC fabric change.  However, the
> session structures are stored in tables that are indexed by these two
> keys, and if we just change the session structure but leave the
> pointers to it in the old places in the table, havoc can ensue.  For
> example, a new session might come along that should go in the old slot
> in the table and overwrite the old session pointer.
> 
> To handle this, add a new tgt_ops->update_sess() method that also
> updates the "by loop_id" and "by s_id" lookup tables when a session
> changes, so that the keys where a session pointer is stored in these
> tables always matches the keys in the session structure itself.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Nice work tracking down this long standing bug with fc_port_t handling !

Queued for v3.7-rc fixes with a CC' to stable.

One extra bit below..

>  drivers/scsi/qla2xxx/qla_target.c  |   22 +++++------
>  drivers/scsi/qla2xxx/qla_target.h  |    1 +
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   73 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 84 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 0e09d8f..556e941 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -557,6 +557,7 @@ static bool qlt_check_fcport_exist(struct scsi_qla_host *vha,
>  	int pmap_len;
>  	fc_port_t *fcport;
>  	int global_resets;
> +	unsigned long flags;
>  
>  retry:
>  	global_resets = atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count);
> @@ -625,10 +626,10 @@ retry:
>  	    sess->s_id.b.area, sess->loop_id, fcport->d_id.b.domain,
>  	    fcport->d_id.b.al_pa, fcport->d_id.b.area, fcport->loop_id);
>  
> -	sess->s_id = fcport->d_id;
> -	sess->loop_id = fcport->loop_id;
> -	sess->conf_compl_supported = !!(fcport->flags &
> -	    FCF_CONF_COMP_SUPPORTED);
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
> +	ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
> +				!!(fcport->flags & FCF_CONF_COMP_SUPPORTED));
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>  

Dropping the extra unnecessary '!!' double inversion check here around
FCF_CONF_COMP_SUPPORTED usage, and folding into the original patch.

>  	res = true;
>  
> @@ -740,10 +741,9 @@ static struct qla_tgt_sess *qlt_create_sess(
>  				qlt_undelete_sess(sess);
>  
>  			kref_get(&sess->se_sess->sess_kref);
> -			sess->s_id = fcport->d_id;
> -			sess->loop_id = fcport->loop_id;
> -			sess->conf_compl_supported = !!(fcport->flags &
> -			    FCF_CONF_COMP_SUPPORTED);
> +			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
> +						!!(fcport->flags & FCF_CONF_COMP_SUPPORTED));
> +

Ditto

>  			if (sess->local && !local)
>  				sess->local = 0;
>  			spin_unlock_irqrestore(&ha->hardware_lock, flags);
> @@ -869,10 +869,8 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
>  			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
>  			    "Reappeared sess %p\n", sess);
>  		}
> -		sess->s_id = fcport->d_id;
> -		sess->loop_id = fcport->loop_id;
> -		sess->conf_compl_supported = !!(fcport->flags &
> -		    FCF_CONF_COMP_SUPPORTED);
> +		ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
> +					!!(fcport->flags & FCF_CONF_COMP_SUPPORTED));
>  	}
>  

And here too..

Thanks Roland!
