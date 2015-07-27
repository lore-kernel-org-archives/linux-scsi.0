From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/8] qla2xxx: kill sessions/log out initiator on RSCN
 and port down events
Date: Mon, 27 Jul 2015 10:09:09 +0200
Message-ID: <55B5E725.4020502@suse.de>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com> <1436904049-27707-2-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbbG0IJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2015 04:09:12 -0400
In-Reply-To: <1436904049-27707-2-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 07/14/2015 10:00 PM, Himanshu Madhani wrote:
> From: Roland Dreier <roland@purestorage.com>
>=20
> To fix some issues talking to ESX, this patch modifies the qla2xxx dr=
iver
> so that it never logs into remote ports.  This has the side effect of
> getting rid of the "rports" entirely, which means we never log out of
> initiators and never tear down sessions when an initiator goes away.
>=20
> This is mostly OK, except that we can run into trouble if we have
> initiator A assigned FC address X:Y:Z by the fabric talking to us, an=
d
> then initiator A goes away.  Some time (could be a long time) later,
> initiator B comes along and also gets FC address X:Y:Z (which is
> available again, because initiator A is gone).  If initiator B starts
> talking to us, then we'll still have the session for initiator A, and
> since we look up incoming IO based on the FC address X:Y:Z, initiator=
 B
> will end up using ACLs for initiator A.
>=20
> Fix this by:
>=20
>  1. Handling RSCN events somewhat differently; instead of completely
>     skipping the processing of fcports, we look through the list, and=
 if
