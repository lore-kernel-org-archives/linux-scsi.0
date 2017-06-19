From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 3/6] qla2xxx: Add FC-NVMe F/W initialization and transport
 registration
Date: Mon, 19 Jun 2017 18:52:02 +0000
Message-ID: <366EB2D1-6FA5-4944-A735-20E1A3C95250@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-4-himanshu.madhani@cavium.com>
 <20170619100135.GA19417@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:39360
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752353AbdFSSwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 14:52:07 -0400
In-Reply-To: <20170619100135.GA19417@linux-x5ow.site>
Content-Language: en-US
Content-ID: <E4D95C0FC472F6409EAFA2BBDE31B3E7@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>


> On Jun 19, 2017, at 3:01 AM, Johannes Thumshirn <jthumshirn@suse.de> wrot=
e:
>=20
> On Fri, Jun 16, 2017 at 03:47:41PM -0700, Himanshu Madhani wrote:
> [...]
>> /*
>> + * Global functions prototype in qla_nvme.c source file.
>> + */
>> +extern void qla_nvme_register_hba(scsi_qla_host_t *);
>> +extern int  qla_nvme_register_remote(scsi_qla_host_t *, fc_port_t *);
>> +extern void qla_nvme_delete(scsi_qla_host_t *);
>> +extern void qla_nvme_abort(struct qla_hw_data *, srb_t *sp);
>> +extern void qla_nvme_unregister_remote_port(struct work_struct *);
>> +extern int qla_nvme_wait_on_rport_del(fc_port_t *);
>> +extern void qla_nvme_abort_all(fc_port_t *);
>> +extern int qla_nvme_post_cmd(struct nvme_fc_local_port *,
>> +    struct nvme_fc_remote_port *, void *, struct nvmefc_fcp_req *);
>> +extern int qla_nvme_alloc_queue(struct nvme_fc_local_port *, unsigned i=
nt,
>> +    u16, void **);
>> +extern int qla_nvme_hba_scan(scsi_qla_host_t *);
>> +extern void qla_nvme_ls_abort(struct nvme_fc_local_port *,
>> +    struct nvme_fc_remote_port *, struct nvmefc_ls_req *);
>> +extern int qla_nvme_ls_req(struct nvme_fc_local_port *,
>> +    struct nvme_fc_remote_port *, struct nvmefc_ls_req *);
>> +extern void qla_nvme_poll(struct nvme_fc_local_port *, void *);
>> +extern int qla2x00_start_nvme_mq(srb_t *);
>> +extern void qla_nvme_fcp_abort(struct nvme_fc_local_port *,
>> +    struct nvme_fc_remote_port *, void *, struct nvmefc_fcp_req *);
>> +extern void qla24xx_nvme_ls4_iocb(scsi_qla_host_t *, struct pt_ls4_requ=
est *,
>> +    struct req_que *);
>=20
> Can't these go into a header instead of using extern?
>=20

Sure.

