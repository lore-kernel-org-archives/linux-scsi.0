From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] tcm_fc: Generate TASK_SET_FULL status
 for response failures
Date: Fri, 06 Jun 2014 14:03:25 -0700
Message-ID: <1402088605.5752.106.camel@vi-devel>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
 <1402011002-20771-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1402011002-20771-3-git-send-email-nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Cc: fcoe-devel <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-06-05 at 23:30 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> 
> This patch changes ft_queue_status() to set SAM_STAT_TASK_SET_FULL
> status upon lport->tt.seq_send( failure, and return -EAGAIN to notify
> target-core to attempt to requeue the response.
> 
> It also does the same for a fc_frame_alloc() failures, in order to
> signal the initiator that it should try to reduce it's current
> queue_depth, to lower the number of outstanding I/Os on the wire.
> 
> Reported-by: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Jun Wu <jwu-kEM2MQtWpIJWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> ---
>  drivers/target/tcm_fc/tfc_cmd.c |   19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index f5fd515..5585038 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -128,6 +128,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
>  	struct fc_lport *lport;
>  	struct fc_exch *ep;
>  	size_t len;
> +	int rc;
>  
>  	if (cmd->aborted)
>  		return 0;
> @@ -137,9 +138,10 @@ int ft_queue_status(struct se_cmd *se_cmd)
>  	len = sizeof(*fcp) + se_cmd->scsi_sense_length;
>  	fp = fc_frame_alloc(lport, len);
>  	if (!fp) {
> -		/* XXX shouldn't just drop it - requeue and retry? */
> -		return 0;
> +		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
> +		return -ENOMEM;
>  	}
> +
>  	fcp = fc_frame_payload_get(fp, len);
>  	memset(fcp, 0, len);
>  	fcp->resp.fr_status = se_cmd->scsi_status;
> @@ -170,7 +172,18 @@ int ft_queue_status(struct se_cmd *se_cmd)
>  	fc_fill_fc_hdr(fp, FC_RCTL_DD_CMD_STATUS, ep->did, ep->sid, FC_TYPE_FCP,
>  		       FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ, 0);
>  
> -	lport->tt.seq_send(lport, cmd->seq, fp);
> +	rc = lport->tt.seq_send(lport, cmd->seq, fp);
> +	if (rc) {
> +		pr_err_ratelimited("%s: Failed to send response frame %p, "
> +				   "xid <0x%x>\n", __func__, fp, ep->xid);

May be should be pr_info_ratelimited since this is not really error and
IO could get aborted due to timeouts in any setups or stressed
workloads.

> +		/*
> +		 * Generate a TASK_SET_FULL status to notify the initiator
> +		 * to reduce it's queue_depth after the se_cmd response has
> +		 * been re-queued by target-core.
> +		 */
> +		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
> +		return -ENOMEM;
> +	}
>  	lport->tt.exch_done(cmd->seq);
>  	return 0;
>  }

Reviewed-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
