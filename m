From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 12/12] xen-scsiback: Convert to TARGET_SCF_ACK_KREF
 I/O krefs
Date: Tue, 26 Jan 2016 22:29:59 -0800
Message-ID: <1453876199.6746.125.camel@haakon3.risingtidesystems.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
	 <1453709466-6308-13-git-send-email-nab@daterainc.com>
	 <56A74122.2040902@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47661 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752405AbcA0GaB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2016 01:30:01 -0500
In-Reply-To: <56A74122.2040902@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, David Vrabel <david.vrabel@citrix.com>

On Tue, 2016-01-26 at 10:49 +0100, Juergen Gross wrote:
> On 25/01/16 09:11, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/xen/xen-scsiback.c | 53 +++++++++++++++++++++++-----------------------
> >  1 file changed, 26 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> > index 640fb22..a10e5f1 100644
> > --- a/drivers/xen/xen-scsiback.c
> > +++ b/drivers/xen/xen-scsiback.c
> > @@ -381,6 +381,12 @@ static void scsiback_cmd_done(struct vscsibk_pend *pending_req)
> >  	scsiback_do_resp_with_sense(sense_buffer, errors, resid, pending_req,
> >  				    pending_req->rqid);
> >  	scsiback_put(info);
> > +	/*
> > +	 * Drop the extra KREF_ACK reference taken by target_submit_cmd_map_sgls()
> > +	 * ahead of scsiback_check_stop_free() ->  transport_generic_free_cmd()
> > +	 * final se_cmd->cmd_kref put.
> > +	 */
> > +	target_put_sess_cmd(&pending_req->se_cmd);
> >  }
> >  
> >  static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
> > @@ -398,7 +404,7 @@ static void scsiback_cmd_exec(struct vscsibk_pend *pending_req)
> >  	rc = target_submit_cmd_map_sgls(se_cmd, sess, pending_req->cmnd,
> >  			pending_req->sense_buffer, pending_req->v2p->lun,
> >  			pending_req->data_len, 0,
> > -			pending_req->sc_data_direction, 0,
> > +			pending_req->sc_data_direction, TARGET_SCF_ACK_KREF,
> >  			pending_req->sgl, pending_req->n_sg,
> >  			NULL, 0, NULL, 0);
> >  	if (rc < 0) {
> > @@ -587,31 +593,28 @@ static void scsiback_disconnect(struct vscsibk_info *info)
> >  static void scsiback_device_action(struct vscsibk_pend *pending_req,
> >  	enum tcm_tmreq_table act, int tag)
> >  {
> > -	int rc, err = FAILED;
> >  	struct scsiback_tpg *tpg = pending_req->v2p->tpg;
> > +	struct scsiback_nexus *nexus = tpg->tpg_nexus;
> >  	struct se_cmd *se_cmd = &pending_req->se_cmd;
> >  	struct scsiback_tmr *tmr;
> > +	u64 unpacked_lun = pending_req->v2p->lun;
> > +	int rc, err = FAILED;
> >  
> >  	tmr = kzalloc(sizeof(struct scsiback_tmr), GFP_KERNEL);
> > -	if (!tmr)
> > -		goto out;
> > +	if (!tmr) {
> > +		target_put_sess_cmd(se_cmd);
> > +		goto err;
> 
> Sure? I think this should still be "goto out;"?
> 
> > +	}
> >  
> >  	init_waitqueue_head(&tmr->tmr_wait);
> >  
> > -	transport_init_se_cmd(se_cmd, tpg->se_tpg.se_tpg_tfo,
> > -		tpg->tpg_nexus->tvn_se_sess, 0, DMA_NONE, TCM_SIMPLE_TAG,
> > -		&pending_req->sense_buffer[0]);
> > -
> > -	rc = core_tmr_alloc_req(se_cmd, tmr, act, GFP_KERNEL);
> > -	if (rc < 0)
> > -		goto out;
> > -
> > -	se_cmd->se_tmr_req->ref_task_tag = tag;
> > +	rc = target_submit_tmr(&pending_req->se_cmd, nexus->tvn_se_sess,
> > +			       &pending_req->sense_buffer[0],
> > +			       unpacked_lun, tmr, act, GFP_KERNEL,
> > +			       tag, TARGET_SCF_ACK_KREF);
> > +	if (rc)
> > +		goto err;
> 
> Again.
> 

Whoops, bisect breakage here..

Fixed up this in latest target-pending/queue-next.