> [...]
>=20
>> @@ -4662,6 +4667,9 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
>> 			break;
>> 	} while (0);
>>=20
>> +	if ((!vha->nvme_local_port) && (vha->flags.nvme_enabled))
>=20
>=20
> [...]
>=20
>> +		if ((ql2xnvmeenable) && IS_QLA27XX(ha))
>> +			mcp->mb[4] |=3D NVME_ENABLE_FLAG;
>> +
>=20
> [...]
>=20
>> +
>> +		/* bit 26 of fw_attributes */
>> +		if ((ha->fw_attributes_h & 0x400) && (ql2xnvmeenable)) {
>=20
> Superfluous parenthesis.
>=20

Good catch. will fix in v2

> [...]
>=20
>> +			vha->flags.nvme_enabled =3D 1;
>> +			icb->firmware_options_2 &=3D
>> +			    cpu_to_le32(~(BIT_0 | BIT_1 | BIT_2 | BIT_3));
>=20
> 0xfffffff0 or maybe even ~0xf?
>=20

will fix in v2

> [...]
>=20
>> +	ret =3D nvme_fc_register_remoteport(vha->nvme_local_port, &rport->req,
>> +	    &fcport->nvme_remote_port);
>> +	if (ret) {
>> +		ql_log(ql_log_warn, vha, 0x212e,
>> +		    "Failed to register remote port. Transport returned %d\n",
>> +		    ret);
>> +		return ret;
>> +	}
>> +
>> +	fcport->nvme_remote_port->private =3D fcport;
>=20
> A FC-NVMe remote port can be in used right after a call to
> nvme_fc_register_remoteport(), if I'm not mistaken. So you should add the
> fcport to the nvme_remote_port->private _before_ calling
> nvme_fc_register_remoteport().

Will check this out.=20

>=20
>> +	fcport->nvme_flag |=3D NVME_FLAG_REGISTERED;
>> +	atomic_set(&fcport->nvme_ref_count, 1);
>> +	rport->fcport =3D fcport;
>> +	list_add_tail(&rport->list, &vha->nvme_rport_list);
>> +#endif
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Perform a scan and register those ports with FC-NVMe transport
>> + * input:  HBA handle
>> + */
>> +int qla_nvme_hba_scan(scsi_qla_host_t *vha)
>=20
> This should be bool.
>=20
>> +{
>> +#if (IS_ENABLED(CONFIG_NVME_FC))
>> +	fc_port_t	*fcport;
>> +	uint8_t not_found =3D 1;
>=20
> bool found =3D false;
>=20
>> +
>> +	/*
>> +	 * We are using the first HBA found
>> +	 * Find matching fcport
>> +	 */
>> +	list_for_each_entry(fcport, &vha->vp_fcports, list) {
>> +		if ((fcport->fc4f_nvme) &&
>> +		    (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))) {
>> +			qla_nvme_register_remote(vha, fcport);
>> +			not_found =3D 0;
>=20
> found =3D true;
>=20
>> +		}
>> +	}
>> +
>> +	return not_found;
>=20
> return found;
>=20
>> +#else
>> +	return 1;
>=20
> return false;
>=20
>> +#endif
>> +}
>=20
> And update the call-sites.
>=20

Ack.=20

> [...]
>=20
>> +	if (unlikely((nvme->u.nvme.comp_status) || res))
>=20
> Parenthesis again.
>=20

Ack.=20

> [...]
>=20
>> +void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
>> +    struct nvme_fc_remote_port *rport, struct nvmefc_ls_req *fd)
>> +{
>> +	struct nvme_private *priv =3D fd->private;
>> +	fc_port_t *fcport =3D rport->private;
>> +	srb_t *sp =3D priv->sp;
>> +	int rval;
>> +	struct qla_hw_data *ha;
>> +
>> +	ql_log(ql_log_info, fcport->vha, 0x212b,
>> +	    "%s: aborting sp:%p on fcport:%p\n", __func__, sp, fcport);
>> +
>> +	ha =3D fcport->vha->hw;
>> +	rval =3D ha->isp_ops->abort_command(sp);
>> +	if (rval !=3D QLA_SUCCESS)
>> +		ql_log(ql_log_warn, fcport->vha, 0x2125,
>> +		    "%s: failed to abort LS command for SP:%p rval=3D%x\n",
>> +		    __func__, sp, rval);
>> +}
>=20
> I think qla_nvme_ls_abort() is a bit too verbose, it nearly only consists=
 of
> logging and thus hides the call to abort_command() from the reader.
>=20

Sure. will make it more readable.


