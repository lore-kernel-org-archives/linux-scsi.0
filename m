From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 3/6] qla2xxx: Add FC-NVMe F/W initialization and
 transport registration
Date: Mon, 19 Jun 2017 12:01:35 +0200
Message-ID: <20170619100135.GA19417@linux-x5ow.site>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-4-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752165AbdFSKBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 06:01:40 -0400
Content-Disposition: inline
In-Reply-To: <20170616224744.3681-4-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On Fri, Jun 16, 2017 at 03:47:41PM -0700, Himanshu Madhani wrote:
[...]
>  /*
> + * Global functions prototype in qla_nvme.c source file.
> + */
> +extern void qla_nvme_register_hba(scsi_qla_host_t *);
> +extern int  qla_nvme_register_remote(scsi_qla_host_t *, fc_port_t *);
> +extern void qla_nvme_delete(scsi_qla_host_t *);
> +extern void qla_nvme_abort(struct qla_hw_data *, srb_t *sp);
> +extern void qla_nvme_unregister_remote_port(struct work_struct *);
> +extern int qla_nvme_wait_on_rport_del(fc_port_t *);
> +extern void qla_nvme_abort_all(fc_port_t *);
> +extern int qla_nvme_post_cmd(struct nvme_fc_local_port *,
> +    struct nvme_fc_remote_port *, void *, struct nvmefc_fcp_req *);
> +extern int qla_nvme_alloc_queue(struct nvme_fc_local_port *, unsigned int,
> +    u16, void **);
> +extern int qla_nvme_hba_scan(scsi_qla_host_t *);
> +extern void qla_nvme_ls_abort(struct nvme_fc_local_port *,
> +    struct nvme_fc_remote_port *, struct nvmefc_ls_req *);
> +extern int qla_nvme_ls_req(struct nvme_fc_local_port *,
> +    struct nvme_fc_remote_port *, struct nvmefc_ls_req *);
> +extern void qla_nvme_poll(struct nvme_fc_local_port *, void *);
> +extern int qla2x00_start_nvme_mq(srb_t *);
> +extern void qla_nvme_fcp_abort(struct nvme_fc_local_port *,
> +    struct nvme_fc_remote_port *, void *, struct nvmefc_fcp_req *);
> +extern void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *, struct pt_ls4_request *,
> +    struct req_que *);

Can't these go into a header instead of using extern?

[...]

> @@ -4662,6 +4667,9 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
>  			break;
>  	} while (0);
>  
> +	if ((!vha->nvme_local_port) && (vha->flags.nvme_enabled))


[...]

> +		if ((ql2xnvmeenable) && IS_QLA27XX(ha))
> +			mcp->mb[4] |= NVME_ENABLE_FLAG;
> +

[...]

> +
> +		/* bit 26 of fw_attributes */
> +		if ((ha->fw_attributes_h & 0x400) && (ql2xnvmeenable)) {

Superfluous parenthesis.

[...]

> +			vha->flags.nvme_enabled = 1;
> +			icb->firmware_options_2 &=
> +			    cpu_to_le32(~(BIT_0 | BIT_1 | BIT_2 | BIT_3));

0xfffffff0 or maybe even ~0xf?

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

A FC-NVMe remote port can be in used right after a call to
nvme_fc_register_remoteport(), if I'm not mistaken. So you should add the
fcport to the nvme_remote_port->private _before_ calling
nvme_fc_register_remoteport().

> +	fcport->nvme_flag |= NVME_FLAG_REGISTERED;
> +	atomic_set(&fcport->nvme_ref_count, 1);
> +	rport->fcport = fcport;
> +	list_add_tail(&rport->list, &vha->nvme_rport_list);
> +#endif
> +	return 0;
> +}
> +
> +/*
> + * Perform a scan and register those ports with FC-NVMe transport
> + * input:  HBA handle
> + */
> +int qla_nvme_hba_scan(scsi_qla_host_t *vha)

This should be bool.

> +{
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	fc_port_t	*fcport;
> +	uint8_t not_found = 1;

bool found = false;

> +
> +	/*
> +	 * We are using the first HBA found
> +	 * Find matching fcport
> +	 */
> +	list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +		if ((fcport->fc4f_nvme) &&
> +		    (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))) {
> +			qla_nvme_register_remote(vha, fcport);
> +			not_found = 0;

found = true;

> +		}
> +	}
> +
> +	return not_found;

return found;

> +#else
> +	return 1;

return false;

> +#endif
> +}

