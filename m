From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 1/2] tcm_fc: Generate TASK_SET_FULL status
 for DataIN failures
Date: Fri, 06 Jun 2014 14:02:14 -0700
Message-ID: <1402088534.26205.8.camel@haakon3.risingtidesystems.com>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
 <1402011002-20771-2-git-send-email-nab@daterainc.com>
 <1402087865.5752.99.camel@vi-devel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1402087865.5752.99.camel@vi-devel>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: fcoe-devel <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "Nicholas A. Bellinger" <nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-06 at 13:51 -0700, Vasu Dev wrote:
> On Thu, 2014-06-05 at 23:30 +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> > 
> > This patch changes ft_queue_data_in() to set SAM_STAT_TASK_SET_FULL
> > status upon a lport->tt.seq_send() failure, where it will now stop
> > sending subsequent DataIN, and immediately attempt to send the
> > response with exception status.
> > 
> > Sending a response with SAM_STAT_TASK_SET_FULL status is useful in
> > order to signal the initiator that it should try to reduce it's
> > current queue_depth, to lower the number of outstanding I/Os on
> > the wire.
> > 
> > Also, add a check to skip sending DataIN if TASK_SET_FULL status
> > has already been set due to a response lport->tt.seq_send()
> > failure, that has asked target-core to requeue a response.
> > 
> > Reported-by: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Jun Wu <jwu-kEM2MQtWpIJWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> > ---
> >  drivers/target/tcm_fc/tfc_io.c |   14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> > index e415af3..140659f 100644
> > --- a/drivers/target/tcm_fc/tfc_io.c
> > +++ b/drivers/target/tcm_fc/tfc_io.c
> > @@ -82,6 +82,10 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
> >  
> >  	if (cmd->aborted)
> >  		return 0;
> > +
> > +	if (se_cmd->scsi_status == SAM_STAT_TASK_SET_FULL)
> > +		goto queue_status;
> > +
> >  	ep = fc_seq_exch(cmd->seq);
> >  	lport = ep->lp;
> >  	cmd->seq = lport->tt.seq_start_next(cmd->seq);
> > @@ -178,14 +182,22 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
> >  			       FC_TYPE_FCP, f_ctl, fh_off);
> >  		error = lport->tt.seq_send(lport, seq, fp);
> >  		if (error) {
> > -			/* XXX For now, initiator will retry */
> >  			pr_err_ratelimited("%s: Failed to send frame %p, "
> >  						"xid <0x%x>, remaining %zu, "
> >  						"lso_max <0x%x>\n",
> >  						__func__, fp, ep->xid,
> >  						remaining, lport->lso_max);
> > +			/*
> > +			 * Generate a TASK_SET_FULL status to notify the
> > +			 * initiator to reduce it's queue_depth, ignoring
> > +			 * the rest of the data-in and immediately attempt
> > +			 * to send the response.
> > +			 */
> 
> I see above added check will drop rest of the frames but cannot find
> notifying to initiator with the TASK_SET_FULL status as in comments
> above, may be just the comment needs update otherwise code changes are
> fine.
> 

The break aborts the DataIN send loop and invokes ft_queue_status()
below in an attempt to send TASK_SET_FULL status.

If the ft_queue_status() -> lport->tt.seq_send() also fails, then
-ENOMEM will be returned to the target and a delayed re-queue attempt
will be made.

In any event, updating the comment above to be more precise.. 

> > +			se_cmd->scsi_status = SAM_STAT_TASK_SET_FULL;
> > +			break;
> >  		}
> >  	}
> > +queue_status:
> >  	return ft_queue_status(se_cmd);
> >  }
> >  
> 
> Reviewed-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
> 

Thanks Vasu!

--nab
