Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53A0C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 11:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F05206D5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 11:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfLJLrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:47:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:52920 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727272AbfLJLrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 06:47:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9434AC44;
        Tue, 10 Dec 2019 11:47:07 +0000 (UTC)
Message-ID: <f7a05e5696b1942b3303e20fe0e6891bc9a61090.camel@suse.de>
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI
 commands
From:   Martin Wilck <mwilck@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Tue, 10 Dec 2019 12:47:57 +0100
In-Reply-To: <20191209180223.194959-3-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
         <20191209180223.194959-3-bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> Since the SCSI core does not reuse the tag of the SCSI command that
> is
> being aborted by .eh_abort() before .eh_abort() has finished it is
> not
> necessary to check from inside that callback whether or not the SCSI
> command
> has already completed. Instead, rely on the firmware to return an
> error code
> when attempting to abort a command that has already completed.
> Additionally,
> rely on the firmware to return an error code when attempting to abort
> an
> already aborted command.

Do we have evidence that the firmware can truly be relied upon in this
respect? It's at least not impossible that the FW (or some version of
it) relies on the driver not trying to abort commands that have been
aborted or completed already, and crashes if that assumption is
violated.

> 
> In qla2x00_abort_srb(), use blk_mq_request_started() instead of
> sp->completed and sp->aborted.

See below.

> This patch eliminates several race conditions triggered by the
> removed member
> variables.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  3 ---
>  drivers/scsi/qla2xxx/qla_isr.c |  5 -----
>  drivers/scsi/qla2xxx/qla_os.c  | 15 ++-------------
>  3 files changed, 2 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h
> b/drivers/scsi/qla2xxx/qla_def.h
> index 460f443f6471..ab7424318ee8 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -597,9 +597,6 @@ typedef struct srb {
>  	struct fc_port *fcport;
>  	struct scsi_qla_host *vha;
>  	unsigned int start_timer:1;
> -	unsigned int abort:1;
> -	unsigned int aborted:1;
> -	unsigned int completed:1;
>  
>  	uint32_t handle;
>  	uint16_t flags;
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> b/drivers/scsi/qla2xxx/qla_isr.c
> index 2601d7673c37..721a8d83e350 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2487,11 +2487,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha,
> struct rsp_que *rsp, void *pkt)
>  		return;
>  	}
>  
> -	if (sp->abort)
> -		sp->aborted = 1;
> -	else
> -		sp->completed = 1;
> -
>  	if (sp->cmd_type != TYPE_SRB) {
>  		req->outstanding_cmds[handle] = NULL;
>  		ql_dbg(ql_dbg_io, vha, 0x3015,
> diff --git a/drivers/scsi/qla2xxx/qla_os.c
> b/drivers/scsi/qla2xxx/qla_os.c
> index 145ea93206f0..2231d99d311b 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1253,17 +1253,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  		return SUCCESS;
>  
>  	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> -	if (sp->completed) {
> -		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> -		return SUCCESS;
> -	}
> -
> -	if (sp->abort || sp->aborted) {
> -		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> -		return FAILED;
> -	}
> -
> -	sp->abort = 1;
>  	sp->comp = &comp;
>  	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
>  
> @@ -1696,6 +1685,7 @@ static void qla2x00_abort_srb(struct qla_qpair
> *qp, srb_t *sp, const int res,
>  	DECLARE_COMPLETION_ONSTACK(comp);
>  	scsi_qla_host_t *vha = qp->vha;
>  	struct qla_hw_data *ha = vha->hw;
> +	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
>  	int rval;
>  	bool ret_cmd;
>  	uint32_t ratov_j;
> @@ -1717,7 +1707,6 @@ static void qla2x00_abort_srb(struct qla_qpair
> *qp, srb_t *sp, const int res,
>  		}
>  
>  		sp->comp = &comp;
> -		sp->abort =  1;
>  		spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
>  
>  		rval = ha->isp_ops->abort_command(sp);
> @@ -1741,7 +1730,7 @@ static void qla2x00_abort_srb(struct qla_qpair
> *qp, srb_t *sp, const int res,
>  		}
>  
>  		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
> -		if (ret_cmd && (!sp->completed || !sp->aborted))
> +		if (ret_cmd && blk_mq_request_started(cmd->request))
>  			sp->done(sp, res);
>  	} else {
>  		sp->done(sp, res);

blk_mq_request_started() returns true for requests in MQ_RQ_COMPLETE
state. Is this really an equivalent condition?

That said, the condition in the current code is sort of strange, as
it's equivalent to !(sp->completed && sp->aborted). I'm wondering what
it means if a command is both completed and aborted. Naïvely thinking
(and inferring from the current code) this condition could never be
met, and thus its negation would hold for every command. Perhaps Quinn
meant "!(sp->completed || sp->aborted)" ?

Regards,
Martin


