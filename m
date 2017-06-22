From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/6] qla2xxx: Add FC-NVMe F/W initialization and
 transport registration
Date: Thu, 22 Jun 2017 11:46:49 +0200
Message-ID: <20170622094649.GD5670@linux-x5ow.site>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-4-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36691 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751674AbdFVJqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 05:46:54 -0400
Content-Disposition: inline
In-Reply-To: <20170621204846.21663-4-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, darren.trapp@cavium.com, giridhar.malavali@cavium.com, linux-nvme@lists.infradead.org

On Wed, Jun 21, 2017 at 01:48:43PM -0700, Madhani, Himanshu wrote:
[...]
> +	wait_queue_head_t nvme_ls_waitQ;

Can you please lower-case the 'Q' in waitQ IFF you have to re-send the series?

[...]
> +	wait_queue_head_t nvme_waitQ;

Ditto

[...]
> +	wait_queue_head_t nvme_waitQ;

And here as well.

> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 6fbee11c1a18..c6af45f7d5d6 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -10,6 +10,16 @@
>  #include <linux/interrupt.h>
>  
>  /*
> + * Global functions prototype in qla_nvme.c source file.
> + */
> +extern void qla_nvme_register_hba(scsi_qla_host_t *);
> +extern int  qla_nvme_register_remote(scsi_qla_host_t *, fc_port_t *);
> +extern void qla_nvme_delete(scsi_qla_host_t *);
> +extern void qla_nvme_abort(struct qla_hw_data *, srb_t *sp);
> +extern void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *, struct pt_ls4_request *,
> +    struct req_que *);

You're still not convinced of the idea of headers, heh ;-)
Especially as you have a qla_nvme.h.

[...]