>     an fcport disappears, we tell the target code the tear down the
>     session and tell the HBA FW to release the N_Port handle.
>=20
>  2. Handling "port down" events by flushing all of our sessions.  The
>     firmware was already releasing the N_Port handle but we want the
>     target code to drop all the sessions too.
>=20
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
> Acked-by: Quinn Tran <quinn.tran@qlogic.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c    |    2 +-
>  drivers/scsi/qla2xxx/qla_init.c   |  137 +++++++++++++++++++++++++++=
+++-------
>  drivers/scsi/qla2xxx/qla_target.c |    9 ++-
>  3 files changed, 117 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/ql=
a_dbg.c
> index 0e6ee3c..e9ae6b9 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -68,7 +68,7 @@
>   * |                              |                    | 0xd101-0xd1=
fe	|
>   * |                              |                    | 0xd214-0xd2=
fe	|
>   * | Target Mode		  |	  0xe079       |		|
> - * | Target Mode Management	  |	  0xf072       | 0xf002		|
> + * | Target Mode Management	  |	  0xf080       | 0xf002		|
>   * |                              |                    | 0xf046-0xf0=
49  |
>   * | Target Mode Task Management  |	  0x1000b      |		|
>   * -----------------------------------------------------------------=
-----
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/q=
la_init.c
> index 766fdfc..4895a4a 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -3462,20 +3462,43 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha=
)
>  			if ((fcport->flags & FCF_FABRIC_DEVICE) =3D=3D 0)
>  				continue;
> =20
> -			if (fcport->scan_state =3D=3D QLA_FCPORT_SCAN &&
> -			    atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> -				qla2x00_mark_device_lost(vha, fcport,
> -				    ql2xplogiabsentdevice, 0);
> -				if (fcport->loop_id !=3D FC_NO_LOOP_ID &&
> -				    (fcport->flags & FCF_FCP2_DEVICE) =3D=3D 0 &&
> -				    fcport->port_type !=3D FCT_INITIATOR &&
> -				    fcport->port_type !=3D FCT_BROADCAST) {
> -					ha->isp_ops->fabric_logout(vha,
> -					    fcport->loop_id,
> -					    fcport->d_id.b.domain,
> -					    fcport->d_id.b.area,
> -					    fcport->d_id.b.al_pa);
> -					qla2x00_clear_loop_id(fcport);
> +			if (fcport->scan_state =3D=3D QLA_FCPORT_SCAN) {
> +				if (qla_ini_mode_enabled(base_vha) &&
> +				    atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> +					qla2x00_mark_device_lost(vha, fcport,
> +					    ql2xplogiabsentdevice, 0);
> +					if (fcport->loop_id !=3D FC_NO_LOOP_ID &&
> +					    (fcport->flags & FCF_FCP2_DEVICE) =3D=3D 0 &&
> +					    fcport->port_type !=3D FCT_INITIATOR &&
> +					    fcport->port_type !=3D FCT_BROADCAST) {
> +						ha->isp_ops->fabric_logout(vha,
> +						    fcport->loop_id,
> +						    fcport->d_id.b.domain,
> +						    fcport->d_id.b.area,
> +						    fcport->d_id.b.al_pa);
> +						qla2x00_clear_loop_id(fcport);
> +					}
> +				} else if (!qla_ini_mode_enabled(base_vha)) {
> +					/*
> +					 * In target mode, explicitly kill
> +					 * sessions and log out of devices
> +					 * that are gone, so that we don't
> +					 * end up with an initiator using the
> +					 * wrong ACL (if the fabric recycles
> +					 * an FC address and we have a stale
> +					 * session around) and so that we don't
> +					 * report initiators that are no longer
> +					 * on the fabric.
> +					 */
> +					ql_dbg(ql_dbg_tgt_mgt, vha, 0xf077,
> +					    "port gone, logging out/killing session: "
> +					    "%8phC state 0x%x flags 0x%x fc4_type 0x%x "
> +					    "scan_state %d\n",
> +					    fcport->port_name,
> +					    atomic_read(&fcport->state),
> +					    fcport->flags, fcport->fc4_type,
> +					    fcport->scan_state);
> +					qlt_fc_port_deleted(vha, fcport);
>  				}
>  			}
>  		}
> @@ -3496,6 +3519,28 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
>  			    (fcport->flags & FCF_LOGIN_NEEDED) =3D=3D 0)
>  				continue;
> =20
> +			/*
> +			 * If we're not an initiator, skip looking for devices
> +			 * and logging in.  There's no reason for us to do it,
> +			 * and it seems to actively cause problems in target
> +			 * mode if we race with the initiator logging into us
> +			 * (we might get the "port ID used" status back from
> +			 * our login command and log out the initiator, which
> +			 * seems to cause havoc).
> +			 */
> +			if (!qla_ini_mode_enabled(base_vha)) {
> +				if (fcport->scan_state =3D=3D QLA_FCPORT_FOUND) {
> +					ql_dbg(ql_dbg_tgt_mgt, vha, 0xf078,
> +					    "port %8phC state 0x%x flags 0x%x fc4_type 0x%x "
> +					    "scan_state %d (initiator mode disabled; skipping "
> +					    "login)\n", fcport->port_name,
> +					    atomic_read(&fcport->state),
> +					    fcport->flags, fcport->fc4_type,
> +					    fcport->scan_state);
> +				}
> +				continue;
> +			}
> +
>  			if (fcport->loop_id =3D=3D FC_NO_LOOP_ID) {
>  				fcport->loop_id =3D next_loopid;
>  				rval =3D qla2x00_find_new_loop_id(
> @@ -3522,16 +3567,38 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha=
)
>  			    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
>  				break;
> =20
> -			/* Find a new loop ID to use. */
> -			fcport->loop_id =3D next_loopid;
> -			rval =3D qla2x00_find_new_loop_id(base_vha, fcport);
> -			if (rval !=3D QLA_SUCCESS) {
> -				/* Ran out of IDs to use */
> -				break;
> -			}
> +			/*
> +			 * If we're not an initiator, skip looking for devices
> +			 * and logging in.  There's no reason for us to do it,
> +			 * and it seems to actively cause problems in target
> +			 * mode if we race with the initiator logging into us
> +			 * (we might get the "port ID used" status back from
> +			 * our login command and log out the initiator, which
> +			 * seems to cause havoc).
> +			 */
> +			if (qla_ini_mode_enabled(base_vha)) {
> +				/* Find a new loop ID to use. */
> +				fcport->loop_id =3D next_loopid;
> +				rval =3D qla2x00_find_new_loop_id(base_vha,
> +				    fcport);
> +				if (rval !=3D QLA_SUCCESS) {
> +					/* Ran out of IDs to use */
> +					break;
> +				}
> =20
> -			/* Login and update database */
> -			qla2x00_fabric_dev_login(vha, fcport, &next_loopid);
> +				/* Login and update database */
> +				qla2x00_fabric_dev_login(vha, fcport,
> +				    &next_loopid);
> +			} else {
> +				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf079,
> +					"new port %8phC state 0x%x flags 0x%x fc4_type "
> +					"0x%x scan_state %d (initiator mode disabled; "
> +					"skipping login)\n",
> +					fcport->port_name,
> +					atomic_read(&fcport->state),
> +					fcport->flags, fcport->fc4_type,
> +					fcport->scan_state);
> +			}
> =20
>  			list_move_tail(&fcport->list, &vha->vp_fcports);
>  		}
> @@ -3727,11 +3794,12 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t =
*vha,
>  			fcport->fp_speed =3D new_fcport->fp_speed;
> =20
>  			/*
> -			 * If address the same and state FCS_ONLINE, nothing
> -			 * changed.
> +			 * If address the same and state FCS_ONLINE
> +			 * (or in target mode), nothing changed.
>  			 */
>  			if (fcport->d_id.b24 =3D=3D new_fcport->d_id.b24 &&
> -			    atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> +			    (atomic_read(&fcport->state) =3D=3D FCS_ONLINE ||
> +			     !qla_ini_mode_enabled(base_vha))) {
>  				break;
>  			}
> =20
> @@ -3751,6 +3819,22 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *=
vha,
>  			 * Log it out if still logged in and mark it for
>  			 * relogin later.
>  			 */
> +			if (!qla_ini_mode_enabled(base_vha)) {
> +				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf080,
> +					 "port changed FC ID, %8phC"
> +					 " old %x:%x:%x (loop_id 0x%04x)-> new %x:%x:%x\n",
> +					 fcport->port_name,
> +					 fcport->d_id.b.domain,
> +					 fcport->d_id.b.area,
> +					 fcport->d_id.b.al_pa,
> +					 fcport->loop_id,
> +					 new_fcport->d_id.b.domain,
> +					 new_fcport->d_id.b.area,
> +					 new_fcport->d_id.b.al_pa);
> +				fcport->d_id.b24 =3D new_fcport->d_id.b24;
> +				break;
> +			}
> +
>  			fcport->d_id.b24 =3D new_fcport->d_id.b24;
>  			fcport->flags |=3D FCF_LOGIN_NEEDED;
>  			if (fcport->loop_id !=3D FC_NO_LOOP_ID &&
> @@ -3770,6 +3854,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *v=
ha,
>  		if (found)
>  			continue;
>  		/* If device was not in our fcports list, then add it. */
> +		new_fcport->scan_state =3D QLA_FCPORT_FOUND;
>  		list_add_tail(&new_fcport->list, new_fcports);
> =20
>  		/* Allocate a new replacement fcport. */
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx=
/qla_target.c
> index 52d8f10..97b42c0 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -113,6 +113,7 @@ static void qlt_abort_cmd_on_host_reset(struct sc=
si_qla_host *vha,
>  static void qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
>  	struct atio_from_isp *atio, uint16_t status, int qfull);
>  static void qlt_disable_vha(struct scsi_qla_host *vha);
> +static void qlt_clear_tgt_db(struct qla_tgt *tgt);
>  /*
>   * Global Variables
>   */
> @@ -431,10 +432,10 @@ static int qlt_reset(struct scsi_qla_host *vha,=
 void *iocb, int mcmd)
> =20
>  	loop_id =3D le16_to_cpu(n->u.isp24.nport_handle);
>  	if (loop_id =3D=3D 0xFFFF) {
> -#if 0 /* FIXME: Re-enable Global event handling.. */
>  		/* Global event */
> -		atomic_inc(&ha->tgt.qla_tgt->tgt_global_resets_count);
> -		qlt_clear_tgt_db(ha->tgt.qla_tgt);
> +		atomic_inc(&vha->vha_tgt.qla_tgt->tgt_global_resets_count);
> +		qlt_clear_tgt_db(vha->vha_tgt.qla_tgt);
> +#if 0 /* FIXME: do we need to choose a session here? */
>  		if (!list_empty(&ha->tgt.qla_tgt->sess_list)) {
>  			sess =3D list_entry(ha->tgt.qla_tgt->sess_list.next,
>  			    typeof(*sess), sess_list_entry);

Hmm? What happened to the original FIXME?
Is it not required anymore?
I guess this warrants a separate patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