And update the call-sites.

[...]

> +	if (unlikely((nvme->u.nvme.comp_status) || res))

Parenthesis again.

[...]

> +void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
> +    struct nvme_fc_remote_port *rport, struct nvmefc_ls_req *fd)
> +{
> +	struct nvme_private *priv = fd->private;
> +	fc_port_t *fcport = rport->private;
> +	srb_t *sp = priv->sp;
> +	int rval;
> +	struct qla_hw_data *ha;
> +
> +	ql_log(ql_log_info, fcport->vha, 0x212b,
> +	    "%s: aborting sp:%p on fcport:%p\n", __func__, sp, fcport);
> +
> +	ha = fcport->vha->hw;
> +	rval = ha->isp_ops->abort_command(sp);
> +	if (rval != QLA_SUCCESS)
> +		ql_log(ql_log_warn, fcport->vha, 0x2125,
> +		    "%s: failed to abort LS command for SP:%p rval=%x\n",
> +		    __func__, sp, rval);
> +}

I think qla_nvme_ls_abort() is a bit too verbose, it nearly only consists of
logging and thus hides the call to abort_command() from the reader.

> +
> +static void qla_nvme_ls_complete(struct work_struct *work)
> +{
> +	struct nvme_private *priv =
> +	    container_of(work, struct nvme_private, ls_work);
> +	struct nvmefc_ls_req *fd = priv->fd;
> +
> +	(*fd->done)(fd, priv->comp_status);

Can't we get the function pointer to done directly this LISP style doesn't
really look too nice;

	done(fd, priv->comp_status); 
or maybe
	fd->done(fd, priv->comp_status);

> +
> +int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
> +    struct nvme_fc_remote_port *rport, struct nvmefc_ls_req *fd)
> +{
> +	fc_port_t *fcport;
> +	struct srb_iocb   *nvme;
> +	struct scsi_qla_host *vha;
> +	int     rval = QLA_FUNCTION_FAILED;
> +	struct qla_hw_data *ha;
> +	srb_t           *sp;
> +	struct nvme_private *priv;
> +
> +	if (!fd) {
> +		ql_log(ql_log_warn, NULL, 0x2135, "NO NVMe FCP reqeust\n");
> +		return rval;
> +	}

Just curious, how likely is this? I.e. have you hit the case in debugging?

> +
> +	priv = fd->private;
> +	fcport = (fc_port_t *)rport->private;
> +	if (!fcport) {
> +		ql_log(ql_log_warn, NULL, 0x212c,
> +		    "%s: No fcport ptr\n", __func__);
> +		return rval;
> +	}

Same here.

[...]

> +
> +void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
> +    struct nvme_fc_remote_port *rport, void *hw_queue_handle,
> +    struct nvmefc_fcp_req *fd)

The comment from the other abort function above applies here as well.