>> +
>> +static void qla_nvme_ls_complete(struct work_struct *work)
>> +{
>> +	struct nvme_private *priv =3D
>> +	    container_of(work, struct nvme_private, ls_work);
>> +	struct nvmefc_ls_req *fd =3D priv->fd;
>> +
>> +	(*fd->done)(fd, priv->comp_status);
>=20
> Can't we get the function pointer to done directly this LISP style doesn'=
t
> really look too nice;
>=20
> 	done(fd, priv->comp_status);=20
> or maybe
> 	fd->done(fd, priv->comp_status);
>=20

Sure. will fix this for v2.

>> +
>> +int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
>> +    struct nvme_fc_remote_port *rport, struct nvmefc_ls_req *fd)
>> +{
>> +	fc_port_t *fcport;
>> +	struct srb_iocb   *nvme;
>> +	struct scsi_qla_host *vha;
>> +	int     rval =3D QLA_FUNCTION_FAILED;
>> +	struct qla_hw_data *ha;
>> +	srb_t           *sp;
>> +	struct nvme_private *priv;
>> +
>> +	if (!fd) {
>> +		ql_log(ql_log_warn, NULL, 0x2135, "NO NVMe FCP reqeust\n");
>> +		return rval;
>> +	}
>=20
> Just curious, how likely is this? I.e. have you hit the case in debugging=
?
>=20

Defensive coding. This can be removed.=20

>> +
>> +	priv =3D fd->private;
>> +	fcport =3D (fc_port_t *)rport->private;
>> +	if (!fcport) {
>> +		ql_log(ql_log_warn, NULL, 0x212c,
>> +		    "%s: No fcport ptr\n", __func__);
>> +		return rval;
>> +	}
>=20
> Same here.
>=20
> [...]
>=20
>> +
>> +void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
>> +    struct nvme_fc_remote_port *rport, void *hw_queue_handle,
>> +    struct nvmefc_fcp_req *fd)
>=20
> The comment from the other abort function above applies here as well.
>=20

Ack.

>> +void qla_nvme_poll(struct nvme_fc_local_port *lport, void *hw_queue_han=
dle)
>> +{
>> +	struct scsi_qla_host *vha =3D lport->private;
>> +	unsigned long flags;
>> +	struct qla_qpair *qpair =3D (struct qla_qpair *)hw_queue_handle;
>> +
>> +	/* Acquire ring specific lock */
>> +	spin_lock_irqsave(&qpair->qp_lock, flags);
>> +	qla24xx_process_response_queue(vha, qpair->rsp);
>> +	spin_unlock_irqrestore(&qpair->qp_lock, flags);
>=20
> Just a side note, I _think_ needing a spin_lock here is a design issue.
>=20
>> +	/* Acquire qpair specific lock */
>> +	spin_lock_irqsave(&qpair->qp_lock, flags);
>=20
> Same here. What is this lock protecting? I see qla_qpair does have a
> reference count (not kref backed btw), so if you're only protecting
> against the structure vanishing under your feet, you could change
> this to krefs. If you're protecting structure members the use of RCUs
> spring to mind. rwlocks as well, if the content that is protected is
> read-mostly. But please note, reworking this requires extensive testing. =
But a
> spin_lock_irqsave() in the I/O path raises a red-flag for me.
>=20

The lock here is protecting hardware queue resource of qla2xxx driver.

> [...]
>=20
>> +
>> +static void qla_nvme_localport_delete(struct nvme_fc_local_port *lport)
>> +{
>> +	struct scsi_qla_host *vha =3D lport->private;
>> +
>> +	ql_log(ql_log_info, vha, 0x210f,
>> +	    "localport delete of %p completed.\n", vha->nvme_local_port);
>> +
>> +	vha->nvme_local_port =3D NULL;
>> +	atomic_dec(&vha->nvme_ref_count);
>=20
> Nit, the debug message says completed, but you haven't "completed" the de=
lete
> ;-).
>=20

:) good catch again=20

>> +}
>> +
>> +static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rpor=
t)
>> +{
>> +	fc_port_t *fcport;
>> +	struct nvme_rport *r_port, *trport;
>> +
>> +	fcport =3D (fc_port_t *)rport->private;
>> +	fcport->nvme_remote_port =3D NULL;
>> +	fcport->nvme_flag &=3D ~NVME_FLAG_REGISTERED;
>> +	atomic_dec(&fcport->nvme_ref_count);
>> +
>> +	ql_log(ql_log_info, fcport->vha, 0x2110,
>> +	    "remoteport_delete of %p completed.\n", fcport);
>> +
>> +	list_for_each_entry_safe(r_port, trport,
>> +	    &fcport->vha->nvme_rport_list, list) {
>> +		if (r_port->fcport =3D=3D fcport) {
>> +			list_del(&r_port->list);
>> +			break;
>> +		}
>> +	}
>> +	kfree(r_port);
>=20
> Ditto.
>=20

:) Ack

