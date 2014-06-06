From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] tcm_fc: Generate TASK_SET_FULL status for response
 failures
Date: Fri, 06 Jun 2014 14:11:03 -0700
Message-ID: <1402089063.26205.16.camel@haakon3.risingtidesystems.com>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
	 <1402011002-20771-3-git-send-email-nab@daterainc.com>
	 <1402088605.5752.106.camel@vi-devel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402088605.5752.106.camel@vi-devel>
Sender: target-devel-owner@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Jun Wu <jwu@stormojo.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-06 at 14:03 -0700, Vasu Dev wrote:
> On Thu, 2014-06-05 at 23:30 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch changes ft_queue_status() to set SAM_STAT_TASK_SET_FULL
> > status upon lport->tt.seq_send( failure, and return -EAGAIN to notify
> > target-core to attempt to requeue the response.
> > 
> > It also does the same for a fc_frame_alloc() failures, in order to
> > signal the initiator that it should try to reduce it's current
> > queue_depth, to lower the number of outstanding I/Os on the wire.
> > 
> > Reported-by: Vasu Dev <vasu.dev@linux.intel.com>
> > Cc: Vasu Dev <vasu.dev@linux.intel.com>
> > Cc: Jun Wu <jwu@stormojo.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/tcm_fc/tfc_cmd.c |   19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> > index f5fd515..5585038 100644
> > --- a/drivers/target/tcm_fc/tfc_cmd.c
> > +++ b/drivers/target/tcm_fc/tfc_cmd.c
> > @@ -128,6 +128,7 @@ int ft_queue_status(struct se_cmd *se_cmd)
> >  	struct fc_lport *lport;
> >  	struct fc_exch *ep;
> >  	size_t len;
> > +	int rc;
> >  
> >  	if (cmd->aborted)
> >  		return 0;
> > @@ -137,9 +138,10 @@ int ft_queue_status(struct se_cmd *se_cmd)
> >  	len = sizeof(*fcp) + se_cmd->scsi_sense_length;
> >  	fp = fc_frame_alloc(lport, len);
> >  	if (!fp) {
> > -		/* XXX shouldn't just drop it - requeue and retry? */
> > -		return 0;
> > +		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
> > +		return -ENOMEM;
> >  	}
> > +
> >  	fcp = fc_frame_payload_get(fp, len);
> >  	memset(fcp, 0, len);
> >  	fcp->resp.fr_status = se_cmd->scsi_status;
> > @@ -170,7 +172,18 @@ int ft_queue_status(struct se_cmd *se_cmd)
> >  	fc_fill_fc_hdr(fp, FC_RCTL_DD_CMD_STATUS, ep->did, ep->sid, FC_TYPE_FCP,
> >  		       FC_FC_EX_CTX | FC_FC_LAST_SEQ | FC_FC_END_SEQ, 0);
> >  
> > -	lport->tt.seq_send(lport, cmd->seq, fp);
> > +	rc = lport->tt.seq_send(lport, cmd->seq, fp);
> > +	if (rc) {
> > +		pr_err_ratelimited("%s: Failed to send response frame %p, "
> > +				   "xid <0x%x>\n", __func__, fp, ep->xid);
> 
> May be should be pr_info_ratelimited since this is not really error and
> IO could get aborted due to timeouts in any setups or stressed
> workloads.

<nod>, changing this to pr_info_ratelimited and doing the same in
ft_queue_data_in() well.

> 
> > +		/*
> > +		 * Generate a TASK_SET_FULL status to notify the initiator
> > +		 * to reduce it's queue_depth after the se_cmd response has
> > +		 * been re-queued by target-core.
> > +		 */
> > +		se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
> > +		return -ENOMEM;
> > +	}
> >  	lport->tt.exch_done(cmd->seq);
> >  	return 0;
> >  }
> 
> Reviewed-by: Vasu Dev <vasu.dev@intel.com> 
> 

Thanks Vasu!

--nab