> +void qla_nvme_poll(struct nvme_fc_local_port *lport, void *hw_queue_handle)
> +{
> +	struct scsi_qla_host *vha = lport->private;
> +	unsigned long flags;
> +	struct qla_qpair *qpair = (struct qla_qpair *)hw_queue_handle;
> +
> +	/* Acquire ring specific lock */
> +	spin_lock_irqsave(&qpair->qp_lock, flags);
> +	qla24xx_process_response_queue(vha, qpair->rsp);
> +	spin_unlock_irqrestore(&qpair->qp_lock, flags);

Just a side note, I _think_ needing a spin_lock here is a design issue.

> +	/* Acquire qpair specific lock */
> +	spin_lock_irqsave(&qpair->qp_lock, flags);

Same here. What is this lock protecting? I see qla_qpair does have a
reference count (not kref backed btw), so if you're only protecting
against the structure vanishing under your feet, you could change
this to krefs. If you're protecting structure members the use of RCUs
spring to mind. rwlocks as well, if the content that is protected is
read-mostly. But please note, reworking this requires extensive testing. But a
spin_lock_irqsave() in the I/O path raises a red-flag for me.

[...]

> +
> +static void qla_nvme_localport_delete(struct nvme_fc_local_port *lport)
> +{
> +	struct scsi_qla_host *vha = lport->private;
> +
> +	ql_log(ql_log_info, vha, 0x210f,
> +	    "localport delete of %p completed.\n", vha->nvme_local_port);
> +
> +	vha->nvme_local_port = NULL;
> +	atomic_dec(&vha->nvme_ref_count);

Nit, the debug message says completed, but you haven't "completed" the delete
;-).

> +}
> +
> +static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
> +{
> +	fc_port_t *fcport;
> +	struct nvme_rport *r_port, *trport;
> +
> +	fcport = (fc_port_t *)rport->private;
> +	fcport->nvme_remote_port = NULL;
> +	fcport->nvme_flag &= ~NVME_FLAG_REGISTERED;
> +	atomic_dec(&fcport->nvme_ref_count);
> +
> +	ql_log(ql_log_info, fcport->vha, 0x2110,
> +	    "remoteport_delete of %p completed.\n", fcport);
> +
> +	list_for_each_entry_safe(r_port, trport,
> +	    &fcport->vha->nvme_rport_list, list) {
> +		if (r_port->fcport == fcport) {
> +			list_del(&r_port->list);
> +			break;
> +		}
> +	}
> +	kfree(r_port);

Ditto.

[..]

> +static int qla_nvme_wait_on_command(srb_t *sp)
> +{
> +#define NVME_ABORT_POLLING_PERIOD    1000
> +#define NVME_ABORT_WAIT_ITER         ((2 * 1000) / (NVME_ABORT_POLLING_PERIOD))
> +	unsigned long wait_iter = NVME_ABORT_WAIT_ITER;
> +	int ret = QLA_SUCCESS;
> +
> +	while ((atomic_read(&sp->ref_count) > 1) && wait_iter--)
> +		msleep(NVME_ABORT_POLLING_PERIOD);
> +
> +	if (atomic_read(&sp->ref_count) > 1)
> +		ret = QLA_FUNCTION_FAILED;
> +
> +	return ret;

wait_event_timeout()?

> +int qla_nvme_wait_on_rport_del(fc_port_t *fcport)
> +{
> +	unsigned long wait_iter = NVME_ABORT_WAIT_ITER;
> +	int ret = QLA_SUCCESS;
> +
> +	while (atomic_read(&fcport->nvme_ref_count) && wait_iter--)
> +		msleep(NVME_ABORT_POLLING_PERIOD);

Ditto.

[...]

> +void qla_nvme_abort(struct qla_hw_data *ha, srb_t *sp)
> +{
> +	int rval;
> +
> +	rval = ha->isp_ops->abort_command(sp);
> +	if (!rval) {

	if (!rval && !qla_nvme_wait_on_command(sp))
		ql_log(ql_log_warn, NULL, 0x2112,
			"nvme_wait_on_comand timed out waiting on sp=%p\n",
			sp);

[...]

> +void qla_nvme_delete(scsi_qla_host_t *vha)
> +{
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	struct nvme_rport *rport, *trport;
> +	fc_port_t *fcport;
> +
> +	if (!list_empty(&vha->nvme_rport_list)) {
> +		list_for_each_entry_safe(rport, trport,
> +		    &vha->nvme_rport_list, list) {

Do you really need the if (!list_empty($list)) call before the
list_for_each_entry_safe()?


> +			fcport = rport->fcport;
> +			ql_log(ql_log_info, fcport->vha, 0x2114,
> +			    "%s: fcport=%p\n", __func__, fcport);
> +			nvme_fc_unregister_remoteport(
> +			    fcport->nvme_remote_port);
> +			qla_nvme_wait_on_rport_del(fcport);
> +			qla_nvme_abort_all(fcport);
> +		}
> +	}
> +
> +	if (vha->nvme_local_port) {
> +		ql_log(ql_log_info, vha, 0x2115,
> +		    "unregister localport = %p\n", vha->nvme_local_port);
> +		nvme_fc_unregister_localport(vha->nvme_local_port);
> +	}
> +
> +	while (atomic_read(&vha->nvme_ref_count))
> +		schedule();

Ugh..., no!
wait_event()?

[...]

> +
> +	ret = nvme_fc_register_localport(&pinfo, tmpl,
> +	    get_device(&ha->pdev->dev), &vha->nvme_local_port);

[...]

> +	vha->nvme_local_port->private = vha;

Please move above the nvme_fc_register_localport().

[...]

> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +int ql2xnvmeenable = 1;
> +#else
> +int ql2xnvmeenable;
> +#endif
> +module_param(ql2xnvmeenable, int, 0644);
> +MODULE_PARM_DESC(ql2xnvmeenable,
> +    "Enables NVME support"
> +    "0 - no NVMe. Default is N");
> +

The message is a bit misleading. NVMe is enabled *IFF* CONFIG_NVME_FC is
enabled.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
