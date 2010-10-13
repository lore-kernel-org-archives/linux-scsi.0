From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] Check return value of fc_block_scsi_eh()
Date: Wed, 13 Oct 2010 15:30:41 +0200
Message-ID: <20101013133041.GA14753@schmichrtp.mainz.de.ibm.com>
References: <20101013114228.96669354D8@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:33404 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0JMNao (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2010 09:30:44 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.1/8.13.1) with ESMTP id o9DDUg5d000860
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 13:30:42 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9DDUgKg4132886
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 15:30:42 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o9DDUf9w023353
	for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2010 15:30:42 +0200
Content-Disposition: inline
In-Reply-To: <20101013114228.96669354D8@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Wed, Oct 13, 2010 at 01:42:28PM +0200, Hannes Reinecke wrote:
>=20
> fc_block_scsi_eh() might return with status FAST_IO_FAIL
> indicating I/O has been terminated due to fast_io_fail timeout.
> In this case the rport is still blocked, so any error recovery
> will be failing on this port.
> Hence each driver needs to check if the return value from
> fc_block_scsi_eh() is something other than SUCCESS, in which
> case it should just return with that status.
> And we need to update the error handler to deal with a
> status of FAST_IO_FAIL, too.
> And fc_block_scsi_eh() should return SUCCESS on success,
> not 0. Otherwise the calling routine will become confused
> when reusing that value.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Smart <james.smart@emulex.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
> Cc: Abhijeet Joglekar <abjoglek@cisco.com>
>=20
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_s=
csi.c
> index ae10883..d5f8b90 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -199,7 +199,7 @@ static int zfcp_scsi_eh_abort_handler(struct scsi=
_cmnd *scpnt)
>=20
>  		zfcp_erp_wait(adapter);
>  		ret =3D fc_block_scsi_eh(scpnt);
> -		if (ret)
> +		if (ret !=3D SUCCESS)
>  			return ret;
>  		if (!(atomic_read(&adapter->status) &
>  		      ZFCP_STATUS_COMMON_RUNNING)) {
> @@ -241,7 +241,7 @@ static int zfcp_task_mgmt_function(struct scsi_cm=
nd *scpnt, u8 tm_flags)
>=20
>  		zfcp_erp_wait(adapter);
>  		ret =3D fc_block_scsi_eh(scpnt);
> -		if (ret)
> +		if (ret !=3D SUCCESS)
>  			return ret;
>=20
>  		if (!(atomic_read(&adapter->status) &

When fc_block_scsi_eh returns SUCCESS, the two functions above could
reuse the retval variable and get rid of ret.

> @@ -283,11 +283,7 @@ static int zfcp_scsi_eh_host_reset_handler(struc=
t scsi_cmnd *scpnt)
>=20
>  	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
>  	zfcp_erp_wait(adapter);
> -	ret =3D fc_block_scsi_eh(scpnt);
> -	if (ret)
> -		return ret;
> -
> -	return SUCCESS;
> +	return fc_block_scsi_eh(scpnt);
>  }
>=20
>  int zfcp_adapter_scsi_register(struct zfcp_adapter *adapter)

This results in:
drivers/s390/scsi/zfcp_scsi.c: In function =E2=80=98zfcp_scsi_eh_host_r=
eset_handler=E2=80=99:
drivers/s390/scsi/zfcp_scsi.c:282: warning: unused variable =E2=80=98re=
t=E2=80=99

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_s=
csi.c
> index 198cbab..8d797a6 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1240,7 +1240,9 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
>=20
>  	/* Wait for rport to unblock */
> -	fc_block_scsi_eh(sc);
> +	ret =3D fc_block_scsi_eh(sc);
> +	if (ret !=3D SUCCESS)
> +		return ret;
>=20
>  	/* Get local-port, check ready and link up */
>  	lp =3D shost_priv(sc->device->host);
> @@ -1512,13 +1514,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	struct fnic_io_req *io_req;
>  	struct fc_rport *rport;
>  	int status;
> -	int ret =3D FAILED;
> +	int ret;
>  	spinlock_t *io_lock;
>  	unsigned long flags;
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
>=20
>  	/* Wait for rport to unblock */
> -	fc_block_scsi_eh(sc);
> +	ret =3D fc_block_scsi_eh(sc);
> +	if (ret !=3D SUCCESS)
> +		return ret;
>=20
>  	/* Get local-port, check ready and link up */
>  	lp =3D shost_priv(sc->device->host);
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/i=
bmvfc.c
> index 00d08b2..a270a00 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2360,17 +2360,21 @@ static int ibmvfc_eh_abort_handler(struct scs=
i_cmnd *cmd)
>  	struct scsi_device *sdev =3D cmd->device;
>  	struct ibmvfc_host *vhost =3D shost_priv(sdev->host);
>  	int cancel_rc, abort_rc;
> -	int rc =3D FAILED;
> +	int rc;
>=20
>  	ENTER;
> -	fc_block_scsi_eh(cmd);
> +	rc =3D fc_block_scsi_eh(cmd);
> +	if (rc !=3D SUCCESS)
> +		goto leave;
>  	ibmvfc_wait_while_resetting(vhost);
>  	cancel_rc =3D ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
>  	abort_rc =3D ibmvfc_abort_task_set(sdev);
>=20
>  	if (!cancel_rc && !abort_rc)
>  		rc =3D ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
> -
> +	else
> +		rc =3D FAILED;
> +leave:
>  	LEAVE;
>  	return rc;
>  }
> @@ -2387,17 +2391,21 @@ static int ibmvfc_eh_device_reset_handler(str=
uct scsi_cmnd *cmd)
>  	struct scsi_device *sdev =3D cmd->device;
>  	struct ibmvfc_host *vhost =3D shost_priv(sdev->host);
>  	int cancel_rc, reset_rc;
> -	int rc =3D FAILED;
> +	int rc;
>=20
>  	ENTER;
> -	fc_block_scsi_eh(cmd);
> +	rc =3D fc_block_scsi_eh(cmd);
> +	if (rc !=3D SUCCESS)
> +		goto leave;
>  	ibmvfc_wait_while_resetting(vhost);
>  	cancel_rc =3D ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
>  	reset_rc =3D ibmvfc_reset_device(sdev, IBMVFC_LUN_RESET, "LUN");
>=20
>  	if (!cancel_rc && !reset_rc)
>  		rc =3D ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
> -
> +	else
> +		rc =3D FAILED;
> +leave:
>  	LEAVE;
>  	return rc;
>  }
> @@ -2427,18 +2435,22 @@ static int ibmvfc_eh_target_reset_handler(str=
uct scsi_cmnd *cmd)
>  	struct ibmvfc_host *vhost =3D shost_priv(sdev->host);
>  	struct scsi_target *starget =3D scsi_target(sdev);
>  	int reset_rc;
> -	int rc =3D FAILED;
> +	int rc;
>  	unsigned long cancel_rc =3D 0;
>=20
>  	ENTER;
> -	fc_block_scsi_eh(cmd);
> +	rc =3D fc_block_scsi_eh(cmd);
> +	if (rc !=3D SUCCESS)
> +		goto leave;
>  	ibmvfc_wait_while_resetting(vhost);
>  	starget_for_each_device(starget, &cancel_rc, ibmvfc_dev_cancel_all_=
reset);
>  	reset_rc =3D ibmvfc_reset_device(sdev, IBMVFC_TARGET_RESET, "target=
");
>=20
>  	if (!cancel_rc && !reset_rc)
>  		rc =3D ibmvfc_wait_for_ops(vhost, starget, ibmvfc_match_target);
> -
> +	else
> +		rc =3D FAILED;
> +leave:
>  	LEAVE;
>  	return rc;
>  }
> @@ -2453,7 +2465,10 @@ static int ibmvfc_eh_host_reset_handler(struct=
 scsi_cmnd *cmd)
