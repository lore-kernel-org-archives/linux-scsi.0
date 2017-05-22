From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 20/25] qla2xxx: Remove redundant code
Date: Sun, 21 May 2017 21:27:59 -0700
Message-ID: <1495427279.27407.20.camel@haakon3.risingtidesystems.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
         <20170519215344.2168-21-himanshu.madhani@cavium.com>
         <1495237379.2581.19.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40790 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdEVE2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 00:28:02 -0400
In-Reply-To: <1495237379.2581.19.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2017-05-19 at 23:43 +0000, Bart Van Assche wrote:
> On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
> > From: Quinn Tran <quinn.tran@cavium.com>
> > 
> > During ABTS or Abort task, qla2xxx does a pre-search for
> > the se_cmd, based on command's tag. The same search is
> > performed by TCM. Remove the extra search from qla2xxx.
> > 
> > Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> > Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_target.c | 29 ++++-------------------------
> >  1 file changed, 4 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> > index 21e8993baf4b..b8e609ae6cff 100644
> > --- a/drivers/scsi/qla2xxx/qla_target.c
> > +++ b/drivers/scsi/qla2xxx/qla_target.c
> > @@ -1836,34 +1836,13 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
> >  	struct abts_recv_from_24xx *abts, struct fc_port *sess)
> >  {
> >  	struct qla_hw_data *ha = vha->hw;
> > -	struct se_session *se_sess = sess->se_sess;
> >  	struct qla_tgt_mgmt_cmd *mcmd;
> > -	struct se_cmd *se_cmd;
> >  	int rc;
> > -	bool found_lun = false;
> > -	unsigned long flags;
> > -
> > -	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> > -	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
> > -		if (se_cmd->tag == abts->exchange_addr_to_abort) {
> > -			found_lun = true;
> > -			break;
> > -		}
> > -	}
> > -	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> >  
> > -	/* cmd not in LIO lists, look in qla list */
> > -	if (!found_lun) {
> > -		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
> > -			/* send TASK_ABORT response immediately */
> > -			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
> > -			return 0;
> > -		} else {
> > -			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
> > -			    "unable to find cmd in driver or LIO for tag 0x%x\n",
> > -			    abts->exchange_addr_to_abort);
> > -			return -ENOENT;
> > -		}
> > +	if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
> > +		/* send TASK_ABORT response immediately */
> > +		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
> > +		return 0;
> >  	}
> >  
> >  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
> 
> Hello Himanshu and Quinn,
> 
> Please drop this patch. If a command has already been submitted to the LIO
> core and an ABTS is received then the LIO core should be requested to perform
> the abort. This patch changes the behavior of the qla2xxx target driver such
> that the LIO core is not informed at all if abort_cmd_for_tag() finds the
> command that has to be aborted in one of the command lists maintained by the
> qla2xxx driver. That can lead to the presence of overlapping writes in the
> command set on the target system and hence to data corruption.

This analysis is wrong.

The three lists abort_cmd_for_tag() walks from __qlt_24xx_handle_abts()
are used to track descriptors only before __qlt_do_work() is reached,
and before a descriptor is submitted into tcm_qla2xxx code.

Or rather, the three lists in abort_cmd_for_tag() only contain
qla_tgt_cmd or qla_tgt_sess_op descriptors that have not yet reached
qla_tgt_func_tmpl->handle_cmd() code.

Both qlt_do_work() and qlt_create_sess_from_atio() drop their respective
descriptors from ->cmd_list before dispatching into tcm_qla2xxx ->
target-core, which means there is no way for a descriptor to be part of
internal lists once __qlt_do_work() is called.

That said, the patch is correct and removes the redundant lookup.

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
