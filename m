From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ib_srpt status
Date: Wed, 19 Oct 2011 10:38:27 -0700
Message-ID: <1319045907.18132.15.camel@haakon2.linux-iscsi.org>
References: <20111012092318.GA9405@lst.de>
	 <CAO+b5-rqc7Dq-7p1XRHrxVMP9JS5N26Ht1q8ee=KGRqpUintFQ@mail.gmail.com>
	 <1318956075.2454.10.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-oxcWM+Sh4t00SxPqbaNGj7uCJK8xgsoRaOxp-6Ac5EmQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-10-19 at 18:59 +0200, Bart Van Assche wrote:
> On Tue, Oct 18, 2011 at 6:41 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > I'm having no problems with the patch posted for v3.2 review on MT26428
> > HCAs
> >
> > Can you verify you are actually using this patch, and not your private
> > tree from github..?  The reason is that your tree did not contain the
> > bugfix below to ib_srpt code that was originally causing problems:
> >
> > ib_srpt: Fix bug with chainged SGLs in srpt_map_sg_to_ib_sge
> > http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=commitdiff;h=ea485147563b6555a97dbf811825fbb586519252
> 
> Yes, that patch was included - sorry, but I had made another mistake.

Thanks for the update here.

> 3.1-rc10 + ib_srpt + patch below is now working fine here. I noticed
> only one unusual issue so far (with kernel debugging enabled) and that
> is that the watchdog thread CPU time was unusually high:
> 
> root         7  2.3  0.0      0     0 ?        S    18:39   0:22 [watchdog/0]
> root        12  0.6  0.0      0     0 ?        S    18:39   0:06 [watchdog/1]
> 
> 

I'm not exactly sure what to make of this..

> The patch I used to backport ib_srpt from LIO-4.1 to kernel 3.1-rc10 is:
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c
> b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 109b412..b3947fe 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1340,7 +1340,7 @@ static void srpt_put_send_ioctx(struct
> srpt_send_ioctx *ioctx)
>         WARN_ON(srpt_get_cmd_state(ioctx) != SRPT_STATE_DONE);
> 
>         srpt_unmap_sg_to_ib_sge(ioctx->ch, ioctx);
> -       transport_generic_free_cmd(&ioctx->cmd, 0);
> +       transport_generic_free_cmd(&ioctx->cmd, 0, 0);
> 
>         if (ioctx->n_rbuf > 1) {
>                 kfree(ioctx->rbufs);
> @@ -1899,7 +1899,7 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
>                         TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
>                 goto process_tmr;
>         }
> -       cmd->se_tmr_req = core_tmr_alloc_req(cmd, NULL, tcm_tmr, GFP_KERNEL);
> +       cmd->se_tmr_req = core_tmr_alloc_req(cmd, NULL, tcm_tmr);
>         if (!cmd->se_tmr_req) {
>                 send_ioctx->cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
>                 send_ioctx->cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
> 

Yep, the ib_srpt patch I sent is against target-pending.git/for-next
along with the other target-core updates for v3.2 that will be merged
first.

Btw, Roland asked me to take a look at the current set of module
parameters for ib_srpt, and see which could be removed and/or converted
to per SPR target endpoint configfs attributes..  So on that note, a few
questions for you on a couple of the module parameters:

*) use_port_guid_in_session_name: This appears to be a legacy compat 
   item, can this be safetly removed for mainline..?

*) srpt_service_guid: Should this really have global scope..?

Aside from those, i'm currently having a look to see which of the module
parameters are not used in the initial srpt_add_one() setup path, and
that using per SRP target endpoint configfs attributes would make sense.

Any input here would be appreciated.

Thanks,

--nab