>  	int rc;
>  	struct ibmvfc_host *vhost =3D shost_priv(cmd->device->host);
>=20
> -	fc_block_scsi_eh(cmd);
> +	rc =3D fc_block_scsi_eh(cmd);
> +	if (rc !=3D SUCCESS)
> +		return rc;
> +
>  	dev_err(vhost->dev, "Resetting connection due to error recovery\n")=
;
>  	rc =3D ibmvfc_issue_fc_host_lip(vhost->host);
>  	return rc ? FAILED : SUCCESS;
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index 3a65895..c516ba8 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3080,7 +3080,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
>  	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
>=20
>  	ret =3D fc_block_scsi_eh(cmnd);
> -	if (ret)
> +	if (ret !=3D SUCCESS)
>  		return ret;
>  	lpfc_cmd =3D (struct lpfc_scsi_buf *)cmnd->host_scribble;
>  	if (!lpfc_cmd) {
> @@ -3407,7 +3407,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmn=
d)
>  	}
>  	pnode =3D rdata->pnode;
>  	status =3D fc_block_scsi_eh(cmnd);
> -	if (status)
> +	if (status !=3D SUCCESS)
>  		return status;
>=20
>  	status =3D lpfc_chk_tgt_mapped(vport, cmnd);
> @@ -3474,7 +3474,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmn=
d)
>  	}
>  	pnode =3D rdata->pnode;
>  	status =3D fc_block_scsi_eh(cmnd);
> -	if (status)
> +	if (status !=3D SUCCESS)
>  		return status;
>=20
>  	status =3D lpfc_chk_tgt_mapped(vport, cmnd);
> @@ -3542,7 +3542,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>  		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
>=20
>  	ret =3D fc_block_scsi_eh(cmnd);
> -	if (ret)
> +	if (ret !=3D SUCCESS)
>  		return ret;
>=20
>  	/*
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla=
_os.c
> index bdd53f0..75e7719 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -834,12 +834,12 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>  	srb_t *spt;
>  	int got_ref =3D 0;
>=20
> -	fc_block_scsi_eh(cmd);
> -
>  	if (!CMD_SP(cmd))
>  		return SUCCESS;
>=20
> -	ret =3D SUCCESS;
> +	ret =3D fc_block_scsi_eh(cmd);
> +	if (ret !=3D SUCCESS)
> +		return ret;
>=20
>  	id =3D cmd->device->id;
>  	lun =3D cmd->device->lun;
> @@ -966,11 +966,13 @@ __qla2xxx_eh_generic_reset(char *name, enum nex=
us_wait_type type,
>  	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
>  	int err;
>=20
> -	fc_block_scsi_eh(cmd);
> -
>  	if (!fcport)
>  		return FAILED;
>=20
> +	err =3D fc_block_scsi_eh(cmd);
> +	if (err !=3D SUCCESS)
> +		return err;
> +
>  	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET ISSUED.\n=
",
>  	    vha->host_no, cmd->device->id, cmd->device->lun, name);
>=20
> @@ -1045,8 +1047,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
>  	unsigned int id, lun;
>  	unsigned long serial;
>=20
> -	fc_block_scsi_eh(cmd);
> -
>  	id =3D cmd->device->id;
>  	lun =3D cmd->device->lun;
>  	serial =3D cmd->serial_number;
> @@ -1054,6 +1054,11 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
>  	if (!fcport)
>  		return ret;
>=20
> +	ret =3D fc_block_scsi_eh(cmd);
> +	if (ret !=3D SUCCESS)
> +		return ret;
> +	ret =3D FAILED;
> +
>  	qla_printk(KERN_INFO, vha->hw,
>  	    "scsi(%ld:%d:%d): BUS RESET ISSUED.\n", vha->host_no, id, lun);
>=20
> @@ -1107,8 +1112,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>  	unsigned long serial;
>  	scsi_qla_host_t *base_vha =3D pci_get_drvdata(ha->pdev);
>=20
> -	fc_block_scsi_eh(cmd);
> -
>  	id =3D cmd->device->id;
>  	lun =3D cmd->device->lun;
>  	serial =3D cmd->serial_number;
> @@ -1116,6 +1119,11 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
>  	if (!fcport)
>  		return ret;
>=20
> +	ret =3D fc_block_scsi_eh(cmd);
> +	if (ret !=3D SUCCESS)
> +		return ret;
> +	ret =3D FAILED;
> +
>  	qla_printk(KERN_INFO, ha,
>  	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, l=
un);
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1de30eb..4279e7c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -655,11 +655,21 @@ static int scsi_try_to_abort_cmd(struct scsi_cm=
nd *scmd)
>=20
>  static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>  {
> -	if (__scsi_try_to_abort_cmd(scmd) !=3D SUCCESS)
> -		if (scsi_try_bus_device_reset(scmd) !=3D SUCCESS)
> -			if (scsi_try_target_reset(scmd) !=3D SUCCESS)
> -				if (scsi_try_bus_reset(scmd) !=3D SUCCESS)
> -					scsi_try_host_reset(scmd);
> +	int ret;
> +
> +	ret =3D __scsi_try_to_abort_cmd(scmd);
> +	if ((ret =3D=3D SUCCESS) || (ret =3D=3D FAST_IO_FAIL))
> +		return;
> +	ret =3D scsi_try_bus_device_reset(scmd);
> +	if ((ret =3D=3D SUCCESS) || (ret =3D=3D FAST_IO_FAIL))
> +		return;
> +	ret =3D scsi_try_target_reset(scmd);
> +	if ((ret =3D=3D SUCCESS) || (ret =3D=3D FAST_IO_FAIL))
> +		return;
> +	ret =3D scsi_try_bus_reset(scmd);
> +	if ((ret =3D=3D SUCCESS) || (ret =3D=3D FAST_IO_FAIL))
> +		return;
> +	scsi_try_host_reset(scmd);
>  }
>=20
>  /**
> @@ -958,6 +968,7 @@ retry_tur:
>  		if (retry_cnt--)
>  			goto retry_tur;
>  		/*FALLTHRU*/
> +	case FAST_IO_FAIL:
>  	case SUCCESS:
>  		return 0;
>  	default:
> @@ -1026,7 +1037,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *sc=
md)
>  		for (i =3D 0; rtn =3D=3D NEEDS_RETRY && i < 2; i++)
>  			rtn =3D scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->req=
uest_queue->rq_timeout, 0);
>=20
> -		if (rtn =3D=3D SUCCESS)
> +		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL)
>  			return 0;
>  	}
>=20
> @@ -1928,17 +1939,17 @@ scsi_reset_provider(struct scsi_device *dev, =
int flag)
>  	switch (flag) {
>  	case SCSI_TRY_RESET_DEVICE:
>  		rtn =3D scsi_try_bus_device_reset(scmd);
> -		if (rtn =3D=3D SUCCESS)
> +		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL)
>  			break;
>  		/* FALLTHROUGH */
>  	case SCSI_TRY_RESET_TARGET:
>  		rtn =3D scsi_try_target_reset(scmd);
> -		if (rtn =3D=3D SUCCESS)
> +		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL)
>  			break;
>  		/* FALLTHROUGH */
>  	case SCSI_TRY_RESET_BUS:
>  		rtn =3D scsi_try_bus_reset(scmd);
> -		if (rtn =3D=3D SUCCESS)
> +		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL)
>  			break;
>  		/* FALLTHROUGH */
>  	case SCSI_TRY_RESET_HOST:
> @@ -1966,7 +1977,7 @@ scsi_reset_provider(struct scsi_device *dev, in=
t flag)
>=20
>  	scsi_next_command(scmd);
>  	scsi_autopm_put_host(shost);
> -	return rtn;
> +	return (rtn =3D=3D FAST_IO_FAIL) ? SUCCESS : rtn;
>  }
>  EXPORT_SYMBOL(scsi_reset_provider);
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index 998c01b..fae5bcd 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3257,7 +3257,7 @@ fc_scsi_scan_rport(struct work_struct *work)
>   * necessary to avoid the scsi_eh failing recovery actions for block=
ed
>   * rports which would lead to offlined SCSI devices.
>   *
> - * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
> + * Returns: SUCCESS if the fc_rport left the state FC_PORTSTATE_BLOC=
KED.
>   *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
>   *	    passed back to scsi_eh.
>   */
> @@ -3279,7 +3279,7 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
>  	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
>  		return FAST_IO_FAIL;
>=20
> -	return 0;
> +	return SUCCESS;
>  }
>  EXPORT_SYMBOL(fc_block_scsi_eh);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