> +	INIT_WORK(&fcport->nvme_del_work, qla_nvme_unregister_remote_port);
> +	rport = kzalloc(sizeof(*rport), GFP_KERNEL);
> +	if (!rport) {
> +		ql_log(ql_log_warn, vha, 0x2101,
> +		    "%s: unable to alloc memory\n", __func__);

kzalloc() will warn you about a failed allocation, no need to double it.
See also:
http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf

[...]

> +	ret = nvme_fc_register_remoteport(vha->nvme_local_port, &rport->req,
> +	    &fcport->nvme_remote_port);
> +	if (ret) {
> +		ql_log(ql_log_warn, vha, 0x212e,
> +		    "Failed to register remote port. Transport returned %d\n",
> +		    ret);
> +		return ret;
> +	}
> +
> +	fcport->nvme_remote_port->private = fcport;

I think I already said that in the last review, but can you please move the 
fcport->nvme_remote_port->private = fcport;
assingment _above_ the nvme_fc_register_remoteport() call.

[...]

> +	vha = (struct scsi_qla_host *)lport->private;

No need to cast from void *
> +	ql_log(ql_log_info, vha, 0x2104,
> +	    "%s: handle %p, idx =%d, qsize %d\n",
> +	    __func__, handle, qidx, qsize);

Btw, sometime in the future you could change your ql_log() thingies to the
kernel's dyndebug facility.

[...]

> +	rval = ha->isp_ops->abort_command(sp);
> +	if (rval != QLA_SUCCESS)
> +		ql_log(ql_log_warn, fcport->vha, 0x2125,
> +		    "%s: failed to abort LS command for SP:%p rval=%x\n",
> +		    __func__, sp, rval);
> +
> +	ql_dbg(ql_dbg_io, fcport->vha, 0x212b,
> +	    "%s: aborted sp:%p on fcport:%p\n", __func__, sp, fcport);

If you insinst in having these two messages ("failed to abort" and "aborted")
can you at least fold it into one print statement.

> +	rval = ha->isp_ops->abort_command(sp);
> +	if (!rval)
> +		ql_log(ql_log_warn, fcport->vha, 0x2127,
> +		    "%s: failed to abort command for SP:%p rval=%x\n",
> +		    __func__, sp, rval);
> +
> +	ql_dbg(ql_dbg_io, fcport->vha, 0x2126,
> +	    "%s: aborted sp:%p on fcport:%p\n", __func__, sp, fcport);

Ditto.

[...]


> +	/* Setup qpair pointers */
> +	req = qpair->req;
> +	tot_dsds = fd->sg_cnt;
> +
> +	/* Acquire qpair specific lock */
> +	spin_lock_irqsave(&qpair->qp_lock, flags);
> +
> +	/* Check for room in outstanding command list. */
> +	handle = req->current_outstanding_cmd;

I've just seen this in qla2xxx_start_scsi_mq() and
qla2xxx_dif_start_scsi_mq() and was about to send you an RFC patch. But
here it is for completeness in the nvme version as well:

You save a pointer to the req_que from you qpair and _afterwards_ you grab
the qp_lock. What prevents someone from changing the request internals
underneath you?

Like this:

CPU0                               CPU1
req = qpair->req;
                                 qla2xxx_delete_qpair(vha, qpair);
                                 `-> ret = qla25xx_delete_req_que(vha, qpair->req);
spin_lock_irqsave(&qpair->qp_lock, flags);
handle = req->current_outstanding_cmd;

Oh and btw, neither qla2xxx_delete_qpair() nor qla25xx_delete_req_que() grab
the qp_lock.

I think this is something work re-thinking. Maybe you can identify the blocks
accessing struct members which need to be touched under a lock and extract
them into a helper function wich calls lockdep_assert_held(). No must just and
idea.

[...]
> +
> +	/* Load data segments */
> +	for_each_sg(sgl, sg, tot_dsds, i) {

Do you really need the whole loop under a spin_lock_irqsave()? If the sglist
has a lot of entries (i.e. becasue we couldn't cluster it) we're in risk to
trigger a NMI watchdog soft-lockup WARN_ON(). You need to grab the lock when
accessing req's members but the rest of the loop? This applies to
qla24xx_build_scsi_iocbs() for SCSI as well.

[...]

> +	struct qla_qpair *qpair = (struct qla_qpair *)hw_queue_handle;

Void pointer cast. Someone really should write a coccinelle script to get rid
of 'em.

[...]

> +	/* Alloc SRB structure */
> +	sp = qla2xxx_get_qpair_sp(qpair, fcport, GFP_ATOMIC);
> +	if (!sp)
> +		return -EIO;

__blk_mq_run_hw_queue()
`-> blk_mq_sched_dispatch_requests()
    `-> blk_mq_dispatch_rq_list()
        `-> nvme_fc_queue_rq()
            `-> nvme_fc_start_fcp_op() 
                `-> qla_nvme_post_cmd()
isn't called from an IRQ context and qla2xxx_get_qpair_sp() internally
uses mempool_alloc(). From mempool_alloc()'s documentation:

"Note that due to preallocation, this function *never* fails when called from
process contexts. (it might fail if called from an IRQ context.)"
mm/mempool.c:306

[...]

> +	fcport = (fc_port_t *)rport->private;
Void cast.

[...]
> +	rval = ha->isp_ops->abort_command(sp);
> +	if (!rval) {
> +		if (!qla_nvme_wait_on_command(sp))

        if (!rval && !qla_nvme_wait_on_command(sp))

[...]

> +		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
> +			sp = req->outstanding_cmds[cnt];
> +			if ((sp) && ((sp->type == SRB_NVME_CMD) ||
                            ^ parenthesis
> +			    (sp->type == SRB_NVME_LS)) &&
> +				(sp->fcport == fcport)) {
                                ^ parenthesis
                                 
[...]

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_nvme.h
[...]

void qla_nvme_register_hba(scsi_qla_host_t *);
int  qla_nvme_register_remote(scsi_qla_host_t *, fc_port_t *);
void qla_nvme_delete(scsi_qla_host_t *);
void qla_nvme_abort(struct qla_hw_data *, srb_t *sp);
void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *, struct pt_ls4_request *, struct req_que *);

[...]

> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +int ql2xnvmeenable = 1;
> +#else
> +int ql2xnvmeenable;
> +#endif
> +module_param(ql2xnvmeenable, int, 0644);
> +MODULE_PARM_DESC(ql2xnvmeenable,
> +    "Enables NVME support. "
> +    "0 - no NVMe.  Default is Y");

Default is Y IFF CONFIG_NVME_FC is enabled. Is it possible to guard the whole module
paraneter with IS_ENABLED(CONFIG_NVME_FC)? Not sure if this would break if
CONFIG_NVME_FC=n and someone does qla2xxx.ql2xnvmeenable=N.

[...]

> -	if (sp->type != SRB_NVME_CMD) {
> +	if ((sp->type != SRB_NVME_CMD) && (sp->type != SRB_NVME_LS)) {

http://en.cppreference.com/w/c/language/operator_precedence

> +					if ((sp->type == SRB_NVME_CMD) ||
> +					    (sp->type == SRB_NVME_LS)) {

^^

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
