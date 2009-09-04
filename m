From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: RE: [PATCH 04/10] drivers: convert fc drivers calling
 scsi_track_queue_full
Date: Fri, 04 Sep 2009 14:43:27 -0700
Message-ID: <1252100607.4516.35.camel@vi2.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
	 <20090903222247.24946.60577.stgit@vi1.jf.intel.com>
	 <412A05BA40734D4887DBC67661F433080FF72616@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934277AbZIDVn0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2009 17:43:26 -0400
In-Reply-To: <412A05BA40734D4887DBC67661F433080FF72616@EXMAIL.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex.Iannicelli@Emulex.Com, andrew.vasquez@qlogic.com, James.Bottomley@HansenPartnership.com
Cc: vasu.dev@intel.com, linux-scsi@vger.kernel.org, James.Smart@Emulex.Com, michaelc@cs.wisc.edu, robert.w.love@intel.com, christof.schmitt@de.ibm.com

On Fri, 2009-09-04 at 06:47 -0700, Alex.Iannicelli@Emulex.Com wrote:
> It looks like you moved the ramp up functionality into the scsi layer=
,
> but did not move the ramp up code from the lpfc driver in the

Correct.

>  lpfc_scsi_cmd_iocb_cmpl routine (just above the code that was remove=
d
> for the ramp down in this patch) to the new lpfc_change_queue_depth
> routine. I think that this new routine should handle both ramp up and
> ramp down but you have it only handling the ramp down case.
>=20

I agree all FC HBA should handle both ramp down and up as per added new
change_queue_depth interface by this series. I did this for libfc/fcoe
and Chrirstof did this for zfcp driver but lpfc & qla2xxx got only ramp
down changes from Mike, now that Mike is busy with other stuff I don't
know how to complete them in this series since I don't understand lpfc
and qla2xxx enough and neither I have way to test changes to these
drivers.

So I'm going to update this series to have just libfc and zfcp driver
changes for now and lpfc and qla2xxx can be updated later by someone
familiar lpfc and qla2xxx, their ramp down changes can be collect from
this series post.

	Thanks
	Vasu