> [..]
>=20
>> +static int qla_nvme_wait_on_command(srb_t *sp)
>> +{
>> +#define NVME_ABORT_POLLING_PERIOD    1000
>> +#define NVME_ABORT_WAIT_ITER         ((2 * 1000) / (NVME_ABORT_POLLING_=
PERIOD))
>> +	unsigned long wait_iter =3D NVME_ABORT_WAIT_ITER;
>> +	int ret =3D QLA_SUCCESS;
>> +
>> +	while ((atomic_read(&sp->ref_count) > 1) && wait_iter--)
>> +		msleep(NVME_ABORT_POLLING_PERIOD);
>> +
>> +	if (atomic_read(&sp->ref_count) > 1)
>> +		ret =3D QLA_FUNCTION_FAILED;
>> +
>> +	return ret;
>=20
> wait_event_timeout()?
>=20
will fix up in v2

>> +int qla_nvme_wait_on_rport_del(fc_port_t *fcport)
>> +{
>> +	unsigned long wait_iter =3D NVME_ABORT_WAIT_ITER;
>> +	int ret =3D QLA_SUCCESS;
>> +
>> +	while (atomic_read(&fcport->nvme_ref_count) && wait_iter--)
>> +		msleep(NVME_ABORT_POLLING_PERIOD);
>=20
> Ditto.
>=20

Ack

> [...]
>=20
>> +void qla_nvme_abort(struct qla_hw_data *ha, srb_t *sp)
>> +{
>> +	int rval;
>> +
>> +	rval =3D ha->isp_ops->abort_command(sp);
>> +	if (!rval) {
>=20
> 	if (!rval && !qla_nvme_wait_on_command(sp))
> 		ql_log(ql_log_warn, NULL, 0x2112,
> 			"nvme_wait_on_comand timed out waiting on sp=3D%p\n",
> 			sp);
>=20
> [...]
>=20
>=20
>=20
>=20
>> +			fcport =3D rport->fcport;
>> +			ql_log(ql_log_info, fcport->vha, 0x2114,
>> +			    "%s: fcport=3D%p\n", __func__, fcport);
>> +			nvme_fc_unregister_remoteport(
>> +			    fcport->nvme_remote_port);
>> +			qla_nvme_wait_on_rport_del(fcport);
>> +			qla_nvme_abort_all(fcport);
>> +		}
>> +	}
>> +
>> +	if (vha->nvme_local_port) {
>> +		ql_log(ql_log_info, vha, 0x2115,
>> +		    "unregister localport =3D %p\n", vha->nvme_local_port);
>> +		nvme_fc_unregister_localport(vha->nvme_local_port);
>> +	}
>> +
>> +	while (atomic_read(&vha->nvme_ref_count))
>> +		schedule();
>=20
> Ugh..., no!
> wait_event()?
>=20

Ack. will fix up in v2

> [...]
>=20
>> +
>> +	ret =3D nvme_fc_register_localport(&pinfo, tmpl,
>> +	    get_device(&ha->pdev->dev), &vha->nvme_local_port);
>=20
> [...]
>=20
>> +	vha->nvme_local_port->private =3D vha;
>=20
> Please move above the nvme_fc_register_localport().
>=20
> [...]
>=20
>> +#if (IS_ENABLED(CONFIG_NVME_FC))
>> +int ql2xnvmeenable =3D 1;
>> +#else
>> +int ql2xnvmeenable;
>> +#endif
>> +module_param(ql2xnvmeenable, int, 0644);
>> +MODULE_PARM_DESC(ql2xnvmeenable,
>> +    "Enables NVME support"
>> +    "0 - no NVMe. Default is N");
>> +
>=20
> The message is a bit misleading. NVMe is enabled *IFF* CONFIG_NVME_FC is
> enabled.
>=20

Will fix up in v2.

> --=20
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Thanks,
- Himanshu