> -Alex
>=20
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Vasu Dev
> > Sent: Thursday, September 03, 2009 6:23 PM
> > To: James Bottomley; linux-scsi@vger.kernel.org
> > Cc: Andrew Vasquez; Smart, James; Mike Christie; Robert Love; Chris=
tof
> > Schmitt
> > Subject: [PATCH 04/10] drivers: convert fc drivers calling
> > scsi_track_queue_full
> >=20
> > From: Mike Christie <michaelc@cs.wisc.edu>
> >=20
> > This converts the fc drivers that were using scsi_track_queue_full
> > to track the queue full from the change_queue_depth callback.
> >=20
> > I have not yet tested the qla2xxx or lpfc parts.
> >=20
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> >=20
> > --
> > Adds check to ignore SCSI_QDEPTH_QFULL in case the
> > ql2xqfulltracking is not set.
> > Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> > ---
> >=20
> >  drivers/scsi/libfc/fc_fcp.c    |   26 +++++---------
> >  drivers/scsi/lpfc/lpfc_scsi.c  |   75 ++++++++++++++++++++++------=
----
> > --------
> >  drivers/scsi/qla2xxx/qla_isr.c |   32 -----------------
> >  drivers/scsi/qla2xxx/qla_os.c  |   30 ++++++++++++++--
> >  4 files changed, 77 insertions(+), 86 deletions(-)
> >=20
> > diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fc=
p.c
> > index 20b88cd..d919c2a 100644
> > --- a/drivers/scsi/libfc/fc_fcp.c
> > +++ b/drivers/scsi/libfc/fc_fcp.c
> > @@ -1814,21 +1814,6 @@ static void fc_io_compl(struct fc_fcp_pkt *f=
sp)
> >  			sc_cmd->result =3D DID_OK << 16;
> >  			if (fsp->scsi_resid)
> >  				CMD_RESID_LEN(sc_cmd) =3D fsp->scsi_resid;
> > -		} else if (fsp->cdb_status =3D=3D QUEUE_FULL) {
> > -			struct scsi_device *tmp_sdev;
> > -			struct scsi_device *sdev =3D sc_cmd->device;
> > -
> > -			shost_for_each_device(tmp_sdev, sdev->host) {
> > -				if (tmp_sdev->id !=3D sdev->id)
> > -					continue;
> > -
> > -				if (tmp_sdev->queue_depth > 1) {
> > -					scsi_track_queue_full(tmp_sdev,
> > -							      tmp_sdev->
> > -							      queue_depth - 1);
> > -				}
> > -			}
> > -			sc_cmd->result =3D (DID_OK << 16) | fsp->cdb_status;
> >  		} else {
> >  			/*
> >  			 * transport level I/O was ok but scsi
> > @@ -2064,9 +2049,16 @@ EXPORT_SYMBOL(fc_slave_alloc);
> >=20
> >  int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, in=
t
> > reason)
> >  {
> > -	if (reason !=3D SCSI_QDEPTH_DEFAULT)
> > +	switch (reason) {
> > +	case SCSI_QDEPTH_DEFAULT:
> > +		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> > qdepth);
> > +		break;
> > +	case SCSI_QDEPTH_QFULL:
> > +		scsi_track_queue_full(sdev, qdepth);
> > +		break;
> > +	default:
> >  		return -EOPNOTSUPP;
> > -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> > +	}
> >  	return sdev->queue_depth;
> >  }
> >  EXPORT_SYMBOL(fc_change_queue_depth);
> > diff --git a/drivers/scsi/lpfc/lpfc_scsi.c
> > b/drivers/scsi/lpfc/lpfc_scsi.c
> > index 61d0897..2d39d84 100644
> > --- a/drivers/scsi/lpfc/lpfc_scsi.c
> > +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> > @@ -2189,7 +2189,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba=
,
> > struct lpfc_iocbq *pIocbIn,
> >  	struct scsi_cmnd *cmd =3D lpfc_cmd->pCmd;
> >  	int result;
> >  	struct scsi_device *tmp_sdev;
> > -	int depth =3D 0;
> >  	unsigned long flags;
> >  	struct lpfc_fast_path_event *fast_path_evt;
> >  	struct Scsi_Host *shost =3D cmd->device->host;
> > @@ -2388,39 +2387,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phb=
a,
> > struct lpfc_iocbq *pIocbIn,
> >  	}
> >=20
>=20
> The code just above this area should be moved into the lpfc_change_qu=
eue_depth routine.
>=20
> >  	/*
> > -	 * Check for queue full.  If the lun is reporting queue full,
> > then
> > -	 * back off the lun queue depth to prevent target overloads.
> > -	 */
> > -	if (result =3D=3D SAM_STAT_TASK_SET_FULL && pnode &&
> > -	    NLP_CHK_NODE_ACT(pnode)) {
> > -		pnode->last_q_full_time =3D jiffies;
> > -
> > -		shost_for_each_device(tmp_sdev, shost) {
> > -			if (tmp_sdev->id !=3D scsi_id)
> > -				continue;
> > -			depth =3D scsi_track_queue_full(tmp_sdev,
> > -					tmp_sdev->queue_depth - 1);
> > -		}
> > -		/*
> > -		 * The queue depth cannot be lowered any more.
> > -		 * Modify the returned error code to store
> > -		 * the final depth value set by
> > -		 * scsi_track_queue_full.
> > -		 */
> > -		if (depth =3D=3D -1)
> > -			depth =3D shost->cmd_per_lun;
> > -
> > -		if (depth) {
> > -			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> > -					 "0711 detected queue full - lun queue "
> > -					 "depth adjusted to %d.\n", depth);
> > -			lpfc_send_sdev_queuedepth_change_event(phba, vport,
> > -				pnode, 0xFFFFFFFF,
> > -				depth+1, depth);
> > -		}
> > -	}
> > -
> > -	/*
> >  	 * If there is a thread waiting for command completion
> >  	 * wake up the thread.
> >  	 */
> > @@ -3551,6 +3517,45 @@ lpfc_slave_configure(struct scsi_device *sde=
v)
> >  	return 0;
> >  }
> >=20
> > +static int lpfc_change_queue_depth(struct scsi_device *sdev, int
> > queue_depth,
> > +				   int reason)
> > +{
> > +	struct Scsi_Host *shost =3D sdev->host;
> > +	struct lpfc_vport *vport =3D (struct lpfc_vport *) shost->hostdat=
a;
> > +	struct lpfc_hba *phba =3D vport->phba;
> > +	struct lpfc_rport_data *rdata =3D sdev->hostdata;
> > +	struct lpfc_nodelist *pnode =3D rdata->pnode;
> > +	int depth;
> > +
> > +	if (reason !=3D SCSI_QDEPTH_QFULL)
> > +		return -EOPNOTSUPP;
>=20
> This should handle qfull(ramp up) and ramp down.
>=20
> > +
> > +	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
> > +		return -EINVAL;
> > +
> > +	pnode->last_q_full_time =3D jiffies;
> > +
> > +	depth =3D scsi_track_queue_full(sdev, queue_depth);
> > +	/*
> > +	 * The queue depth cannot be lowered any more.
> > +	 * Modify the returned error code to store
> > +	 * the final depth value set by
> > +	 * scsi_track_queue_full.
> > +	 */
> > +	if (depth =3D=3D -1)
> > +		depth =3D shost->cmd_per_lun;
> > +
> > +	if (depth) {
> > +		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
> > +				 "0711 detected queue full - lun queue "
> > +				 "depth adjusted to %d.\n", depth);
> > +		lpfc_send_sdev_queuedepth_change_event(phba, vport,
> > +						       pnode, 0xFFFFFFFF,
> > +						       depth + 1, depth);
> > +	}
> > +	return sdev->queue_depth;
> > +}
> > +
> >  /**
> >   * lpfc_slave_destroy - slave_destroy entry point of SHT data
> > structure
> >   * @sdev: Pointer to scsi_device.
> > @@ -3574,6 +3579,7 @@ struct scsi_host_template lpfc_template =3D {
> >  	.eh_device_reset_handler =3D lpfc_device_reset_handler,
> >  	.eh_target_reset_handler =3D lpfc_target_reset_handler,
> >  	.eh_bus_reset_handler	=3D lpfc_bus_reset_handler,
> > +	.change_queue_depth	=3D lpfc_change_queue_depth,
> >  	.slave_alloc		=3D lpfc_slave_alloc,
> >  	.slave_configure	=3D lpfc_slave_configure,
> >  	.slave_destroy		=3D lpfc_slave_destroy,
> > @@ -3596,6 +3602,7 @@ struct scsi_host_template lpfc_vport_template=
 =3D {
> >  	.eh_device_reset_handler =3D lpfc_device_reset_handler,
> >  	.eh_target_reset_handler =3D lpfc_target_reset_handler,
> >  	.eh_bus_reset_handler	=3D lpfc_bus_reset_handler,
> > +	.change_queue_depth	=3D lpfc_change_queue_depth,
> >  	.slave_alloc		=3D lpfc_slave_alloc,
> >  	.slave_configure	=3D lpfc_slave_configure,
> >  	.slave_destroy		=3D lpfc_slave_destroy,
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> > b/drivers/scsi/qla2xxx/qla_isr.c
> > index 74fa6f9..66fda3a 100644
> > --- a/drivers/scsi/qla2xxx/qla_isr.c
> > +++ b/drivers/scsi/qla2xxx/qla_isr.c
> > @@ -836,20 +836,6 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_devi=
ce
> > *sdev, void *data)
> >  	    sdev->queue_depth));
> >  }
> >=20
> > -static void
> > -qla2x00_adjust_sdev_qdepth_down(struct scsi_device *sdev, void *da=
ta)
> > -{
> > -	fc_port_t *fcport =3D data;
> > -
> > -	if (!scsi_track_queue_full(sdev, sdev->queue_depth - 1))
> > -		return;
> > -
> > -	DEBUG2(qla_printk(KERN_INFO, fcport->vha->hw,
> > -	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
> > -	    fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
> > -	    sdev->queue_depth));
> > -}
> > -
> >  static inline void
> >  qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, struct req_que *=
req,
> >  								srb_t *sp)
> > @@ -1176,13 +1162,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha,
> > struct rsp_que *rsp, void *pkt)
> >  			    "scsi(%ld): QUEUE FULL status detected "
> >  			    "0x%x-0x%x.\n", vha->host_no, comp_status,
> >  			    scsi_status));
> > -
> > -			/* Adjust queue depth for all luns on the port. */
> > -			if (!ql2xqfulltracking)
> > -				break;
> > -			fcport->last_queue_full =3D jiffies;
> > -			starget_for_each_device(cp->device->sdev_target,
> > -			    fcport, qla2x00_adjust_sdev_qdepth_down);
> >  			break;
> >  		}
> >  		if (lscsi_status !=3D SS_CHECK_CONDITION)
> > @@ -1233,17 +1212,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha,
> > struct rsp_que *rsp, void *pkt)
> >  				    "scsi(%ld): QUEUE FULL status detected "
> >  				    "0x%x-0x%x.\n", vha->host_no, comp_status,
> >  				    scsi_status));
> > -
> > -				/*
> > -				 * Adjust queue depth for all luns on the
> > -				 * port.
> > -				 */
> > -				if (!ql2xqfulltracking)
> > -					break;
> > -				fcport->last_queue_full =3D jiffies;
> > -				starget_for_each_device(
> > -				    cp->device->sdev_target, fcport,
> > -				    qla2x00_adjust_sdev_qdepth_down);
> >  				break;
> >  			}
> >  			if (lscsi_status !=3D SS_CHECK_CONDITION)
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c
> > b/drivers/scsi/qla2xxx/qla_os.c
> > index c05c460..9652aac 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -1222,12 +1222,36 @@ qla2xxx_slave_destroy(struct scsi_device *s=
dev)
> >  	sdev->hostdata =3D NULL;
> >  }
> >=20
> > +static void qla2x00_handle_queue_full(struct scsi_device *sdev, in=
t
> > qdepth)
> > +{
> > +	fc_port_t *fcport =3D (struct fc_port *) sdev->hostdata;
> > +
> > +	fcport->last_queue_full =3D jiffies;
> > +
> > +	if (!scsi_track_queue_full(sdev, qdepth))
> > +		return;
> > +
> > +	DEBUG2(qla_printk(KERN_INFO, fcport->vha->hw,
> > +		"scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
> > +		fcport->vha->host_no, sdev->channel, sdev->id, sdev->lun,
> > +		sdev->queue_depth));
> > +}
> > +
> >  static int
> >  qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth, i=
nt
> > reason)
> >  {
> > -	if (reason !=3D SCSI_QDEPTH_DEFAULT)
> > -		return -EOPNOTSUPP;
> > -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> > +	switch (reason) {
> > +	case SCSI_QDEPTH_DEFAULT:
> > +		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> > qdepth);
> > +		break;
> > +	case SCSI_QDEPTH_QFULL:
> > +		if (!ql2xqfulltracking)
> > +			qla2x00_handle_queue_full(sdev, qdepth);
> > +		break;
> > +	default:
> > +		return EOPNOTSUPP;
> > +	}
> > +
> >  	return sdev->queue_depth;
> >  }
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j=07fhz=1Ew=0Cj:+vwjm=07=
zZ+=DD=A2j"!

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
